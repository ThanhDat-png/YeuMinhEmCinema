using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class Form1 : Form
    {
        // Bộ nhớ đệm lưu các màn hình UserControl đã được khởi tạo
        private readonly Dictionary<string, UserControl> _danhSachManHinhPhu = new();
        private readonly List<Button> _danhSachNutMenu = new();

        public Form1()
        {
            InitializeComponent();

            // Khởi tạo danh sách các nút điều hướng sidebar
            KhoiTaoMenuSidebar();
            KhoiTaoTheLoai();
            KhoiTaoPhanQuyen();

            // Thiết lập giá trị mặc định cho bộ lọc phim
            cboLocTrangThai.SelectedIndex = 0;

            // Tải danh sách phim từ database thật SQL Server lên dgvPhim
            TaiDanhSachPhim();
        }

        private void KhoiTaoMenuSidebar()
        {
            _danhSachNutMenu.Add(btnNavTongQuan);
            _danhSachNutMenu.Add(btnNavQuanLyPhim);
            _danhSachNutMenu.Add(btnNavRapPhong);
            _danhSachNutMenu.Add(btnNavLichChieu);
            _danhSachNutMenu.Add(btnNavGiaVeFnb);
            _danhSachNutMenu.Add(btnNavDonDatVe);
            _danhSachNutMenu.Add(btnNavBanVe);
            _danhSachNutMenu.Add(btnNavKiemTraVe);
            _danhSachNutMenu.Add(btnNavKhachHang);
            _danhSachNutMenu.Add(btnNavNhanVien);
            _danhSachNutMenu.Add(btnNavBaoCao);
        }

        #region XỬ LÝ ĐIỀU HƯỚNG MÀN HÌNH CHÍNH (NAVIGATION)

        /// <summary>
        /// Chuyển đổi giữa các màn hình chức năng trên giao diện Admin.
        /// </summary>
        private void ChuyenManHinh(string maManHinh, string tieuDe, Button nutDangChon)
        {
            try
            {
                Db.RefreshRights();
                ApplyRights();
            }
            catch (Exception ex)
            {
                MessageBox.Show(Db.Error(ex));
                return;
            }
            if (!Allowed(maManHinh))
            {
                MessageBox.Show("Bạn không có quyền mở màn hình này.");
                return;
            }
            UserControl? destination = null;
            if (maManHinh != "QuanLyPhim" && !_danhSachManHinhPhu.TryGetValue(maManHinh, out destination))
            {
                try
                {
                    destination = TaoManHinhPhu(maManHinh);
                    if (destination == null)
                        return;
                    destination.Dock = DockStyle.Fill;
                    destination.Visible = false;
                    pnlContent.Controls.Add(destination);
                    _danhSachManHinhPhu[maManHinh] = destination;
                }
                catch (Exception ex)
                {
                    destination?.Dispose();
                    MessageBox.Show(Db.Error(ex));
                    return;
                }
            }
            pnlContent.SuspendLayout();
            try
            {
                foreach (var page in _danhSachManHinhPhu.Values)
                    page.Visible = false;
                pnlQuanLyPhim.Visible = maManHinh == "QuanLyPhim";
                if (destination != null)
                {
                    destination.Visible = true;
                    destination.BringToFront();
                }
                else
                    pnlQuanLyPhim.BringToFront();
                lblScreenTitle.Text = tieuDe;
                foreach (Button btn in _danhSachNutMenu)
                {
                    bool active = btn == nutDangChon;
                    btn.BackColor = active ? AdminUi.Primary : Color.FromArgb(20, 20, 26);
                    btn.ForeColor = active ? Color.White : Color.FromArgb(203, 213, 225);
                    btn.Font = new Font("Segoe UI", 9.75F, active ? FontStyle.Bold : FontStyle.Regular);
                }
            }
            finally
            {
                pnlContent.ResumeLayout(true);
            }
        }

        private UserControl? TaoManHinhPhu(string maManHinh)
        {
            return maManHinh switch
            {
                "TongQuan" => new UcTongQuan(),
                "RapPhong" => new UcRapPhongChieu(),
                "LichChieu" => new UcLichChieu(),
                "GiaVeFnb" => new UcGiaVeVaFnb(),
                "DonDatVe" => new UcDonDatVe(),
                "BanVe" => new UcBanVeTaiQuay(),
                "KiemTraVe" => new UcKiemTraVe(),
                "KhachHang" => new UcKhachHang(),
                "NhanVien" => new UcNhanVienPhanQuyen(),
                "BaoCao" => new UcBaoCaoThongKe(),
                _ => null
            };
        }

        private void btnNavTongQuan_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("TongQuan",
                "📊 BÁO CÁO TỔNG QUAN HOẠT ĐỘNG RẠP PHIM",
                btnNavTongQuan);
        }

        private void btnNavQuanLyPhim_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("QuanLyPhim",
                "🎬 QUẢN LÝ PHIM (KẾT NỐI DATABASE THẬT)",
                btnNavQuanLyPhim);
        }

        private void btnNavRapPhong_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("RapPhong",
                "🏛️ CỤM RẠP, PHÒNG CHIẾU & SƠ ĐỒ GHẾ (KẾT NỐI DATABASE THẬT)",
                btnNavRapPhong);
        }

        private void btnNavLichChieu_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("LichChieu", "📅 QUẢN LÝ LỊCH CHIẾU", btnNavLichChieu);
        }

        private void btnNavGiaVeFnb_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("GiaVeFnb", "🍿 QUẢN LÝ GIÁ VÉ & F&B", btnNavGiaVeFnb);
        }

        private void btnNavDonDatVe_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("DonDatVe", "📑 ĐƠN ĐẶT VÉ & HÓA ĐƠN", btnNavDonDatVe);
        }

        private void btnNavBanVe_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("BanVe", "🛒 BÁN VÉ TẠI QUẦY - POS", btnNavBanVe);
        }

        private void btnNavKiemTraVe_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("KiemTraVe", "🔍 KIỂM TRA VÉ & SOÁT VÉ", btnNavKiemTraVe);
        }

        private void btnNavKhachHang_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("KhachHang", "👥 THÀNH VIÊN & KHÁCH HÀNG", btnNavKhachHang);
        }

        private void btnNavNhanVien_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("NhanVien", "👤 NHÂN SỰ & PHÂN QUYỀN", btnNavNhanVien);
        }

        private void btnNavBaoCao_Click(object sender, EventArgs e)
        {
            ChuyenManHinh("BaoCao", "📈 BÁO CÁO DOANH THU & THỐNG KÊ", btnNavBaoCao);
        }

        #endregion

        #region QUẢN LÝ PHIM — HOẠT ĐỘNG THẬT VỚI CƠ SỞ DỮ LIỆU SQL SERVER

        /// <summary>
        /// Tải danh sách phim từ SQL Server lên dgvPhim.
        /// Sử dụng lớp PhimDAL để đảm bảo tách biệt code truy cập dữ liệu khỏi giao diện.
        /// </summary>
        private void TaiDanhSachPhim()
        {
            if (!rightsReady || !Db.Has("PHIM_XEM"))
                return;
            string tuKhoa = txtTimKiemPhim.Text.Trim();
            string trangThai = cboLocTrangThai.SelectedItem?.ToString() ?? "Tất cả trạng thái";

            try
            {
                DataTable bangPhim = PhimDAL.LayDanhSachPhim(tuKhoa, trangThai);

                dgvPhim.AutoGenerateColumns = true;
                dgvPhim.DataSource = bangPhim;

                void DatTieuDeCot(string tenCot,
                    string tieuDe,
                    float fillWeight = 100,
                    bool an = false)
                {
                    if (dgvPhim.Columns[tenCot] is DataGridViewColumn col)
                    {
                        col.HeaderText = tieuDe;
                        col.FillWeight = fillWeight;
                        col.Visible = !an;
                    }
                }

                // Cấu hình tiêu đề và tỷ trọng hiển thị
                DatTieuDeCot("MaPhim", "Mã phim", 60);
                DatTieuDeCot("TenPhim", "Tên phim", 180);
                DatTieuDeCot("TheLoai", "Thể loại", 140);
                DatTieuDeCot("ThoiLuong", "Thời lượng (phút)", 85);
                DatTieuDeCot("NgayKhoiChieu", "Ngày khởi chiếu", 95);
                DatTieuDeCot("GioiHanTuoi", "Giới hạn tuổi", 75);
                DatTieuDeCot("TrangThai", "Trạng thái", 85);

                // Định dạng ngày hiển thị
                if (dgvPhim.Columns["NgayKhoiChieu"] is DataGridViewColumn colNgay)
                {
                    colNgay.DefaultCellStyle.Format = "dd/MM/yyyy";
                }

                // Ẩn bớt các cột nội dung dài trên bảng chính (đã có khung chi tiết xem bên dưới)
                DatTieuDeCot("MoTa", "Mô tả", 100, an : true);
                DatTieuDeCot("Poster", "Poster", 100, an : true);
                DatTieuDeCot("Trailer", "Trailer", 100, an : true);

                // Cập nhật khung chi tiết cho dòng đầu tiên nếu có dữ liệu
                CapNhatChiTietPhimDangChon();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Không tải được danh sách phim từ cơ sở dữ liệu:\n" + ex.Message,
                    "Lỗi kết nối dữ liệu",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void CapNhatChiTietPhimDangChon()
        {
            if (dgvPhim.CurrentRow == null || !dgvPhim.Columns.Contains("MaPhim"))
            {
                lblChiTietPhim.Text = "Chưa có phim nào được chọn.";
                return;
            }

            DataGridViewRow row = dgvPhim.CurrentRow;
            string maPhim = row.Cells["MaPhim"]?.Value?.ToString() ?? "";
            string tenPhim = row.Cells["TenPhim"]?.Value?.ToString() ?? "";
            string thoiLuong = row.Cells["ThoiLuong"]?.Value?.ToString() ?? "";
            string ngayChieu = "";
            if (row.Cells["NgayKhoiChieu"]?.Value != null && row.Cells["NgayKhoiChieu"]?.Value != DBNull.Value)
            {
                ngayChieu = Convert.ToDateTime(row.Cells["NgayKhoiChieu"].Value).ToString("dd/MM/yyyy");
            }
            string tuoi = row.Cells["GioiHanTuoi"]?.Value?.ToString() ?? "";
            string trangThai = row.Cells["TrangThai"]?.Value?.ToString() ?? "";
            string moTa = row.Cells["MoTa"]?.Value != DBNull.Value ? row.Cells["MoTa"]?.Value?.ToString() ?? "" : "";
            string poster = row.Cells["Poster"]?.Value != DBNull.Value ? row.Cells["Poster"]?.Value?.ToString() ?? "" : "";
            string trailer = row.Cells["Trailer"]?.Value != DBNull.Value ? row.Cells["Trailer"]?.Value?.ToString() ?? "" : "";

            lblChiTietPhim.Text =
            $"🎬 [{maPhim}] {tenPhim} | Thời lượng: {thoiLuong} phút | Giới hạn: {tuoi} | Khởi chiếu: {ngayChieu} | Trạng thái: {trangThai}\n" +
            $"• Poster: {(string.IsNullOrWhiteSpace(poster) ? "Chưa có" : poster)} | Trailer: {(string.IsNullOrWhiteSpace(trailer) ? "Chưa có" : trailer)}\n" +
            $"• Tóm tắt mô tả: {(string.IsNullOrWhiteSpace(moTa) ? "(Chưa cập nhật mô tả cho phim này)" : moTa)}";
        }

        private void dgvPhim_SelectionChanged(object? sender, EventArgs e)
        {
            CapNhatChiTietPhimDangChon();
        }

        // Sự kiện khi nhấn nút Thêm phim mới
        private void btnThemPhim_Click(object? sender, EventArgs e)
        {
            try
            {
                Db.Require("PHIM_QUAN_LY");
            }
            catch (Exception ex)
            {
                MessageBox.Show(Db.Error(ex));
                return;
            }
            using FormThemSuaPhim form = new FormThemSuaPhim();
            if (form.ShowDialog(this) == DialogResult.OK)
            {
                // Sau khi lưu thành công vào database, tự động tải lại danh sách phim
                TaiDanhSachPhim();
            }
        }

        // Sự kiện khi nhấn nút Sửa phim
        private void btnSuaPhim_Click(object? sender, EventArgs e)
        {
            try
            {
                Db.Require("PHIM_QUAN_LY");
            }
            catch (Exception ex)
            {
                MessageBox.Show(Db.Error(ex));
                return;
            }
            if (dgvPhim.CurrentRow == null || !dgvPhim.Columns.Contains("MaPhim"))
            {
                MessageBox.Show("Vui lòng chọn một bộ phim trong bảng để chỉnh sửa.",
                    "Chưa chọn phim",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }

            int maPhim = Convert.ToInt32(dgvPhim.CurrentRow.Cells["MaPhim"].Value);
            using FormThemSuaPhim form = new FormThemSuaPhim(maPhim);
            if (form.ShowDialog(this) == DialogResult.OK)
            {
                // Sau khi cập nhật thành công vào database, tự động tải lại danh sách phim
                TaiDanhSachPhim();
            }
        }

        // Sự kiện khi nhấn nút Ngừng chiếu (không xóa vật lý theo yêu cầu nghiệp vụ)
        private void btnNgungChieu_Click(object? sender, EventArgs e)
        {
            try
            {
                Db.Require("PHIM_QUAN_LY");
            }
            catch (Exception ex)
            {
                MessageBox.Show(Db.Error(ex));
                return;
            }
            if (dgvPhim.CurrentRow == null || !dgvPhim.Columns.Contains("MaPhim"))
            {
                MessageBox.Show("Vui lòng chọn một bộ phim trong bảng để ngừng chiếu.",
                    "Chưa chọn phim",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }

            int maPhim = Convert.ToInt32(dgvPhim.CurrentRow.Cells["MaPhim"].Value);
            string tenPhim = dgvPhim.CurrentRow.Cells["TenPhim"].Value?.ToString() ?? "";
            string trangThaiHienTai = dgvPhim.CurrentRow.Cells["TrangThai"].Value?.ToString() ?? "";

            if (trangThaiHienTai == "Ngừng chiếu")
            {
                MessageBox.Show($"Bộ phim '{tenPhim}' hiện đã ở trạng thái 'Ngừng chiếu'.",
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
                return;
            }

            DialogResult xacNhan = MessageBox.Show(
                $"Bạn có chắc chắn muốn chuyển trạng thái bộ phim '{tenPhim}' (Mã phim: {maPhim}) sang 'Ngừng chiếu'?\n\n(Hệ thống giữ nguyên dữ liệu trong cơ sở dữ liệu để bảo đảm toàn vẹn lịch sử đặt vé).",
                "Xác nhận ngừng chiếu phim",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (xacNhan == DialogResult.Yes)
            {
                var (thanhCong, thongBao) = PhimDAL.NgungChieuPhim(maPhim);
                if (thanhCong)
                {
                    MessageBox.Show(thongBao,
                        "Thông báo thành công",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                    TaiDanhSachPhim();
                }
                else
                {
                    MessageBox.Show(thongBao, "Lỗi cập nhật", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void btnTimKiemPhim_Click(object? sender, EventArgs e)
        {
            TaiDanhSachPhim();
        }

        private void txtTimKiemPhim_KeyDown(object? sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                TaiDanhSachPhim();
            }
        }

        private void cboLocTrangThai_SelectedIndexChanged(object? sender, EventArgs e)
        {
            TaiDanhSachPhim();
        }

        private void btnLamMoiPhim_Click(object? sender, EventArgs e)
        {
            txtTimKiemPhim.Clear();
            cboLocTrangThai.SelectedIndex = 0; // "Tất cả trạng thái"
            TaiDanhSachPhim();
        }

        // Giữ lại vì Designer có thể đang liên kết sự kiện này
        private void dataGridView1_CellContentClick(
            object sender,
            DataGridViewCellEventArgs e)
        {
        }

        #endregion
    }
}
