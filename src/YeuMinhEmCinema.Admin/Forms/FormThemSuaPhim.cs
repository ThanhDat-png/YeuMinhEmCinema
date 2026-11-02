using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class FormThemSuaPhim : Form
    {
        private readonly int _maPhim = 0;
        private readonly bool _laChucNangSua = false;

        /// <summary>
        /// Khởi tạo form ở chế độ Thêm phim mới.
        /// </summary>
        public FormThemSuaPhim()
        {
            InitializeComponent();
            _laChucNangSua = false;
            lblTieuDeForm.Text = "🎬 THÊM PHIM MỚI VÀO HỆ THỐNG";
            btnLuu.Text = "Thêm phim";

            // Giá trị mặc định
            cboGioiHanTuoi.SelectedIndex = 0; // P
            cboTrangThai.SelectedIndex = 0; // Sắp chiếu
            dtpNgayKhoiChieu.Value = DateTime.Today;
        }

        /// <summary>
        /// Khởi tạo form ở chế độ Sửa thông tin phim.
        /// </summary>
        /// <param name="maPhim">Mã phim cần chỉnh sửa</param>
        public FormThemSuaPhim(int maPhim) : this()
        {
            _maPhim = maPhim;
            _laChucNangSua = true;
            lblTieuDeForm.Text = $"🎬 CHỈNH SỬA PHIM (MÃ PHIM: {_maPhim})";
            btnLuu.Text = "Cập nhật";

            TaiDuLieuPhimCu();
        }

        /// <summary>
        /// Nạp thông tin phim hiện có từ cơ sở dữ liệu lên giao diện để chỉnh sửa.
        /// </summary>
        private void TaiDuLieuPhimCu()
        {
            try
            {
                DataRow? row = PhimDAL.LayPhimTheoMa(_maPhim);
                if (row == null)
                {
                    MessageBox.Show(
                        $"Không tìm thấy dữ liệu của phim có mã {_maPhim}.",
                        "Không tìm thấy",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                    Close();
                    return;
                }

                txtTenPhim.Text = row["TenPhim"]?.ToString() ?? "";
                numThoiLuong.Value = Convert.ToDecimal(row["ThoiLuong"]);

                if (row["NgayKhoiChieu"] != DBNull.Value)
                {
                    dtpNgayKhoiChieu.Value = Convert.ToDateTime(row["NgayKhoiChieu"]);
                }

                string tuoi = row["GioiHanTuoi"]?.ToString() ?? "P";
                int idxTuoi = cboGioiHanTuoi.Items.IndexOf(tuoi);
                cboGioiHanTuoi.SelectedIndex = idxTuoi >= 0 ? idxTuoi : 0;

                string trangThai = row["TrangThai"]?.ToString() ?? "Sắp chiếu";
                int idxTrangThai = cboTrangThai.Items.IndexOf(trangThai);
                cboTrangThai.SelectedIndex = idxTrangThai >= 0 ? idxTrangThai : 0;

                txtPoster.Text = row["Poster"] != DBNull.Value ? row["Poster"].ToString() : "";
                txtTrailer.Text = row["Trailer"] != DBNull.Value ? row["Trailer"].ToString() : "";
                txtMoTa.Text = row["MoTa"] != DBNull.Value ? row["MoTa"].ToString() : "";
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Lỗi khi nạp dữ liệu phim:\n" + ex.Message,
                    "Lỗi hệ thống",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                Close();
            }
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút Lưu phim (Thêm hoặc Cập nhật).
        /// </summary>
        private void btnLuu_Click(object sender, EventArgs e)
        {
            string tenPhim = txtTenPhim.Text.Trim();
            int thoiLuong = (int)numThoiLuong.Value;
            DateTime ngayKhoiChieu = dtpNgayKhoiChieu.Value;
            string gioiHanTuoi = cboGioiHanTuoi.SelectedItem?.ToString() ?? "P";
            string trangThai = cboTrangThai.SelectedItem?.ToString() ?? "Sắp chiếu";
            string poster = txtPoster.Text.Trim();
            string trailer = txtTrailer.Text.Trim();
            string moTa = txtMoTa.Text.Trim();

            // Kiểm tra tính hợp lệ cơ bản
            if (string.IsNullOrWhiteSpace(tenPhim))
            {
                MessageBox.Show("Vui lòng nhập tên phim.",
                    "Thiếu thông tin",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                txtTenPhim.Focus();
                return;
            }

            if (thoiLuong <= 0)
            {
                MessageBox.Show("Thời lượng phim phải lớn hơn 0 phút.",
                    "Thông tin không hợp lệ",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                numThoiLuong.Focus();
                return;
            }

            bool thanhCong;
            string thongBao;

            if (_laChucNangSua)
            {
                (thanhCong, thongBao) = PhimDAL.CapNhatPhim(
                    _maPhim,
                    tenPhim,
                    moTa,
                    thoiLuong,
                    ngayKhoiChieu,
                    gioiHanTuoi,
                    poster,
                    trailer,
                    trangThai);
            }
            else
            {
                (thanhCong, thongBao) = PhimDAL.ThemPhim(
                    tenPhim,
                    moTa,
                    thoiLuong,
                    ngayKhoiChieu,
                    gioiHanTuoi,
                    poster,
                    trailer,
                    trangThai);
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
                // Khi có lỗi, giữ nguyên dữ liệu vừa nhập trên form để người dùng sửa đổi
                MessageBox.Show(thongBao, "Lỗi lưu phim", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}
