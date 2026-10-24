using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Services;
using YeuMinhEmCinema.Web.ViewModels;

namespace YeuMinhEmCinema.Web.Controllers;

/// <summary>Luồng khách hàng, không cung cấp quyền hoặc giao diện quản trị.</summary>
public class TaiKhoanController : Controller
{
    private readonly TaiKhoanData data;

    public TaiKhoanController(TaiKhoanData data)
    {
        this.data = data;
    }

    [HttpGet]
    public IActionResult DangNhap(string? returnUrl)
    {
        return View(new DangNhapModel { ReturnUrl = returnUrl });
    }

    [HttpPost]
    public async Task<IActionResult> DangNhap(DangNhapModel model)
    {
        if (ModelState.IsValid)
        {
            try
            {
                var row = data.DangNhap(model.TenDangNhap, model.MatKhau);
                if (row != null)
                {
                    await HttpContext.SignInAsync(KhachHangSession.TaoDanhTinh(
                        (int)row["MaTaiKhoan"], (string)row["HoTen"], (byte[])row["PhienTaiKhoan"]));
                    if (Url.IsLocalUrl(model.ReturnUrl))
                    {
                        return LocalRedirect(model.ReturnUrl!);
                    }
                    return RedirectToAction("Index", "Home");
                }
                ModelState.AddModelError("", "Thông tin không đúng hoặc tài khoản khách đang bị khóa/ngừng hoạt động.");
            }
            catch (SqlException exception) when (exception.Number >= 50000 && exception.Number < 51000)
            {
                ModelState.AddModelError("", "Chưa đăng nhập được. Kiểm tra thông tin hoặc chờ hết thời gian khóa.");
            }
        }
        model.MatKhau = "";
        ModelState.SetModelValue(nameof(model.MatKhau), "", "");
        return View(model);
    }

    [HttpGet]
    public IActionResult DangKy()
    {
        return View(new DangKyModel());
    }

    [HttpPost]
    public IActionResult DangKy(DangKyModel model)
    {
        if (string.IsNullOrEmpty(model.MatKhau) || model.MatKhau.Length < 12)
        {
            ModelState.AddModelError(nameof(model.MatKhau), "Mật khẩu phải có ít nhất 12 ký tự.");
        }
        if (ModelState.IsValid)
        {
            try
            {
                data.DangKy(model);
                TempData["ThongBao"] = "Đăng ký thành công. Bạn có thể đăng nhập.";
                return RedirectToAction(nameof(DangNhap));
            }
            catch (SqlException exception) when (exception.Number is 2601 or 2627)
            {
                ModelState.AddModelError("", WebErrors.ThongBao(exception));
            }
        }
        model.MatKhau = "";
        model.XacNhanMatKhau = "";
        ModelState.SetModelValue(nameof(model.MatKhau), "", "");
        ModelState.SetModelValue(nameof(model.XacNhanMatKhau), "", "");
        return View(model);
    }

    [Authorize(Roles = "KhachHang")]
    [HttpPost]
    public async Task<IActionResult> DangXuat()
    {
        await HttpContext.SignOutAsync();
        return RedirectToAction("Index", "Home");
    }

    [Authorize(Roles = "KhachHang")]
    [HttpGet]
    public IActionResult HoSo()
    {
        var row = data.HoSo(Id());
        if (row == null)
        {
            return Challenge();
        }
        return View(new HoSoModel
        {
            HoTen = (string)row["HoTen"],
            Email = row["Email"] as string,
            DienThoai = row["DienThoai"] as string,
            NgaySinh = row["NgaySinh"] as DateTime?
        });
    }

    [Authorize(Roles = "KhachHang")]
    [HttpPost]
    public async Task<IActionResult> HoSo(HoSoModel model)
    {
        if (model.NgaySinh > DateTime.UtcNow.AddHours(7).Date)
        {
            ModelState.AddModelError(nameof(model.NgaySinh), "Ngày sinh không được ở tương lai.");
        }
        if (ModelState.IsValid)
        {
            try
            {
                data.CapNhat(Id(), model);
                var row = data.HoSo(Id())!;
                await HttpContext.SignInAsync(KhachHangSession.TaoDanhTinh(
                    Id(), (string)row["HoTen"], (byte[])row["PhienTaiKhoan"]));
                TempData["ThongBao"] = "Đã cập nhật hồ sơ.";
                return RedirectToAction(nameof(HoSo));
            }
            catch (SqlException exception) when (exception.Number >= 50000 || exception.Number is 2601 or 2627)
            {
                ModelState.AddModelError("", WebErrors.ThongBao(exception));
            }
        }
        return View(model);
    }

    [Authorize(Roles = "KhachHang")]
    [HttpGet]
    public IActionResult DoiMatKhau()
    {
        return View(new DoiMatKhauModel());
    }

    [Authorize(Roles = "KhachHang")]
    [HttpPost]
    public async Task<IActionResult> DoiMatKhau(DoiMatKhauModel model)
    {
        if (ModelState.IsValid)
        {
            try
            {
                if (data.DoiMatKhau(Id(), model))
                {
                    await HttpContext.SignOutAsync();
                    TempData["ThongBao"] = "Đã đổi mật khẩu. Vui lòng đăng nhập lại.";
                    return RedirectToAction(nameof(DangNhap));
                }
                ModelState.AddModelError(nameof(model.MatKhauCu), "Mật khẩu hiện tại không đúng.");
            }
            catch (SqlException exception) when (exception.Number >= 50000)
            {
                ModelState.AddModelError("", WebErrors.ThongBao(exception));
            }
        }
        model.MatKhauCu = "";
        model.MatKhauMoi = "";
        model.XacNhanMatKhau = "";
        return View(model);
    }

    private int Id()
    {
        return int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    }
}
