namespace YeuMinhEmCinema.Admin
{
    public partial class UcKiemTraVe : UserControl
    {
        public UcKiemTraVe()
        {
            InitializeComponent();
            txtMaVe.Text = "VE-1029-A";
        }

        private void btnKiemTra_Click(object sender, EventArgs e)
        {
            string ma = txtMaVe.Text.Trim();
            if (string.IsNullOrWhiteSpace(ma))
            {
                MessageBox.Show("Vui lòng nhập mã vé cần kiểm tra.", "Chưa nhập mã", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (ma.ToUpper().Contains("1029"))
            {
                lblTrangThaiVe.Text = "✔ VÉ HỢP LỆ — ĐỦ ĐIỀU KIỆN VÀO RẠP";
                lblTrangThaiVe.BackColor = Color.FromArgb(16, 185, 129);
                lblChiTietVe.Text =
                    $"• Mã vé: {ma.ToUpper()}\n" +
                    "• Phim: Đào, Phở và Piano (Giới hạn: T13)\n" +
                    "• Suất chiếu: 19:30 - Hôm nay (21/10/2026)\n" +
                    "• Cụm rạp: YeuMinhEm Landmark 81\n" +
                    "• Phòng chiếu: Phòng 01 (2D Digital)\n" +
                    "• Vị trí ghế: C5 (Ghế VIP)\n" +
                    "• Khách hàng: Trần Minh Quân (SĐT: 0901234567)\n" +
                    "• Dịch vụ kèm theo: 1x Combo Solo (Đã nhận tại quầy)\n\n" +
                    "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu)";
            }
            else
            {
                lblTrangThaiVe.Text = "✖ VÉ ĐÃ SỬ DỤNG HOẶC KHÔNG HỢP LỆ";
                lblTrangThaiVe.BackColor = Color.FromArgb(239, 68, 68);
                lblChiTietVe.Text =
                    $"• Mã vé: {ma.ToUpper()}\n" +
                    "• Trạng thái hệ thống: Vé không tồn tại trên hệ thống hoặc đã soát vé trước đó.\n" +
                    "• Vui lòng liên hệ quầy vé hỗ trợ kiểm tra lại.\n\n" +
                    "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu)";
            }
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng quét QR qua webcam hoặc xác nhận soát vé đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
