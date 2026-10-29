using System.Data;
using Microsoft.AspNetCore.Mvc;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.ViewModels;

namespace YeuMinhEmCinema.Web.Controllers;

/// <summary>Khách chưa đăng nhập vẫn được xem phim, trailer, rạp và lịch.</summary>
public class PhimController : Controller
{
    private readonly PhimData data;

    public PhimController(PhimData data)
    {
        this.data = data;
    }

    public IActionResult ChiTiet(int id, int? maRap, DateTime? ngay)
    {
        if (!HopLe(id, maRap, ngay))
        {
            return BadRequest("Mã phim, rạp hoặc ngày không hợp lệ.");
        }
        var phim = data.ChiTiet(id);
        if (phim == null)
        {
            return NotFound("Phim không tồn tại hoặc đã ngừng công khai.");
        }
        var model = TaoLich(id, maRap, ngay);
        model.Phim = phim;
        return View(model);
    }

    public IActionResult Lich(int? maPhim, int? maRap, DateTime? ngay)
    {
        if (!HopLe(maPhim, maRap, ngay))
        {
            return BadRequest("Bộ lọc lịch chiếu không hợp lệ.");
        }
        return View(TaoLich(maPhim, maRap, ngay));
    }

    public IActionResult Rap()
    {
        return View(data.Rap());
    }

    public IActionResult PhimTaiRap(int id)
    {
        if (!ModelState.IsValid || id <= 0)
        {
            return BadRequest("Mã rạp không hợp lệ.");
        }
        var rap = data.Rap().AsEnumerable().FirstOrDefault(row => (int)row["MaRap"] == id);
        if (rap == null)
        {
            return NotFound("Rạp không tồn tại hoặc đang ngừng hoạt động.");
        }
        ViewData["TenRap"] = rap["TenRap"];
        ViewData["DiaChi"] = rap["DiaChi"];
        ViewData["MaRap"] = id;
        return View(data.PhimTaiRap(id));
    }

    private bool HopLe(int? phim, int? rap, DateTime? ngay)
    {
        return ModelState.IsValid && (phim == null || phim > 0) && (rap == null || rap > 0)
            && (ngay == null || (ngay >= new DateTime(2000, 1, 1) && ngay < new DateTime(9999, 12, 31)));
    }

    private LichModel TaoLich(int? phim, int? rap, DateTime? ngay)
    {
        var model = new LichModel
        {
            MaPhim = phim,
            MaRap = rap,
            Ngay = ngay?.Date ?? DateTime.UtcNow.AddHours(7).Date,
            XemGanNhat = !ngay.HasValue,
            DanhSachPhim = data.DanhSach(),
            Rap = data.Rap()
        };
        // Không chọn phim vẫn có suất gợi ý; mọi bộ lọc khách chọn đều được giữ.
        model.Lich = phim.HasValue && ngay.HasValue
        ? data.Lich(phim.Value, rap, model.Ngay)
        : data.GanNhat(phim, rap, ngay);
        return model;
    }
}
