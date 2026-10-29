using System.Data;
using System.Diagnostics;
using System.Net;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Services;
using YeuMinhEmCinema.Web.ViewModels;
using static YeuMinhEmCinema.Web.Data.WebDb;

// Các fixture chỉ được phép ghi vào database _Test, không dùng connection mặc định của Web.
var cs = Environment.GetEnvironmentVariable("YMC_TEST_CONNECTION")
?? throw new InvalidOperationException("Cần YMC_TEST_CONNECTION trỏ database _Test.");
if (!new SqlConnectionStringBuilder(cs).InitialCatalog.EndsWith("_Test", StringComparison.OrdinalIgnoreCase))
{
    throw new InvalidOperationException("Từ chối kiểm thử ghi trên database không có hậu tố _Test.");
}
var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
{
    ["ConnectionStrings:Cinema"] = cs
}).Build();
var db = new WebDb(config);
var bookings = new DatVeData(db);
var accounts = new TaiKhoanData(db);
var tag = "webit_" + Guid.NewGuid().ToString("N")[.. 12];
var password = "WebTest!" + Guid.NewGuid().ToString("N");
var root = Directory.GetCurrentDirectory();
var web = Path.Combine(root, "src", "YeuMinhEmCinema.Web");
var url = "http://localhost:5192";
Process? server = null;
int rap = 0, phim = 0, loai = 0, phong = 0, suat = 0, sanPham = 0, combo = 0, staff = 0;

void Check(bool condition, string name)
{
    if (!condition)
    {
        throw new Exception("FAIL: " + name);
    }
    Console.WriteLine("PASS: " + name);
}

int Insert(string sql, params SqlParameter[] parameters)
{
    return Convert.ToInt32(db.Table(sql + "; SELECT CONVERT(INT,SCOPE_IDENTITY()) AS Id", false, parameters).Rows[0][0]);
}

HttpClient Client()
{
    return new HttpClient(new HttpClientHandler
    {
        CookieContainer = new CookieContainer(),
        AllowAutoRedirect = false
    })
    {
        BaseAddress = new Uri(url)
    };
}

async Task<HttpResponseMessage> Post(HttpClient client,
    string path,
    Dictionary<string, string> fields,
    string? formPath = null)
{
    var html = await client.GetStringAsync(formPath ?? path);
    var token = Regex.Match(html, "name=\"__RequestVerificationToken\"[^>]*value=\"([^\"]+)\"").Groups[1].Value;
    if (token.Length == 0)
    {
        throw new Exception("Không tìm thấy token form: " + (formPath ?? path));
    }
    fields["__RequestVerificationToken"] = WebUtility.HtmlDecode(token);
    return await client.PostAsync(path, new FormUrlEncodedContent(fields));
}

async Task Register(HttpClient client, string name)
{
    var response = await Post(client,
        "/TaiKhoan/DangKy",
        new()
        {
            ["TenDangNhap"] = name,
            ["HoTen"] = "Khách kiểm thử " + tag,
            ["MatKhau"] = password,
            ["XacNhanMatKhau"] = password
        });
    Check(response.StatusCode == HttpStatusCode.Redirect,
        "HTTP đăng ký khách " + name);
}

async Task Login(HttpClient client, string name, string pass)
{
    var response = await Post(client,
        "/TaiKhoan/DangNhap",
        new()
        {
            ["TenDangNhap"] = name,
            ["MatKhau"] = pass,
            ["ReturnUrl"] = "https://example.invalid/outside"
        });
    Check(response.StatusCode == HttpStatusCode.Redirect && response.Headers.Location?.ToString() == "/",
        "HTTP đăng nhập và chặn ReturnUrl ngoài");
}

DatVeModel Selection(int ghe, Guid? request = null)
{
    return new DatVeModel
    {
        MaSuatChieu = suat,
        MaYeuCau = request ?? Guid.NewGuid(),
        Ghe = [ghe],
        HoTen = "Khách kiểm thử",
        Fnb = [new FnbChon
        {
            MaSanPham = combo,
            SoLuong = 2
        }]
    };
}

