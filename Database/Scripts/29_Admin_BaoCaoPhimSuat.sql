USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_BaoCaoDoanhThu
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@MaPhim INT=NULL
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
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND t.NgayThuUtc>=@tu AND t.NgayThuUtc<@den
 UNION ALL SELECT CONVERT(DATE,DATEADD(HOUR,7,h.NgayHoanUtc)),0,h.SoTien FROM dbo.HoanTien h
 JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND h.NgayHoanUtc>=@tu AND h.NgayHoanUtc<@den)
SELECT Ngay,SUM(TienThu) TienDaThu,SUM(TienHoan) TienDaHoan,SUM(TienThu-TienHoan) DoanhThuThuan FROM dong GROUP BY Ngay ORDER BY Ngay;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKePhim
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@MaPhim INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231' THROW 50600,N'Khoảng ngày không hợp lệ.',1;
;WITH suat AS(
 SELECT s.MaSuatChieu,s.MaPhim,(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=s.MaPhong AND g.TrangThai=N'Hoạt động') SucChua
 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND s.TrangThai<>N'Đã hủy'
 AND s.GioBatDau>=@TuNgay AND s.GioBatDau<DATEADD(DAY,1,@DenNgay)),ban AS(
 SELECT d.MaSuatChieu,COUNT(*) SoVe,SUM(c.DonGia) TienVe FROM dbo.DonHang d JOIN dbo.ChiTietVe c ON c.MaDonHang=d.MaDonHang
 WHERE d.TrangThai='DA_THANH_TOAN' GROUP BY d.MaSuatChieu)
SELECT f.MaPhim,f.TenPhim,COUNT(*) SoSuat,SUM(s.SucChua) TongGheHienTai,SUM(ISNULL(b.SoVe,0)) VeDaBan,
SUM(ISNULL(b.TienVe,0)) TienVe,CAST(100.0*SUM(ISNULL(b.SoVe,0))/NULLIF(SUM(s.SucChua),0) AS DECIMAL(8,2)) TyLeLapDay
FROM suat s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim LEFT JOIN ban b ON b.MaSuatChieu=s.MaSuatChieu GROUP BY f.MaPhim,f.TenPhim;

END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKeFnb
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@MaPhim INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231' THROW 50600,N'Khoảng ngày không hợp lệ.',1;
SELECT c.MaSanPham,c.TenSanPham,SUM(c.SoLuong) SoLuong,SUM(c.SoLuong*c.DonGia) TienBan
FROM dbo.ChiTietDonFnb c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang JOIN dbo.ThanhToan t ON t.MaDonHang=d.MaDonHang
JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND d.TrangThai='DA_THANH_TOAN'
AND t.NgayThuUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
AND t.NgayThuUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)))
GROUP BY c.MaSanPham,c.TenSanPham ORDER BY SoLuong DESC;

END;
GO

