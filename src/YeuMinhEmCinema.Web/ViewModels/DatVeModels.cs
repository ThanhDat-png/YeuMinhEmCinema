using System.ComponentModel.DataAnnotations;
using System.Data;

namespace YeuMinhEmCinema.Web.ViewModels;

/// <summary>Chỉ nhận mã ghế, mã sản phẩm và số lượng; không nhận giá từ trình duyệt.</summary>
public class DatVeModel
{
    public int MaSuatChieu { get; set; }
    public Guid MaYeuCau { get; set; }
    public List<int> Ghe { get; set; } = [];
    public List<FnbChon> Fnb { get; set; } = [];

    [Required(ErrorMessage = "Nhập tên liên hệ.")]
    [StringLength(150)]
    public string HoTen { get; set; } = "";

    [RegularExpression(@"[0-9+() .-]{6,20}", ErrorMessage = "Số điện thoại không hợp lệ.")]
    public string? DienThoai { get; set; }

    public DataRow? Suat { get; set; }
    public DataTable SoDo { get; set; } = new();
    public DataTable Menu { get; set; } = new();
    public bool ChonBap { get; set; }
}

/// <summary>Một dòng bắp nước; số lượng 0 nghĩa là không mua.</summary>
public class FnbChon
{
    public int MaSanPham { get; set; }

    [Range(0, 99, ErrorMessage = "Số lượng từ 0 đến 99.")]
    public int SoLuong { get; set; }
}

/// <summary>Chi tiết snapshot SQL và các tùy chọn thanh toán server cho phép.</summary>
public class DonModel
{
    public DataSet ChiTiet { get; set; } = new();
    public bool ChoPhepMoPhong { get; set; }
}

/// <summary>Phân trang và lọc đơn cá nhân được thực hiện tại SQL.</summary>
public class LichSuModel
{
    public DataTable Don { get; set; } = new();
    public int Trang { get; set; } = 1;
    public int Tong { get; set; }
    public int TongTrang => (int)Math.Ceiling(Tong / 10.0);
    public string? TrangThai { get; set; }
}
