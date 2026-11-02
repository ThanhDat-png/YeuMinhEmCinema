using System.Data;
namespace YeuMinhEmCinema.Admin;
public static class PhimDAL
{
 public static DataTable LayDanhSachPhim(string? tuKhoa=null,string? trangThai=null){Db.Require("PHIM_XEM");return Db.Table("dbo.sp_YMC_LayPhimKemTheLoaiAdmin",("@NguoiThucHien",Db.Actor),("@TuKhoa",string.IsNullOrWhiteSpace(tuKhoa)?null:tuKhoa.Trim()),("@TrangThai",trangThai is null or "Tất cả" or "Tất cả trạng thái"?null:trangThai));}
 public static DataRow? LayPhimTheoMa(int maPhim){Db.Require("PHIM_XEM");return Db.First(Db.Query("SELECT * FROM dbo.Phim WHERE MaPhim=@M",("@M",maPhim)));}
 private static (bool,string) Luu(int? ma,string ten,string? mota,int thoiluong,DateTime ngay,string tuoi,string? poster,string? trailer,string tt)
 {try{Db.Call("dbo.sp_YMC_LuuPhim",("@NguoiThucHien",Db.Actor),("@MaPhim",ma),("@TenPhim",ten.Trim()),("@MoTa",mota),("@ThoiLuong",thoiluong),("@NgayKhoiChieu",ngay.Date),("@GioiHanTuoi",tuoi),("@Poster",poster),("@Trailer",trailer),("@TrangThai",tt));return(true,"Đã lưu phim.");}catch(Exception e){return(false,Db.Error(e));}}
 public static (bool thanhCong,string thongBao) ThemPhim(string tenPhim,string? moTa,int thoiLuong,DateTime ngayKhoiChieu,string gioiHanTuoi,string? poster,string? trailer,string trangThai)=>Luu(null,tenPhim,moTa,thoiLuong,ngayKhoiChieu,gioiHanTuoi,poster,trailer,trangThai);
 public static (bool thanhCong,string thongBao) CapNhatPhim(int maPhim,string tenPhim,string? moTa,int thoiLuong,DateTime ngayKhoiChieu,string gioiHanTuoi,string? poster,string? trailer,string trangThai)=>Luu(maPhim,tenPhim,moTa,thoiLuong,ngayKhoiChieu,gioiHanTuoi,poster,trailer,trangThai);
 public static (bool thanhCong,string thongBao) NgungChieuPhim(int maPhim){try{var r=LayPhimTheoMa(maPhim)??throw new ArgumentException("Không tìm thấy phim.");return Luu(maPhim,(string)r["TenPhim"],r["MoTa"] as string,(int)r["ThoiLuong"],(DateTime)r["NgayKhoiChieu"],(string)r["GioiHanTuoi"],r["Poster"] as string,r["Trailer"] as string,"Ngừng chiếu");}catch(Exception e){return(false,Db.Error(e));}}
}
