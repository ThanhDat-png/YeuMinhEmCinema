using Microsoft.Data.SqlClient;

namespace YeuMinhEmCinema.Admin
{
    public partial class FormDangNhap : Form
    {
        private bool dangXuLy;
        private bool daCoAdmin = true;

        internal KetQuaDangNhap? TaiKhoanDaDangNhap
        {
            get;
            private set;
        }

        public FormDangNhap()
        {
            InitializeComponent();

            StartPosition = FormStartPosition.CenterScreen;
            AcceptButton = btnDangNhap;

            txtTenDangNhap.MaxLength = 50;
            txtMatKhau.MaxLength = 256;
            txtMatKhau.UseSystemPasswordChar = true;

            // Kích thước cửa sổ
            ClientSize = new Size(460, 280);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;

            // Hai dòng nhập liệu
            lblTenDangNhap.Location = new Point(35, 45);
            txtTenDangNhap.Location = new Point(175, 42);
            txtTenDangNhap.Size = new Size(240, 23);

            lblMatKhau.Location = new Point(35, 95);
            txtMatKhau.Location = new Point(175, 92);
            txtMatKhau.Size = new Size(240, 23);

            // Hai nút tách nhau
            btnKhoiTaoAdmin.AutoSize = false;
            btnKhoiTaoAdmin.Location = new Point(35, 155);
            btnKhoiTaoAdmin.Size = new Size(185, 38);

            btnDangNhap.AutoSize = false;
            btnDangNhap.Location = new Point(235, 155);
            btnDangNhap.Size = new Size(180, 38);
            btnKhoiTaoAdmin.Enabled = false;

            // Gắn sự kiện tại đây, không cần nhấp đúp nút.
            Shown += FormDangNhap_Shown;
            btnDangNhap.Click += BtnDangNhap_Click;
            btnKhoiTaoAdmin.Click += BtnKhoiTaoAdmin_Click;

            FormClosing += (_, e) =>
            {
                if (dangXuLy)
                {
                    e.Cancel = true;
                }
            };
        }

