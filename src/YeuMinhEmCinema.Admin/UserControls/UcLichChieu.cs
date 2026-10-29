using System.Data;

namespace YeuMinhEmCinema.Admin;

public partial class UcLichChieu : UserControl
{
    private readonly ComboBox _rap = LichChieuUi.Combo(),
        _phong = LichChieuUi.Combo(180),
        _phim = LichChieuUi.Combo(),
        _tt = LichChieuUi.Combo(160);
    private readonly DateTimePicker _tu = LichChieuUi.Ngay(), _den = LichChieuUi.Ngay();
    private readonly CheckBox _locNgay = new()
    {
        Text = "Lọc khoảng ngày",
        AutoSize = true
    };
    private readonly TextBox _tim = new()
    {
        Width = 230,
        MaxLength = 200,
        PlaceholderText = "Nhập tên phim"
    };
    private readonly DataGridView _bang = LichChieuUi.Bang();
    private readonly Label _tong = new()
    {
        AutoSize = true,
        Padding = new Padding(6)
    };
    private bool _loading;
    private readonly List<Button> _thaoTac = new();

    public UcLichChieu()
    {
        InitializeComponent();
        Dock = DockStyle.Fill;
        Font = new Font("Segoe UI", 10F);
        BackColor = Color.White;
        var layout = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 5,
            Padding = new Padding(12)
        };
        layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.Controls.Add(new Label
            {
                Text = "QUẢN LÝ SUẤT CHIẾU",
                Font = new Font("Segoe UI", 15F, FontStyle.Bold),
                AutoSize = true,
                Padding = new Padding(4, 4, 4, 10)
            },
            0,
            0);
        var filters = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill,
            WrapContents = true
        };
        filters.Controls.AddRange(new Control[]
            {
                LichChieuUi.Nhom("Rạp", _rap),
                LichChieuUi.Nhom("Phòng", _phong),
                LichChieuUi.Nhom("Phim", _phim),
                LichChieuUi.Nhom("Trạng thái", _tt),
                LichChieuUi.Nhom("Từ ngày", _tu),
                LichChieuUi.Nhom("Đến ngày", _den),
                LichChieuUi.Nhom("Tên phim", _tim),
                _locNgay
            });
        layout.Controls.Add(filters, 0, 1);
        var actions = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill,
            WrapContents = true
        };
        actions.Controls.Add(LichChieuUi.Nut("Lọc", (_, _) => Tai()));
        actions.Controls.Add(LichChieuUi.Nut("Làm mới", (_, _) => NapBoLoc()));
        actions.Controls.Add(LichChieuUi.Nut("+ Thêm suất", (_, _) => Them(), true));

        void ThemNut(string ten, Action f)
        {
            var b = LichChieuUi.Nut(ten, (_, _) => f());
            _thaoTac.Add(b);
            actions.Controls.Add(b);
        }
        ThemNut("Sửa", Sua);
        ThemNut("Ngừng bán", () => Doi("Ngừng bán"));
        ThemNut("Mở bán lại", () => Doi("Mở bán"));
        ThemNut("Hủy suất", () => Doi("Đã hủy"));
        ThemNut("Lịch phòng", XemPhong);
        actions.Controls.Add(LichChieuUi.Nut("Sao chép ngày", (_, _) => SaoChep()));
        actions.Controls.Add(LichChieuUi.Nut("Xuất CSV", (_, _) => Xuat()));
        layout.Controls.Add(actions, 0, 2);
        layout.Controls.Add(_bang, 0, 3);
        layout.Controls.Add(_tong, 0, 4);
        Controls.Add(layout);
        _tt.Items.AddRange(new object[]
        {
            "Tất cả",
            "Mở bán",
            "Ngừng bán",
            "Đã hủy"
        });
        _tt.SelectedIndex = 0;
        _rap.SelectedIndexChanged += (_, _) =>
        {
            if (!_loading)
                NapPhong();
        };
        _bang.SelectionChanged += (_, _) => CapNhatNut();
        _bang.CellFormatting += (_, e) =>
        {
            if (e.RowIndex >= 0 && _bang.Rows[e.RowIndex].DataBoundItem is DataRowView rv)
                _bang.Rows[e.RowIndex].DefaultCellStyle.ForeColor = rv.Row["TrangThai"].ToString() == "Đã hủy" ? Color.Gray :
                rv.Row["TrangThai"].ToString() == "Ngừng bán" ? Color.FromArgb(156, 80, 0) : Color.FromArgb(15, 23, 42);
        };
        _tim.KeyDown += (_, e) =>
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                Tai();
            }
        };
        Load += (_, _) => NapBoLoc();
        CapNhatNut();
    }

    private void NapBoLoc()
    {
        _loading = true;
        try
        {
            LichChieuUi.Gan(_rap, SuatChieuDAL.LayRap(), "MaRap", "TenRap", "Tất cả rạp");
            LichChieuUi.Gan(_phim, SuatChieuDAL.LayPhim(), "MaPhim", "TenPhim", "Tất cả phim");
            _tt.SelectedIndex = 0;
            _locNgay.Checked = false;
            _tu.Value = DateTime.Today;
            _den.Value = DateTime.Today.AddDays(7);
            _tim.Clear();
            NapPhong();
            _loading = false;
            Tai();
        }
        catch (Exception ex)
        {
            LichChieuUi.Loi(ex, FindForm());
        }
        finally
        {
            _loading = false;
        }
    }

    private void NapPhong()
    {
        try
        {
            LichChieuUi.Gan(_phong,
                SuatChieuDAL.LayPhong(LichChieuUi.Ma(_rap)),
                "MaPhong",
                "TenPhong",
                "Tất cả phòng");
        }
        catch (Exception ex)
        {
            _phong.DataSource = null;
            LichChieuUi.Loi(ex, FindForm());
        }
    }

    private void Tai(int? chon = null)
    {
        try
        {
            if (_locNgay.Checked && _tu.Value.Date > _den.Value.Date)
            {
                MessageBox.Show("Từ ngày phải trước hoặc bằng đến ngày.");
                return;
            }
            var dt = SuatChieuDAL.LayDanhSachSuatChieu(_locNgay.Checked ? _tu.Value.Date : null,
                _locNgay.Checked ? _den.Value.Date : null,
                LichChieuUi.Ma(_rap),
                LichChieuUi.Ma(_phong),
                LichChieuUi.Ma(_phim),
                _tt.SelectedIndex <= 0 ? null : _tt.Text,
                _tim.Text);
            AdminUi.BindTable(_bang, dt);
            LichChieuUi.DinhDang(_bang);
            _tong.Text = dt.Rows.Count == 0 ? "Không có suất chiếu phù hợp." : $"{dt.Rows.Count} suất. Phòng sẵn sàng = giờ kết thúc + thời gian dọn phòng.";
            if (chon.HasValue)
                foreach (DataGridViewRow row in _bang.Rows)
                if (Convert.ToInt32(row.Cells["MaSuatChieu"].Value) == chon.Value)
                {
                    _bang.CurrentCell = row.Cells["MaSuatChieu"];
                    row.Selected = true;
                    break;
                }
            CapNhatNut();
        }
        catch (Exception ex)
        {
            _bang.DataSource = null;
            _tong.Text = "Không tải được danh sách.";
            CapNhatNut();
            LichChieuUi.Loi(ex, FindForm());
        }
    }

    private DataRow? Chon() => (_bang.CurrentRow?.DataBoundItem as DataRowView)?.Row;

    private void CapNhatNut()
    {
        var row = Chon();
        bool co = row != null;
        foreach (var b in _thaoTac)
            b.Enabled = co;
        if (!co)
            return;
        bool sua = Convert.ToDateTime(row!["GioBatDau"]) > DateTime.Now && row["TrangThai"].ToString() != "Đã hủy";
        _thaoTac[0].Enabled = sua;
        _thaoTac[1].Enabled = sua && row["TrangThai"].ToString() == "Mở bán";
        _thaoTac[2].Enabled = sua && row["TrangThai"].ToString() == "Ngừng bán";
        _thaoTac[3].Enabled = sua;
    }

    private void BoLoc()
    {
        _loading = true;
        _rap.SelectedValue = 0;
        NapPhong();
        _phim.SelectedValue = 0;
        _tt.SelectedIndex = 0;
        _locNgay.Checked = false;
        _tim.Clear();
        _loading = false;
    }

    private void Them()
    {
        using var f = new FormThemSuatChieu();
        if (f.ShowDialog(FindForm()) == DialogResult.OK)
        {
            BoLoc();
            Tai(f.MaSuatChieuMoi);
        }
    }

    private void Sua()
    {
        var row = Chon();
        if (row == null)
            return;
        int ma = Convert.ToInt32(row["MaSuatChieu"]);
        using var f = new FormSuaSuatChieu(ma, row);
        if (f.ShowDialog(FindForm()) == DialogResult.OK)
        {
            BoLoc();
            Tai(ma);
        }
    }

    private void Doi(string tt)
    {
        var row = Chon();
        if (row == null)
            return;
        int ma = Convert.ToInt32(row["MaSuatChieu"]);
        if (MessageBox.Show($"Suất {ma}: {row["TenPhim"]}\n{row["TenRap"]} — {row["TenPhong"]}\n{Convert.ToDateTime(row["GioBatDau"]):dd/MM/yyyy HH:mm}\n\nChuyển thành: {tt}?",
            "Xác nhận",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question) != DialogResult.Yes)
            return;
        try
        {
            SuatChieuDAL.DoiTrangThai(ma, tt);
            Tai(ma);
        }
        catch (Exception ex)
        {
            LichChieuUi.Loi(ex, FindForm());
        }
    }

    private void XemPhong()
    {
        var row = Chon();
        if (row == null)
            return;
        using var f = new FormLichPhongTrongNgay(Convert.ToInt32(row["MaPhong"]),
            row["TenPhong"].ToString() ?? "",
            Convert.ToDateTime(row["GioBatDau"]).Date);
        f.ShowDialog(FindForm());
    }

    private void SaoChep()
    {
        using var f = new FormSaoChepLich();
        if (f.ShowDialog(FindForm()) == DialogResult.OK)
        {
            BoLoc();
            Tai();
        }
    }

    private void Xuat()
    {
        if (_bang.Rows.Count == 0)
        {
            MessageBox.Show("Chưa có dữ liệu để xuất.");
            return;
        }
        using var dialog = new SaveFileDialog
        {
            Filter = "CSV (*.csv)|*.csv",
            FileName = $"LichChieu-{DateTime.Now:yyyyMMdd-HHmm}.csv",
            DefaultExt = "csv",
            AddExtension = true
        };
        if (dialog.ShowDialog(FindForm()) != DialogResult.OK)
            return;
        try
        {
            var cols = _bang.Columns.Cast<DataGridViewColumn>().Where(c => c.Visible).OrderBy(c => c.DisplayIndex).ToList();
            var dt = new DataTable();
            foreach (var c in cols)
                dt.Columns.Add(c.HeaderText, typeof(string));
            foreach (DataGridViewRow row in _bang.Rows)
                dt.Rows.Add(cols.Select(c => row.Cells[c.Index].FormattedValue?.ToString() ?? "").Cast<object>().ToArray());
            CsvUtility.Ghi(dialog.FileName, dt);
            MessageBox.Show("Đã xuất danh sách đang hiển thị.");
        }
        catch (Exception ex)
        {
            LichChieuUi.Loi(ex, FindForm());
        }
    }
}
