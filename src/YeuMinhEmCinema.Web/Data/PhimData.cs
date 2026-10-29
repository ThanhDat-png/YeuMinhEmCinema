using System.Data;
using Microsoft.Data.SqlClient;
using static YeuMinhEmCinema.Web.Data.WebDb;

namespace YeuMinhEmCinema.Web.Data;

/// <summary>Danh mục công khai và lịch chỉ gồm suất được phép bán theo thủ tục SQL.</summary>
public class PhimData
{
    private readonly WebDb db;

    public PhimData(WebDb db)
    {
        this.db = db;
    }

    public virtual DataTable DanhSach()
    {
        return db.Table("SELECT MaPhim,TenPhim FROM dbo.Phim WHERE TrangThai IN(N'Đang chiếu',N'Sắp chiếu') ORDER BY TenPhim");
    }

    public virtual DataTable Rap()
    {
        return db.Table("SELECT MaRap,TenRap,DiaChi FROM dbo.Rap WHERE TrangThai=N'Đang hoạt động' ORDER BY MaRap");
    }

    public virtual DataRow? ChiTiet(int id)
    {
        var table = db.Table("dbo.sp_YMC_WebChiTietPhim", true, P("@MaPhim", id));
        return table.Rows.Count == 0 ? null : table.Rows[0];
    }

    /// <summary>Lấy tối đa 18 suất tương lai, gần nhất trước; không bắt khách đoán ngày có lịch.</summary>
    public virtual DataTable GanNhat(int? phim, int? rap, DateTime? ngay = null)
    {
        return db.Table("""
            SELECT TOP (18) s.MaSuatChieu,f.MaPhim,f.TenPhim,f.Poster,r.MaRap,r.TenRap,r.DiaChi,p.TenPhong,p.DinhDang,
                s.GioBatDau,s.GioKetThuc,
                (SELECT COUNT(*) FROM dbo.Ghe g
                 WHERE g.MaPhong=p.MaPhong AND g.TrangThai=N'Hoạt động'
                 AND NOT EXISTS(
                    SELECT 1 FROM dbo.GiuGhe h JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
                    WHERE h.MaSuatChieu=s.MaSuatChieu AND h.MaGhe=g.MaGhe
                    AND (d.TrangThai='DA_THANH_TOAN' OR
                        (d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME())))) SoGheTrong
            FROM dbo.SuatChieu s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
            JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
            WHERE (@Phim IS NULL OR s.MaPhim=@Phim) AND (@Rap IS NULL OR r.MaRap=@Rap)
                AND (@Ngay IS NULL OR (s.GioBatDau>=@Ngay AND s.GioBatDau<DATEADD(DAY,1,@Ngay)))
                AND s.GioBatDau>dbo.fn_YMC_GioVietNam() AND s.TrangThai=N'Mở bán'
                AND f.TrangThai=N'Đang chiếu' AND p.TrangThai=N'Đang hoạt động'
                AND r.TrangThai=N'Đang hoạt động'
            ORDER BY s.GioBatDau,r.MaRap,s.MaSuatChieu
            """,
            false,
            new SqlParameter("@Phim", SqlDbType.Int)
            {
                Value = (object?)phim ?? DBNull.Value
            },
            new SqlParameter("@Rap", SqlDbType.Int)
            {
                Value = (object?)rap ?? DBNull.Value
            },
            new SqlParameter("@Ngay", SqlDbType.DateTime2)
            {
                Value = (object?)ngay?.Date ?? DBNull.Value
            });
    }

    /// <summary>Mỗi phim xuất hiện một lần nếu có suất tương lai đang mở bán tại rạp.</summary>
    public virtual DataTable PhimTaiRap(int rap)
    {
        return db.Table("""
            SELECT f.MaPhim,f.TenPhim,f.Poster,f.ThoiLuong,f.GioiHanTuoi,
                MIN(s.GioBatDau) AS SuatGanNhat
            FROM dbo.Phim f
            JOIN dbo.SuatChieu s ON s.MaPhim=f.MaPhim
            JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
            JOIN dbo.Rap r ON r.MaRap=p.MaRap
            WHERE r.MaRap=@Rap AND r.TrangThai=N'Đang hoạt động'
                AND p.TrangThai=N'Đang hoạt động'
                AND f.TrangThai=N'Đang chiếu' AND s.TrangThai=N'Mở bán'
                AND s.GioBatDau>dbo.fn_YMC_GioVietNam()
            GROUP BY f.MaPhim,f.TenPhim,f.Poster,f.ThoiLuong,f.GioiHanTuoi
            ORDER BY MIN(s.GioBatDau),f.MaPhim
            """,
            false,
            P("@Rap", rap));
    }

    public virtual DataTable Lich(int phim, int? rap, DateTime ngay)
    {
        return db.Table("dbo.sp_YMC_WebLichChieu", true,
        P("@MaPhim", phim), P("@Ngay", ngay.Date), P("@MaRap", rap));
    }
}
