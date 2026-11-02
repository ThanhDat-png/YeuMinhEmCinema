USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TimNhanVienAdmin
@NguoiThucHien INT,@TuKhoa NVARCHAR(150)=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'NHAN_VIEN_QUAN_LY';
 DECLARE @K NVARCHAR(150)=NULLIF(LTRIM(RTRIM(@TuKhoa)),N'');
SELECT t.MaTaiKhoan,t.TenDangNhap,t.Email,t.DangHoatDong,t.KhoaDenLuc,t.PhienBan TaiKhoanPhienBan,
 n.MaNhanVien,n.HoTen,n.DienThoai,n.DangLamViec,n.PhienBan NhanVienPhienBan,
 (SELECT STRING_AGG(v.TenHienThi,N', ') FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=t.MaTaiKhoan) VaiTro,
 (SELECT STRING_AGG(r.TenRap,N', ') FROM dbo.NhanVienRap nr JOIN dbo.Rap r ON r.MaRap=nr.MaRap WHERE nr.MaNhanVien=n.MaNhanVien) RapLamViec
 FROM dbo.TaiKhoan t LEFT JOIN dbo.NhanVien n ON n.MaTaiKhoan=t.MaTaiKhoan
 WHERE @K IS NULL OR CHARINDEX(@K,t.TenDangNhap)>0 OR CHARINDEX(@K,n.HoTen)>0 OR CHARINDEX(@K,n.DienThoai)>0
 OR n.MaNhanVien=TRY_CONVERT(INT,@K) OR t.MaTaiKhoan=TRY_CONVERT(INT,@K) ORDER BY t.MaTaiKhoan;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TraCuuPhongAdmin
@NguoiThucHien INT,@TuKhoa NVARCHAR(100)=NULL,@MaRap INT=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_XEM',@MaRap;
 SET @TuKhoa=NULLIF(LTRIM(RTRIM(@TuKhoa)),N'');
 SELECT p.MaPhong,p.MaRap,r.TenRap,p.TenPhong,p.DinhDang,p.TrangThai,COUNT(g.MaGhe) SucChua,
 COUNT(CASE WHEN g.TrangThai=N'Hoạt động' THEN 1 END) SoGheHoatDong,
 COUNT(CASE WHEN g.TrangThai<>N'Hoạt động' THEN 1 END) SoGheHong
 FROM dbo.PhongChieu p JOIN dbo.Rap r ON r.MaRap=p.MaRap LEFT JOIN dbo.Ghe g ON g.MaPhong=p.MaPhong
 WHERE dbo.fn_YMC_CoPhamViRap(@NguoiThucHien,p.MaRap)=1 AND(@MaRap IS NULL OR p.MaRap=@MaRap)
 AND(@TuKhoa IS NULL OR p.MaPhong=TRY_CONVERT(INT,@TuKhoa) OR CHARINDEX(@TuKhoa,p.TenPhong)>0)
 GROUP BY p.MaPhong,p.MaRap,r.TenRap,p.TenPhong,p.DinhDang,p.TrangThai ORDER BY p.MaRap,p.MaPhong;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TimSuatTaiQuay
@NguoiThucHien INT,@MaRap INT,@Ngay DATE,@TenPhim NVARCHAR(200)=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAN_VE',@MaRap;
 IF @MaRap IS NULL OR @Ngay IS NULL OR @Ngay>='99991231' THROW 50600,N'Chọn rạp và ngày bán vé.',1;
 SET @TenPhim=NULLIF(LTRIM(RTRIM(@TenPhim)),N'');
 SELECT s.MaSuatChieu,CONCAT(f.TenPhim,N' | ',CONVERT(VARCHAR(16),s.GioBatDau,120),N' | ',p.TenPhong,N' | ',p.DinhDang) TenHienThi
 FROM dbo.SuatChieu s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
 WHERE p.MaRap=@MaRap AND s.TrangThai=N'Mở bán' AND s.GioBatDau>dbo.fn_YMC_GioVietNam()
 AND s.GioBatDau>=@Ngay AND s.GioBatDau<DATEADD(DAY,1,@Ngay)
 AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động' AND f.TrangThai=N'Đang chiếu'
 AND(@TenPhim IS NULL OR CHARINDEX(@TenPhim,f.TenPhim)>0)
 ORDER BY s.GioBatDau,s.MaSuatChieu;
END;
GO