try
{
    // Cấu trúc độc lập có 8 ghế, hai sản phẩm và giá riêng, không đụng danh mục có sẵn.
    rap = Insert("INSERT dbo.Rap(TenRap,TrangThai) VALUES(@T,N'Đang hoạt động')",
        P("@T", tag));
    phong = Insert("INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@R,@T,@T,N'Đang hoạt động')",
        P("@R", rap),
        P("@T", tag));
    loai = Insert("INSERT dbo.LoaiGhe(TenLoai) VALUES(@T)", P("@T", tag));
    for (var i = 1; i <= 8; i++)
    {
        Insert("INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@P,'A',@S,@L,N'Hoạt động')",
            P("@P", phong),
            P("@S", i),
            P("@L", loai));
    }
    phim = Insert("INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(@T,90,CONVERT(DATE,dbo.fn_YMC_GioVietNam()),'P',N'Đang chiếu')",
        P("@T", tag));
    suat = Insert("""
        INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai)
        VALUES(@F,@P,DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),DATEADD(MINUTE,110,dbo.fn_YMC_GioVietNam()),15,N'Mở bán')
        """,
        P("@F", phim),
        P("@P", phong));
    db.Read("""
        INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung)
        SELECT @L,@T,CASE WHEN (DATEDIFF(DAY,'19000101',CONVERT(DATE,GioBatDau))%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END,
            CONVERT(DATE,GioBatDau),80000,1 FROM dbo.SuatChieu WHERE MaSuatChieu=@S
        """,
        false,
        P("@L", loai),
        P("@T", tag),
        P("@S", suat));
    sanPham = Insert("INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia) VALUES(@T,@T,N'Nước',N'Nhỏ',20000)",
        P("@T", tag));
    combo = Insert("INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia) VALUES(@T,@T,N'Combo',N'Nhỏ',30000)",
        P("@T", tag + "c"));
    db.Read("INSERT dbo.FnbComboChiTiet VALUES(@C,@P,1)",
        false,
        P("@C", combo),
        P("@P", sanPham));

    var start = new ProcessStartInfo("dotnet")
    {
        WorkingDirectory = web,
        UseShellExecute = false,
        RedirectStandardOutput = true,
        RedirectStandardError = true,
        CreateNoWindow = true
    };
    start.ArgumentList.Add("bin/Review/Debug/net10.0/YeuMinhEmCinema.Web.dll");
    start.ArgumentList.Add("--urls");
    start.ArgumentList.Add(url);
    start.Environment["ConnectionStrings__Cinema"] = cs;
    start.Environment["ASPNETCORE_ENVIRONMENT"] = "Development";
    start.Environment["ThanhToan__ChoPhepMoPhong"] = "true";
    server = Process.Start(start)!;
    // Chỉ in log đã được backend làm sạch; không in cấu hình hoặc request body.
    server.OutputDataReceived += (_, e) =>
    {
        if (e.Data?.Contains("Lỗi Web:") == true)
        {
            Console.WriteLine(e.Data);
        }
    };
    server.BeginOutputReadLine();
    server.BeginErrorReadLine();
    using var anonymous = Client();
    var ready = false;
    for (var i = 0; i < 50; i++)
    {
        try
        {
            ready = (await anonymous.GetAsync("/")).StatusCode == HttpStatusCode.OK;
            if (ready)
            {
                break;
            }
        }
        catch (HttpRequestException)
        {
        }
        await Task.Delay(100);
    }
    Check(ready, "Web thử nghiệm khởi động trên SQL _Test");
    Check((await anonymous.GetAsync("/DatVe/Ghe/" + suat)).StatusCode == HttpStatusCode.Redirect,
        "Chưa đăng nhập chuyển tới đăng nhập");
    Check((await anonymous.PostAsync("/TaiKhoan/DangNhap",
            new FormUrlEncodedContent(new Dictionary<string, string>()))).StatusCode == HttpStatusCode.BadRequest,
        "Thiếu CSRF bị từ chối");
    using var c1 = Client();
    using var c2 = Client();
    await Register(c1, tag + "a");
    await Register(c2, tag + "b");
    var bad = await Post(c1,
        "/TaiKhoan/DangNhap",
        new()
        {
            ["TenDangNhap"] = tag + "a",
            ["MatKhau"] = "Sai-mat-khau"
        });
    Check(bad.StatusCode == HttpStatusCode.OK
            && (await bad.Content.ReadAsStringAsync()).Contains("validation-summary-errors"),
        "HTTP đăng nhập sai có lỗi thật");
    await Login(c1, tag + "a", password);
    await Login(c2, tag + "b", password);
    var id1 = (int)db.Table("SELECT MaTaiKhoan FROM dbo.TaiKhoan WHERE TenDangNhap=@T",
        false,
        P("@T", tag + "a")).Rows[0][0];
    var id2 = (int)db.Table("SELECT MaTaiKhoan FROM dbo.TaiKhoan WHERE TenDangNhap=@T",
        false,
        P("@T", tag + "b")).Rows[0][0];
    Check(db.Table("SELECT * FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@Id AND v.TenVaiTro<>'KHACH_HANG'",
            false,
            P("@Id", id1)).Rows.Count == 0,
        "Đăng ký không có vai trò quản trị");
    var profile = await Post(c1,
        "/TaiKhoan/HoSo",
        new()
        {
            ["HoTen"] = "Khách đã cập nhật",
            ["DienThoai"] = "0901234567",
            ["Email"] = tag + "@example.invalid"
        });
    Check(profile.StatusCode == HttpStatusCode.Redirect
            && (string)accounts.HoSo(id1)!["HoTen"] == "Khách đã cập nhật",
        "HTTP cập nhật hồ sơ của chính mình");
    Check((string)accounts.HoSo(id1)!["Email"] == tag + "@example.invalid",
        "Cập nhật email cùng transaction hồ sơ");
    Check((await c1.GetAsync($"/Phim/ChiTiet/{phim}")).StatusCode == HttpStatusCode.OK,
        "Chi tiết phim thật trên _Test");
    Check((await c1.GetAsync($"/Phim/Lich?maPhim={phim}&maRap={rap}")).StatusCode == HttpStatusCode.OK,
        "Lịch chiếu theo phim/rạp/ngày");
    var soDo = bookings.Ghe(suat);
    var ghe1 = (int)soDo.Rows[0]["MaGhe"];
    var ghe2 = (int)soDo.Rows[1]["MaGhe"];
    var ghe3 = (int)soDo.Rows[2]["MaGhe"];
    var ghe4 = (int)soDo.Rows[3]["MaGhe"];
    var request = Guid.NewGuid();
    var fields = new Dictionary<string, string>
    {
        ["MaSuatChieu"] = suat.ToString(),
        ["MaYeuCau"] = request.ToString(),
        ["Ghe"] = ghe1.ToString(),
        ["HoTen"] = "Khách HTTP",
        ["Fnb[0].MaSanPham"] = combo.ToString(),
        ["Fnb[0].SoLuong"] = "2"
    };
    var hold = await Post(c1, "/DatVe/GiuGhe", new(fields), "/DatVe/Ghe/" + suat);
    Check(hold.StatusCode == HttpStatusCode.Redirect,
        "HTTP giữ ghế và bắp nước");
    var don = (long)db.Table("SELECT MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@R", false, P("@R", request)).Rows[0][0];
    var holdAgain = await Post(c1, "/DatVe/GiuGhe", new(fields), "/DatVe/Ghe/" + suat);
    Check(holdAgain.Headers.Location == hold.Headers.Location,
        "HTTP gửi lại giữ ghế trả cùng đơn");
    Check((decimal)bookings.ChiTiet(id1, don).Tables[0].Rows[0]["TongTien"] == 140000,
        "Giá server: 80.000 vé + 2 combo 30.000");
    Check((await c2.GetAsync("/Don/ChiTiet/" + don)).StatusCode == HttpStatusCode.NotFound,
        "Khách khác không xem đơn");
    var beforePay = await c1.GetStringAsync("/Don/ChiTiet/" + don);
    Check(!beforePay.Contains("class=\"qr\""), "Chưa thanh toán không có QR");
    var failed = await Post(c1,
        "/Don/ThanhToan",
        new()
        {
            ["id"] = don.ToString(),
            ["ketQua"] = "that-bai"
        },
        "/Don/ChiTiet/" + don);
    Check(failed.StatusCode == HttpStatusCode.Redirect && bookings.ChiTiet(id1, don).Tables[3].Rows.Count == 0,
        "Mô phỏng thất bại không thu hoặc phát vé");
    var payment = await Post(c1,
        "/Don/ThanhToan",
        new()
        {
            ["id"] = don.ToString(),
            ["ketQua"] = "thanh-cong"
        },
        "/Don/ChiTiet/" + don);
    var paymentAgain = await Post(c1,
        "/Don/ThanhToan",
        new()
        {
            ["id"] = don.ToString(),
            ["ketQua"] = "thanh-cong"
        },
        "/Don/ChiTiet/" + don);
    var detail = bookings.ChiTiet(id1, don);
    Check(payment.StatusCode == HttpStatusCode.Redirect && paymentAgain.StatusCode == HttpStatusCode.Redirect
            && detail.Tables[3].Rows.Count == 1,
        "Thanh toán gửi lại không tạo giao dịch trùng");
    var ticket = (Guid)detail.Tables[1].Rows[0]["MaVe"];
    Check((await c1.GetAsync("/Don/Qr/" + ticket)).StatusCode == HttpStatusCode.OK,
        "HTTP QR chỉ phát sau thanh toán");
    Check((await c2.GetAsync("/Don/Qr/" + ticket)).StatusCode == HttpStatusCode.NotFound,
        "Khách khác không lấy QR");
    // Tài khoản kiểm vé chỉ phục vụ fixture, không được dùng làm danh tính thanh toán Web.
    staff = Insert("INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@T,@H)",
        P("@T", tag + "staff"),
        P("@H", KhachHangSession.Bam(password)));
    db.Read("INSERT dbo.TaiKhoanVaiTro SELECT @Id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN'",
        false,
        P("@Id", staff));
    var checkedTicket = db.Table("dbo.sp_YMC_KiemTraVe",
        true,
        P("@NguoiThucHien", staff),
        P("@MaVe", ticket),
        P("@XacNhanVaoRap", false));
    Check((Guid)checkedTicket.Rows[0]["MaVe"] == ticket,
        "GUID vé Web được procedure kiểm vé WinForms tra cứu");
    var cancelDon = bookings.TaoDon(id1, Selection(ghe2));
    await Post(c1,
        "/Don/Huy",
        new()
        {
            ["id"] = cancelDon.ToString()
        },
        "/Don/ChiTiet/" + cancelDon);
    Check(db.Table("SELECT * FROM dbo.GiuGhe WHERE MaDonHang=@D", false, P("@D", cancelDon)).Rows.Count == 0,
        "Hủy đơn giải phóng ghế");
    var expired = bookings.TaoDon(id1, Selection(ghe3));
    db.Read("UPDATE dbo.DonHang SET HanThanhToanUtc=DATEADD(SECOND,-1,SYSUTCDATETIME()) WHERE MaDonHang=@D",
        false,
        P("@D", expired));
    try
    {
        bookings.MoPhong(id1, expired);
        throw new Exception("FAIL: đơn hết hạn vẫn thanh toán");
    }
    catch (SqlException exception) when (exception.Number == 50324)
    {
        Console.WriteLine("PASS: SQL từ chối thanh toán đơn hết hạn");
    }
    Check(WebUtility.HtmlDecode(await c1.GetStringAsync("/Don/ChiTiet/" + expired)).Contains("Hết hạn"),
        "HTTP hiển thị hết hạn theo server");
    // Hai kết nối cạnh tranh cùng ghế, chỉ một lệnh được phép thành công.
    async Task<bool> Race(int id)
    {
        return await Task.Run(() =>
        {
            try
            {
                bookings.TaoDon(id, Selection(ghe4));
                return true;
            }
            catch (SqlException exception) when (exception.Number == 50310)
            {
                return false;
            }
        });
    }
    var winners = await Task.WhenAll(Race(id1), Race(id2));
    Check(winners.Count(winner => winner) == 1,
        "Hai khách tranh ghế: chỉ một người giữ được");
    if (Environment.GetEnvironmentVariable("YMC_BROWSER_TEST") == "1")
    {
        var browser = new ProcessStartInfo("node")
        {
            WorkingDirectory = root,
            UseShellExecute = false,
            CreateNoWindow = true,
            RedirectStandardOutput = true,
            RedirectStandardError = true
        };
        browser.ArgumentList.Add("Tests/WebCustomerIntegration/browser.mjs");
        browser.Environment["YMC_BROWSER_USER"] = tag + "a";
        browser.Environment["YMC_BROWSER_PASSWORD"] = password;
        browser.Environment["YMC_BROWSER_MOVIE"] = phim.ToString();
        browser.Environment["YMC_BROWSER_SHOW"] = suat.ToString();
        browser.Environment["YMC_BROWSER_SEAT"] = soDo.Rows[4]["MaGhe"].ToString();
        browser.Environment["YMC_BROWSER_COMBO"] = combo.ToString();
        using var process = Process.Start(browser)!;
        var output = process.StandardOutput.ReadToEndAsync();
        var errors = process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();
        Console.Write(await output);
        Console.Write(await errors);
        Check(process.ExitCode == 0, "Kiểm thử trình duyệt luồng khách hàng");
        // Đăng nhập trình duyệt làm rowversion đổi, xác thực lại client HTTP trước ca tiếp theo.
        await Login(c1, tag + "a", password);
    }
    // Thử đủ năm lần sai trên tài khoản fixture để kiểm tra khóa thật của SQL.
    for (var i = 0; i < 5; i++)
    {
        await Post(c2,
            "/TaiKhoan/DangNhap",
            new()
            {
                ["TenDangNhap"] = tag + "b",
                ["MatKhau"] = "Sai-mat-khau"
            });
    }
    Check(accounts.HoSo(id2) == null, "Năm lần sai khóa tài khoản theo SQL");
    Check((await c2.GetAsync("/Don")).StatusCode == HttpStatusCode.Redirect,
        "Cookie khách bị khóa không truy cập đơn");
    var change = await Post(c1, "/TaiKhoan/DoiMatKhau", new()
    {
        ["MatKhauCu"] = password,
        ["MatKhauMoi"] = password + "new",
        ["XacNhanMatKhau"] = password + "new"
    });
    Check(change.StatusCode == HttpStatusCode.Redirect,
        "HTTP đổi mật khẩu và yêu cầu đăng nhập lại");
    await Login(c1, tag + "a", password + "new");
    await Post(c1, "/TaiKhoan/DangXuat", new(), "/TaiKhoan/HoSo");
    Check((await c1.GetAsync("/Don")).StatusCode == HttpStatusCode.Redirect,
        "Đăng xuất POST kết thúc phiên");

    // Chạy cùng binary với Production để chứng minh cấu hình true cũng không vượt được môi trường.
    server.Kill(true);
    await server.WaitForExitAsync();
    start.Environment["ASPNETCORE_ENVIRONMENT"] = "Production";
    server = Process.Start(start)!;
    server.BeginOutputReadLine();
    server.BeginErrorReadLine();
    await Task.Delay(1000);
    using var production = Client();
    await Login(production, tag + "a", password + "new");
    var productionPay = await Post(production,
        "/Don/ThanhToan",
        new()
        {
            ["id"] = don.ToString(),
            ["ketQua"] = "thanh-cong"
        },
        "/Don/ChiTiet/" + don);
    Check(productionPay.StatusCode == HttpStatusCode.Forbidden,
        "Production chặn mô phỏng dù cấu hình true");
}
finally
{
    if (server != null && !server.HasExited)
    {
        server.Kill(true);
        await server.WaitForExitAsync();
    }
    // Dọn đúng fixture của lần chạy. Không dùng tên chung hoặc thao tác trên database chính.
    db.Read("""
        DELETE v FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE h FROM dbo.GiuGhe h WHERE h.MaSuatChieu=@S;
        DELETE c FROM dbo.ChiTietComboDaBan c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE c FROM dbo.ChiTietDonFnb c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE c FROM dbo.ChiTietVe c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE c FROM dbo.HoanTien c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE c FROM dbo.ThanhToan c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang WHERE d.MaSuatChieu=@S;
        DELETE dbo.DonHang WHERE MaSuatChieu=@S;
        DELETE dbo.SuatChieu WHERE MaSuatChieu=@S;
        DELETE dbo.Ghe WHERE MaPhong=@P;
        DELETE dbo.PhongChieu WHERE MaPhong=@P;
        DELETE dbo.GiaVe WHERE MaLoaiGhe=@L;
        DELETE dbo.LoaiGhe WHERE MaLoai=@L;
        DELETE dbo.Rap WHERE MaRap=@R;
        DELETE dbo.Phim WHERE MaPhim=@F;
        DELETE dbo.FnbComboChiTiet WHERE MaCombo=@C;
        DELETE dbo.FnbSanPham WHERE MaSanPham IN(@C,@SP);
        DELETE tv FROM dbo.TaiKhoanVaiTro tv JOIN dbo.TaiKhoan t ON t.MaTaiKhoan=tv.MaTaiKhoan WHERE t.TenDangNhap IN(@A,@B,@Staff);
        DELETE kh FROM dbo.KhachHang kh JOIN dbo.TaiKhoan t ON t.MaTaiKhoan=kh.MaTaiKhoan WHERE t.TenDangNhap IN(@A,@B);
        DELETE dbo.TaiKhoan WHERE TenDangNhap IN(@A,@B,@Staff);
        """,
        false,
        P("@S", suat),
        P("@P", phong),
        P("@L", loai),
        P("@R", rap),
        P("@F", phim),
        P("@C", combo),
        P("@SP", sanPham),
        P("@A", tag + "a"),
        P("@B", tag + "b"),
        P("@Staff", tag + "staff"));
    Console.WriteLine("Đã dọn fixture của lần kiểm thử trong _Test.");
}