        private async void FormDangNhap_Shown(
        object? sender,
        EventArgs e)
        {
            await ThucHienAsync(async () =>
            {
                daCoAdmin = await Task.Run(
                TaiKhoanDAL.DaCoAdmin);

                if (!daCoAdmin)
                {
                    MessageBox.Show(
                        this,
                        "Chưa có Admin. Nhập tên đăng nhập và "
                        + "mật khẩu ít nhất 12 ký tự, "
                        + "sau đó bấm Tạo Admin đầu tiên.",
                        "Khởi tạo hệ thống",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
            });

            txtTenDangNhap.Focus();
        }

        private async void BtnKhoiTaoAdmin_Click(
        object? sender,
        EventArgs e)
        {
            if (dangXuLy)
            {
                return;
            }

            string tenDangNhap = txtTenDangNhap.Text.Trim();

            // Không Trim mật khẩu.
            string matKhau = txtMatKhau.Text;

            if (tenDangNhap.Length < 3)
            {
                MessageBox.Show(
                this,
                "Tên đăng nhập phải có ít nhất 3 ký tự.");

                txtTenDangNhap.Focus();
                return;
            }

            if (matKhau.Length < 12)
            {
                MessageBox.Show(
                this,
                "Mật khẩu phải có ít nhất 12 ký tự.");

                txtMatKhau.Focus();
                return;
            }

            if (!XacNhanMatKhau(matKhau))
            {
                return;
            }

            await ThucHienAsync(async () =>
            {
                await Task.Run(() =>
                TaiKhoanDAL.KhoiTaoAdmin(
                tenDangNhap,
                matKhau));

                daCoAdmin = true;
                txtMatKhau.Clear();

                MessageBox.Show(
                    this,
                    "Đã tạo Admin thành công. "
                    + "Nhập lại mật khẩu rồi bấm Đăng nhập.",
                    "Thành công",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);

                txtMatKhau.Focus();
            });
        }

        private async void BtnDangNhap_Click(
        object? sender,
        EventArgs e)
        {
            if (dangXuLy)
            {
                return;
            }

            string tenDangNhap = txtTenDangNhap.Text.Trim();
            string matKhau = txtMatKhau.Text;

            if (tenDangNhap.Length == 0 ||
            matKhau.Length == 0)
            {
                MessageBox.Show(
                this,
                "Nhập đầy đủ tên đăng nhập và mật khẩu.");

                return;
            }

            bool thanhCong = false;

            await ThucHienAsync(async () =>
            {
                var ketQua = await Task.Run(() =>
                TaiKhoanDAL.DangNhap(
                tenDangNhap,
                matKhau));

                txtMatKhau.Clear();

                if (ketQua is null)
                {
                    MessageBox.Show(
                        this,
                        "Thông tin đăng nhập không đúng "
                        + "hoặc tài khoản không được vào Admin.",
                        "Không đăng nhập được",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);

                    txtMatKhau.Focus();
                    return;
                }

                TaiKhoanDaDangNhap = ketQua;
                thanhCong = true;
            });

            // Chỉ đóng form sau khi đã kết thúc xử lý.
            if (thanhCong)
            {
                DialogResult = DialogResult.OK;
                Close();
            }
        }

        private async Task ThucHienAsync(Func<Task> congViec)
        {
            if (dangXuLy)
            {
                return;
            }

            dangXuLy = true;
            btnDangNhap.Enabled = false;
            btnKhoiTaoAdmin.Enabled = false;
            txtTenDangNhap.Enabled = false;
            txtMatKhau.Enabled = false;
            UseWaitCursor = true;

            try
            {
                await congViec();
            }
            catch (SqlException ex) when (ex.Number >= 50000)
            {
                if (ex.Number == 50406)
                {
                    // Một phiên khác đã tạo Admin trước.
                    daCoAdmin = true;
                }

                MessageBox.Show(
                    this,
                    ex.Message,
                    "Thông báo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
            }
            catch (SqlException ex)
            {
                MessageBox.Show(
                    this,
                    Db.Error(ex) + " " + "Không thực hiện được thao tác với SQL Server. "
                    + "Kiểm tra kết nối và database "
                    + "YeuMinhEmCinema.",
                    "Lỗi dữ liệu",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
            catch (ArgumentException ex)
            {
                MessageBox.Show(
                    this,
                    ex.Message,
                    "Kiểm tra thông tin",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
            }
            catch (Exception)
            {
                MessageBox.Show(
                    this,
                    "Có lỗi khi xử lý đăng nhập. "
                    + "Vui lòng kiểm tra lại cấu hình.",
                    "Lỗi",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
            finally
            {
                dangXuLy = false;
                UseWaitCursor = false;
                btnDangNhap.Enabled = true;
                btnKhoiTaoAdmin.Enabled = !daCoAdmin;
                txtTenDangNhap.Enabled = true;
                txtMatKhau.Enabled = true;
            }
        }

        // Hộp nhập lại mật khẩu khi tạo Admin,
        // không cần tạo thêm file Designer.
        private bool XacNhanMatKhau(string matKhau)
        {
            using var hopThoai = new Form
            {
                Text = "Nhập lại mật khẩu Admin",
                ClientSize = new Size(360, 130),
                StartPosition = FormStartPosition.CenterParent,
                FormBorderStyle = FormBorderStyle.FixedDialog,
                MaximizeBox = false,
                MinimizeBox = false
            };

            var oNhapLai = new TextBox
            {
                Location = new Point(20, 20),
                Size = new Size(320, 23),
                UseSystemPasswordChar = true,
                MaxLength = 256
            };

            var nutDongY = new Button
            {
                Text = "Xác nhận",
                Location = new Point(145, 70),
                Size = new Size(95, 30),
                DialogResult = DialogResult.OK
            };

            var nutHuy = new Button
            {
                Text = "Hủy",
                Location = new Point(250, 70),
                Size = new Size(90, 30),
                DialogResult = DialogResult.Cancel
            };

            hopThoai.Controls.AddRange(
            new Control[]
            {
                oNhapLai,
                nutDongY,
                nutHuy
            });

            hopThoai.AcceptButton = nutDongY;
            hopThoai.CancelButton = nutHuy;

            if (hopThoai.ShowDialog(this) != DialogResult.OK)
            {
                return false;
            }

            if (oNhapLai.Text != matKhau)
            {
                MessageBox.Show(
                this,
                "Hai lần nhập mật khẩu không khớp.");

                return false;
            }

            return true;
        }
    }
}
