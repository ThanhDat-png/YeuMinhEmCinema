using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Services;
using YeuMinhEmCinema.Web.ViewModels;

namespace YeuMinhEmCinema.Web.Controllers;

/// <summary>Đơn và vé luôn giới hạn theo chủ tài khoản, kể cả truy cập trực tiếp bằng ID.</summary>
[Authorize(Roles = "KhachHang")]
[ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
public class DonController : Controller
{
    private readonly DatVeData data;
    private readonly IWebHostEnvironment environment;
    private readonly IConfiguration configuration;

    public DonController(DatVeData data,
        IWebHostEnvironment environment,
        IConfiguration configuration)
    {
        this.data = data;
        this.environment = environment;
        this.configuration = configuration;
    }

    public IActionResult Index(string? trangThai, int trang = 1)
    {
        trangThai = string.IsNullOrWhiteSpace(trangThai) ? null : trangThai;
        if (!ModelState.IsValid
            || trang is < 1 or > 1000000
            ||
            (trangThai != null
            && !new []
            {
                "CHO_THANH_TOAN",
                "DA_THANH_TOAN",
                "DA_HUY",
                "HET_HAN",
                "DA_HOAN_TIEN"
            }.Contains(trangThai)))
        {
            return BadRequest("Bộ lọc đơn không hợp lệ.");
        }
        var model = data.LichSu(Id(), trangThai, trang);
        if (trang > Math.Max(1, model.TongTrang))
        {
            return RedirectToAction(nameof(Index), new
            {
                trangThai, trang = Math.Max(1, model.TongTrang)
            });
        }
        return View(model);
    }

    public IActionResult ChiTiet(long id)
    {
        if (!ModelState.IsValid || id < 1 || !data.ThuocKhach(Id(), id))
        {
            return NotFound("Không tìm thấy đơn của bạn.");
        }
        return View(new DonModel
            {
                ChiTiet = data.ChiTiet(Id(), id),
                ChoPhepMoPhong = MoPhongBat()
            });
    }

    [HttpPost]
    public IActionResult Huy(long id)
    {
        if (!ModelState.IsValid || id < 1 || !data.ThuocKhach(Id(), id))
        {
            return NotFound();
        }
        try
        {
            data.Huy(Id(), id);
            TempData["ThongBao"] = "Đã hủy đơn và giải phóng ghế.";
        }
        catch (SqlException exception) when (exception.Number >= 50000 && exception.Number < 51000)
        {
            TempData["ThongBao"] = WebErrors.ThongBao(exception);
        }
        return RedirectToAction(nameof(ChiTiet), new
        {
            id
        });
    }

    [HttpPost]
    public IActionResult ThanhToan(long id, string ketQua)
    {
        // Cổng duy nhất của mô phỏng: kiểm tra cả môi trường và cấu hình ở server.
        if (!MoPhongBat())
        {
            return StatusCode(403, "Thanh toán mô phỏng chỉ được bật trong Development.");
        }
        if (!ModelState.IsValid || id < 1 || !data.ThuocKhach(Id(), id))
        {
            return NotFound();
        }
        if (ketQua == "that-bai")
        {
            TempData["ThongBao"] = "Mô phỏng giao dịch thất bại. Chưa thu tiền, chưa phát hành vé; bạn có thể thử lại trước hạn.";
            return RedirectToAction(nameof(ChiTiet), new
            {
                id
            });
        }
        if (ketQua != "thanh-cong")
        {
            return BadRequest("Kết quả mô phỏng không hợp lệ.");
        }
        try
        {
            data.MoPhong(Id(), id);
            TempData["ThongBao"] = "Mô phỏng thành công (không có tiền thật). Vé đã được phát hành cho đồ án.";
        }
        catch (SqlException exception) when (exception.Number >= 50000 && exception.Number < 51000)
        {
            TempData["ThongBao"] = WebErrors.ThongBao(exception);
        }
        return RedirectToAction(nameof(ChiTiet), new
        {
            id
        });
    }

    public IActionResult Qr(Guid id)
    {
        if (!ModelState.IsValid || id == Guid.Empty)
        {
            return BadRequest();
        }
        var bytes = data.Ve(Id(), id);
        if (bytes == null)
        {
            return NotFound();
        }
        return File(bytes, "image/png");
    }

    private bool MoPhongBat()
    {
        return environment.IsDevelopment() && configuration.GetValue<bool>("ThanhToan:ChoPhepMoPhong");
    }

    private int Id()
    {
        return int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    }
}
