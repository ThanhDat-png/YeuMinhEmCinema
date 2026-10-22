using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcBaoCaoThongKe : UserControl
    {
        public UcBaoCaoThongKe()
        {
            InitializeComponent();
            cboLoaiBaoCao.SelectedIndex = 0;
            dtpTuNgay.Value = DateTime.Today.AddDays(-7);
            dtpDenNgay.Value = DateTime.Today;
            NapBaoCaoMinhHoa();
        }

        private void NapBaoCaoMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("STT", typeof(int));
            dt.Columns.Add("Tên phim / Hạng mục", typeof(string));
            dt.Columns.Add("Số suất chiếu", typeof(int));
            dt.Columns.Add("Số vé bán ra", typeof(int));
            dt.Columns.Add("Doanh thu vé", typeof(string));
            dt.Columns.Add("Doanh thu F&B", typeof(string));
            dt.Columns.Add("Tổng doanh thu", typeof(string));
            dt.Columns.Add("Tỷ lệ đóng góp", typeof(string));

            dt.Rows.Add(1, "Mai", 48, 1120, "108.500.000 đ", "28.400.000 đ", "136.900.000 đ", "55.1 %");
            dt.Rows.Add(2, "Đào, Phở và Piano", 36, 850, "76.500.000 đ", "18.200.000 đ", "94.700.000 đ", "38.1 %");
            dt.Rows.Add(3, "Lật Mặt 7: Một Điều Ước", 28, 480, "43.200.000 đ", "11.600.000 đ", "54.800.000 đ", "22.0 %");
            dt.Rows.Add(4, "Dune: Hành Tinh Cát 2", 18, 260, "36.400.000 đ", "6.800.000 đ", "43.200.000 đ", "17.4 %");
            dt.Rows.Add(5, "Kung Fu Panda 4", 12, 130, "11.700.000 đ", "3.200.000 đ", "14.900.000 đ", "6.0 %");

            dgvBaoCao.DataSource = dt;
        }

        private void btnXemBaoCao_Click(object sender, EventArgs e)
        {
            NapBaoCaoMinhHoa();
            MessageBox.Show(
                $"Đã tổng hợp số liệu báo cáo từ ngày {dtpTuNgay.Value:dd/MM/yyyy} đến ngày {dtpDenNgay.Value:dd/MM/yyyy} (Dữ liệu minh họa).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng xuất báo cáo Excel / In ấn đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
