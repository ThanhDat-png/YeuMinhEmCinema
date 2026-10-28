using System.Data;
namespace YeuMinhEmCinema.Admin;
public static class GheDAL
{
 public static DataTable LayDanhSachLoaiGhe(){Db.Require("RAP_XEM");return Db.Query("SELECT MaLoai,TenLoai FROM dbo.LoaiGhe ORDER BY MaLoai");}
 public static DataTable LayDanhSachGheTheoPhong(int maPhong){Db.Require("RAP_XEM",Db.RoomRap(maPhong));return Db.Query("SELECT g.*,l.TenLoai TenLoaiGhe FROM dbo.Ghe g JOIN dbo.LoaiGhe l ON l.MaLoai=g.MaLoaiGhe WHERE g.MaPhong=@P ORDER BY LEN(g.HangGhe),g.HangGhe,g.SoGhe",("@P",maPhong));}
 public static int DemSoGheCuaPhong(int maPhong)=>LayDanhSachGheTheoPhong(maPhong).Rows.Count;
 public static (bool thanhCong,string thongBao,int soGheDaTao,int soGheBoQua) TaoSoDoGhe(int maPhong,int soHang,int soGheMoiHang,int maLoaiGheMacDinh){try{var t=Db.Table("dbo.sp_YMC_TaoGheTheoLo",("@NguoiThucHien",Db.Actor),("@MaPhong",maPhong),("@SoHang",soHang),("@SoGheMoiHang",soGheMoiHang),("@MaLoaiGhe",maLoaiGheMacDinh));int n=(int)t.Rows[0][0],s=(int)t.Rows[0][1];return(true,$"Đã thêm {n} ghế, giữ nguyên {s} ghế cũ.",n,s);}catch(Exception e){return(false,Db.Error(e),0,0);}}
 public static (bool thanhCong,string thongBao) CapNhatLoaiGhe(int maGhe,int maLoaiGheMoi)=>CapNhatNhieuGhe(new(){maGhe},maLoaiGheMoi,null);
 public static (bool thanhCong,string thongBao) DoiTrangThaiGhe(int maGhe,string trangThaiMoi)=>CapNhatNhieuGhe(new(){maGhe},null,trangThaiMoi);
 public static (bool thanhCong,string thongBao) CapNhatNhieuGhe(List<int> danhSachMaGhe,int? maLoaiGheMoi,string? trangThaiMoi){try{var t=new DataTable();t.Columns.Add("MaGhe",typeof(int));foreach(int n in danhSachMaGhe.Distinct())t.Rows.Add(n);
 Db.Call("dbo.sp_YMC_CapNhatLoGhe",("@NguoiThucHien",Db.Actor),("@Ghe",new Tvp("dbo.YMC_DanhSachGhe",t)),("@MaLoaiGhe",maLoaiGheMoi),("@TrangThai",trangThaiMoi));return(true,"Đã cập nhật ghế.");}catch(Exception e){return(false,Db.Error(e));}}
}
