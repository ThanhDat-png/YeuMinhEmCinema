using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.ViewModels;

namespace YeuMinhEmCinema.Web.Controllers;

/// <summary>Nhận bộ lọc, kiểm tra đầu vào và chuyển dữ liệu cho trang chủ.</summary>
public class HomeController : Controller
{
    private readonly TrangChuData data;
    private readonly ILogger<HomeController> logger;

    /// <summary>Nhận DAL và bộ ghi log qua cơ chế DI của ASP.NET Core.</summary>
    public HomeController(TrangChuData data, ILogger<HomeController> logger)
    {
        this.data = data;
        this.logger = logger;
    }

    /// <summary>Chặn đầu vào sai trước SQL và đưa trang vượt phạm vi về trang cuối.</summary>
    public async Task<IActionResult> Index(string? tuKhoa, string? trangThai, int trang = 1,
        CancellationToken cancellationToken = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest("Tham số không hợp lệ. Số trang phải là số nguyên từ 1 đến 1.000.000.");
        }
        tuKhoa = string.IsNullOrWhiteSpace(tuKhoa) ? null : tuKhoa.Trim();
        trangThai = string.IsNullOrWhiteSpace(trangThai) ? null : trangThai.Trim();
        if (trang < 1 || trang > 1000000)
        {
            return BadRequest("Số trang phải từ 1 đến 1.000.000.");
        }
        if (tuKhoa?.Length > 200)
        {
            return BadRequest("Từ khóa tối đa 200 ký tự.");
        }
        if (trangThai != null && trangThai != "Đang chiếu" && trangThai != "Sắp chiếu")
        {
            return BadRequest("Trạng thái phim không hợp lệ. Vui lòng chọn Đang chiếu, Sắp chiếu hoặc Tất cả.");
        }
        var model = new TrangChuViewModel
        {
            TuKhoa = tuKhoa,
            TrangThai = trangThai,
            Trang = trang
        };
        try
        {
            (model.Phim, model.TongKetQua) = await data.LayPhimAsync(tuKhoa, trangThai, trang, 12, cancellationToken);
            if (model.Phim.Count == 0 && trang > 1)
            {
                var trangHopLe = Math.Max(1, model.TongTrang);
                return RedirectToAction(nameof(Index), "Home", new
                {
                    tuKhoa,
                    trangThai,
                    trang = trangHopLe
                });
            }
            // Chưa có tiêu chí độ hot trong SQL: dùng phim đang chiếu mới khởi chiếu làm nổi bật.
            (model.PhimNoiBat, _) = await data.LayPhimAsync(null, "Đang chiếu", 1, 4, cancellationToken);
            model.Rap = await data.LayRapAsync(cancellationToken);
        }
        catch (Exception exception) when (exception is SqlException or InvalidOperationException)
        {
            logger.LogError("Không tải được trang chủ. Loại lỗi: {LoaiLoi}; mã SQL: {MaLoi}",
                exception.GetType().Name, (exception as SqlException)?.Number);
            model = new TrangChuViewModel
            {
                TuKhoa = tuKhoa,
                TrangThai = trangThai,
                Trang = trang,
                Loi = "Chưa tải được dữ liệu rạp. Vui lòng thử lại sau."
            };
            Response.StatusCode = StatusCodes.Status503ServiceUnavailable;
        }
        return View(model);
    }

    /// <summary>Hiện thông báo chung, không đưa nội dung lỗi kỹ thuật ra trình duyệt.</summary>
    public IActionResult Loi()
    {
        Response.StatusCode = StatusCodes.Status500InternalServerError;
        return View();
    }
}
