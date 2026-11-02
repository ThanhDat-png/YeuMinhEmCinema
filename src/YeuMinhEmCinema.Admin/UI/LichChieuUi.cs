using System.Data;
using Microsoft.Data.SqlClient;

namespace YeuMinhEmCinema.Admin;

internal static class LichChieuUi
{
    public static ComboBox Combo(int width = 230) => new()
    {
        Width = width,
        DropDownStyle = ComboBoxStyle.DropDownList
    };

    public static DateTimePicker Ngay() => new()
    {
        Width = 145,
        Format = DateTimePickerFormat.Custom,
        CustomFormat = "dd/MM/yyyy"
    };

    public static Button Nut(string text, EventHandler click, bool chinh = false)
    {
        var b = new Button
        {
            Text = text,
            AutoSize = true,
            Padding = new Padding(8, 5, 8, 5),
            BackColor = chinh ? Color.FromArgb(211, 47, 47) : Color.FromArgb(51, 65, 85),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Cursor = Cursors.Hand,
            Margin = new Padding(4)
        };
        b.Click += click;
        return b;
    }

    public static Control Nhom(string ten, Control c)
    {
        var p = new FlowLayoutPanel
        {
            AutoSize = true,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false,
            Margin = new Padding(4, 4, 10, 8)
        };
        p.Controls.Add(new Label
        {
            Text = ten,
            AutoSize = true
        });
        p.Controls.Add(c);
        return p;
    }

    public static void Gan(ComboBox cbo,
        DataTable dt,
        string ma,
        string ten,
        string? dau = null)
    {
        cbo.DataSource = null;
        cbo.DisplayMember = ten;
        cbo.ValueMember = ma;
        var copy = dt.Copy();
        if (dau != null)
        {
            var row = copy.NewRow();
            row[ma] = 0;
            row[ten] = dau;
            copy.Rows.InsertAt(row, 0);
        }
        cbo.DataSource = copy;
        if (copy.Rows.Count > 0)
            cbo.SelectedIndex = 0;
    }

    public static int? Ma(ComboBox c) => c.SelectedValue is int n && n > 0 ? n : null;

    public static DataGridView Bang() =>
        new()
        {
            Dock = DockStyle.Fill,
            ReadOnly = true,
            AllowUserToAddRows = false,
            AllowUserToDeleteRows = false,
            RowHeadersVisible = false,
            SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            MultiSelect = false,
            AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells,
            BackgroundColor = Color.White,
            BorderStyle = BorderStyle.None
        };

    public static void DinhDang(DataGridView g)
    {
        var ten = new Dictionary<string, string>
        {
            ["MaSuatChieu"] = "Mã suất",
            ["MaSuatNguon"] = "Mã nguồn",
            ["TenPhim"] = "Phim",
            ["TenRap"] = "Rạp",
            ["TenPhong"] = "Phòng",
            ["DinhDang"] = "Định dạng",
            ["GioBatDau"] = "Bắt đầu",
            ["GioKetThuc"] = "Kết thúc",
            ["PhutDonPhong"] = "Dọn phòng (phút)",
            ["GioSanSang"] = "Phòng sẵn sàng",
            ["TrangThai"] = "Trạng thái"
        };
        foreach (DataGridViewColumn c in g.Columns)
        {
            if (ten.TryGetValue(c.Name, out var t))
                c.HeaderText = t;
            if (c.Name is "MaPhim" or "MaPhong" or "MaRap" or "ChuKy")
                c.Visible = false;
            if (c.ValueType == typeof(DateTime))
                c.DefaultCellStyle.Format = "dd/MM/yyyy HH:mm";
        }
        g.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
    }

    public static void Loi(Exception ex, IWin32Window? owner = null)
    {
        string msg;
        if (ex is SqlException sql && sql.Number >= 50000)
            msg = sql.Message;
        else
        {
            msg = ex is SqlException ? "Không thể truy cập dữ liệu. Kiểm tra kết nối và đã chạy script SQL 04–08." :
            "Thao tác chưa hoàn tất. Kiểm tra quyền truy cập và dữ liệu đầu vào.";
            try
            {
                var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "YeuMinhEmCinema",
                    "Logs");
                Directory.CreateDirectory(path);
                // Không ghi câu SQL, chuỗi kết nối, hoặc dữ liệu khách hàng.
                File.AppendAllText(Path.Combine(path, "lich-chieu.log"),
                    $"{DateTime.Now:O} {ex.GetType().Name} SQL={(ex as SqlException)?.Number} {ex.StackTrace}\n");
            }
            catch
            {
                System.Diagnostics.Trace.WriteLine("Không ghi được log lịch chiếu.");
            }
        }
        MessageBox.Show(owner,
            msg,
            "Thông báo lịch chiếu",
            MessageBoxButtons.OK,
            MessageBoxIcon.Warning);
    }
}
