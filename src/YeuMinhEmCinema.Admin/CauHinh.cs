namespace YeuMinhEmCinema.Admin
{
    /// <summary>
    /// Cấu hình dùng chung cho toàn bộ ứng dụng YeuMinhEm Cinema Admin.
    /// Quản lý chuỗi kết nối cơ sở dữ liệu tại một nơi duy nhất.
    /// </summary>
    public static class CauHinh
    {
        /// <summary>
        /// Chuỗi kết nối đến SQL Server cục bộ YeuMinhEmCinema.
        /// </summary>
        public static string ChuoiKetNoi { get; set; } =
            @"Server=.\SQLEXPRESS;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;";
    }
}
