using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcGiaVeVaFnb : UserControl
    {
        public UcGiaVeVaFnb()
        {
            InitializeComponent();
            NapGiaVeMinhHoa();
            NapFnbMinhHoa();
        }

        private void NapGiaVeMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã loại vé", typeof(string));
            dt.Columns.Add("Loại ghế", typeof(string));
            dt.Columns.Add("Định dạng phòng", typeof(string));
            dt.Columns.Add("Ngày thường (T2 - T5)", typeof(string));
            dt.Columns.Add("Cuối tuần (T6 - CN) & Lễ", typeof(string));
            dt.Columns.Add("Ghi chú phụ thu", typeof(string));

            dt.Rows.Add("VE-STD-2D", "Ghế thường (Standard)", "2D Digital", "80.000 đ", "95.000 đ", "Áp dụng giá chuẩn");
            dt.Rows.Add("VE-VIP-2D", "Ghế VIP", "2D Digital", "90.000 đ", "110.000 đ", "+10.000 đ so với ghế thường");
            dt.Rows.Add("VE-SWT-2D", "Ghế đôi (Sweetbox)", "2D Digital", "190.000 đ / cặp", "230.000 đ / cặp", "Bao gồm 2 vị trí ngồi");
            dt.Rows.Add("VE-STD-3D", "Ghế thường (Standard)", "3D RealD", "110.000 đ", "130.000 đ", "Đã gồm kính 3D mượn");
            dt.Rows.Add("VE-IMAX-2D", "Ghế chuẩn IMAX", "IMAX Laser", "140.000 đ", "165.000 đ", "Màn chiếu cực đại Laser");
            dt.Rows.Add("VE-GOLD-2D", "Ghế thương gia (Gold Class)", "Gold Class", "180.000 đ", "220.000 đ", "Ghế massage + welcome drink");

            dgvGiaVe.DataSource = dt;
        }

        private void NapFnbMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã món", typeof(string));
            dt.Columns.Add("Tên sản phẩm / Combo", typeof(string));
            dt.Columns.Add("Phân loại", typeof(string));
            dt.Columns.Add("Kích cỡ", typeof(string));
            dt.Columns.Add("Đơn giá", typeof(string));
            dt.Columns.Add("Trạng thái", typeof(string));

            dt.Rows.Add("FNB01", "Bắp rang bơ phô mai", "Bắp rang", "Lớn (Large)", "55.000 đ", "Đang bán");
            dt.Rows.Add("FNB02", "Bắp rang bơ Caramel", "Bắp rang", "Lớn (Large)", "55.000 đ", "Đang bán");
            dt.Rows.Add("FNB03", "Coca Cola tươi", "Nước ngọt", "32oz (Lớn)", "35.000 đ", "Đang bán");
            dt.Rows.Add("FNB04", "Sprite tươi", "Nước ngọt", "32oz (Lớn)", "35.000 đ", "Đang bán");
            dt.Rows.Add("FNB05", "Combo Solo (1 Bắp + 1 Nước)", "Combo F&B", "Tiêu chuẩn", "79.000 đ", "Đang bán");
            dt.Rows.Add("FNB06", "Combo Couple (1 Bắp lớn + 2 Nước)", "Combo F&B", "Cặp đôi", "109.000 đ", "Bán chạy nhất");
            dt.Rows.Add("FNB07", "Combo Gia Đình (2 Bắp + 4 Nước + 1 Snack)", "Combo F&B", "Gia đình", "199.000 đ", "Đang bán");
            dt.Rows.Add("FNB08", "Snack khoai tây Lay's", "Đồ ăn nhẹ", "Gói 75g", "25.000 đ", "Đang bán");

            dgvFnb.DataSource = dt;
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng đang được phát triển (chưa có cơ sở dữ liệu cho giá vé và menu F&B).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
