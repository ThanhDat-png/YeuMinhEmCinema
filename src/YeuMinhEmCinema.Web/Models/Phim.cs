namespace YeuMinhEmCinema.Web.Models;

/// <summary>Thông tin công khai từ thủ tục danh sách phim hiện có.</summary>
public class Phim
{
    public int MaPhim { get; set; }
    public string TenPhim { get; set; } = "";
    public int ThoiLuong { get; set; }
    public DateTime NgayKhoiChieu { get; set; }
    public string GioiHanTuoi { get; set; } = "";
    public string TrangThai { get; set; } = "";
    public string? Poster { get; set; }

    // Chỉ cho phép ảnh HTTP(S) hoặc đường dẫn bên trong wwwroot.
    // Đường dẫn ổ đĩa của WinForms không phải địa chỉ ảnh trên Web.
    public string AnhPoster
    {
        get
        {
            if (!string.IsNullOrWhiteSpace(Poster))
            {
                if (Poster.StartsWith('/') && !Poster.StartsWith("//") && !Poster.Contains('\\'))
                {
                    return Poster;
                }
                if (Uri.TryCreate(Poster, UriKind.Absolute, out var uri) &&
                    (uri.Scheme == "https" || uri.Scheme == "http"))
                {
                    return uri.AbsoluteUri;
                }
            }
            return "/images/poster-placeholder.svg";
        }
    }
}
