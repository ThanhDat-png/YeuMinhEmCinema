using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcLichChieu : UserControl
    {
        public UcLichChieu()
        {
            InitializeComponent();
            cboRap.SelectedIndex = 0;
            cboPhim.SelectedIndex = 0;
            dtpNgayChieu.Value = DateTime.Today;
            NapLichChieuMinhHoa();
        }

        private void NapLichChieuMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã suất", typeof(string));
            dt.Columns.Add("Tên phim", typeof(string));
            dt.Columns.Add("Cụm rạp", typeof(string));
            dt.Columns.Add("Phòng chiếu", typeof(string));
            dt.Columns.Add("Định dạng", typeof(string));
            dt.Columns.Add("Giờ bắt đầu", typeof(string));
            dt.Columns.Add("Giờ kết thúc", typeof(string));
            dt.Columns.Add("Giá vé cơ bản", typeof(string));
            dt.Columns.Add("Ghế trống / Tổng", typeof(string));

            dt.Rows.Add("SC01", "Đào, Phở và Piano", "YeuMinhEm Landmark 81", "Phòng 01", "2D Phụ đề", "09:30", "11:10", "90.000 đ", "42 / 60");
            dt.Rows.Add("SC02", "Mai", "YeuMinhEm Landmark 81", "Phòng 02", "2D Lồng tiếng", "10:15", "12:25", "90.000 đ", "18 / 80");
            dt.Rows.Add("SC03", "Dune: Hành Tinh Cát 2", "YeuMinhEm Landmark 81", "Phòng 03", "IMAX Laser 2D", "11:00", "13:46", "140.000 đ", "5 / 120");
            dt.Rows.Add("SC04", "Lật Mặt 7: Một Điều Ước", "YeuMinhEm Vincom Đồng Khởi", "Phòng 01", "2D Phụ đề", "13:30", "15:48", "95.000 đ", "25 / 70");
            dt.Rows.Add("SC05", "Kung Fu Panda 4", "YeuMinhEm Vincom Đồng Khởi", "Phòng 02", "Gold Class 2D", "14:45", "16:20", "160.000 đ", "12 / 40");
            dt.Rows.Add("SC06", "Mai", "YeuMinhEm Thủ Đức", "Phòng 01", "2D Phụ đề", "18:00", "20:10", "85.000 đ", "8 / 80");
            dt.Rows.Add("SC07", "Đào, Phở và Piano", "YeuMinhEm Landmark 81", "Phòng 01", "2D Phụ đề", "19:30", "21:10", "100.000 đ", "0 / 60 (Hết vé)");
            dt.Rows.Add("SC08", "Dune: Hành Tinh Cát 2", "YeuMinhEm Landmark 81", "Phòng 03", "IMAX Laser 2D", "20:30", "23:16", "150.000 đ", "14 / 120");

            dgvLichChieu.DataSource = dt;
        }

        private void btnLoc_Click(object sender, EventArgs e)
        {
            NapLichChieuMinhHoa();
            MessageBox.Show(
                $"Đã lọc suất chiếu theo ngày {dtpNgayChieu.Value:dd/MM/yyyy} (Dữ liệu minh họa).",
                "Lọc dữ liệu",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng đang được phát triển (chưa có cơ sở dữ liệu cho quản lý suất chiếu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
