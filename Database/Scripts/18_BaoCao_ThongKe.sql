USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_BaoCaoDoanhThu
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231'
 THROW 50600,N'Chọn rạp và khoảng ngày hợp lệ.',1;
DECLARE @tu DATETIME2(0)=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay)),
 @den DATETIME2(0)=DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)));
;WITH dong AS(
 SELECT CONVERT(DATE,DATEADD(HOUR,7,t.NgayThuUtc)) Ngay,t.SoTien TienThu,CONVERT(DECIMAL(18,0),0) TienHoan
 FROM dbo.ThanhToan t JOIN dbo.DonHang d ON d.MaDonHang=t.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND t.NgayThuUtc>=@tu AND t.NgayThuUtc<@den
 UNION ALL SELECT CONVERT(DATE,DATEADD(HOUR,7,h.NgayHoanUtc)),0,h.SoTien FROM dbo.HoanTien h
 JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND h.NgayHoanUtc>=@tu AND h.NgayHoanUtc<@den)
SELECT Ngay,SUM(TienThu) TienDaThu,SUM(TienHoan) TienDaHoan,SUM(TienThu-TienHoan) DoanhThuThuan FROM dong GROUP BY Ngay ORDER BY Ngay;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKePhim
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231' THROW 50600,N'Khoảng ngày không hợp lệ.',1;
;WITH suat AS(
 SELECT s.MaSuatChieu,s.MaPhim,(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=s.MaPhong AND g.TrangThai=N'Hoạt động') SucChua
 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND s.TrangThai<>N'Đã hủy'
 AND s.GioBatDau>=@TuNgay AND s.GioBatDau<DATEADD(DAY,1,@DenNgay)),ban AS(
 SELECT d.MaSuatChieu,COUNT(*) SoVe,SUM(c.DonGia) TienVe FROM dbo.DonHang d JOIN dbo.ChiTietVe c ON c.MaDonHang=d.MaDonHang
 WHERE d.TrangThai='DA_THANH_TOAN' GROUP BY d.MaSuatChieu)
SELECT f.MaPhim,f.TenPhim,COUNT(*) SoSuat,SUM(s.SucChua) TongGheHienTai,SUM(ISNULL(b.SoVe,0)) VeDaBan,
SUM(ISNULL(b.TienVe,0)) TienVe,CAST(100.0*SUM(ISNULL(b.SoVe,0))/NULLIF(SUM(s.SucChua),0) AS DECIMAL(8,2)) TyLeLapDay
FROM suat s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim LEFT JOIN ban b ON b.MaSuatChieu=s.MaSuatChieu GROUP BY f.MaPhim,f.TenPhim;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKeFnb
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231' THROW 50600,N'Khoảng ngày không hợp lệ.',1;
SELECT c.MaSanPham,c.TenSanPham,SUM(c.SoLuong) SoLuong,SUM(c.SoLuong*c.DonGia) TienBan
FROM dbo.ChiTietDonFnb c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang JOIN dbo.ThanhToan t ON t.MaDonHang=d.MaDonHang
JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
WHERE p.MaRap=@MaRap AND d.TrangThai='DA_THANH_TOAN'
AND t.NgayThuUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
AND t.NgayThuUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)))
GROUP BY c.MaSanPham,c.TenSanPham ORDER BY SoLuong DESC;

END;
GO
