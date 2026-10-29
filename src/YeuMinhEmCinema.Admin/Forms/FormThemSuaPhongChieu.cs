using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class FormThemSuaPhongChieu : Form
    {
        private readonly int _maPhong = 0;
        private readonly int _maRapMacDinh = 0;
        private readonly bool _laChucNangSua = false;

        /// <summary>
        /// Khởi tạo form ở chế độ Thêm phòng chiếu mới.
        /// </summary>
        public FormThemSuaPhongChieu(int maRapMacDinh = 0)
        {
            InitializeComponent();
            _maRapMacDinh = maRapMacDinh;
            _laChucNangSua = false;

            lblTieuDeForm.Text = "🎬 THÊM PHÒNG CHIẾU MỚI";
            btnLuu.Text = "Thêm phòng";

            NapDanhSachRap();

            cboDinhDang.SelectedIndex = 0; // 2D Digital
            cboTrangThai.SelectedIndex = 0; // Đang hoạt động
        }

        /// <summary>
        /// Khởi tạo form ở chế độ Sửa phòng chiếu.
        /// </summary>
        public FormThemSuaPhongChieu(int maPhong, bool laChucNangSua) : this()
        {
            _maPhong = maPhong;
            _laChucNangSua = true;

            lblTieuDeForm.Text = $"🎬 CHỈNH SỬA PHÒNG CHIẾU (MÃ: {_maPhong})";
            btnLuu.Text = "Cập nhật";

            TaiDuLieuPhongCu();
        }

        private void NapDanhSachRap()
        {
            try
            {
                DataTable dtRap = RapDAL.LayDanhSachRap();
                cboRap.DataSource = dtRap;
                cboRap.DisplayMember = "TenRap";
                cboRap.ValueMember = "MaRap";

                if (_maRapMacDinh > 0)
                {
                    cboRap.SelectedValue = _maRapMacDinh;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Lỗi khi tải danh sách cụm rạp:\n" + ex.Message,
                    "Lỗi nạp dữ liệu",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void TaiDuLieuPhongCu()
        {
            try
            {
                DataRow? row = PhongChieuDAL.LayPhongTheoMa(_maPhong);
                if (row == null)
                {
                    MessageBox.Show(
                        $"Không tìm thấy dữ liệu phòng chiếu có mã {_maPhong}.",
                        "Không tìm thấy",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                    Close();
                    return;
                }

                if (row["MaRap"] != DBNull.Value)
                {
                    cboRap.SelectedValue = Convert.ToInt32(row["MaRap"]);
                }

                txtTenPhong.Text = row["TenPhong"]?.ToString() ?? "";

                string dinhDang = row["DinhDang"]?.ToString() ?? "2D Digital";
                int idxDinhDang = cboDinhDang.Items.IndexOf(dinhDang);
                if (idxDinhDang < 0)
                {
                    cboDinhDang.Items.Add(dinhDang);
                    idxDinhDang = cboDinhDang.Items.Count - 1;
                }
                cboDinhDang.SelectedIndex = idxDinhDang;

                string trangThai = row["TrangThai"]?.ToString() ?? "Đang hoạt động";
                int idxTrangThai = cboTrangThai.Items.IndexOf(trangThai);
                cboTrangThai.SelectedIndex = idxTrangThai >= 0 ? idxTrangThai : 0;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Lỗi khi nạp dữ liệu phòng chiếu:\n" + ex.Message,
                    "Lỗi hệ thống",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                Close();
            }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (cboRap.SelectedValue == null)
            {
                MessageBox.Show("Vui lòng chọn cụm rạp cho phòng chiếu.",
                    "Thiếu thông tin",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                cboRap.Focus();
                return;
            }

            int maRap = Convert.ToInt32(cboRap.SelectedValue);
            string tenPhong = txtTenPhong.Text.Trim();
            string dinhDang = cboDinhDang.SelectedItem?.ToString() ?? "2D Digital";
            string trangThai = cboTrangThai.SelectedItem?.ToString() ?? "Đang hoạt động";

            if (string.IsNullOrWhiteSpace(tenPhong))
            {
                MessageBox.Show("Vui lòng nhập tên phòng chiếu.",
                    "Thiếu thông tin",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                txtTenPhong.Focus();
                return;
            }

            bool thanhCong;
            string thongBao;

            if (_laChucNangSua)
            {
                (thanhCong, thongBao) = PhongChieuDAL.CapNhatPhong(_maPhong, maRap, tenPhong, dinhDang, trangThai);
            }
            else
            {
                (thanhCong, thongBao, _) = PhongChieuDAL.ThemPhong(maRap, tenPhong, dinhDang, trangThai);
            }

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
                    "Lỗi lưu phòng chiếu",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}
