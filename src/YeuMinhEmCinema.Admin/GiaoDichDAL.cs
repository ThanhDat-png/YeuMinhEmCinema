using System.Data;
namespace YeuMinhEmCinema.Admin;
internal static class GiaoDichDAL
{
 internal static DataTable Suat(int rap,DateTime ngay){Db.Require("BAN_VE",rap);return Db.Query(@"SELECT s.MaSuatChieu,CONCAT(f.TenPhim,N' | ',CONVERT(VARCHAR(16),s.GioBatDau,120),N' | ',p.TenPhong,N' | ',p.DinhDang) TenHienThi
 FROM dbo.SuatChieu s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
 WHERE p.MaRap=@R AND s.TrangThai=N'Mở bán' AND s.GioBatDau>dbo.fn_YMC_GioVietNam() AND s.GioBatDau>=@N AND s.GioBatDau<DATEADD(DAY,1,@N)
 AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động' AND f.TrangThai=N'Đang chiếu' ORDER BY s.GioBatDau",("@R",rap),("@N",ngay.Date));}
 internal static DataTable Ghe(int suat){int rap=Convert.ToInt32(Db.Query("SELECT p.MaRap FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE s.MaSuatChieu=@S",("@S",suat)).Rows[0][0]);Db.Require("BAN_VE",rap);return Db.Table("dbo.sp_YMC_SoDoGheTheoSuat",("@MaSuatChieu",suat));}
 internal static DataTable Fnb(){Db.Require("BAN_VE");return Db.Query("SELECT MaSanPham,MaHang,TenSanPham,Nhom,DonGia FROM dbo.v_YMC_FnbMenu WHERE CoTheBan=1 ORDER BY Nhom,TenSanPham");}
 internal static DataRow Tao(Guid request,int suat,DataTable ghe,DataTable fnb,string ten,string dt)=>Db.Table("dbo.sp_YMC_TaoDonGiuGhe",("@NguoiThucHien",Db.Actor),("@MaYeuCau",request),("@MaSuatChieu",suat),("@Kenh","QUAY"),("@DanhSachGhe",new Tvp("dbo.YMC_DanhSachGhe",ghe)),("@DanhSachFnb",new Tvp("dbo.YMC_DanhSachFnb",fnb)),("@HoTenLienHe",ten),("@DienThoaiLienHe",dt)).Rows[0];
 internal static DataSet ChiTiet(long don)=>Db.Call("dbo.sp_YMC_XemChiTietDon",("@NguoiThucHien",Db.Actor),("@MaDonHang",don));
 internal static void Thu(long don,string ma,string pt,decimal tien)=>Db.Call("dbo.sp_YMC_XacNhanThanhToan",("@NguoiThucHien",Db.Actor),("@MaDonHang",don),("@MaGiaoDich",ma),("@PhuongThuc",pt),("@SoTien",tien));
 internal static void Huy(long don,string lydo)=>Db.Call("dbo.sp_YMC_HuyDonChuaThanhToan",("@NguoiThucHien",Db.Actor),("@MaDonHang",don),("@LyDo",lydo));
 internal sealed record TrangDon(DataTable DuLieu,int TongKetQua);
 internal static TrangDon Don(int rap,DateTime tu,DateTime den,string? tt,int trang=1,string? tuKhoa=null)
 {
  using var command=Db.Command("dbo.sp_YMC_DanhSachDonAdmin",true,("@NguoiThucHien",Db.Actor),("@MaRap",rap),
   ("@TuNgay",tu.Date),("@DenNgay",den.Date),("@TrangThai",tt),("@Trang",trang),("@KichThuocTrang",50),("@TuKhoa",tuKhoa));
  var count=command.Parameters.Add("@TongKetQua",System.Data.SqlDbType.Int);count.Direction=ParameterDirection.Output;
  var data=Db.Read(command).Tables[0];
  return new TrangDon(data,Convert.ToInt32(count.Value));
 }
}
