using System.Data;
namespace YeuMinhEmCinema.Admin;
public static class PhongChieuDAL
{
 public static DataTable LayDanhSachTatCaPhong(string? tuKhoa=null)=>DanhSach(null,tuKhoa);
 public static DataTable LayDanhSachPhongTheoRap(int maRap)=>DanhSach(maRap,null);
 private static DataTable DanhSach(int? rap,string? tuKhoa)=>Db.Table("dbo.sp_YMC_TraCuuPhongAdmin",("@NguoiThucHien",Db.Actor),("@TuKhoa",tuKhoa),("@MaRap",rap));
 public static DataRow? LayPhongTheoMa(int maPhong){Db.Require("RAP_XEM",Db.RoomRap(maPhong));return Db.First(Db.Query("SELECT p.*,r.TenRap,(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=p.MaPhong) SucChua FROM dbo.PhongChieu p JOIN dbo.Rap r ON r.MaRap=p.MaRap WHERE p.MaPhong=@P",("@P",maPhong)));}
 public static int LaySucChuaPhong(int maPhong){Db.Require("RAP_XEM",Db.RoomRap(maPhong));return Convert.ToInt32(Db.Query("SELECT COUNT(*) FROM dbo.Ghe WHERE MaPhong=@P",("@P",maPhong)).Rows[0][0]);}
 public static (bool thanhCong,string thongBao,int maPhongMoi) ThemPhong(int maRap,string tenPhong,string dinhDang,string trangThai){try{var t=Db.Table("dbo.sp_YMC_LuuPhong",("@NguoiThucHien",Db.Actor),("@MaRap",maRap),("@TenPhong",tenPhong),("@DinhDang",dinhDang),("@TrangThai",trangThai));return(true,"Đã lưu phòng.",Convert.ToInt32(t.Rows[0][0]));}catch(Exception e){return(false,Db.Error(e),0);}}
 public static (bool thanhCong,string thongBao) CapNhatPhong(int maPhong,int maRap,string tenPhong,string dinhDang,string trangThai){try{Db.Call("dbo.sp_YMC_LuuPhong",("@NguoiThucHien",Db.Actor),("@MaPhong",maPhong),("@MaRap",maRap),("@TenPhong",tenPhong),("@DinhDang",dinhDang),("@TrangThai",trangThai));return(true,"Đã lưu phòng.");}catch(Exception e){return(false,Db.Error(e));}}
 public static (bool thanhCong,string thongBao) DoiTrangThaiPhong(int maPhong,string trangThaiMoi){try{var r=LayPhongTheoMa(maPhong)??throw new ArgumentException("Không tìm thấy phòng.");return CapNhatPhong(maPhong,(int)r["MaRap"],(string)r["TenPhong"],(string)r["DinhDang"],trangThaiMoi);}catch(Exception e){return(false,Db.Error(e));}}
}
