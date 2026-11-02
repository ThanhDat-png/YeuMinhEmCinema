using System.Data;

namespace YeuMinhEmCinema.Admin;

public class FormSuatChieuBase : Form
{
    private readonly int? _ma;
    private readonly DataRow? _row;
    private readonly ComboBox _phim = LichChieuUi.Combo(340);
    private readonly ComboBox _rap = LichChieuUi.Combo(340);
    private readonly ComboBox _phong = LichChieuUi.Combo(340);
    private readonly DateTimePicker _gio = new()
    {
        Width = 260,
        Format = DateTimePickerFormat.Custom,
        CustomFormat = "dd/MM/yyyy HH:mm"
    };
    private readonly NumericUpDown _don = new()
    {
        Width = 100,
        Minimum = 0,
        Maximum = 120,
        Value = 15
    };
    private readonly Label _duKien = new()
    {
        AutoSize = true,
        MaximumSize = new Size(340, 0),
        Padding = new Padding(4, 10, 4, 10)
    };
    private readonly Label _tieuDeLich = new()
    {
        AutoSize = true,
        Font = new Font("Segoe UI", 12F, FontStyle.Bold),
        Text = "Lịch phòng trong ngày",
        Padding = new Padding(0, 4, 0, 8)
    };
    private readonly Label _trangThaiLich = new()
    {
        Dock = DockStyle.Fill,
        Padding = new Padding(10),
        Text = "Chọn rạp và phòng để xem lịch.",
        BackColor = Color.FromArgb(232, 241, 253),
        AutoEllipsis = true
    };
    private readonly Label _chuThich = new()
    {
        AutoSize = true,
        MaximumSize = new Size(620, 0),
        Text = "Bảng hiển thị cả thời gian dọn phòng và suất qua đêm. Suất đã hủy không chiếm phòng.",
        Padding = new Padding(0, 8, 0, 8)
    };
    private readonly DataGridView _bangLich = LichChieuUi.Bang();
    private readonly Button _luu;
    private readonly Button _goiY;
    private DataTable? _lichPhong;
    private int? _phongDaTai;
    private DateTime _tuDaTai;
    private DateTime _denDaTai;
    private DateTime? _gioGoiY;
    private bool _loading;
    private bool _busy;
    private bool _lichSanSang;
    private bool _trungLich;

    public int MaDaLuu { get; private set; }

    protected FormSuatChieuBase(int? ma, DataRow? row)
    {
        _ma = ma;
        _row = row;
        Text = ma.HasValue ? $"Sửa suất chiếu {ma}" : "Thêm suất chiếu — kiểm tra lịch phòng";
        Font = new Font("Segoe UI", 10F);
        AutoScaleMode = AutoScaleMode.Font;
        ClientSize = new Size(1120, 660);
        MinimumSize = new Size(980, 580);
        StartPosition = FormStartPosition.CenterParent;

        var shell = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 2,
            Padding = new Padding(14)
        };
        shell.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        shell.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        shell.RowStyles.Add(new RowStyle(SizeType.AutoSize));

