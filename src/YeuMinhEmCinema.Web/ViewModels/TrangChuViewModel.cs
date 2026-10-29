using YeuMinhEmCinema.Web.Models;

namespace YeuMinhEmCinema.Web.ViewModels;

/// <summary>Giữ bộ lọc và dữ liệu hiển thị, không chứa thao tác SQL.</summary>
public class TrangChuViewModel
{
    public string? TuKhoa
    {
        get;
        set;
    }

    public string? TrangThai
    {
        get;
        set;
    }

    public int Trang
    {
        get;
        set;
    } = 1;

    public int TongKetQua
    {
        get;
        set;
    }

    public int TongTrang => (int)Math.Ceiling(TongKetQua / 12.0);

    public string? Loi
    {
        get;
        set;
    }

    public List<Phim> Phim
    {
        get;
        set;
    } = [];

    public List<Phim> PhimNoiBat
    {
        get;
        set;
    } = [];

    public List<Rap> Rap
    {
        get;
        set;
    } = [];
}
