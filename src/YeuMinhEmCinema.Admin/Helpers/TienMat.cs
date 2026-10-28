using System.Globalization;
using System.Text.RegularExpressions;

namespace YeuMinhEmCinema.Admin;

internal static class TienMat
{
    internal static decimal Doc(string text)
    {
        text = text.Trim();
        if (!Regex.IsMatch(text, @"^(?:[0-9]+|[0-9]{1,3}(?:\.[0-9]{3})+)$"))
            throw new ArgumentException("Nhập tiền khách đưa bằng số đồng, ví dụ 100000 hoặc 100.000; không nhập số âm hay phần lẻ.");
        string digits = text.Replace(".", "");
        if (!decimal.TryParse(digits, NumberStyles.None, CultureInfo.InvariantCulture, out decimal value)
            || value > 999999999999999999m)
            throw new ArgumentException("Tiền khách đưa vượt giới hạn 18 chữ số.");
        return value;
    }

    internal static decimal TienThua(decimal tong, string khachDua)
    {
        if (tong <= 0) throw new ArgumentException("Đơn hàng chưa có tổng tiền hợp lệ.");
        decimal tien = Doc(khachDua);
        if (tien < tong) throw new ArgumentException($"Khách đưa thiếu {tong - tien:N0} đ. Chưa thể xác nhận thu tiền.");
        return tien - tong;
    }
}
