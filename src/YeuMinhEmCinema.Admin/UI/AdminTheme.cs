using System.Runtime.CompilerServices;

namespace YeuMinhEmCinema.Admin;

/// <summary>
/// Bảng màu Cinema Blue cho WinForms. Chỉ đổi cách hiển thị control,
/// không thay đổi dữ liệu, phân quyền hoặc trình xử lý nghiệp vụ.
/// </summary>
internal static class AdminTheme
{
    internal static readonly Color Primary = Color.FromArgb(37, 99, 235);
    internal static readonly Color Sidebar = Color.FromArgb(12, 29, 54);
    internal static readonly Color Background = Color.FromArgb(239, 245, 252);
    internal static readonly Color Surface = Color.FromArgb(255, 255, 255);
    internal static readonly Color Text = Color.FromArgb(24, 42, 66);
    internal static readonly Color Muted = Color.FromArgb(84, 107, 135);
    internal static readonly Color Border = Color.FromArgb(209, 223, 240);
    internal static readonly Color Selection = Color.FromArgb(219, 234, 254);

    internal static readonly Color SidebarText = Color.FromArgb(221, 235, 255);
    internal static readonly Color SidebarHover = Color.FromArgb(27, 54, 87);

    // Weak references tránh giữ lại form/control đã đóng.
    private static readonly ConditionalWeakTable<Control, object> Styled = new();
    private static bool initialized;

    internal static void Initialize()
    {
        if (initialized)
        {
            return;
        }

        initialized = true;
        Application.Idle += ApplyOpenForms;
    }

    private static void ApplyOpenForms(object? sender, EventArgs e)
    {
        // Bao gồm form đăng nhập, màn hình chính và các hộp thoại ShowDialog.
        foreach (Form form in Application.OpenForms.Cast<Form>().ToArray())
        {
            Apply(form);
        }
    }

    internal static void Apply(Control control)
    {
        if (control.IsDisposed || Styled.TryGetValue(control, out _))
        {
            return;
        }

        Styled.Add(control, new object());
        StyleControl(control);
        control.ControlAdded += OnControlAdded;

        foreach (Control child in control.Controls)
        {
            Apply(child);
        }
    }

    private static void OnControlAdded(object? sender, ControlEventArgs e)
    {
        if (e.Control is not null)
        {
            Apply(e.Control);
        }
    }

    private static void StyleControl(Control control)
    {
        if (control is DataGridView grid)
        {
            StyleGrid(grid);
            return;
        }

        control.BackColor = MapBackground(control.BackColor);
        control.ForeColor = MapForeground(control.ForeColor);

        if (control is Form || control is UserControl)
        {
            control.BackColor = Background;
            control.ForeColor = Text;
        }
        else if (control is Panel && control.BackColor.ToArgb() == SystemColors.Control.ToArgb())
        {
            control.BackColor = Surface;
        }

        if (control.Name is "pnlSidebar" or "pnlBrand" or "flpNav")
        {
            control.BackColor = Sidebar;
        }

        if (control.Name == "lblBrandSubtitle")
        {
            control.ForeColor = SidebarText;
        }

        if (control is Button button)
        {
            StyleButton(button);
            if (button.Width >= 75 && button.Height >= 28)
            {
                SoftCorners.Attach(button, 10);
            }
        }

        StyleSurface(control);
    }

    private static void StyleSurface(Control control)
    {
        // Chỉ trang trí các khối có sẵn, không thay control hay gắn lại sự kiện nghiệp vụ.
        if (control.Name == "pnlHeader")
        {
            control.BackColor = Color.FromArgb(16, 39, 72);
        }

        if (control.Name is "lblScreenTitle" or "lblUserName")
        {
            control.ForeColor = Color.FromArgb(247, 248, 255);
        }

        if (control.Name is "lblBrandTitle" or "lblBrandMonogram")
        {
            control.ForeColor = SidebarText;
        }

        if (control.Name == "lblUserRole")
        {
            control.ForeColor = Color.FromArgb(188, 231, 220);
        }

        if (control.Name is "pnlGridContainer" or "pnlPhimDetail" or "pnlChucNang")
        {
            control.BackColor = Surface;
            SoftCorners.Attach(control, 14);
        }

        if (control.Name is "pnlDatabaseBanner" or "ReportSummary")
        {
            SoftCorners.Attach(control, 12);
        }

        if (control.Name == "ReportSummary")
        {
            control.BackColor = Color.FromArgb(224, 237, 255);
            control.ForeColor = Text;
        }

        if (control is DoanhThuChart)
        {
            control.BackColor = Surface;
            SoftCorners.Attach(control, 14);
        }
    }

