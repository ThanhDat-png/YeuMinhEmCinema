using System.Data;
namespace YeuMinhEmCinema.Admin;

internal static class GiaVeFnbUi
{
    internal static NumericUpDown Gia() =>
        new()
        {
            Minimum = 1,
            Maximum = 1000000000,
            Value = 80000,
            DecimalPlaces = 0,
            ThousandsSeparator = true,
            Increment = 1000,
            Width = 210
        };

    internal static void DinhDang(DataGridView g)
    {
        var map = new Dictionary<string, string>
        {
            ["MaGiaVe"] = "Mã giá",
            ["TenLoai"] = "Loại ghế",
            ["DinhDang"] = "Định dạng",
            ["LoaiNgay"] = "Loại ngày",
            ["TuNgay"] = "Từ ngày",
            ["DenNgay"] = "Đến ngày",
            ["DonGia"] = "Đơn giá (đ)",
            ["DangApDung"] = "Đang bật",
            ["MaSanPham"] = "Mã SP",
            ["MaHang"] = "Mã hàng",
            ["TenSanPham"] = "Tên sản phẩm",
            ["Nhom"] = "Nhóm",
            ["KichCo"] = "Kích cỡ",
            ["DangBan"] = "Bật bán",
            ["CoTheBan"] = "Có thể bán",
            ["TinhTrang"] = "Tình trạng",
            ["SoLuong"] = "Số lượng"
        };
        foreach (DataGridViewColumn c in g.Columns)
        {
            if (map.TryGetValue(c.Name, out var text))
                c.HeaderText = text;
            if (c.Name is "MaLoaiGhe" or "PhienBan" or "MaThanhPhan")
                c.Visible = false;
            if (c.ValueType == typeof(DateTime))
                c.DefaultCellStyle.Format = "dd/MM/yyyy";
            if (c.Name == "DonGia")
                c.DefaultCellStyle.Format = "N0";
        }
    }

    internal static void Loi(Exception ex, IWin32Window owner)
    {
        if (ex is Microsoft.Data.SqlClient.SqlException s && s.Number >= 50000)
            MessageBox.Show(owner, s.Message, "Giá vé & F&B", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        else
        {
            try
            {
                var dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "YeuMinhEmCinema",
                    "Logs");
                Directory.CreateDirectory(dir);
                File.AppendAllText(Path.Combine(dir, "gia-ve-fnb.log"),
                    $"{DateTime.Now:O} {ex.GetType().Name} SQL={(ex as Microsoft.Data.SqlClient.SqlException)?.Number} {ex.StackTrace}\n");
            }
            catch
            {
                System.Diagnostics.Trace.WriteLine("Không ghi được log Giá vé & F&B.");
            }
            MessageBox.Show(owner,
                "Không hoàn tất thao tác. Kiểm tra kết nối và đã chạy script 09_GiaVe_Fnb.sql. Chi tiết kỹ thuật được ghi vào log.",
                "Giá vé & F&B",
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning);
        }
    }

    internal static Control GhiChu(string text) => new Label
    {
        Text = text,
        AutoSize = true,
        MaximumSize = new Size(600, 0),
        Padding = new Padding(6)
    };

    internal static void Xuat(DataGridView g, IWin32Window owner, string ten)
    {
        if (g.Rows.Count == 0)
        {
            MessageBox.Show(owner, "Không có dữ liệu để xuất.");
            return;
        }
        using var f = new SaveFileDialog
        {
            Filter = "CSV (*.csv)|*.csv",
            FileName = $"{ten}-{DateTime.Now:yyyyMMdd-HHmm}.csv",
            DefaultExt = "csv",
            AddExtension = true
        };
        if (f.ShowDialog(owner) != DialogResult.OK)
            return;
        try
        {
            var cols = g.Columns.Cast<DataGridViewColumn>().Where(c => c.Visible).OrderBy(c => c.DisplayIndex).ToList();
            var dt = new DataTable();
            foreach (var c in cols)
                dt.Columns.Add(c.HeaderText);
            foreach (DataGridViewRow row in g.Rows)
                dt.Rows.Add(cols.Select(c => row.Cells[c.Index].FormattedValue?.ToString() ?? "").Cast<object>().ToArray());
            CsvUtility.Ghi(f.FileName, dt);
            MessageBox.Show(owner, "Đã xuất danh sách đang hiển thị.");
        }
        catch (Exception ex)
        {
            Loi(ex, owner);
        }
    }
}