        var columns = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 2,
            RowCount = 1
        };
        columns.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 380));
        columns.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        columns.RowStyles.Add(new RowStyle(SizeType.Percent, 100));

        var body = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false,
            Padding = new Padding(0, 0, 10, 0)
        };
        body.Controls.AddRange(new Control[]
        {
            LichChieuUi.Nhom("Phim", _phim),
            LichChieuUi.Nhom("Rạp", _rap),
            LichChieuUi.Nhom("Phòng có ghế hoạt động", _phong),
            LichChieuUi.Nhom("Bắt đầu", _gio),
            LichChieuUi.Nhom("Dọn phòng (phút)", _don),
            _duKien
        });

        var calendar = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 5,
            Padding = new Padding(12, 0, 0, 0)
        };
        calendar.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        calendar.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        calendar.RowStyles.Add(new RowStyle(SizeType.Absolute, 105));
        calendar.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        calendar.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        calendar.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        _bangLich.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
        _bangLich.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
        _bangLich.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
        _bangLich.DataBindingComplete += (_, _) => ToMauLich();

        var calendarActions = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill,
            WrapContents = true
        };
        _goiY = LichChieuUi.Nut("Dùng giờ trống kế tiếp", (_, _) => DungGioGoiY(), true);
        _goiY.Enabled = false;
        calendarActions.Controls.Add(_goiY);
        calendarActions.Controls.Add(LichChieuUi.Nut("Tải lại lịch", (_, _) => CapNhatLich(true)));
        calendar.Controls.Add(_tieuDeLich, 0, 0);
        calendar.Controls.Add(_trangThaiLich, 0, 1);
        calendar.Controls.Add(_bangLich, 0, 2);
        calendar.Controls.Add(_chuThich, 0, 3);
        calendar.Controls.Add(calendarActions, 0, 4);
        columns.Controls.Add(body, 0, 0);
        columns.Controls.Add(calendar, 1, 0);

        var actions = new FlowLayoutPanel
        {
            AutoSize = true,
            Dock = DockStyle.Fill,
            WrapContents = true,
            Padding = new Padding(0, 8, 0, 0)
        };
        actions.Controls.Add(LichChieuUi.Nut("Mở lịch phòng riêng", (_, _) => XemLich()));
        _luu = LichChieuUi.Nut("Lưu suất chiếu", (_, _) => Luu(), true);
        _luu.Enabled = false;
        var dong = LichChieuUi.Nut("Đóng", (_, _) =>
        {
            DialogResult = DialogResult.Cancel;
            Close();
        });
        dong.DialogResult = DialogResult.Cancel;
        actions.Controls.AddRange(new Control[] { _luu, dong });
        shell.Controls.Add(columns, 0, 0);
        shell.Controls.Add(actions, 0, 1);
        Controls.Add(shell);
        AcceptButton = _luu;
        CancelButton = dong;

        _rap.SelectedIndexChanged += (_, _) =>
        {
            if (!_loading)
            {
                NapPhong();
                CapNhatLich(true);
            }
        };
        _phong.SelectedIndexChanged += (_, _) => CapNhatLich();
        _phim.SelectedIndexChanged += (_, _) => CapNhatDuKien();
        _gio.ValueChanged += (_, _) => CapNhatDuKien();
        _don.ValueChanged += (_, _) => CapNhatDuKien();
        Load += (_, _) => Nap();
    }

    private void Nap()
    {
        _loading = true;
        try
        {
            LichChieuUi.Gan(_phim, SuatChieuDAL.LayPhim(true), "MaPhim", "TenPhim", "— Chọn phim —");
            LichChieuUi.Gan(_rap, SuatChieuDAL.LayRap(true), "MaRap", "TenRap", "— Chọn rạp —");
            _gio.Value = DateTime.Today.AddDays(1).AddHours(18);
            if (_row != null)
            {
                _phim.SelectedValue = Convert.ToInt32(_row["MaPhim"]);
                _rap.SelectedValue = Convert.ToInt32(_row["MaRap"]);
                NapPhong();
                _phong.SelectedValue = Convert.ToInt32(_row["MaPhong"]);
                _gio.Value = Convert.ToDateTime(_row["GioBatDau"]);
                _don.Value = Convert.ToDecimal(_row["PhutDonPhong"]);
                if (!LichChieuUi.Ma(_phim).HasValue || !LichChieuUi.Ma(_phong).HasValue)
                {
                    MessageBox.Show(this,
                        "Phim hoặc phòng cũ không còn đủ điều kiện. Vui lòng chọn lại; chưa có thay đổi nào được lưu.",
                        "Kiểm tra lịch");
                }
            }
            else
            {
                NapPhong();
            }
        }
        catch (Exception ex)
        {
            LichChieuUi.Loi(ex, this);
        }
        finally
        {
            _loading = false;
            CapNhatDuKien();
        }
    }

    private void NapPhong()
    {
        var wasLoading = _loading;
        _loading = true;
        try
        {
            var rap = LichChieuUi.Ma(_rap);
            if (!rap.HasValue)
            {
                _phong.DataSource = null;
                return;
            }

            LichChieuUi.Gan(_phong, SuatChieuDAL.LayPhong(rap, true),
                "MaPhong", "TenPhong", "— Chọn phòng —");
        }
        catch (Exception ex)
        {
            _phong.DataSource = null;
            LichChieuUi.Loi(ex, this);
        }
        finally
        {
            _loading = wasLoading;
        }
    }

    private DateTime Gio()
    {
        return new DateTime(_gio.Value.Year, _gio.Value.Month, _gio.Value.Day,
            _gio.Value.Hour, _gio.Value.Minute, 0);
    }

    private int? ThoiLuong()
    {
        if (!LichChieuUi.Ma(_phim).HasValue || _phim.SelectedItem is not DataRowView rv
            || rv.Row["ThoiLuong"] == DBNull.Value)
        {
            return null;
        }

        return Convert.ToInt32(rv.Row["ThoiLuong"]);
    }

    private DateTime? SanSang()
    {
        var duration = ThoiLuong();
        return duration.HasValue ? Gio().AddMinutes(duration.Value + (int)_don.Value) : null;
    }

    private void KhaDung()
    {
        _luu.Enabled = !_busy && !_loading && _lichSanSang && !_trungLich
            && ThoiLuong().HasValue && LichChieuUi.Ma(_phong).HasValue;
        _goiY.Enabled = !_busy && _lichSanSang && _gioGoiY.HasValue;
    }

    private void CapNhatDuKien()
    {
        var duration = ThoiLuong();
        if (!duration.HasValue || _phim.SelectedItem is not DataRowView rv)
        {
            _duKien.Text = "Chọn phim để xem thời lượng và giờ kết thúc.";
        }
        else
        {
            var end = Gio().AddMinutes(duration.Value);
            _duKien.Text = $"Thời lượng: {duration} phút | Khởi chiếu: {Convert.ToDateTime(rv.Row["NgayKhoiChieu"]):dd/MM/yyyy}\n"
                + $"Kết thúc dự kiến: {end:dd/MM/yyyy HH:mm}\n"
                + $"Phòng sẵn sàng: {SanSang():dd/MM/yyyy HH:mm}";
        }

        CapNhatLich();
    }

    private List<RoomBooking> CacSuatKhac()
    {
        return _lichPhong?.AsEnumerable()
            .Where(row => !_ma.HasValue || Convert.ToInt32(row["MaSuatChieu"]) != _ma.Value)
            .Select(row => new RoomBooking(Convert.ToInt32(row["MaSuatChieu"]),
                Convert.ToDateTime(row["GioBatDau"]), Convert.ToDateTime(row["GioSanSang"])))
            .ToList() ?? new List<RoomBooking>();
    }

    private void CapNhatLich(bool force = false)
    {
        if (_loading)
        {
            return;
        }

        _gioGoiY = null;
        _goiY.Text = "Dùng giờ trống kế tiếp";
        var room = LichChieuUi.Ma(_phong);
        if (!room.HasValue)
        {
            _lichSanSang = false;
            _lichPhong = null;
            _phongDaTai = null;
            _bangLich.DataSource = null;
            BaoTrangThai("Chọn rạp và phòng để xem lịch.", false);
            KhaDung();
            return;
        }

        try
        {
            var start = Gio();
            var ready = SanSang();
            // Đọc trước 7 ngày để gợi ý khoảng trống; lịch qua nửa đêm vẫn được kiểm.
            if (force || !_lichSanSang || _phongDaTai != room || _tuDaTai != start.Date
                || (ready.HasValue && ready.Value > _denDaTai))
            {
                _lichSanSang = false;
                _lichPhong = null;
                _tuDaTai = start.Date;
                _denDaTai = start.Date.AddDays(7);
                if (ready.HasValue && ready.Value > _denDaTai)
                {
                    _denDaTai = ready.Value;
                }

                _lichPhong = SuatChieuDAL.LayLichPhongTrongKhoang(room.Value, _tuDaTai, _denDaTai);
                _phongDaTai = room;
                _lichSanSang = true;
            }

            _tieuDeLich.Text = $"{_phong.Text} · {start:dd/MM/yyyy}";
            var bookings = CacSuatKhac();
            var until = ready.HasValue && ready.Value > start.Date.AddDays(1)
                ? ready.Value : start.Date.AddDays(1);
            var visible = _lichPhong!.Clone();
            foreach (DataRow row in _lichPhong.Rows)
            {
                var id = Convert.ToInt32(row["MaSuatChieu"]);
                var bookingStart = Convert.ToDateTime(row["GioBatDau"]);
                var bookingReady = Convert.ToDateTime(row["GioSanSang"]);
                if ((!_ma.HasValue || id != _ma.Value) && bookingStart < until && bookingReady > start.Date)
                {
                    visible.ImportRow(row);
                }
            }

            AdminUi.BindTable(_bangLich, visible);
            LichChieuUi.DinhDang(_bangLich);
            _bangLich.Columns["GioSanSang"].HeaderText = "Dọn xong / sẵn sàng";
            _trungLich = ready.HasValue && bookings.Any(item => RoomSchedule.Overlaps(start, ready.Value, item));
            if (!ready.HasValue)
            {
                BaoTrangThai(visible.Rows.Count == 0
                    ? "Chưa có suất chiếm phòng trong ngày này. Chọn phim để kiểm tra khung giờ mới."
                    : $"Đã có {visible.Rows.Count} suất chiếm phòng trong ngày. Chọn phim để kiểm tra khung giờ mới.", false);
            }
            else if (_trungLich)
            {
                var candidate = RoomSchedule.NextStart(bookings, start, ready.Value - start);
                // Không gợi ý nếu phần cuối nằm ngoài khoảng dữ liệu đã đọc.
                if (candidate.Add(ready.Value - start) <= _denDaTai)
                {
                    _gioGoiY = candidate;
                    _goiY.Text = $"Dùng giờ trống {candidate:dd/MM HH:mm}";
                }

                BaoTrangThai("TRÙNG LỊCH — khung giờ mới chồng lên suất chiếu hoặc thời gian dọn phòng.\n"
                    + (_gioGoiY.HasValue ? $"Có thể bắt đầu từ {_gioGoiY:dd/MM/yyyy HH:mm}." : "Hãy thử ngày khác."), true);
            }
            else
            {
                BaoTrangThai($"KHUNG GIỜ TRỐNG — {start:HH:mm dd/MM} → {ready:HH:mm dd/MM}.\n"
                    + (visible.Rows.Count == 0 ? "Chưa có suất khác trong khoảng ngày đang xem."
                        : $"Có {visible.Rows.Count} suất khác; không trùng với khung giờ mới."), false, true);
            }

            _chuThich.Text = "Hồng: trùng khung giờ mới. Bảng gồm giờ dọn phòng và suất qua đêm; không tính suất đã hủy"
                + (_ma.HasValue ? " hoặc suất đang sửa." : ".")
                + " Bấm Tải lại lịch để lấy thay đổi từ máy khác. CSDL kiểm tra lại khi lưu.";
            ToMauLich();
        }
        catch (Exception ex)
        {
            _lichSanSang = false;
            _lichPhong = null;
            _bangLich.DataSource = null;
            BaoTrangThai("Chưa xác định được phòng trống vì không tải được lịch.\n" + Db.Error(ex), true);
        }
        finally
        {
            KhaDung();
        }
    }

    private void BaoTrangThai(string text, bool error, bool available = false)
    {
        _trangThaiLich.Text = text;
        _trangThaiLich.BackColor = error ? Color.FromArgb(255, 232, 235)
            : available ? Color.FromArgb(225, 246, 237) : Color.FromArgb(232, 241, 253);
        _trangThaiLich.ForeColor = error ? Color.FromArgb(153, 27, 27)
            : available ? Color.FromArgb(16, 101, 70) : Color.FromArgb(18, 57, 100);
    }

    private void ToMauLich()
    {
        var ready = SanSang();
        foreach (DataGridViewRow row in _bangLich.Rows)
        {
            if (row.DataBoundItem is not DataRowView view)
            {
                continue;
            }

            var booking = new RoomBooking(Convert.ToInt32(view.Row["MaSuatChieu"]),
                Convert.ToDateTime(view.Row["GioBatDau"]), Convert.ToDateTime(view.Row["GioSanSang"]));
            var conflict = ready.HasValue && RoomSchedule.Overlaps(Gio(), ready.Value, booking);
            row.DefaultCellStyle.BackColor = conflict ? Color.FromArgb(255, 232, 235) : Color.White;
            row.DefaultCellStyle.ForeColor = conflict ? Color.FromArgb(153, 27, 27) : Color.FromArgb(18, 39, 68);
            row.DefaultCellStyle.SelectionBackColor = conflict ? Color.FromArgb(255, 205, 214) : Color.FromArgb(219, 237, 255);
            row.DefaultCellStyle.SelectionForeColor = row.DefaultCellStyle.ForeColor;
        }
    }

    private void DungGioGoiY()
    {
        if (_gioGoiY.HasValue)
        {
            _gio.Value = _gioGoiY.Value;
        }
    }

    private void XemLich()
    {
        var room = LichChieuUi.Ma(_phong);
        if (!room.HasValue)
        {
            MessageBox.Show(this, "Chọn phòng trước.");
            return;
        }

        using var form = new FormLichPhongTrongNgay(room.Value, _phong.Text, Gio().Date);
        form.ShowDialog(this);
        CapNhatLich(true);
    }

    private void Luu()
    {
        if (_busy)
        {
            return;
        }

        var film = LichChieuUi.Ma(_phim);
        var room = LichChieuUi.Ma(_phong);
        if (!film.HasValue || !room.HasValue)
        {
            MessageBox.Show(this, "Chọn phim và phòng.");
            return;
        }

        if (Gio() <= DateTime.Now)
        {
            MessageBox.Show(this, "Giờ bắt đầu phải ở tương lai.");
            return;
        }

        // Lấy lại dữ liệu sát lúc lưu; procedure hiện có vẫn là kiểm tra cuối cùng.
        CapNhatLich(true);
        if (!_lichSanSang || _trungLich)
        {
            MessageBox.Show(this, "Chưa thể lưu. Kiểm tra thông báo lịch phòng bên phải.");
            return;
        }

        _busy = true;
        KhaDung();
        UseWaitCursor = true;
        try
        {
            if (_ma.HasValue)
            {
                SuatChieuDAL.Sua(_ma.Value, film.Value, room.Value, Gio(), (int)_don.Value);
                MaDaLuu = _ma.Value;
            }
            else
            {
                MaDaLuu = SuatChieuDAL.Them(film.Value, room.Value, Gio(), (int)_don.Value);
            }

            MessageBox.Show(this, $"Đã lưu suất chiếu {MaDaLuu}.", "Thành công");
            DialogResult = DialogResult.OK;
            Close();
        }
        catch (Exception ex)
        {
            LichChieuUi.Loi(ex, this);
            CapNhatLich(true);
        }
        finally
        {
            _busy = false;
            UseWaitCursor = false;
            KhaDung();
        }
    }
}
