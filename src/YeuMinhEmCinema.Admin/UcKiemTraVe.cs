using System.Data;

namespace YeuMinhEmCinema.Admin;

public partial class UcKiemTraVe : DataPage
{
    private readonly TextBox code = AdminUi.Text(100);
    private readonly ComboBox show = AdminUi.Combo();
    private readonly DateTimePicker day = new() { Format = DateTimePickerFormat.Custom, CustomFormat = "dd/MM/yyyy", Width = 125 };
    private readonly Label status = new() { AutoSize = true, Padding = new Padding(5), Text = "Chọn suất trước khi kiểm vé." };
    private readonly Button lookup, confirm;

    public UcKiemTraVe() : base("Kiểm vé — chọn suất, quét QR hoặc dán mã vé")
    {
        show.Width = 580;
        show.AccessibleName = "Suất chiếu đang soát";
        show.DropDownWidth = 1000;
        day.AccessibleName = "Ngày soát vé";
        code.Width = 350;
        code.PlaceholderText = "Mã vé / QR (GUID)";
        code.AccessibleName = "Mã vé / QR";
        var context = new FlowLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, WrapContents = true };
        context.Controls.AddRange(new Control[] { AdminUi.Label("Ngày"), day,
            AdminUi.Button("Tải suất", LoadShows), AdminUi.Label("Suất đang soát"), show });
        var inputs = new FlowLayoutPanel { AutoSize = true, Dock = DockStyle.Fill, WrapContents = true };
        lookup = AdminUi.Button("Tra cứu", () => Run(() => Check(false)));
        confirm = AdminUi.Button("Xác nhận vào rạp", () => Run(() =>
        {
            var row = SelectedShow();
            if (AdminUi.Confirm($"Xác nhận vào {row["TenRap"]} — {row["TenPhong"]}\n{show.Text}?")) Check(true);
        }));
        inputs.Controls.AddRange(new Control[] { code, lookup, confirm });
        Bar.FlowDirection = FlowDirection.TopDown;
        Bar.WrapContents = false;
        Bar.Controls.AddRange(new Control[] { context, inputs, status });
        show.SelectedIndexChanged += (_, _) => ClearResult();
        code.TextChanged += (_, _) => Grid.DataSource = null;
        day.ValueChanged += (_, _) => Run(LoadShows);
        code.KeyDown += (_, e) =>
        {
            if (e.KeyCode == Keys.Enter) { e.SuppressKeyPress = true; Run(() => Check(false)); }
        };
        Load += (_, _) => Run(LoadShows);
        ClearResult();
    }

    private DataRow SelectedShow() => (show.SelectedItem as DataRowView)?.Row
        ?? throw new ArgumentException("Chọn suất chiếu đang soát trước khi kiểm vé.");

    private void ClearResult()
    {
        Grid.DataSource = null;
        bool selected = show.SelectedItem is DataRowView;
        lookup.Enabled = confirm.Enabled = selected && Db.Has("VE_KIEM_TRA");
        status.Text = selected ? $"Đang soát: {show.Text}" : "Chọn suất trước khi kiểm vé. Danh sách gồm cả suất từ hôm trước còn chiếu trong ngày.";
    }

    private void LoadShows()
    {
        show.DataSource = null;
        ClearResult();
        var table = Db.Table("dbo.sp_YMC_LaySuatSoatVe", ("@NguoiThucHien", Db.Actor), ("@Ngay", day.Value.Date));
        table.Columns.Add("HienThi", typeof(string));
        foreach (DataRow row in table.Rows)
            row["HienThi"] = $"#{row["MaSuatChieu"]} • {row["TenRap"]} / {row["TenPhong"]} • {Convert.ToDateTime(row["GioBatDau"]):dd/MM HH:mm} • {row["TenPhim"]}";
        AdminUi.Bind(show, table, "MaSuatChieu", "HienThi");
        show.SelectedIndex = -1;
        ClearResult();
        if (table.Rows.Count == 0) status.Text = "Không có suất trong ngày thuộc phạm vi của bạn. Chọn ngày khác hoặc tải lại suất.";
    }

    private void Check(bool confirmEntry)
    {
        Grid.DataSource = null;
        var row = SelectedShow();
        if (!Guid.TryParse(code.Text.Trim(), out var id)) throw new ArgumentException("Mã QR/mã vé phải là GUID hợp lệ.");
        var table = Db.Table("dbo.sp_YMC_KiemTraVe", ("@NguoiThucHien", Db.Actor), ("@MaVe", id),
            ("@XacNhanVaoRap", confirmEntry), ("@MaSuatChieu", (int)row["MaSuatChieu"]), ("@MaPhong", (int)row["MaPhong"]));
        AdminUi.Bind(Grid, table);
        if (confirmEntry)
        {
            MessageBox.Show("Đã xác nhận vé vào rạp.");
            code.Clear();
            code.Focus();
        }
    }
}
