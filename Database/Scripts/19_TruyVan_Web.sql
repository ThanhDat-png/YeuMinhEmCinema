USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebDanhSachPhim
@TrangThai NVARCHAR(30)=NULL,@TuKhoa NVARCHAR(200)=NULL,@Trang INT=1,@KichThuocTrang INT=12
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N'Phân trang không hợp lệ.',1;
SELECT MaPhim,TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai,COUNT(*) OVER() TongKetQua
FROM dbo.Phim WHERE TrangThai IN(N'Đang chiếu',N'Sắp chiếu') AND (@TrangThai IS NULL OR TrangThai=@TrangThai)
AND (@TuKhoa IS NULL OR CHARINDEX(@TuKhoa,TenPhim)>0) ORDER BY NgayKhoiChieu DESC,MaPhim DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebChiTietPhim
@MaPhim INT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

SELECT MaPhim,TenPhim,MoTa,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai FROM dbo.Phim
WHERE MaPhim=@MaPhim AND TrangThai IN(N'Đang chiếu',N'Sắp chiếu');

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebLichChieu
@MaPhim INT,@Ngay DATE,@MaRap INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

IF @Ngay IS NULL OR @Ngay>='99991231' THROW 50611,N'Ngày không hợp lệ.',1;
SELECT s.MaSuatChieu,r.MaRap,r.TenRap,r.DiaChi,p.TenPhong,p.DinhDang,s.GioBatDau,s.GioKetThuc,
(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=p.MaPhong AND g.TrangThai=N'Hoạt động' AND NOT EXISTS(
 SELECT 1 FROM dbo.GiuGhe h JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
 WHERE h.MaSuatChieu=s.MaSuatChieu AND h.MaGhe=g.MaGhe AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME())))) SoGheTrong
FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
JOIN dbo.Phim f ON f.MaPhim=s.MaPhim WHERE s.MaPhim=@MaPhim AND (@MaRap IS NULL OR r.MaRap=@MaRap)
AND s.TrangThai=N'Mở bán' AND s.GioBatDau>dbo.fn_YMC_GioVietNam() AND s.GioBatDau>=@Ngay AND s.GioBatDau<DATEADD(DAY,1,@Ngay)
AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động' AND f.TrangThai=N'Đang chiếu' ORDER BY r.MaRap,s.GioBatDau;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebDonHangCuaToi
@MaTaiKhoan INT,@Trang INT=1,@KichThuocTrang INT=20
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan,'DON_HANG_CA_NHAN';
IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N'Phân trang không hợp lệ.',1;
SELECT d.MaDonHang,d.MaThamChieu,d.TrangThai,d.TongTien,d.NgayTaoUtc,d.HanThanhToanUtc,COUNT(*) OVER() TongKetQua
FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
WHERE k.MaTaiKhoan=@MaTaiKhoan AND k.DangHoatDong=1 ORDER BY d.MaDonHang DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DanhSachDonAdmin
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@TrangThai VARCHAR(20)=NULL,@Trang INT=1,@KichThuocTrang INT=50
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231' THROW 50600,N'Chọn rạp và khoảng ngày.',1;
IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N'Phân trang không hợp lệ.',1;
SELECT d.*,COUNT(*) OVER() TongKetQua FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND (@TrangThai IS NULL OR d.TrangThai=@TrangThai)
AND d.NgayTaoUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
AND d.NgayTaoUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay))) ORDER BY d.MaDonHang DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;
GO
