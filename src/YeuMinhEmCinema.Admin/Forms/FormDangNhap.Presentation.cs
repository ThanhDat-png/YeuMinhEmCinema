namespace YeuMinhEmCinema.Admin;

public partial class FormDangNhap
{
    /// <summary>Chỉ sắp xếp lại các control đăng nhập đang có, giữ nguyên sự kiện và xác thực.</summary>
    private void KhoiTaoGiaoDienCinemaBlue()
    {
        SuspendLayout();
        try
        {
            Font = new Font("Segoe UI", 10F);
            ClientSize = new Size(580, 410);
            BackColor = AdminTheme.Background;
            Text = "YeuMinhEm Cinema · Đăng nhập quản trị";

            var heading = new Panel
            {
                Name = "LoginHeading",
                Location = new Point(0, 0),
                Size = new Size(580, 128),
                Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right,
                BackColor = AdminTheme.Sidebar
            };
            var brand = new Label
            {
                AutoSize = true,
                Text = "YEUMINHEM CINEMA",
                Location = new Point(32, 22),
                ForeColor = Color.FromArgb(104, 219, 249),
                Font = new Font("Segoe UI", 9F, FontStyle.Bold)
            };
            var title = new Label
            {
                AutoSize = true,
                Text = "Đăng nhập quản trị",
                Location = new Point(29, 49),
                ForeColor = Color.White,
                Font = new Font("Segoe UI", 22F, FontStyle.Bold)
            };
            var caption = new Label
            {
                AutoSize = true,
                Text = "Quản lý rạp phim trong một không gian làm việc.",
                Location = new Point(32, 94),
                ForeColor = AdminTheme.SidebarText,
                Font = new Font("Segoe UI", 9F)
            };
            heading.Controls.Add(brand);
            heading.Controls.Add(title);
            heading.Controls.Add(caption);
            Controls.Add(heading);

            lblTenDangNhap.Location = new Point(33, 165);
            txtTenDangNhap.Location = new Point(205, 161);
            txtTenDangNhap.Width = 338;
            lblMatKhau.Location = new Point(33, 220);
            txtMatKhau.Location = new Point(205, 216);
            txtMatKhau.Width = 338;
            btnKhoiTaoAdmin.Location = new Point(33, 287);
            btnKhoiTaoAdmin.Size = new Size(230, 46);
            btnKhoiTaoAdmin.BackColor = AdminTheme.Selection;
            btnKhoiTaoAdmin.ForeColor = AdminTheme.Text;
            btnDangNhap.Location = new Point(280, 287);
            btnDangNhap.Size = new Size(263, 46);
            btnDangNhap.BackColor = AdminTheme.Primary;
            btnDangNhap.ForeColor = Color.White;
        }
        finally
        {
            ResumeLayout(true);
        }
    }
}
