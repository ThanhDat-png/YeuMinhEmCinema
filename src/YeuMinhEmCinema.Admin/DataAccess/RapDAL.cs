using System.Data;
namespace YeuMinhEmCinema.Admin;

public static class RapDAL
{
    public static DataTable LayDanhSachRap(string? tuKhoa = null, string? trangThai = null)
    {
        Db.Require("RAP_XEM");
        return Db.Query(@"SELECT r.MaRap,r.TenRap,r.DiaChi,r.TrangThai,COUNT(DISTINCT p.MaPhong) SoLuongPhong,COUNT(g.MaGhe) TongSucChua
 FROM dbo.Rap r LEFT JOIN dbo.PhongChieu p ON p.MaRap=r.MaRap LEFT JOIN dbo.Ghe g ON g.MaPhong=p.MaPhong
 WHERE dbo.fn_YMC_CoPhamViRap(@A,r.MaRap)=1 AND(@TK IS NULL OR CHARINDEX(@TK,r.TenRap)>0 OR CHARINDEX(@TK,r.DiaChi)>0) AND(@TT IS NULL OR r.TrangThai=@TT)
 GROUP BY r.MaRap,r.TenRap,r.DiaChi,r.TrangThai ORDER BY r.MaRap",
            ("@A", Db.Actor),
            ("@TK", string.IsNullOrWhiteSpace(tuKhoa) ? null : tuKhoa),
            ("@TT", trangThai is null or "Tất cả" ? null : trangThai));
    }

    public static DataRow? LayRapTheoMa(int maRap)
    {
        Db.Require("RAP_XEM", maRap);
        return Db.First(Db.Query("SELECT * FROM dbo.Rap WHERE MaRap=@M", ("@M", maRap)));
    }

    public static (bool thanhCong, string thongBao, int maRapMoi) ThemRap(string tenRap, string? diaChi, string trangThai)
    {
        try
        {
            var t = Db.Table("dbo.sp_YMC_LuuRap",
                ("@NguoiThucHien", Db.Actor),
                ("@TenRap", tenRap),
                ("@DiaChi", diaChi),
                ("@TrangThai", trangThai));
            return (true, "Đã lưu rạp.", Convert.ToInt32(t.Rows[0][0]));
        }
        catch (Exception e)
        {
            return (false, Db.Error(e), 0);
        }
    }

    public static (bool thanhCong, string thongBao) CapNhatRap(int maRap, string tenRap, string? diaChi, string trangThai)
    {
        try
        {
            Db.Call("dbo.sp_YMC_LuuRap",
                ("@NguoiThucHien", Db.Actor),
                ("@MaRap", maRap),
                ("@TenRap", tenRap),
                ("@DiaChi", diaChi),
                ("@TrangThai", trangThai));
            return (true, "Đã lưu rạp.");
        }
        catch (Exception e)
        {
            return (false, Db.Error(e));
        }
    }

    public static (bool thanhCong, string thongBao) DoiTrangThaiRap(int maRap, string trangThaiMoi)
    {
        try
        {
            var r = LayRapTheoMa(maRap) ?? throw new ArgumentException("Không tìm thấy rạp.");
            return CapNhatRap(maRap, (string)r["TenRap"], r["DiaChi"] as string, trangThaiMoi);
        }
        catch (Exception e)
        {
            return (false, Db.Error(e));
        }
    }
}
