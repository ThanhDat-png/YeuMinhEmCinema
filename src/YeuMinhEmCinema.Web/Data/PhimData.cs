using System.Data;
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

    public DataTable DanhSach()
    {
        return db.Table("SELECT MaPhim,TenPhim FROM dbo.Phim WHERE TrangThai IN(N'Đang chiếu',N'Sắp chiếu') ORDER BY TenPhim");
    }

    public DataTable Rap()
    {
        return db.Table("SELECT MaRap,TenRap,DiaChi FROM dbo.Rap WHERE TrangThai=N'Đang hoạt động' ORDER BY MaRap");
    }

    public DataRow? ChiTiet(int id)
    {
        var table = db.Table("dbo.sp_YMC_WebChiTietPhim", true, P("@MaPhim", id));
        return table.Rows.Count == 0 ? null : table.Rows[0];
    }

    public DataTable Lich(int phim, int? rap, DateTime ngay)
    {
        return db.Table("dbo.sp_YMC_WebLichChieu", true,
            P("@MaPhim", phim), P("@Ngay", ngay.Date), P("@MaRap", rap));
    }
}
