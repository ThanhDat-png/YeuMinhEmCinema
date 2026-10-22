using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcTongQuan : UserControl
    {
        public UcTongQuan()
        {
            InitializeComponent();
            NapDuLieuMinhHoa();
        }

        private void NapDuLieuMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã đơn", typeof(string));
            dt.Columns.Add("Khách hàng", typeof(string));
            dt.Columns.Add("Tên phim", typeof(string));
            dt.Columns.Add("Suất chiếu", typeof(string));
            dt.Columns.Add("Phòng", typeof(string));
            dt.Columns.Add("Số vé", typeof(int));
            dt.Columns.Add("Tổng tiền", typeof(string));
            dt.Columns.Add("Thời gian đặt", typeof(string));
            dt.Columns.Add("Trạng thái", typeof(string));

            dt.Rows.Add("DH1029", "Trần Minh Quân", "Đào, Phở và Piano", "19:30", "Phòng 01 (2D)", 2, "180.000 đ", "10 phút trước", "Đã thanh toán");
            dt.Rows.Add("DH1028", "Nguyễn Thu Hà", "Mai", "20:00", "Phòng 03 (IMAX)", 4, "480.000 đ", "25 phút trước", "Đã thanh toán");
            dt.Rows.Add("DH1027", "Lê Văn Đạt", "Lật Mặt 7: Một Điều Ước", "18:15", "Phòng 02 (2D)", 1, "90.000 đ", "42 phút trước", "Đã thanh toán");
            dt.Rows.Add("DH1026", "Phạm Hoàng Yến", "Kung Fu Panda 4", "17:00", "Phòng 01 (2D)", 3, "270.000 đ", "1 giờ trước", "Đã thanh toán");
            dt.Rows.Add("DH1025", "Vũ Minh Khang", "Dune: Hành Tinh Cát 2", "16:30", "Phòng 03 (IMAX)", 2, "260.000 đ", "2 giờ trước", "Đã thanh toán");

            dgvDonHangGanDay.DataSource = dt;
        }
    }
}
