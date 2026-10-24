using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using YeuMinhEmCinema.Web.Controllers;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Models;
using YeuMinhEmCinema.Web.ViewModels;

// Chạy không cần framework kiểm thử, không ghi dữ liệu. Ném lỗi thì tiến trình thất bại.
static void KiemTra(bool dung, string ten)
{
    if (!dung)
    {
        throw new Exception("FAIL: " + ten);
    }
    Console.WriteLine("PASS: " + ten);
}

static HomeController TaoController(TrangChuData data)
{
    return new HomeController(data, NullLogger<HomeController>.Instance)
    {
        ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext()
        }
    };
}

var gia = new DuLieuGia();
var controller = TaoController(gia);
foreach (var trang in new[] { 0, -1, 1000001, int.MaxValue })
{
    KiemTra(await controller.Index(null, null, trang) is BadRequestObjectResult, "Từ chối trang " + trang);
}
controller.ModelState.AddModelError("trang", "abc hoặc vượt int");
KiemTra(await controller.Index(null, null) is BadRequestObjectResult, "ModelState lỗi không được dùng trang mặc định");
controller.ModelState.Clear();
KiemTra(await controller.Index(new string('a', 201), null) is BadRequestObjectResult, "Từ khóa quá dài");
KiemTra(await controller.Index(null, "Sai") is BadRequestObjectResult, "Trạng thái không hợp lệ");
KiemTra(gia.SoLanGoi == 0, "Đầu vào sai không gọi DAL");

gia.Tong = 25;
var redirect = await controller.Index("  Phim  ", "Đang chiếu", 99) as RedirectToActionResult;
KiemTra(redirect?.RouteValues?["trang"]?.ToString() == "3", "Vượt trang chuyển về trang cuối của 25 phim");
KiemTra(redirect?.RouteValues?["tuKhoa"]?.ToString() == "Phim" &&
    redirect.RouteValues["trangThai"]?.ToString() == "Đang chiếu", "Chuyển trang giữ bộ lọc");
gia.Tong = 0;
redirect = await controller.Index("không có", "", 9) as RedirectToActionResult;
KiemTra(redirect?.RouteValues?["trang"]?.ToString() == "1", "Danh sách rỗng chuẩn hóa về trang đầu");
var view = await controller.Index("không có", "", 1) as ViewResult;
var model = view?.Model as TrangChuViewModel;
KiemTra(model?.TongKetQua == 0 && model.TrangThai == null, "Không có kết quả khác với vượt trang, trạng thái rỗng là tất cả");

foreach (var poster in new[] { @"C:\anh\phim.jpg", "//host/anh.jpg", @"/\host/anh.jpg", "javascript:alert(1)", "file:///C:/anh.jpg" })
{
    KiemTra(new Phim { Poster = poster }.AnhPoster == "/images/poster-placeholder.svg", "Chặn đường dẫn " + poster);
}
KiemTra(new Phim { Poster = "/images/phim.jpg" }.AnhPoster == "/images/phim.jpg", "Chấp nhận ảnh wwwroot");

var khongCauHinh = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
{
    ["ConnectionStrings:Cinema"] = ""
}).Build();
var controllerLoi = TaoController(new TrangChuData(khongCauHinh));
var viewLoi = await controllerLoi.Index(null, null) as ViewResult;
KiemTra(controllerLoi.Response.StatusCode == 503 &&
    (viewLoi?.Model as TrangChuViewModel)?.Loi != null, "Thiếu cấu hình trả 503 với thông báo an toàn");

// Tùy chọn kiểm tra DAL thật bằng database đã có; không thêm phim để tạo trang thứ hai.
if (Environment.GetEnvironmentVariable("YMC_WEB_SQL_TEST") == "1")
{
    var data = new TrangChuData(new ConfigurationBuilder().Build());
    var dau = await data.LayPhimAsync(null, null, 1, 1, default);
    KiemTra(dau.tong > 0, "SQL có phim công khai để kiểm tra");
    var cuoi = await data.LayPhimAsync(null, null, dau.tong, 1, default);
    var vuot = await data.LayPhimAsync(null, null, dau.tong + 1, 1, default);
    KiemTra(cuoi.phim.Count == 1 && cuoi.tong == dau.tong, "DAL trang cuối đúng tổng");
    KiemTra(vuot.phim.Count == 0 && vuot.tong == dau.tong, "DAL trang vượt vẫn giữ tổng thật");
    var rong = await data.LayPhimAsync("zzzznotfound_web_smoke", null, 99, 12, default);
    KiemTra(rong.phim.Count == 0 && rong.tong == 0, "DAL bộ lọc rỗng ở trang vượt");
    var khongKetNoi = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
    {
        ["ConnectionStrings:Cinema"] = "Server=tcp:127.0.0.1,1;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;Connect Timeout=1"
    }).Build();
    var loiSql = TaoController(new TrangChuData(khongKetNoi));
    var ketQuaLoi = await loiSql.Index(null, null) as ViewResult;
    KiemTra(loiSql.Response.StatusCode == 503 &&
        (ketQuaLoi?.Model as TrangChuViewModel)?.Loi != null, "SQL không truy cập được trả 503 an toàn");
}

/// <summary>Thay DAL để xác minh nhánh Controller mà không phụ thuộc SQL.</summary>
class DuLieuGia : TrangChuData
{
    public int SoLanGoi { get; private set; }
    public int Tong { get; set; }

    public DuLieuGia() : base(new ConfigurationBuilder().Build())
    {
    }

    public override Task<(List<Phim> phim, int tong)> LayPhimAsync(
        string? tuKhoa, string? trangThai, int trang, int kichThuoc, CancellationToken cancellationToken)
    {
        SoLanGoi++;
        return Task.FromResult((new List<Phim>(), Tong));
    }

    public override Task<List<Rap>> LayRapAsync(CancellationToken cancellationToken)
    {
        return Task.FromResult(new List<Rap>());
    }
}