-- Mở rộng báo cáo: thu chi tiết theo ngày giao dịch, từng suất theo ngày chiếu và bộ lọc phim.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_BaoCaoThuChiTiet
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@MaPhim INT=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
 IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231'
  THROW 50600,N'Chọn rạp và khoảng ngày hợp lệ.',1;
 DECLARE @tu DATETIME2(0)=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay)),
 @den DATETIME2(0)=DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)));
 -- Mỗi CTE chỉ một dòng/đơn: không join chéo nhiều vé và nhiều dòng F&B.
 ;WITH ve AS(SELECT MaDonHang,SUM(DonGia) ThuVe FROM dbo.ChiTietVe GROUP BY MaDonHang),
 fnb AS(SELECT MaDonHang,SUM(SoLuong*DonGia) ThuFnb FROM dbo.ChiTietDonFnb GROUP BY MaDonHang),
 dong AS(
  SELECT CONVERT(DATE,DATEADD(HOUR,7,t.NgayThuUtc)) Ngay,ISNULL(v.ThuVe,0) ThuVe,ISNULL(f.ThuFnb,0) ThuFnb,
   t.SoTien TienDaThu,CONVERT(DECIMAL(18,0),0) TienDaHoan
  FROM dbo.ThanhToan t JOIN dbo.DonHang d ON d.MaDonHang=t.MaDonHang
  JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
  LEFT JOIN ve v ON v.MaDonHang=d.MaDonHang LEFT JOIN fnb f ON f.MaDonHang=d.MaDonHang
  WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND t.NgayThuUtc>=@tu AND t.NgayThuUtc<@den
  UNION ALL
  SELECT CONVERT(DATE,DATEADD(HOUR,7,h.NgayHoanUtc)),0,0,0,h.SoTien
  FROM dbo.HoanTien h JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
  JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
  WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim) AND h.NgayHoanUtc>=@tu AND h.NgayHoanUtc<@den
 )
 SELECT Ngay,SUM(ThuVe) ThuVe,SUM(ThuFnb) ThuFnb,SUM(TienDaThu) TienDaThu,SUM(TienDaHoan) TienDaHoan,
  SUM(TienDaThu-TienDaHoan) DoanhThuThuan FROM dong GROUP BY Ngay ORDER BY Ngay;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_BaoCaoTheoSuat
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@MaPhim INT=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
 IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231'
  THROW 50600,N'Chọn rạp và khoảng ngày hợp lệ.',1;
 ;WITH ve AS(SELECT MaDonHang,COUNT(*) SoVe,SUM(DonGia) ThuVe FROM dbo.ChiTietVe GROUP BY MaDonHang),
 fnb AS(SELECT MaDonHang,SUM(SoLuong*DonGia) ThuFnb FROM dbo.ChiTietDonFnb GROUP BY MaDonHang),
 ban AS(
  SELECT d.MaSuatChieu,SUM(ISNULL(v.SoVe,0)) VePhatHanh,
   SUM(CASE WHEN h.MaDonHang IS NOT NULL THEN ISNULL(v.SoVe,0) ELSE 0 END) VeDaHoan,
   SUM(ISNULL(v.ThuVe,0)) ThuVe,SUM(ISNULL(f.ThuFnb,0)) ThuFnb,SUM(t.SoTien) TienDaThu,SUM(ISNULL(h.SoTien,0)) TienDaHoan
  FROM dbo.DonHang d JOIN dbo.ThanhToan t ON t.MaDonHang=d.MaDonHang
  LEFT JOIN ve v ON v.MaDonHang=d.MaDonHang LEFT JOIN fnb f ON f.MaDonHang=d.MaDonHang
  LEFT JOIN dbo.HoanTien h ON h.MaDonHang=d.MaDonHang
  GROUP BY d.MaSuatChieu
 )
 SELECT s.MaSuatChieu,s.MaPhim,f.TenPhim,r.TenRap,p.TenPhong,s.GioBatDau,s.GioKetThuc,s.TrangThai,
  ISNULL(b.VePhatHanh,0) VePhatHanh,ISNULL(b.VeDaHoan,0) VeDaHoan,ISNULL(b.VePhatHanh-b.VeDaHoan,0) VeChuaHoan,
  ISNULL(b.ThuVe,0) ThuVe,ISNULL(b.ThuFnb,0) ThuFnb,ISNULL(b.TienDaThu,0) TienDaThu,
  ISNULL(b.TienDaHoan,0) TienDaHoan,ISNULL(b.TienDaThu-b.TienDaHoan,0) DoanhThuThuan
 FROM dbo.SuatChieu s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
 JOIN dbo.Rap r ON r.MaRap=p.MaRap LEFT JOIN ban b ON b.MaSuatChieu=s.MaSuatChieu
 WHERE p.MaRap=@MaRap AND (@MaPhim IS NULL OR s.MaPhim=@MaPhim)
 AND s.GioBatDau>=@TuNgay AND s.GioBatDau<DATEADD(DAY,1,@DenNgay)
 -- Gồm suất hủy để không mất lịch sử thu/hoàn. Không dùng giá/sức chứa hiện tại để tính tiền.
 ORDER BY s.GioBatDau,s.MaSuatChieu;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayPhimBaoCao
@NguoiThucHien INT,@MaRap INT
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAO_CAO_XEM',@MaRap;
 IF @MaRap IS NULL THROW 50600,N'Chọn rạp báo cáo.',1;
 SELECT DISTINCT f.MaPhim,f.TenPhim FROM dbo.Phim f JOIN dbo.SuatChieu s ON s.MaPhim=f.MaPhim
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap ORDER BY f.TenPhim,f.MaPhim;
END;
GO
