using System.Data;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Admin;
if (Environment.GetEnvironmentVariable("YMC_TEST_CONNECTION") is not string testCs
    || !new SqlConnectionStringBuilder(testCs).InitialCatalog.EndsWith("_Test", StringComparison.OrdinalIgnoreCase))
    throw new InvalidOperationException("Chỉ chạy khi YMC_TEST_CONNECTION trỏ database có hậu tố _Test.");
// Chỉ chạy thủ công sau script 09; test dùng mã riêng rồi dọn đúng fixture.
if (Environment.GetEnvironmentVariable("YMC_TEST_CONNECTION") is string cs)
    CauHinh.ChuoiKetNoi = cs;
var tag = "TEST_" + Guid.NewGuid().ToString("N")[.. 12].ToUpperInvariant();
int actor = 0;
int loai = 0;
var ids = new List<int>();
var day = DateTime.Today.AddDays(14);
SqlConnection Open()
{
    var c = new SqlConnection(CauHinh.ChuoiKetNoi);
    c.Open();
    return c;
}
byte[] GiaRV(int ma) => (byte[])GiaVeFnbDAL.GiaVe().AsEnumerable().Single(r => r.Field<int>("MaGiaVe") == ma)["PhienBan"];
DataRow Fnb(int ma) => GiaVeFnbDAL.Fnb().AsEnumerable().Single(r => r.Field<int>("MaSanPham") == ma);
DataTable Parts(params (int, int)[] parts)
{
    var t = GiaVeFnbDAL.TaoThanhPhan();
    foreach (var (a, b) in parts)
        t.Rows.Add(a, b);
    return t;
}
void Fail(Action a, int code, string text)
{
    try
    {
        a();
    }
    catch (SqlException ex) when (ex.Number == code)
    {
        Console.WriteLine("PASS: " + text);
        return;
    }
    throw new Exception("Không chặn: " + text);
}
int Item(string code,
    string group,
    DataTable parts,
    bool on = true,
    int? id = null,
    byte[]? rv = null)
{
    int n = GiaVeFnbDAL.LuuFnb(id, code, code, group, "L", 20000, on, parts, rv);
    if (!ids.Contains(n))
        ids.Add(n);
    return n;
}
try
{
    using (var cn = Open())
        using (var c = new SqlCommand("INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@U,REPLICATE('X',80));DECLARE @id INT=CONVERT(INT,SCOPE_IDENTITY());INSERT dbo.TaiKhoanVaiTro SELECT @id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';SELECT @id;",
            cn))
        {
            c.Parameters.AddWithValue("@U", tag);
            actor = Convert.ToInt32(c.ExecuteScalar());
            PhienDangNhap.TaiKhoan = new KetQuaDangNhap
            {
                MaTaiKhoan = actor,
                TenDangNhap = tag
            };
        }
    using (var c = Open())
        using (var cmd = new SqlCommand("INSERT dbo.LoaiGhe(TenLoai)VALUES(@t);SELECT CONVERT(INT,SCOPE_IDENTITY());",
            c))
        {
            cmd.Parameters.AddWithValue("@t", tag);
            loai = Convert.ToInt32(cmd.ExecuteScalar());
        }
    int p1 = GiaVeFnbDAL.LuuGia(null, loai, tag, "Ngày thường", day, day.AddDays(2), 80000, true, null);
    int p2 = GiaVeFnbDAL.LuuGia(null, loai, tag, "Ngày thường", day.AddDays(3), null, 90000, true, null);
    Console.WriteLine("PASS: Hai khoảng liền kề không chồng nhau");
    Fail(() => GiaVeFnbDAL.LuuGia(null, loai, tag, "Ngày thường", day.AddDays(2), day.AddDays(4), 81000, true, null),
        50207,
        "Chồng ngày biên bị chặn");
    int disabled = GiaVeFnbDAL.LuuGia(null, loai, tag, "Ngày thường", day, null, 70000, false, null);
    Fail(() => GiaVeFnbDAL.LuuGia(disabled, loai, tag, "Ngày thường", day, null, 70000, true, GiaRV(disabled)),
        50207,
        "Bật lại giá chồng bị chặn");
    Fail(() => GiaVeFnbDAL.LuuGia(null, loai, tag, "Cuối tuần", day, day.AddDays(-1), 10000, true, null),
        50204,
        "Ngày kết thúc sai");
    var stale = GiaRV(p1);
    GiaVeFnbDAL.LuuGia(p1, loai, tag, "Ngày thường", day, day.AddDays(2), 82000, true, stale);
    Fail(() => GiaVeFnbDAL.LuuGia(p1, loai, tag, "Ngày thường", day, day.AddDays(2), 83000, true, stale),
        50206,
        "Bảo vệ phiên bản giá");
    int w = GiaVeFnbDAL.LuuGia(null, loai, tag, "Cuối tuần", day, null, 95000, true, null);
    for (int n = 0; n < 3; n++)
    {
        var d = day.AddDays(n);
        var t = GiaVeFnbDAL.TraGia(loai, tag, d);
        bool weekend = (int)d.DayOfWeek == 0 || (int)d.DayOfWeek >= 5;
        if (t.Rows.Count != 1 || Convert.ToDecimal(t.Rows[0]["DonGia"]) != (weekend ? 95000 : 82000))
            throw new Exception("Tra sai ngày");
    }
    Console.WriteLine("PASS: Tra giá phân biệt ngày thường/cuối tuần");
    var result = await Task.WhenAll(Enumerable.Range(0, 2).Select(_ => Task.Run(() =>
    {
        try
        {
            GiaVeFnbDAL.LuuGia(null, loai, tag + "_CON", "Ngày thường", day, null, 80000, true, null);
            return true;
        }
        catch (SqlException ex) when (ex.Number == 50207)
        {
            return false;
        }
    })));
    if (result.Count(x => x) != 1)
        throw new Exception("Giá chồng khi ghi đồng thời");
    Console.WriteLine("PASS: Hai kết nối không tạo giá chồng");
    int a = Item(tag + "_A", "Bắp", Parts());
    int b = Item(tag + "_B", "Nước", Parts());
    Fail(() => Item(tag + "_A", "Bắp", Parts()), 50216, "Mã hàng trùng");
    Fail(() => Item(tag + "_C", "Combo", Parts()), 50217, "Combo rỗng");
    int combo = Item(tag + "_C", "Combo", Parts((a, 1), (b, 2)));
    if (GiaVeFnbDAL.ThanhPhan(combo).Rows.Count != 2)
        throw new Exception("Thiếu thành phần");
    Fail(() => Item(tag + "_N", "Combo", Parts((combo, 1))), 50218, "Không lồng combo");
    Fail(() => Item(tag + "_A", "Combo", Parts((b, 1)), true, a, (byte[])Fnb(a)["PhienBan"]),
        50220,
        "Không biến thành phần thành combo");
    Item(tag + "_B", "Nước", Parts(), false, b, (byte[])Fnb(b)["PhienBan"]);
    if (Convert.ToBoolean(Fnb(combo)["CoTheBan"]))
        throw new Exception("Combo vẫn bán khi món ngừng");
    Console.WriteLine("PASS: Ngừng món làm combo không thể bán");
    Fail(() => Item(tag + "_C", "Combo", Parts((a, 1), (b, 2)), true, combo, (byte[])Fnb(combo)["PhienBan"]),
        50219,
        "Không bật combo có món ngừng");
    Item(tag + "_B", "Nước", Parts(), true, b, (byte[])Fnb(b)["PhienBan"]);
    if (!Convert.ToBoolean(Fnb(combo)["CoTheBan"]))
        throw new Exception("Combo không khôi phục khả năng bán");
    var old = (byte[])Fnb(a)["PhienBan"];
    Item(tag + "_A", "Bắp", Parts(), true, a, old);
    Fail(() => Item(tag + "_A", "Bắp", Parts(), true, a, old),
        50215,
        "Bảo vệ phiên bản sản phẩm");
    Console.WriteLine("PASS: Toàn bộ kiểm tra Giá vé & F&B");
}
finally
{
    using var cn = Open();
    using var cmd = new SqlCommand(@"SET XACT_ABORT ON;BEGIN TRAN;
        DELETE c FROM dbo.FnbComboChiTiet c JOIN dbo.FnbSanPham p ON p.MaSanPham=c.MaCombo WHERE p.MaHang LIKE @prefix;
        DELETE dbo.FnbSanPham WHERE MaHang LIKE @prefix;
        DELETE dbo.GiaVe WHERE MaLoaiGhe=@loai;DELETE dbo.LoaiGhe WHERE MaLoai=@loai;COMMIT;",
        cn);
    // Escape '_' trong tiền tố để LIKE chỉ khớp fixture này.
    string prefix = tag.Replace("_", "[_]") + "[_]%";
    cmd.Parameters.AddWithValue("@prefix", prefix);
    cmd.Parameters.AddWithValue("@loai", loai);
    cmd.ExecuteNonQuery();
    Console.WriteLine("Đã dọn fixture: " + tag);
    if (actor > 0)
    {
        using var cleanupCn = Open();
        using var cleanupCmd = new SqlCommand("DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@A;DELETE dbo.TaiKhoan WHERE MaTaiKhoan=@A",
            cleanupCn);
        cleanupCmd.Parameters.AddWithValue("@A", actor);
        cleanupCmd.ExecuteNonQuery();
    }
}
