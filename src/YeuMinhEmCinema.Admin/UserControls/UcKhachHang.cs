using System.Data;
namespace YeuMinhEmCinema.Admin;

public partial class UcKhachHang : DataPage
{
    private readonly TextBox search = AdminUi.Text(150);

    public UcKhachHang() : base("Hồ sơ khách hàng")
    {
        Bar.Controls.AddRange(new Control[]
        {
            AdminUi.Label("Tên / số điện thoại"),
            search
        });
        Action("Tìm", Reload);
        Action("Thêm khách tại quầy", () => Edit(null), "KHACH_HANG_QUAN_LY");
        Action("Sửa hồ sơ", () => Edit(AdminUi.Row(Grid)), "KHACH_HANG_QUAN_LY");
        Action("Bật / ngừng hồ sơ", Status, "KHACH_HANG_QUAN_LY");
        Action("Lịch sử đơn", Orders);
        StandardActions(Reload);
        Load += (_, _) => Run(Reload);
    }

    private void Reload()
    {
        Db.Require("KHACH_HANG_XEM");
        AdminUi.Bind(Grid,
            Db.Query(@"SELECT k.*,t.TenDangNhap FROM dbo.KhachHang k LEFT JOIN dbo.TaiKhoan t ON t.MaTaiKhoan=k.MaTaiKhoan
 WHERE(@K=N'' OR CHARINDEX(@K,k.HoTen)>0 OR CHARINDEX(@K,k.DienThoai)>0) AND(EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@A AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 OR EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaKhachHang=k.MaKhachHang AND dbo.fn_YMC_CoPhamViRap(@A,p.MaRap)=1)) ORDER BY k.MaKhachHang DESC",
                ("@K", search.Text.Trim()),
                ("@A", Db.Actor)));
    }

    private void Edit(DataRow? r)
    {
        using var f = new EditDialog(r == null ? "Thêm khách tại quầy" : "Sửa hồ sơ khách");
        var name = f.TextField("Họ tên", Convert.ToString(r? ["HoTen"]) ?? "");
        var phone = f.TextField("Điện thoại", Convert.ToString(r? ["DienThoai"]) ?? "", 20);
        var birth = f.Field("Ngày sinh (bỏ tích nếu chưa biết)",
            new DateTimePicker
            {
                ShowCheckBox = true,
                Checked = r? ["NgaySinh"] is DateTime,
                Format = DateTimePickerFormat.Short
            });
        if (r? ["NgaySinh"] is DateTime d)
            birth.Value = d;
        f.Save(() =>
        {
            if (string.IsNullOrWhiteSpace(name.Text))
                throw new ArgumentException("Nhập họ tên.");
            if (r == null)
                Db.Call("dbo.sp_YMC_TaoKhachTaiQuay",
                    ("@NguoiThucHien", Db.Actor),
                    ("@HoTen", name.Text.Trim()),
                    ("@DienThoai", phone.Text.Trim()),
                    ("@NgaySinh", birth.Checked ? birth.Value.Date : null));
            else
                Db.Call("dbo.sp_YMC_CapNhatKhachHang",
                    ("@NguoiThucHien", Db.Actor),
                    ("@MaKhachHang", r["MaKhachHang"]),
                    ("@HoTen", name.Text.Trim()),
                    ("@DienThoai", phone.Text.Trim()),
                    ("@NgaySinh", birth.Checked ? birth.Value.Date : null),
                    ("@PhienBan", r["PhienBan"]));
        });
        if (f.ShowDialog(this) == DialogResult.OK)
            Reload();
    }

    private void Status()
    {
        var r = AdminUi.Row(Grid);
        if (!AdminUi.Confirm("Đổi trạng thái hồ sơ khách? Tài khoản đăng nhập là trạng thái riêng."))
            return;
        Db.Call("dbo.sp_YMC_DoiTrangThaiKhach",
            ("@NguoiThucHien", Db.Actor),
            ("@MaKhachHang", r["MaKhachHang"]),
            ("@DangHoatDong", !(bool)r["DangHoatDong"]),
            ("@PhienBan", r["PhienBan"]));
        Reload();
    }

    private void Orders()
    {
        var r = AdminUi.Row(Grid);
        Db.Require("DON_HANG_XEM");
        var t = Db.Query(@"SELECT d.MaDonHang,d.TrangThai,d.TongTien,d.NgayTaoUtc,f.TenPhim,p.TenPhong,r.TenRap FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.Phim f ON f.MaPhim=s.MaPhim JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap WHERE d.MaKhachHang=@K AND dbo.fn_YMC_CoPhamViRap(@A,r.MaRap)=1 ORDER BY d.MaDonHang DESC",
            ("@K", r["MaKhachHang"]),
            ("@A", Db.Actor));
        using var f = AdminUi.Dialog("Lịch sử đơn trong rạp được phân công");
        var g = AdminUi.Grid();
        AdminUi.Bind(g, t);
        f.Controls.Add(g);
        f.ShowDialog(this);
    }
}
