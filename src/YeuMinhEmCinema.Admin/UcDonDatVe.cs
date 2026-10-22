using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcDonDatVe : UserControl
    {
        public UcDonDatVe()
        {
            InitializeComponent();
            cboTrangThai.SelectedIndex = 0;
            NapDonHangMinhHoa();
        }

        private void NapDonHangMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã đơn", typeof(string));
            dt.Columns.Add("Thời gian đặt", typeof(string));
            dt.Columns.Add("Tên khách hàng", typeof(string));
            dt.Columns.Add("Số điện thoại", typeof(string));
            dt.Columns.Add("Tên phim", typeof(string));
            dt.Columns.Add("Suất chiếu", typeof(string));
            dt.Columns.Add("Phòng chiếu", typeof(string));
            dt.Columns.Add("Ghế ngồi", typeof(string));
            dt.Columns.Add("Combo F&B", typeof(string));
            dt.Columns.Add("Tổng tiền", typeof(string));
            dt.Columns.Add("Phương thức", typeof(string));
            dt.Columns.Add("Trạng thái", typeof(string));

            dt.Rows.Add("DH1029", "21/10/2026 15:45", "Trần Minh Quân", "0901234567", "Đào, Phở và Piano", "19:30", "Phòng 01 (2D)", "C5, C6", "Combo Solo", "259.000 đ", "Momo", "Đã thanh toán");
            dt.Rows.Add("DH1028", "21/10/2026 15:30", "Nguyễn Thu Hà", "0912345678", "Mai", "20:00", "Phòng 03 (IMAX)", "D7, D8, D9, D10", "Combo Couple", "589.000 đ", "Thẻ ATM", "Đã thanh toán");
            dt.Rows.Add("DH1027", "21/10/2026 15:12", "Lê Văn Đạt", "0987654321", "Lật Mặt 7: Một Điều Ước", "18:15", "Phòng 02 (2D)", "B4", "Không có", "90.000 đ", "Tiền mặt tại quầy", "Đã thanh toán");
            dt.Rows.Add("DH1026", "21/10/2026 14:50", "Phạm Hoàng Yến", "0933445566", "Kung Fu Panda 4", "17:00", "Phòng 01 (2D)", "E1, E2, E3", "2 Bắp ngọt lớn", "380.000 đ", "ZaloPay", "Đã thanh toán");
            dt.Rows.Add("DH1025", "21/10/2026 14:20", "Vũ Minh Khang", "0977889900", "Dune: Hành Tinh Cát 2", "16:30", "Phòng 03 (IMAX)", "F5, F6", "Combo Couple", "389.000 đ", "VNPay", "Đã thanh toán");
            dt.Rows.Add("DH1024", "21/10/2026 13:40", "Đỗ Thị Mai", "0944556677", "Mai", "19:00", "Phòng 02 (2D)", "A1, A2", "Không có", "180.000 đ", "Trực tuyến", "Đang giữ chỗ");
            dt.Rows.Add("DH1023", "21/10/2026 12:15", "Bùi Quốc Anh", "0966112233", "Godzilla x Kong", "15:00", "Phòng 01 (2D)", "B8", "Không có", "90.000 đ", "Chưa thanh toán", "Đã hủy");

            dgvDonHang.DataSource = dt;
        }

        private void btnLoc_Click(object sender, EventArgs e)
        {
            NapDonHangMinhHoa();
            MessageBox.Show(
                "Đã lọc danh sách đơn hàng theo từ khóa và trạng thái (Dữ liệu minh họa).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void btnChiTiet_Click(object sender, EventArgs e)
        {
            if (dgvDonHang.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn một đơn hàng trong danh sách để xem chi tiết.", "Chưa chọn dòng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DataGridViewRow row = dgvDonHang.CurrentRow;
            string maDon = row.Cells["Mã đơn"].Value?.ToString() ?? "";
            string tenKhach = row.Cells["Tên khách hàng"].Value?.ToString() ?? "";
            string sdt = row.Cells["Số điện thoại"].Value?.ToString() ?? "";
            string tenPhim = row.Cells["Tên phim"].Value?.ToString() ?? "";
            string suat = row.Cells["Suất chiếu"].Value?.ToString() ?? "";
            string phong = row.Cells["Phòng chiếu"].Value?.ToString() ?? "";
            string ghe = row.Cells["Ghế ngồi"].Value?.ToString() ?? "";
            string fnb = row.Cells["Combo F&B"].Value?.ToString() ?? "";
            string tongTien = row.Cells["Tổng tiền"].Value?.ToString() ?? "";
            string pttt = row.Cells["Phương thức"].Value?.ToString() ?? "";
            string trangThai = row.Cells["Trạng thái"].Value?.ToString() ?? "";

            string chiTiet =
                $"═══════════════════════════════════════\n" +
                $"   HÓA ĐƠN VÉ XEM PHIM YEUMINHEM CINEMA\n" +
                $"═══════════════════════════════════════\n\n" +
                $"• Mã đơn hàng: {maDon}\n" +
                $"• Khách hàng: {tenKhach} (SĐT: {sdt})\n" +
                $"• Phim: {tenPhim}\n" +
                $"• Suất chiếu: {suat} - {phong}\n" +
                $"• Vị trí ghế: {ghe}\n" +
                $"• Dịch vụ kèm theo: {fnb}\n" +
                $"• Phương thức thanh toán: {pttt}\n" +
                $"• Trạng thái: {trangThai}\n\n" +
                $"───────────────────────────────────────\n" +
                $"▶ TỔNG THANH TOÁN: {tongTien}\n" +
                $"───────────────────────────────────────\n\n" +
                $"(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu)";

            MessageBox.Show(chiTiet, $"Chi tiết đơn hàng {maDon}", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng in vé đang được phát triển (chưa có kết nối máy in vé nhiệt hoặc cơ sở dữ liệu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
