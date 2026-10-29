using System.Data;
namespace YeuMinhEmCinema.Admin;

internal sealed class FormGiaVe : Form
{
    private readonly DataRow? _row;
    private readonly ComboBox _loai = LichChieuUi.Combo(460),
        _dd = new()
        {
            Width = 460,
            MaxLength = 50,
            DropDownStyle = ComboBoxStyle.DropDown
        },
        _ln = LichChieuUi.Combo(230);
    private readonly DateTimePicker _tu = LichChieuUi.Ngay(), _den = LichChieuUi.Ngay();
    private readonly CheckBox _voHan = new()
    {
        Text = "Không có ngày kết thúc",
        AutoSize = true,
        Checked = true
    },
        _bat = new()
        {
            Text = "Đang áp dụng",
            AutoSize = true,
            Checked = true
        };
    private readonly NumericUpDown _gia = GiaVeFnbUi.Gia();
    private readonly Button _luu;
    private bool _busy;

    public FormGiaVe(DataRow? row)
    {
        _row = row;
        Text = row == null ? "Thêm giá vé" : "Sửa giá vé";
        Font = new Font("Segoe UI", 10F);
        AutoScaleMode = AutoScaleMode.Font;
        ClientSize = new Size(540, 620);
        MinimumSize = new Size(530, 470);
        StartPosition = FormStartPosition.CenterParent;
        var body = Khung(out var actions);
        _luu = LichChieuUi.Nut("Lưu", (_, _) => Luu(), true);
        actions.Controls.Add(_luu);
        var close = LichChieuUi.Nut("Đóng", (_, _) => Close());
        close.DialogResult = DialogResult.Cancel;
        actions.Controls.Add(close);
        AcceptButton = _luu;
        CancelButton = close;
        _ln.Items.AddRange(new object[]
        {
            "Ngày thường",
            "Cuối tuần"
        });
        _ln.SelectedIndex = 0;
        body.Controls.AddRange(new Control[]
            {
                LichChieuUi.Nhom("Loại ghế", _loai),
                LichChieuUi.Nhom("Định dạng (phải khớp phòng chiếu)", _dd),
                LichChieuUi.Nhom("Loại ngày: T2–T5 / T6–CN", _ln),
                LichChieuUi.Nhom("Áp dụng từ ngày", _tu),
                _voHan,
                LichChieuUi.Nhom("Đến hết ngày", _den),
                LichChieuUi.Nhom("Đơn giá cho mỗi mã ghế (đồng)", _gia),
                _bat,
                new Label
                {
                    Text = "Giá Sweetbox tính cho mỗi mã ghế trong sơ đồ, không tự nhân đôi.",
                    AutoSize = true,
                    MaximumSize = new Size(460, 0),
                    Padding = new Padding(4)
                }
            });
        _voHan.CheckedChanged += (_, _) => _den.Enabled = !_voHan.Checked;
        _den.Enabled = false;
        Load += (_, _) => Nap();
    }

    private FlowLayoutPanel Khung(out FlowLayoutPanel actions)
    {
        var panel = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 2,
            Padding = new Padding(12)
        };
        panel.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        panel.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        panel.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        var body = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true,
            WrapContents = false,
            FlowDirection = FlowDirection.TopDown
        };
        actions = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill
        };
        panel.Controls.Add(body, 0, 0);
        panel.Controls.Add(actions, 0, 1);
        Controls.Add(panel);
        return body;
    }

    private void Nap()
    {
        try
        {
            LichChieuUi.Gan(_loai, GiaVeFnbDAL.LoaiGhe(), "MaLoai", "TenLoai", "— Chọn loại ghế —");
            foreach (DataRow d in GiaVeFnbDAL.DinhDang().Rows)
                _dd.Items.Add(d["DinhDang"].ToString()!);
            if (_dd.Items.Count > 0)
                _dd.SelectedIndex = 0;
            if (_row != null)
            {
                _loai.SelectedValue = Convert.ToInt32(_row["MaLoaiGhe"]);
                _dd.Text = _row["DinhDang"].ToString();
                _ln.SelectedItem = _row["LoaiNgay"].ToString();
                _tu.Value = Convert.ToDateTime(_row["TuNgay"]);
                _voHan.Checked = _row["DenNgay"] == DBNull.Value;
                if (!_voHan.Checked)
                    _den.Value = Convert.ToDateTime(_row["DenNgay"]);
                _gia.Value = Convert.ToDecimal(_row["DonGia"]);
                _bat.Checked = Convert.ToBoolean(_row["DangApDung"]);
            }
        }
        catch (Exception ex)
        {
            _luu.Enabled = false;
            GiaVeFnbUi.Loi(ex, this);
        }
    }

    private void Luu()
    {
        if (_busy)
            return;
        var loai = LichChieuUi.Ma(_loai);
        if (!loai.HasValue || string.IsNullOrWhiteSpace(_dd.Text))
        {
            MessageBox.Show(this, "Chọn loại ghế và nhập định dạng.");
            return;
        }
        if (!_voHan.Checked && _den.Value.Date < _tu.Value.Date)
        {
            MessageBox.Show(this, "Ngày kết thúc không được trước ngày bắt đầu.");
            return;
        }
        _busy = true;
        _luu.Enabled = false;
        try
        {
            GiaVeFnbDAL.LuuGia(_row == null ? null : Convert.ToInt32(_row["MaGiaVe"]),
                loai.Value,
                _dd.Text,
                _ln.Text,
                _tu.Value,
                _voHan.Checked ? null : _den.Value,
                _gia.Value,
                _bat.Checked,
                _row == null ? null : (byte[])_row["PhienBan"]);
            DialogResult = DialogResult.OK;
            Close();
        }
        catch (Exception ex)
        {
            GiaVeFnbUi.Loi(ex, this);
        }
        finally
        {
            _busy = false;
            _luu.Enabled = true;
        }
    }
}
