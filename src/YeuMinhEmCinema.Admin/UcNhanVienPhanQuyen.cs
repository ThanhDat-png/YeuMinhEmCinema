using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcNhanVienPhanQuyen : UserControl
    {
        public UcNhanVienPhanQuyen()
        {
            InitializeComponent();
            NapNhanVienMinhHoa();
        }

        private void NapNhanVienMinhHoa()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Mã NV", typeof(string));
            dt.Columns.Add("Họ và tên", typeof(string));
            dt.Columns.Add("Chức vụ", typeof(string));
            dt.Columns.Add("Cụm rạp làm việc", typeof(string));
            dt.Columns.Add("Email", typeof(string));
            dt.Columns.Add("Số điện thoại", typeof(string));
            dt.Columns.Add("Trạng thái", typeof(string));

            dt.Rows.Add("NV001", "Nguyễn Văn Hưng", "Quản lý rạp", "YeuMinhEm Landmark 81", "hung.nv@yeuminhem.vn", "0911223344", "Đang hoạt động");
            dt.Rows.Add("NV002", "Lê Thị Thảo", "Nhân viên bán vé", "YeuMinhEm Landmark 81", "thao.lt@yeuminhem.vn", "0922334455", "Đang hoạt động");
            dt.Rows.Add("NV003", "Trần Đình Trọng", "Nhân viên soát vé", "YeuMinhEm Landmark 81", "trong.td@yeuminhem.vn", "0933445566", "Đang hoạt động");
            dt.Rows.Add("NV004", "Phạm Quốc Bảo", "Quản lý rạp", "YeuMinhEm Vincom Đồng Khởi", "bao.pq@yeuminhem.vn", "0944556677", "Đang hoạt động");
            dt.Rows.Add("NV005", "Đặng Hoàng My", "Nhân viên bán vé", "YeuMinhEm Vincom Đồng Khởi", "my.dh@yeuminhem.vn", "0955667788", "Đang hoạt động");
            dt.Rows.Add("NV006", "Võ Minh Trí", "Kỹ thuật chiếu phim", "YeuMinhEm Thủ Đức", "tri.vm@yeuminhem.vn", "0966778899", "Đang hoạt động");

            dgvNhanVien.DataSource = dt;
        }

        private void dgvNhanVien_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvNhanVien.CurrentRow == null) return;

            string ma = dgvNhanVien.CurrentRow.Cells["Mã NV"].Value?.ToString() ?? "";
            string ten = dgvNhanVien.CurrentRow.Cells["Họ và tên"].Value?.ToString() ?? "";
            string chucVu = dgvNhanVien.CurrentRow.Cells["Chức vụ"].Value?.ToString() ?? "";

            lblNhanVienDangChon.Text = $"Đang chọn: {ma} - {ten} ({chucVu})";

            if (chucVu.Contains("Quản lý"))
            {
                rdoQuanLyRap.Checked = true;
                chkQuyenPhim.Checked = true;
                chkQuyenBanVe.Checked = true;
                chkQuyenSoatVe.Checked = true;
                chkQuyenBaoCao.Checked = true;
                chkQuyenHeThong.Checked = false;
            }
            else if (chucVu.Contains("bán vé"))
            {
                rdoBanVe.Checked = true;
                chkQuyenPhim.Checked = false;
                chkQuyenBanVe.Checked = true;
                chkQuyenSoatVe.Checked = false;
                chkQuyenBaoCao.Checked = false;
                chkQuyenHeThong.Checked = false;
            }
            else
            {
                rdoSoatVe.Checked = true;
                chkQuyenPhim.Checked = false;
                chkQuyenBanVe.Checked = false;
                chkQuyenSoatVe.Checked = true;
                chkQuyenBaoCao.Checked = false;
                chkQuyenHeThong.Checked = false;
            }
        }

        private void btnLuuQuyen_Click(object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng phân quyền nhân viên đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu phân quyền).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }

        private void BtnChuaTrienKhai_Click(object? sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng thêm nhân sự mới đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
