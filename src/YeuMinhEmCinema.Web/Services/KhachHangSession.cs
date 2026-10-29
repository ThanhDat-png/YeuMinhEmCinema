using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using YeuMinhEmCinema.Web.Data;
using Microsoft.Data.SqlClient;

namespace YeuMinhEmCinema.Web.Services;

/// <summary>Cookie chỉ giữ định danh; mỗi request kiểm tra lại khóa và quyền trong SQL.</summary>
public class KhachHangSession : CookieAuthenticationEvents
{
    private readonly TaiKhoanData data;

    public KhachHangSession(TaiKhoanData data)
    {
        this.data = data;
    }

    public override async Task ValidatePrincipal(CookieValidatePrincipalContext context)
    {
        var hopLe = false;
        try
        {
            hopLe = int.TryParse(context.Principal?.FindFirstValue(ClaimTypes.NameIdentifier), out var id)
                && data.PhienHopLe(id, context.Principal?.FindFirstValue("PhienBan"));
        }
        catch (Exception exception) when (exception is SqlException or InvalidOperationException)
        {
            context.HttpContext.RequestServices.GetRequiredService<ILogger<KhachHangSession>>()
            .LogError("Không kiểm tra được phiên khách. Loại lỗi: {Loai}; mã SQL: {Ma}",
                exception.GetType().Name,
                (exception as SqlException)?.Number);
        }
        if (!hopLe)
        {
            context.RejectPrincipal();
            await context.HttpContext.SignOutAsync();
        }
    }

    /// <summary>Cookie mã hóa không chứa hash hay mật khẩu; rowversion giúp thu hồi phiên sau đổi mật khẩu.</summary>
    public static ClaimsPrincipal TaoDanhTinh(int id, string ten, byte[] phienBan)
    {
        var identity = new ClaimsIdentity(new []
            {
                new Claim(ClaimTypes.NameIdentifier, id.ToString()),
                new Claim(ClaimTypes.Name, ten),
                new Claim(ClaimTypes.Role, "KhachHang"),
                new Claim("PhienBan", Convert.ToBase64String(phienBan))
            },
            CookieAuthenticationDefaults.AuthenticationScheme);
        return new ClaimsPrincipal(identity);
    }

    public static string Bam(string matKhau)
    {
        return new PasswordHasher<object>().HashPassword(new object (), matKhau);
    }

    public static bool KiemTra(string hash, string matKhau)
    {
        try
        {
            return new PasswordHasher<object>().VerifyHashedPassword(new object (), hash, matKhau)
            != PasswordVerificationResult.Failed;
        }
        catch (Exception exception) when (exception is FormatException or ArgumentException or IndexOutOfRangeException)
        {
            return false;
        }
    }
}
