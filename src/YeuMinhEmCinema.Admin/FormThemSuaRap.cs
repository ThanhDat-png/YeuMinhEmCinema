using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class FormThemSuaRap : Form
    {
        private readonly int _maRap = 0;
        private readonly bool _laChucNangSua = false;

        /// <summary>
        /// Khởi tạo form ở chế độ Thêm cụm rạp mới.
        /// </summary>
        public FormThemSuaRap()
        {
            InitializeComponent();
            _laChucNangSua = false;
            lblTieuDeForm.Text = "🏛️ THÊM CỤM RẠP MỚI";
            btnLuu.Text = "Thêm rạp";
            cboTrangThai.SelectedIndex = 0; // "Đang hoạt động"
        }

        /// <summary>
        /// Khởi tạo form ở chế độ Sửa cụm rạp.
        /// </summary>
        public FormThemSuaRap(int maRap) : this()
        {
            _maRap = maRap;
            _laChucNangSua = true;
            lblTieuDeForm.Text = $"🏛️ CHỈNH SỬA CỤM RẠP (MÃ: {_maRap})";
            btnLuu.Text = "Cập nhật";

            TaiDuLieuRapCu();
        }

        private void TaiDuLieuRapCu()
        {
            try
            {
                DataRow? row = RapDAL.LayRapTheoMa(_maRap);
                if (row == null)
                {
                    MessageBox.Show(
                        $"Không tìm thấy dữ liệu của cụm rạp có mã {_maRap}.",
                        "Không tìm thấy",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                    Close();
                    return;
                }

                txtTenRap.Text = row["TenRap"]?.ToString() ?? "";
                txtDiaChi.Text = row["DiaChi"] != DBNull.Value ? row["DiaChi"].ToString() : "";

                string trangThai = row["TrangThai"]?.ToString() ?? "Đang hoạt động";
                int idxTrangThai = cboTrangThai.Items.IndexOf(trangThai);
                cboTrangThai.SelectedIndex = idxTrangThai >= 0 ? idxTrangThai : 0;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Lỗi khi nạp dữ liệu cụm rạp:\n" + ex.Message,
                    "Lỗi hệ thống",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                Close();
            }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            string tenRap = txtTenRap.Text.Trim();
            string diaChi = txtDiaChi.Text.Trim();
            string trangThai = cboTrangThai.SelectedItem?.ToString() ?? "Đang hoạt động";

            if (string.IsNullOrWhiteSpace(tenRap))
            {
                MessageBox.Show("Vui lòng nhập tên cụm rạp.", "Thiếu thông tin", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtTenRap.Focus();
                return;
            }

            bool thanhCong;
            string thongBao;

            if (_laChucNangSua)
            {
                (thanhCong, thongBao) = RapDAL.CapNhatRap(_maRap, tenRap, diaChi, trangThai);
            }
            else
            {
                (thanhCong, thongBao, _) = RapDAL.ThemRap(tenRap, diaChi, trangThai);
            }

            if (thanhCong)
            {
                MessageBox.Show(thongBao, "Thông báo thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
                DialogResult = DialogResult.OK;
                Close();
            }
            else
            {
                MessageBox.Show(thongBao, "Lỗi lưu cụm rạp", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}
