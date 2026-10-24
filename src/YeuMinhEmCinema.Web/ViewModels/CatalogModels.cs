using System.Data;

namespace YeuMinhEmCinema.Web.ViewModels;

/// <summary>Dữ liệu công khai của trang phim và lịch chiếu, không chứa thông tin tài khoản.</summary>
public class LichModel
{
    public int? MaPhim { get; set; }
    public int? MaRap { get; set; }
    public DateTime Ngay { get; set; } = DateTime.UtcNow.AddHours(7).Date;
    public DataTable DanhSachPhim { get; set; } = new();
    public DataTable Rap { get; set; } = new();
    public DataTable Lich { get; set; } = new();
    public bool XemGanNhat { get; set; }
    public DataRow? Phim { get; set; }
}
