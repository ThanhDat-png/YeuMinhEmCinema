namespace YeuMinhEmCinema.Admin;

public partial class UcTongQuan : UcBaoCaoThongKe
{
    public UcTongQuan() : base()
    {
        // Chỉ bọc bố cục cũ: giữ nguyên các bộ lọc, nút, bảng, biểu đồ và sự kiện.
        var shell = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 2,
            Padding = new Padding(12)
        };
        shell.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        shell.RowStyles.Add(new RowStyle(SizeType.Absolute, 118));
        shell.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        var banner = new AdminWelcomeCard
        {
            Dock = DockStyle.Fill,
            Margin = new Padding(0, 0, 0, 12)
        };

        Controls.Remove(PageLayout);
        shell.Controls.Add(banner, 0, 0);
        shell.Controls.Add(PageLayout, 0, 1);
        Controls.Add(shell);
        Resize += (_, _) => shell.RowStyles[0].Height = ClientSize.Height < 600 ? 100 : 118;
    }
}
