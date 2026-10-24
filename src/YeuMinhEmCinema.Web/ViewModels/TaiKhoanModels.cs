using System.ComponentModel.DataAnnotations;

namespace YeuMinhEmCinema.Web.ViewModels;

/// <summary>Chỉ nhận trường cho khách hàng, không nhận vai trò hoặc mã tài khoản từ form.</summary>
public class DangNhapModel
{
    [Required(ErrorMessage = "Nhập tên đăng nhập.")]
    [RegularExpression(@"[a-zA-Z0-9_.-]{3,50}", ErrorMessage = "Tên đăng nhập gồm 3–50 chữ không dấu, số, dấu chấm, gạch ngang hoặc gạch dưới.")]
    public string TenDangNhap { get; set; } = "";

    [Required(ErrorMessage = "Nhập mật khẩu.")]
    [StringLength(200, ErrorMessage = "Mật khẩu tối đa 200 ký tự.")]
    [DataType(DataType.Password)]
    public string MatKhau { get; set; } = "";

    public string? ReturnUrl { get; set; }
}

/// <summary>Dữ liệu đăng ký, kiểm tra bằng DataAnnotations ở server.</summary>
public class DangKyModel : DangNhapModel
{
    [Required(ErrorMessage = "Nhập họ tên.")]
    [StringLength(150, ErrorMessage = "Họ tên tối đa 150 ký tự.")]
    public string HoTen { get; set; } = "";

    [EmailAddress(ErrorMessage = "Email không hợp lệ.")]
    [StringLength(254)]
    public string? Email { get; set; }

    [RegularExpression(@"[0-9+() .-]{6,20}", ErrorMessage = "Số điện thoại gồm 6–20 ký tự hợp lệ.")]
    public string? DienThoai { get; set; }

    [Compare(nameof(MatKhau), ErrorMessage = "Xác nhận mật khẩu không khớp.")]
    [DataType(DataType.Password)]
    public string XacNhanMatKhau { get; set; } = "";
}

/// <summary>Hồ sơ thuộc tài khoản đang đăng nhập; mã chủ hồ sơ lấy từ cookie xác thực.</summary>
public class HoSoModel
{
    [EmailAddress(ErrorMessage = "Email không hợp lệ.")]
    [StringLength(254)]
    public string? Email { get; set; }

    [Required(ErrorMessage = "Nhập họ tên.")]
    [StringLength(150)]
    public string HoTen { get; set; } = "";

    [RegularExpression(@"[0-9+() .-]{6,20}", ErrorMessage = "Số điện thoại không hợp lệ.")]
    public string? DienThoai { get; set; }

    [DataType(DataType.Date)]
    public DateTime? NgaySinh { get; set; }
}

/// <summary>Đổi mật khẩu yêu cầu mật khẩu cũ và xác nhận mật khẩu mới.</summary>
public class DoiMatKhauModel
{
    [Required(ErrorMessage = "Nhập mật khẩu hiện tại.")]
    [StringLength(200)]
    [DataType(DataType.Password)]
    public string MatKhauCu { get; set; } = "";

    [Required(ErrorMessage = "Nhập mật khẩu mới.")]
    [StringLength(200, MinimumLength = 12, ErrorMessage = "Mật khẩu mới gồm 12–200 ký tự.")]
    [DataType(DataType.Password)]
    public string MatKhauMoi { get; set; } = "";

    [Compare(nameof(MatKhauMoi), ErrorMessage = "Xác nhận mật khẩu không khớp.")]
    [DataType(DataType.Password)]
    public string XacNhanMatKhau { get; set; } = "";
}
