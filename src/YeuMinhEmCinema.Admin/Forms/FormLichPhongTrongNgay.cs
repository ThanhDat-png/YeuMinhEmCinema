namespace YeuMinhEmCinema.Admin;

public sealed class FormLichPhongTrongNgay : Form
{
    private readonly int _ma;
    private readonly DateTimePicker _ngay = LichChieuUi.Ngay();
    private readonly DataGridView _bang = LichChieuUi.Bang();
    private readonly Label _count = new()
    {
        AutoSize = true,
        Padding = new Padding(8)
    };

    public FormLichPhongTrongNgay(int maPhong, string tenPhong, DateTime ngay)
    {
        _ma = maPhong;
        Text = $"Lịch phòng {tenPhong} — mã {maPhong}";
        Font = new Font("Segoe UI", 10F);
        AutoScaleMode = AutoScaleMode.Font;
        ClientSize = new Size(980, 520);
        MinimumSize = new Size(700, 400);
        StartPosition = FormStartPosition.CenterParent;
        var layout = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 3,
            Padding = new Padding(10)
        };
        layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        _ngay.Value = ngay;
        var bar = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill
        };
        bar.Controls.Add(_ngay);
        bar.Controls.Add(LichChieuUi.Nut("Xem lịch", (_, _) => Tai()));
        layout.Controls.Add(bar, 0, 0);
        layout.Controls.Add(_bang, 0, 1);
        layout.Controls.Add(_count, 0, 2);
        Controls.Add(layout);
        Load += (_, _) => Tai();
    }

    private void Tai()
    {
        try
        {
            var dt = SuatChieuDAL.LayLichPhongTrongNgay(_ma, _ngay.Value);
            AdminUi.BindTable(_bang, dt);
            LichChieuUi.DinhDang(_bang);
            _count.Text = $"{dt.Rows.Count} suất chiếm phòng trong ngày (gồm suất qua đêm và thời gian dọn phòng).";
        }
        catch (Exception ex)
        {
            _bang.DataSource = null;
            LichChieuUi.Loi(ex, this);
        }
    }
}
