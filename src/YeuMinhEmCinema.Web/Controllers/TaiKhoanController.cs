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
        return View(new DangNhapModel
        {
            ReturnUrl = returnUrl
        });
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
                ModelState.AddModelError("",
                    "Thông tin không đúng hoặc tài khoản khách đang bị khóa/ngừng hoạt động.");
            }
            catch (SqlException exception) when (exception.Number >= 50000 && exception.Number < 51000)
            {
                ModelState.AddModelError("",
                    "Chưa đăng nhập được. Kiểm tra thông tin hoặc chờ hết thời gian khóa.");
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

    /// <summary>Ảnh đại diện chỉ được đọc bởi chính tài khoản đang đăng nhập.</summary>
    [Authorize(Roles = "KhachHang")]
    [HttpGet]
    [ResponseCache(NoStore = true, Location = ResponseCacheLocation.None)]
    public IActionResult AnhDaiDien()
    {
        var path = DuongDanAnh();
        if (!System.IO.File.Exists(path))
        {
            return Redirect("~/images/brand-mascot.png");
        }
        var bytes = System.IO.File.ReadAllBytes(path);
        var type = KieuAnh(bytes);
        if (type == null)
        {
            return Redirect("~/images/brand-mascot.png");
        }
        Response.Headers["X-Content-Type-Options"] = "nosniff";
        return File(bytes, type);
    }

    /// <summary>Không dùng tên file khách gửi; giới hạn PNG/JPEG 2 MB và lưu ngoài wwwroot.</summary>
    [Authorize(Roles = "KhachHang")]
    [HttpPost]
    [RequestSizeLimit(3 * 1024 * 1024)]
    public async Task<IActionResult> DoiAnh(IFormFile? anh)
    {
        if (anh == null || anh.Length == 0 || anh.Length > 2 * 1024 * 1024)
        {
            TempData["ThongBao"] = "Chọn ảnh PNG hoặc JPEG, dung lượng tối đa 2 MB.";
            return RedirectToAction(nameof(HoSo));
        }
        using var stream = new MemoryStream();
        await anh.CopyToAsync(stream);
        var bytes = stream.ToArray();
        if (KieuAnh(bytes) == null)
        {
            TempData["ThongBao"] = "File không có định dạng PNG/JPEG hợp lệ.";
            return RedirectToAction(nameof(HoSo));
        }
        var path = DuongDanAnh();
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        // File tạm riêng cho mỗi request tránh hai lần tải đồng thời ghi đè dở dang.
        var temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            await System.IO.File.WriteAllBytesAsync(temporary, bytes);
            System.IO.File.Move(temporary, path, true);
        }
        finally
        {
            if (System.IO.File.Exists(temporary))
            {
                System.IO.File.Delete(temporary);
            }
        }
        TempData["ThongBao"] = "Đã cập nhật ảnh đại diện.";
        return RedirectToAction(nameof(HoSo));
    }

    private string DuongDanAnh()
    {
        var environment = HttpContext.RequestServices.GetRequiredService<IWebHostEnvironment>();
        return Path.Combine(environment.ContentRootPath, "App_Data", "Avatars", Id() + ".bin");
    }

    private static string? KieuAnh(byte[] bytes)
    {
        if (bytes.Length >= 24 && bytes.AsSpan(0, 8).SequenceEqual(new byte[]
        {
            137,
            80,
            78,
            71,
            13,
            10,
            26,
            10
        }))
        {
            return "image/png";
        }
        if (bytes.Length >= 4 && bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255
            && bytes[^ 2] == 255
            && bytes[^ 1] == 217)
        {
            return "image/jpeg";
        }
        return null;
    }

    private int Id()
    {
        return int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    }
}
