using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin;

public static class SuatChieuDAL
{
    private static SqlConnection KetNoi() => new(CauHinh.ChuoiKetNoi);
    private static DataTable Doc(SqlCommand cmd)
    {
        if(cmd.CommandType==CommandType.StoredProcedure)cmd.Parameters.Add("@NguoiThucHien",SqlDbType.Int).Value=Db.Actor;
        else Db.Require("LICH_CHIEU_XEM");
        using var cn = KetNoi();
        cmd.Connection = cn;
        using var da = new SqlDataAdapter(cmd);
        var dt = new DataTable();
        da.Fill(dt);
        return dt;
    }
    private static void So(SqlCommand c,string ten,int? value) =>
        c.Parameters.Add(ten,SqlDbType.Int).Value=(object?)value ?? DBNull.Value;
    private static void Ngay(SqlCommand c,string ten,DateTime? value) =>
        c.Parameters.Add(ten,SqlDbType.Date).Value=(object?)value?.Date ?? DBNull.Value;

    public static DataTable LayDanhSachSuatChieu(DateTime? tuNgay=null,DateTime? denNgay=null,
        int? maRap=null,int? maPhong=null,int? maPhim=null,string? trangThai=null,string? tuKhoa=null)
    {
        using var c=new SqlCommand(@"SELECT sc.MaSuatChieu,p.TenPhim,r.TenRap,pc.TenPhong,
            pc.DinhDang,sc.GioBatDau,sc.GioKetThuc,sc.PhutDonPhong,
            DATEADD(MINUTE,sc.PhutDonPhong,sc.GioKetThuc) AS GioSanSang,sc.TrangThai,
            sc.MaPhim,sc.MaPhong,r.MaRap
            FROM dbo.SuatChieu sc JOIN dbo.Phim p ON p.MaPhim=sc.MaPhim
            JOIN dbo.PhongChieu pc ON pc.MaPhong=sc.MaPhong JOIN dbo.Rap r ON r.MaRap=pc.MaRap
            WHERE dbo.fn_YMC_CoPhamViRap(@A,r.MaRap)=1 AND (@Tu IS NULL OR sc.GioBatDau>=@Tu)
              AND (@Den IS NULL OR sc.GioBatDau<DATEADD(DAY,1,@Den))
              AND (@Rap IS NULL OR r.MaRap=@Rap) AND (@Phong IS NULL OR sc.MaPhong=@Phong)
              AND (@Phim IS NULL OR sc.MaPhim=@Phim) AND (@TT IS NULL OR sc.TrangThai=@TT)
              AND (@TK IS NULL OR p.TenPhim LIKE @TK)
            ORDER BY sc.GioBatDau,sc.MaSuatChieu;");
        So(c,"@A",Db.Actor); Ngay(c,"@Tu",tuNgay); Ngay(c,"@Den",denNgay);
        So(c,"@Rap",maRap); So(c,"@Phong",maPhong); So(c,"@Phim",maPhim);
        c.Parameters.Add("@TT",SqlDbType.NVarChar,30).Value=string.IsNullOrWhiteSpace(trangThai)?DBNull.Value:trangThai;
        c.Parameters.Add("@TK",SqlDbType.NVarChar,402).Value=string.IsNullOrWhiteSpace(tuKhoa)?DBNull.Value:"%"+tuKhoa.Trim()+"%";
        return Doc(c);
    }
    public static DataTable LayRap(bool hoatDong=false)
    {
        using var c=new SqlCommand("SELECT MaRap,TenRap FROM dbo.Rap "+
            (hoatDong?"WHERE TrangThai=N'Đang hoạt động' ":"")+"ORDER BY MaRap;");
        var result=Doc(c);var allowed=Db.Raps().AsEnumerable().Select(r=>(int)r["MaRap"]).ToHashSet();foreach(DataRow r in result.Rows.Cast<DataRow>().ToArray())if(!allowed.Contains((int)r["MaRap"]))result.Rows.Remove(r);return result;
    }
    public static DataTable LayPhim(bool xepLich=false)
    {
        using var c=new SqlCommand("SELECT MaPhim,TenPhim,ThoiLuong,NgayKhoiChieu FROM dbo.Phim "+
            (xepLich?"WHERE TrangThai IN(N'Sắp chiếu',N'Đang chiếu') ":"")+"ORDER BY TenPhim,MaPhim;");
        return Doc(c);
    }
    public static DataTable LayPhong(int? maRap,bool hoatDong=false)
    {
        using var c=new SqlCommand(@"SELECT p.MaPhong,p.TenPhong,p.DinhDang FROM dbo.PhongChieu p
            JOIN dbo.Rap r ON r.MaRap=p.MaRap WHERE dbo.fn_YMC_CoPhamViRap(@A,p.MaRap)=1 AND (@Rap IS NULL OR p.MaRap=@Rap) "+
            (hoatDong?@"AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động'
            AND EXISTS(SELECT 1 FROM dbo.Ghe g WHERE g.MaPhong=p.MaPhong AND g.TrangThai=N'Hoạt động') ":"")+
            "ORDER BY p.MaPhong;");
        So(c,"@A",Db.Actor);So(c,"@Rap",maRap); return Doc(c);
    }
    public static DataTable LayLichPhongTrongNgay(int maPhong,DateTime ngay)
    {
        // Bao gồm suất bắt đầu từ hôm trước nhưng còn chiếm phòng trong ngày chọn.
        using var c=new SqlCommand(@"SELECT sc.MaSuatChieu,p.TenPhim,sc.GioBatDau,sc.GioKetThuc,
            sc.PhutDonPhong,DATEADD(MINUTE,sc.PhutDonPhong,sc.GioKetThuc) AS GioSanSang,sc.TrangThai
            FROM dbo.SuatChieu sc JOIN dbo.Phim p ON p.MaPhim=sc.MaPhim
            WHERE sc.MaPhong=@Phong AND sc.TrangThai<>N'Đã hủy'
            AND sc.GioBatDau<DATEADD(DAY,1,@Ngay)
            AND DATEADD(MINUTE,sc.PhutDonPhong,sc.GioKetThuc)>@Ngay ORDER BY sc.GioBatDau;");
        Db.Require("LICH_CHIEU_XEM",Db.RoomRap(maPhong));So(c,"@Phong",maPhong); Ngay(c,"@Ngay",ngay); return Doc(c);
    }
    private static SqlCommand LenhSuat(string ten,int maPhim,int maPhong,DateTime gio,int don,int? ma=null)
    {
        var c=new SqlCommand(ten){CommandType=CommandType.StoredProcedure};
        So(c,"@MaPhim",maPhim); So(c,"@MaPhong",maPhong); So(c,"@PhutDonPhong",don);
        var p=c.Parameters.Add("@GioBatDau",SqlDbType.DateTime2); p.Scale=0;p.Value=gio;
        if(ma.HasValue)So(c,"@MaSuatChieu",ma);
        return c;
    }
    public static int Them(int phim,int phong,DateTime gio,int don)
    {
        using var c=LenhSuat("dbo.sp_YMC_AdminThemSuatChieu",phim,phong,gio,don);
        var dt=Doc(c);return Convert.ToInt32(dt.Rows[0]["MaSuatChieu"]);
    }
    public static void Sua(int ma,int phim,int phong,DateTime gio,int don)
    {
        using var c=LenhSuat("dbo.sp_YMC_AdminSuaSuatChieu",phim,phong,gio,don,ma);Doc(c);
    }
    public static void DoiTrangThai(int ma,string trangThai)
    {
        using var cn=KetNoi();using var c=new SqlCommand("dbo.sp_YMC_AdminDoiTrangThaiSuat",cn){CommandType=CommandType.StoredProcedure};
        So(c,"@NguoiThucHien",Db.Actor);So(c,"@MaSuatChieu",ma); c.Parameters.Add("@TrangThaiMoi",SqlDbType.NVarChar,30).Value=trangThai;
        cn.Open(); c.ExecuteNonQuery();
    }
    public static DataTable SaoChep(DateTime nguon,DateTime dich,int? rap,int? phong,bool xem,string? chuKy=null)
    {
        if(!rap.HasValue)throw new ArgumentException("Chọn một rạp để sao chép lịch.");
        using var c=new SqlCommand("dbo.sp_YMC_AdminSaoChepLich"){CommandType=CommandType.StoredProcedure};
        Ngay(c,"@NgayNguon",nguon);Ngay(c,"@NgayDich",dich);So(c,"@MaRap",rap);So(c,"@MaPhong",phong);
        c.Parameters.Add("@XemTruoc",SqlDbType.Bit).Value=xem;
        c.Parameters.Add("@ChuKy",SqlDbType.VarChar,64).Value=(object?)chuKy??DBNull.Value;
        return Doc(c);
    }
}
