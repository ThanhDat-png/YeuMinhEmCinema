using System.Data;
namespace YeuMinhEmCinema.Admin;

internal sealed class FormTraGiaVe : Form
{
    private readonly ComboBox _loai = LichChieuUi.Combo(450), _dd = LichChieuUi.Combo(450);
    private readonly DateTimePicker _ngay = LichChieuUi.Ngay();
    private readonly Label _result = new()
    {
        AutoSize = true,
        MaximumSize = new Size(480, 0),
        Padding = new Padding(6),
        Font = new Font("Segoe UI", 11F, FontStyle.Bold)
    };

    public FormTraGiaVe()
    {
        Text = "Tra giá vé theo ngày chiếu";
        ClientSize = new Size(530, 420);
        Font = new Font("Segoe UI", 10F);
        AutoScaleMode = AutoScaleMode.Font;
        StartPosition = FormStartPosition.CenterParent;
        var p = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            Padding = new Padding(14),
            AutoScroll = true,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false
        };
        p.Controls.AddRange(new Control[]
            {
                LichChieuUi.Nhom("Loại ghế", _loai),
                LichChieuUi.Nhom("Định dạng phòng", _dd),
                LichChieuUi.Nhom("Ngày chiếu", _ngay),
                LichChieuUi.Nut("Tra giá", (_, _) => Tra(), true),
                _result
            });
        Controls.Add(p);
        _ngay.ValueChanged += (_, _) => _result.Text = "";
        _loai.SelectedIndexChanged += (_, _) => _result.Text = "";
        _dd.SelectedIndexChanged += (_, _) => _result.Text = "";
        Load += (_, _) =>
        {
            try
            {
                LichChieuUi.Gan(_loai, GiaVeFnbDAL.LoaiGhe(), "MaLoai", "TenLoai", "— Chọn loại ghế —");
                foreach (DataRow d in GiaVeFnbDAL.DinhDang().Rows)
                    _dd.Items.Add(d["DinhDang"].ToString()!);
                if (_dd.Items.Count > 0)
                    _dd.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                GiaVeFnbUi.Loi(ex, this);
            }
        };
    }

    private void Tra()
    {
        var loai = LichChieuUi.Ma(_loai);
        if (!loai.HasValue || string.IsNullOrEmpty(_dd.Text))
        {
            MessageBox.Show(this, "Chọn loại ghế và định dạng.");
            return;
        }
        try
        {
            var dt = GiaVeFnbDAL.TraGia(loai.Value, _dd.Text, _ngay.Value);
            _result.Text = dt.Rows.Count == 0 ? "Chưa có giá áp dụng. Cần cấu hình trước khi bán." : dt.Rows.Count > 1 ? "Có nhiều giá chồng nhau. Cần kiểm tra dữ liệu." :
            $"{Convert.ToDecimal(dt.Rows[0]["DonGia"]):N0} đ / mã ghế\n{dt.Rows[0]["LoaiNgay"]} — giá mã {dt.Rows[0]["MaGiaVe"]}";
        }
        catch (Exception ex)
        {
            _result.Text = "Không tra được giá.";
            GiaVeFnbUi.Loi(ex, this);
        }
    }
}
