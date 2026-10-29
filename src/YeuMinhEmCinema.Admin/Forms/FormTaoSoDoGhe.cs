using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class FormTaoSoDoGhe : Form
    {
        private readonly int _maPhong;
        private readonly string _tenPhong;
        private readonly string _tenRap;

        public FormTaoSoDoGhe(int maPhong, string tenPhong, string tenRap)
        {
            InitializeComponent();
            _maPhong = maPhong;
            _tenPhong = tenPhong;
            _tenRap = tenRap;

            lblThongTinPhong.Text = $"🎬 Phòng: {_tenPhong} | Cụm rạp: {_tenRap}";
            CapNhatSoGheHienTai();
            NapDanhSachLoaiGhe();
            CapNhatGiaiThichHang();
        }

        private void CapNhatSoGheHienTai()
        {
            int soGhe = GheDAL.DemSoGheCuaPhong(_maPhong);
            lblSoGheHienTai.Text = $"Số ghế hiện có trong phòng: {soGhe} ghế";
        }

        private void NapDanhSachLoaiGhe()
        {
            try
            {
                DataTable dtLoai = GheDAL.LayDanhSachLoaiGhe();
                cboLoaiGheMacDinh.DataSource = dtLoai;
                cboLoaiGheMacDinh.DisplayMember = "TenLoai";
                cboLoaiGheMacDinh.ValueMember = "MaLoai";

                if (cboLoaiGheMacDinh.Items.Count > 0)
                {
                    cboLoaiGheMacDinh.SelectedIndex = 0;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi nạp danh sách loại ghế:\n" + ex.Message,
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void CapNhatGiaiThichHang()
        {
            int soHang = (int)numSoHang.Value;
            char hangDau = 'A';
            char hangCuoi = (char)('A' + soHang - 1);
            lblGiaiThichHang.Text = $"(Tương ứng các hàng ghế từ {hangDau} đến {hangCuoi})";
        }

        private void numSoHang_ValueChanged(object sender, EventArgs e)
        {
            CapNhatGiaiThichHang();
        }

        private void btnTaoSoDo_Click(object sender, EventArgs e)
        {
            int soHang = (int)numSoHang.Value;
            int soGheMoiHang = (int)numSoGheMoiHang.Value;

            if (cboLoaiGheMacDinh.SelectedValue == null)
            {
                MessageBox.Show("Vui lòng chọn loại ghế mặc định.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }

            int maLoaiGhe = Convert.ToInt32(cboLoaiGheMacDinh.SelectedValue);

            DialogResult xacNhan = MessageBox.Show(
                $"Bạn có chắc chắn muốn tạo sơ đồ gồm {soHang} hàng và {soGheMoiHang} ghế/hàng cho phòng '{_tenPhong}'?\n\n(Hệ thống bảo đảm giữ nguyên toàn bộ ghế đã có, không xóa hoặc ghi đè).",
                "Xác nhận tạo sơ đồ ghế",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (xacNhan != DialogResult.Yes)
                return;

            var (thanhCong, thongBao, soGheDaTao, soGheBoQua) = GheDAL.TaoSoDoGhe(_maPhong, soHang, soGheMoiHang, maLoaiGhe);

            if (thanhCong)
            {
                MessageBox.Show(thongBao,
                    "Thông báo thành công",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
                DialogResult = DialogResult.OK;
                Close();
            }
            else
            {
                MessageBox.Show(thongBao,
                    "Lỗi tạo sơ đồ ghế",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnDong_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}
