using System.Data;
using YeuMinhEmCinema.Web.Services;
using YeuMinhEmCinema.Web.ViewModels;
using static YeuMinhEmCinema.Web.Data.WebDb;

namespace YeuMinhEmCinema.Web.Data;

/// <summary>Xác thực tương thích PasswordHasher và quy tắc khóa đăng nhập của Admin.</summary>
public class TaiKhoanData
{
    private readonly WebDb db;

    public TaiKhoanData(WebDb db)
    {
        this.db = db;
    }

    public DataRow? HoSo(int id)
    {
        var table = db.Table("""
            SELECT t.MaTaiKhoan,k.MaKhachHang,k.HoTen,k.DienThoai,k.NgaySinh,k.PhienBan,
                t.TenDangNhap,t.Email,t.PhienBan AS PhienTaiKhoan
            FROM dbo.KhachHang k JOIN dbo.TaiKhoan t ON t.MaTaiKhoan=k.MaTaiKhoan
            WHERE t.MaTaiKhoan=@Id AND t.DangHoatDong=1 AND k.DangHoatDong=1
                AND (t.KhoaDenLuc IS NULL OR t.KhoaDenLuc<=SYSUTCDATETIME())
                AND EXISTS(SELECT 1 FROM dbo.v_YMC_QuyenTaiKhoan q
                    WHERE q.MaTaiKhoan=t.MaTaiKhoan AND q.MaQuyen='DON_HANG_CA_NHAN')
                AND EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro
                    WHERE tv.MaTaiKhoan=t.MaTaiKhoan AND v.TenVaiTro='KHACH_HANG' AND v.DangHoatDong=1)
            """,
            false,
            P("@Id", id));
        return table.Rows.Count == 0 ? null : table.Rows[0];
    }

    public bool PhienHopLe(int id, string? phienBan)
    {
        var row = HoSo(id);
        return row != null && Convert.ToBase64String((byte[])row["PhienTaiKhoan"]) == phienBan;
    }

    public DataRow? DangNhap(string ten, string matKhau)
    {
        var table = db.Table("dbo.sp_YMC_LayThongTinDangNhap", true, P("@TenDangNhap", ten));
        if (table.Rows.Count == 0)
        {
            return null;
        }
        var row = table.Rows[0];
        var dung = KhachHangSession.KiemTra((string)row["MatKhauHash"], matKhau);
        db.Read("dbo.sp_YMC_GhiNhanDangNhap", true,
        P("@MaTaiKhoan", row["MaTaiKhoan"]), P("@ThanhCong", dung), P("@PhienBan", row["PhienBan"]));
        if (!dung)
        {
            return null;
        }
        return HoSo((int)row["MaTaiKhoan"]);
    }

    public void DangKy(DangKyModel model)
    {
        db.Read("dbo.sp_YMC_DangKyKhachHang",
            true,
            P("@TenDangNhap", model.TenDangNhap),
            P("@MatKhauHash", KhachHangSession.Bam(model.MatKhau)),
            P("@HoTen", model.HoTen.Trim()),
            P("@Email", model.Email),
            P("@DienThoai", model.DienThoai));
    }

    public void CapNhat(int id, HoSoModel model)
    {
        var row = HoSo(id) ?? throw new InvalidOperationException("Phiên khách hàng không còn hợp lệ.");
        // Gộp hồ sơ và email vào cùng transaction; email trùng phải rollback cả thay đổi hồ sơ.
        db.Read("""
            SET XACT_ABORT ON;
            BEGIN TRY
                BEGIN TRANSACTION;
                EXEC dbo.sp_YMC_CapNhatKhachHang @NguoiThucHien,@MaKhachHang,@HoTen,@DienThoai,@NgaySinh,@PhienBan;
                UPDATE dbo.TaiKhoan SET Email=@Email
                WHERE MaTaiKhoan=@NguoiThucHien AND PhienBan=@PhienTaiKhoan
                    AND DangHoatDong=1 AND (KhoaDenLuc IS NULL OR KhoaDenLuc<=SYSUTCDATETIME());
                IF @@ROWCOUNT<>1 THROW 50413,N'Tài khoản đã thay đổi. Vui lòng tải lại.',1;
                COMMIT;
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT>0 ROLLBACK;
                THROW;
            END CATCH;
            """,
            false,
            P("@NguoiThucHien", id),
            P("@MaKhachHang", row["MaKhachHang"]),
            P("@HoTen", model.HoTen.Trim()),
            P("@DienThoai", model.DienThoai),
            P("@NgaySinh", model.NgaySinh),
            P("@PhienBan", row["PhienBan"]),
            P("@PhienTaiKhoan", row["PhienTaiKhoan"]),
            P("@Email", model.Email));
    }

    public bool DoiMatKhau(int id, DoiMatKhauModel model)
    {
        var hoSo = HoSo(id) ?? throw new InvalidOperationException("Phiên khách hàng không còn hợp lệ.");
        var row = db.Table("dbo.sp_YMC_LayThongTinDangNhap", true,
        P("@TenDangNhap", hoSo["TenDangNhap"])).Rows[0];
        var dung = KhachHangSession.KiemTra((string)row["MatKhauHash"], model.MatKhauCu);
        // Ghi nhận sai mật khẩu cũ bằng cùng cơ chế khóa để tránh thử vô hạn qua trang đổi mật khẩu.
        db.Read("dbo.sp_YMC_GhiNhanDangNhap", true, P("@MaTaiKhoan", id),
        P("@ThanhCong", dung), P("@PhienBan", row["PhienBan"]));
        if (!dung)
        {
            return false;
        }
        var moi = db.Table("dbo.sp_YMC_LayThongTinDangNhap", true,
        P("@TenDangNhap", hoSo["TenDangNhap"])).Rows[0];
        db.Read("dbo.sp_YMC_DoiMatKhau", true, P("@MaTaiKhoan", id),
        P("@MatKhauHashMoi", KhachHangSession.Bam(model.MatKhauMoi)), P("@PhienBan", moi["PhienBan"]));
        return true;
    }
}
