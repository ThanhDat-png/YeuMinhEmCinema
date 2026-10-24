using System.Globalization;

namespace YeuMinhEmCinema.Web.Services;

/// <summary>Chuyển mã trạng thái nội bộ và thời gian SQL sang nội dung khách hàng dễ đọc.</summary>
public static class HienThi
{
    public static string Tien(object value)
    {
        return Convert.ToDecimal(value).ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + " đ";
    }

    public static string TrangThai(object value)
    {
        return value.ToString() switch
        {
            "CHO_THANH_TOAN" => "Chờ thanh toán",
            "DA_THANH_TOAN" => "Đã thanh toán",
            "DA_HUY" => "Đã hủy",
            "HET_HAN" => "Hết hạn",
            "DA_HOAN_TIEN" => "Đã hoàn tiền",
            "HIEU_LUC" => "Còn hiệu lực",
            "DA_SU_DUNG" => "Đã sử dụng",
            _ => "Không xác định"
        };
    }

    public static string GioUtc(object value)
    {
        return Convert.ToDateTime(value).AddHours(7).ToString("dd/MM/yyyy HH:mm:ss");
    }

    /// <summary>Chỉ mở trailer YouTube/Vimeo qua liên kết ngoài, không nhúng HTML tùy ý.</summary>
    public static string? Trailer(object value)
    {
        if (Uri.TryCreate(value as string, UriKind.Absolute, out var uri)
            && uri.Scheme == "https" && string.IsNullOrEmpty(uri.UserInfo)
            && uri.Host is "youtube.com" or "www.youtube.com" or "youtu.be" or "vimeo.com" or "www.vimeo.com")
        {
            return uri.AbsoluteUri;
        }
        return null;
    }
}
