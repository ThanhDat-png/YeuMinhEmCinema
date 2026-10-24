using System.Security.Claims;
using System.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Services;
using YeuMinhEmCinema.Web.ViewModels;

namespace YeuMinhEmCinema.Web.Controllers;

/// <summary>Ghế và bắp nước được kiểm tra lại tại server trước khi giữ bằng SQL.</summary>
[Authorize(Roles = "KhachHang")]
public class DatVeController : Controller
{
    private readonly DatVeData data;
    private readonly TaiKhoanData taiKhoan;

    public DatVeController(DatVeData data, TaiKhoanData taiKhoan)
    {
        this.data = data;
        this.taiKhoan = taiKhoan;
    }

    [HttpGet]
    public IActionResult Ghe(int id)
    {
        if (!ModelState.IsValid || id < 1)
        {
            return BadRequest("Suất chiếu không hợp lệ.");
        }
        var row = taiKhoan.HoSo(Id());
        if (row == null)
        {
            return Challenge();
        }
        var model = new DatVeModel
        {
            MaSuatChieu = id,
            MaYeuCau = Guid.NewGuid(),
            HoTen = (string)row["HoTen"],
            DienThoai = row["DienThoai"] as string
        };
        if (!Tai(model))
        {
            return NotFound("Suất chiếu đã ngừng bán hoặc đã bắt đầu.");
        }
        return View(model);
    }

    [HttpPost]
    public IActionResult BapNuoc(DatVeModel model)
    {
        if (!Tai(model))
        {
            return BadRequest("Suất chiếu không còn mở bán.");
        }
        KiemTraGhe(model);
        if (!ModelState.IsValid)
        {
            return View("Ghe", model);
        }
        model.ChonBap = true;
        return View(model);
    }

    [HttpPost]
    public IActionResult GiuGhe(DatVeModel model)
    {
        if (!Tai(model))
        {
            return BadRequest("Suất chiếu không còn mở bán.");
        }
        // Retry trước tiên để SQL trả đơn cũ theo MaYeuCau, không từ chối ghế do chính đơn đó đang giữ.
        if (model.Ghe.Count is < 1 or > 8 || model.Ghe.Distinct().Count() != model.Ghe.Count
            || model.MaYeuCau == Guid.Empty || model.Fnb.Count > 1000
            || model.Fnb.Count(f => f.SoLuong > 0) > 20
            || model.Fnb.Select(f => f.MaSanPham).Distinct().Count() != model.Fnb.Count)
        {
            ModelState.AddModelError("", "Chọn 1–8 ghế khác nhau và tối đa 20 sản phẩm.");
        }
        if (ModelState.IsValid)
        {
            try
            {
                var don = data.TaoDon(Id(), model);
                return RedirectToAction("ChiTiet", "Don", new { id = don });
            }
            catch (SqlException exception) when (exception.Number >= 50000 && exception.Number < 51000)
            {
                ModelState.AddModelError("", WebErrors.ThongBao(exception));
                Tai(model);
                model.Ghe = model.Ghe.Where(ma => model.SoDo.AsEnumerable().Any(r =>
                    (int)r["MaGhe"] == ma && (string)r["TinhTrang"] == "Trống" && r["Gia"] != DBNull.Value)).ToList();
                TempData["ThongBao"] = "Trạng thái ghế đã được tải lại. Vui lòng kiểm tra lựa chọn.";
                Tai(model);
                return View("Ghe", model);
            }
        }
        model.ChonBap = true;
        return View("BapNuoc", model);
    }

    private bool Tai(DatVeModel model)
    {
        if (!ModelState.IsValid && model.MaSuatChieu < 1)
        {
            return false;
        }
        model.Suat = data.Suat(model.MaSuatChieu);
        if (model.Suat == null)
        {
            return false;
        }
        model.SoDo = data.Ghe(model.MaSuatChieu);
        model.Menu = data.Menu();
        return true;
    }

    private void KiemTraGhe(DatVeModel model)
    {
        if (model.Ghe.Count is < 1 or > 8 || model.Ghe.Distinct().Count() != model.Ghe.Count)
        {
            ModelState.AddModelError("", "Chọn từ 1 đến 8 ghế khác nhau.");
        }
        foreach (var ma in model.Ghe)
        {
            if (!model.SoDo.AsEnumerable().Any(r => (int)r["MaGhe"] == ma
                && (string)r["TinhTrang"] == "Trống" && r["Gia"] != DBNull.Value))
            {
                ModelState.AddModelError("", "Một ghế đã được giữ, đã bán, hỏng hoặc chưa có giá. Hãy chọn lại.");
                break;
            }
        }
    }

    private int Id()
    {
        return int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    }
}
