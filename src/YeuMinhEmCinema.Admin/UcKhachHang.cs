using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcKhachHang : UserControl
    {
        public UcKhachHang()
        {
            InitializeComponent();
            cboHangThanhVien.SelectedIndex = 0;
            NapKhachHangMinhHoa();
        }

        private void NapKhachHangMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã KH", typeof(string));
            dt.Columns.Add("Họ và tên", typeof(string));
            dt.Columns.Add("Số điện thoại", typeof(string));
            dt.Columns.Add("Email", typeof(string));
            dt.Columns.Add("Hạng thành viên", typeof(string));
            dt.Columns.Add("Điểm tích lũy", typeof(string));
            dt.Columns.Add("Tổng chi tiêu", typeof(string));
            dt.Columns.Add("Ngày đăng ký", typeof(string));

            dt.Rows.Add("KH001", "Trần Minh Quân", "0901234567", "quan.tran@gmail.com", "Diamond Club", "1.250 điểm", "8.500.000 đ", "12/01/2024");
            dt.Rows.Add("KH002", "Nguyễn Thu Hà", "0912345678", "ha.nguyen@yahoo.com", "VIP Member", "680 điểm", "4.200.000 đ", "15/03/2024");
            dt.Rows.Add("KH003", "Lê Văn Đạt", "0987654321", "dat.le@outlook.com", "Standard", "150 điểm", "950.000 đ", "05/06/2025");
            dt.Rows.Add("KH004", "Phạm Hoàng Yến", "0933445566", "yen.pham@gmail.com", "VIP Member", "820 điểm", "5.600.000 đ", "20/08/2024");
            dt.Rows.Add("KH005", "Vũ Minh Khang", "0977889900", "khang.vu@gmail.com", "Diamond Club", "1.890 điểm", "12.300.000 đ", "10/11/2023");
            dt.Rows.Add("KH006", "Đỗ Thị Mai", "0944556677", "mai.do@gmail.com", "Standard", "90 điểm", "600.000 đ", "02/09/2025");

            dgvKhachHang.DataSource = dt;
        }

        private void dgvKhachHang_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvKhachHang.CurrentRow == null) return;

            DataGridViewRow row = dgvKhachHang.CurrentRow;
            string ma = row.Cells["Mã KH"].Value?.ToString() ?? "";
            string ten = row.Cells["Họ và tên"].Value?.ToString() ?? "";
            string sdt = row.Cells["Số điện thoại"].Value?.ToString() ?? "";
            string email = row.Cells["Email"].Value?.ToString() ?? "";
            string hang = row.Cells["Hạng thành viên"].Value?.ToString() ?? "";
            string diem = row.Cells["Điểm tích lũy"].Value?.ToString() ?? "";
            string tongTien = row.Cells["Tổng chi tiêu"].Value?.ToString() ?? "";

            lblChiTietKhach.Text =
                $"• Khách hàng: {ten} ({ma}) | Hạng: {hang} | Điểm thưởng: {diem} | Tổng chi tiêu: {tongTien}\n" +
                $"• Liên hệ: {sdt} - Email: {email}\n" +
                $"• Lịch sử xem gần nhất: Đào, Phở và Piano (Suất 19:30, 2 vé VIP C5-C6) | Mai (Suất 20:00, 4 vé IMAX)\n" +
                $"• Ưu đãi khả dụng: 01 Vé sinh nhật miễn phí (tháng 11) + Voucher giảm 20% Combo F&B.\n" +
                $"(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu)";
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            NapKhachHangMinhHoa();
            MessageBox.Show(
                "Đã tìm kiếm danh sách khách hàng (Dữ liệu minh họa).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng thêm khách hàng mới đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
