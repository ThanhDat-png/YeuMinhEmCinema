using Microsoft.AspNetCore.Identity;

namespace YeuMinhEmCinema.Admin
{
    internal static class BaoMatMatKhau
    {
        // PasswordHasher tự tạo salt và lưu thông tin cần thiết
        // trong chuỗi băm để kiểm tra mật khẩu sau này.
        private static readonly PasswordHasher<object> BoBam = new();
        private static readonly object NguoiDung = new();

        public static string TaoHash(string matKhau)
        {
            ArgumentNullException.ThrowIfNull(matKhau);

            if (matKhau.Length < 12)
            {
                throw new ArgumentException(
                    "Mật khẩu phải có ít nhất 12 ký tự.");
            }

            return BoBam.HashPassword(NguoiDung, matKhau);
        }

        public static PasswordVerificationResult KiemTra(
            string matKhauHash,
            string matKhauNhap)
        {
            if (string.IsNullOrEmpty(matKhauHash) ||
                string.IsNullOrEmpty(matKhauNhap))
            {
                return PasswordVerificationResult.Failed;
            }

            try
            {
                return BoBam.VerifyHashedPassword(
                    NguoiDung,
                    matKhauHash,
                    matKhauNhap);
            }
            catch (Exception ex) when (ex is FormatException or ArgumentException or IndexOutOfRangeException)
            {
                return PasswordVerificationResult.Failed;
            }
        }
    }
}