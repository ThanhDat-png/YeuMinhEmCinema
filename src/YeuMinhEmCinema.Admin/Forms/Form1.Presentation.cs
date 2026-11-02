namespace YeuMinhEmCinema.Admin;

public partial class Form1
{
    private readonly Dictionary<Button, string> _tenMenuDayDu = new();
    private ToolTip? _menuToolTip;
    private bool _menuThuGon;

    private void KhoiTaoBoCucLavender()
    {
        _menuToolTip = new ToolTip
        {
            InitialDelay = 250,
            ReshowDelay = 100,
            AutoPopDelay = 5000,
            ShowAlways = true
        };
        Disposed += (_, _) => _menuToolTip?.Dispose();

        foreach (var button in _danhSachNutMenu)
        {
            _tenMenuDayDu[button] = button.Text;
            button.AccessibleName = button.Text.Replace("&&", "&");
            button.Margin = new Padding(2, 3, 2, 3);
            _menuToolTip.SetToolTip(button, button.AccessibleName);
        }

        flpNav.FlowDirection = FlowDirection.TopDown;
        flpNav.WrapContents = false;
        var footer = new Panel
        {
            Name = "pnlSidebarFooter",
            Dock = DockStyle.Bottom,
            Height = 56,
            Padding = new Padding(10),
            BackColor = AdminTheme.Sidebar
        };
        var toggle = new Button
        {
            Dock = DockStyle.Fill,
            Text = "☰",
            AccessibleName = "Mở rộng hoặc thu gọn thanh điều hướng",
            FlatStyle = FlatStyle.Flat,
            BackColor = AdminTheme.SidebarHover,
            ForeColor = AdminTheme.SidebarText,
            UseVisualStyleBackColor = false
        };
        toggle.FlatAppearance.BorderSize = 0;
        toggle.Click += (_, _) => DatMenuThuGon(!_menuThuGon);
        _menuToolTip.SetToolTip(toggle, "Mở rộng / thu gọn menu");
        footer.Controls.Add(toggle);
        // Đặt footer sau các control đang có để menu Dock.Fill nhường chỗ phía dưới.
        pnlSidebar.Controls.Add(footer);
        SoftCorners.Attach(toggle, 10);

        var monogram = new Label
        {
            Name = "lblBrandMonogram",
            Dock = DockStyle.Fill,
            Text = "YME",
            TextAlign = ContentAlignment.MiddleCenter,
            ForeColor = AdminTheme.SidebarText,
            Font = new Font("Segoe UI", 10F, FontStyle.Bold),
            BackColor = AdminTheme.Sidebar,
            AccessibleName = "YeuMinhEm Cinema"
        };
        pnlBrand.Controls.Add(monogram);
        monogram.BringToFront();
        _menuToolTip.SetToolTip(monogram, "YeuMinhEm Cinema");
        // Chỉ thay hình thức menu; không sửa Click, Enabled, Visible hoặc phân quyền của nút.
        DatMenuThuGon(false);
    }

    private void DatMenuThuGon(bool compact)
    {
        _menuThuGon = compact;
        pnlSidebar.SuspendLayout();
        flpNav.SuspendLayout();
        try
        {
            pnlSidebar.Width = compact ? 88 : 230;
            lblBrandTitle.Visible = !compact;
            lblBrandSubtitle.Visible = !compact;
            var monogram = pnlBrand.Controls["lblBrandMonogram"];
            if (monogram is not null)
            {
                monogram.Visible = compact;
            }

            foreach (var item in _tenMenuDayDu)
            {
                var button = item.Key;
                var original = item.Value;
                int separator = original.IndexOf(' ');
                button.Text = compact && separator > 0 ? original[..separator] : original;
                button.TextAlign = compact ? ContentAlignment.MiddleCenter : ContentAlignment.MiddleLeft;
                button.Width = pnlSidebar.Width - SystemInformation.VerticalScrollBarWidth
                    - flpNav.Padding.Horizontal - 8;
            }
        }
        finally
        {
            flpNav.ResumeLayout(true);
            pnlSidebar.ResumeLayout(true);
        }
    }
}