    private static void StyleButton(Button button)
    {
        bool navigation = button.Name.StartsWith("btnNav", StringComparison.Ordinal);

        if (navigation)
        {
            button.AutoEllipsis = true;
            button.BackColor = button.BackColor == Primary ? Primary : Sidebar;
            button.ForeColor = button.BackColor == Primary ? Color.White : SidebarText;
            button.FlatStyle = FlatStyle.Flat;
            button.FlatAppearance.BorderSize = 0;
            button.FlatAppearance.MouseOverBackColor = button.BackColor == Primary ? Primary : SidebarHover;
            button.FlatAppearance.MouseDownBackColor = button.BackColor == Primary ? Primary : SidebarHover;
            button.UseVisualStyleBackColor = false;
            SoftCorners.Attach(button, 10);
            return;
        }

        // Nút phụ dùng màu xanh nhạt; giữ màu ghế và thao tác nguy hiểm.
        if (button.Width >= 75 && (Is(button.BackColor, 51, 65, 85)
            || Is(button.BackColor, 71, 85, 105) || Is(button.BackColor, 15, 23, 42)))
        {
            button.BackColor = Selection;
            button.ForeColor = Text;
        }

        if (button.BackColor.ToArgb() == SystemColors.Control.ToArgb())
        {
            button.BackColor = Primary;
            button.ForeColor = Color.White;
        }

        button.FlatStyle = FlatStyle.Flat;
        button.UseVisualStyleBackColor = false;
        button.FlatAppearance.BorderSize = 1;
        button.FlatAppearance.BorderColor = Border;
        button.FlatAppearance.MouseOverBackColor = ControlPaint.Light(button.BackColor, .12f);
        button.FlatAppearance.MouseDownBackColor = ControlPaint.Dark(button.BackColor, .08f);
    }

    private static void StyleGrid(DataGridView grid)
    {
        grid.EnableHeadersVisualStyles = false;
        grid.RowTemplate.Height = Math.Max(grid.RowTemplate.Height, 34);
        grid.ColumnHeadersHeight = Math.Max(grid.ColumnHeadersHeight, 38);
        grid.DefaultCellStyle.Padding = new Padding(5, 3, 5, 3);
        grid.BackgroundColor = Surface;
        grid.BorderStyle = BorderStyle.None;
        grid.GridColor = Border;
        grid.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single;
        grid.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(230, 240, 255);
        grid.ColumnHeadersDefaultCellStyle.ForeColor = Text;
        grid.ColumnHeadersDefaultCellStyle.SelectionBackColor = Color.FromArgb(230, 240, 255);
        grid.ColumnHeadersDefaultCellStyle.SelectionForeColor = Text;
        grid.DefaultCellStyle.BackColor = Surface;
        grid.DefaultCellStyle.ForeColor = Text;
        grid.DefaultCellStyle.SelectionBackColor = Selection;
        grid.DefaultCellStyle.SelectionForeColor = Text;
        grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(246, 249, 254);
        grid.AlternatingRowsDefaultCellStyle.ForeColor = Text;
        grid.AlternatingRowsDefaultCellStyle.SelectionBackColor = Selection;
        grid.AlternatingRowsDefaultCellStyle.SelectionForeColor = Text;
    }

    private static Color MapBackground(Color color)
    {
        if (Is(color, 211, 47, 47) || Is(color, 37, 99, 235))
        {
            return Primary;
        }

        if (Is(color, 20, 20, 26) || Is(color, 15, 15, 20))
        {
            return Sidebar;
        }

        if (Is(color, 237, 243, 251))
        {
            return Background;
        }

        if (color.ToArgb() == Color.White.ToArgb())
        {
            return Surface;
        }

        if (Is(color, 240, 242, 245) || Is(color, 241, 245, 249))
        {
            return Background;
        }

        return color;
    }

    private static Color MapForeground(Color color)
    {
        if (color.ToArgb() == SystemColors.ControlText.ToArgb()
            || Is(color, 24, 24, 27) || Is(color, 15, 23, 42) || Is(color, 30, 41, 59))
        {
            return Text;
        }

        if (Is(color, 51, 65, 85) || Is(color, 71, 85, 105))
        {
            return Muted;
        }

        return color;
    }

    private static bool Is(Color color, int red, int green, int blue)
    {
        return color.A == 255 && color.R == red && color.G == green && color.B == blue;
    }
}
