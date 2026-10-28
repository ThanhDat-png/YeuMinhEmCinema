USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraVe
@NguoiThucHien INT,@MaVe UNIQUEIDENTIFIER,@XacNhanVaoRap BIT=0,
@MaSuatChieu INT=NULL,@MaPhong INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20),@don BIGINT,@batdau DATETIME2(0),@ketthuc DATETIME2(0),@suat INT,@phong INT;
SELECT @suat=s.MaSuatChieu,@phong=s.MaPhong,@rap=p.MaRap,@tt=v.TrangThai,@don=v.MaDonHang,@batdau=s.GioBatDau,@ketthuc=s.GioKetThuc
FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE v.MaVe=@MaVe AND d.TrangThai='DA_THANH_TOAN' AND s.TrangThai<>N'Đã hủy';
IF @rap IS NULL THROW 50340,N'Vé không tồn tại hoặc không hợp lệ.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'VE_KIEM_TRA',@rap;
IF @MaSuatChieu IS NOT NULL AND @MaSuatChieu<>@suat
 THROW 50343,N'Vé không thuộc suất chiếu đang soát. Hãy kiểm tra lại suất đã chọn.',1;
IF @MaPhong IS NOT NULL AND @MaPhong<>@phong
 THROW 50344,N'Vé không thuộc phòng đang soát. Hãy kiểm tra lại phòng đã chọn.',1;
IF @tt<>'HIEU_LUC' THROW 50341,N'Vé đã được sử dụng hoặc đã hủy.',1;
IF @XacNhanVaoRap=1
BEGIN
 IF dbo.fn_YMC_GioVietNam()<DATEADD(MINUTE,-30,@batdau) OR dbo.fn_YMC_GioVietNam()>=@ketthuc
 THROW 50342,N'Chỉ cho vào từ 30 phút trước giờ chiếu đến trước khi suất kết thúc.',1;
 UPDATE dbo.Ve SET TrangThai='DA_SU_DUNG',NgaySoatUtc=SYSUTCDATETIME(),NguoiSoat=@NguoiThucHien WHERE MaVe=@MaVe AND TrangThai='HIEU_LUC';
 IF @@ROWCOUNT<>1 THROW 50341,N'Vé đã được sử dụng hoặc đã hủy.',1;
END;
SELECT v.MaVe,v.TrangThai,v.NgaySoatUtc,c.TenPhim,c.TenRap,c.TenPhong,c.NhanGhe,c.GioBatDau
FROM dbo.Ve v JOIN dbo.ChiTietVe c ON c.MaDonHang=v.MaDonHang AND c.MaGhe=v.MaGhe WHERE v.MaVe=@MaVe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

-- Danh sách chỉ dành cho quyền soát vé; không yêu cầu quyền quản lý lịch. Bao gồm suất qua đêm.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LaySuatSoatVe
@NguoiThucHien INT,@Ngay DATE=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'VE_KIEM_TRA';
 SET @Ngay=COALESCE(@Ngay,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 SELECT s.MaSuatChieu,s.MaPhong,p.MaRap,r.TenRap,p.TenPhong,f.TenPhim,s.GioBatDau,s.GioKetThuc
 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
 JOIN dbo.Rap r ON r.MaRap=p.MaRap JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
 WHERE dbo.fn_YMC_CoPhamViRap(@NguoiThucHien,p.MaRap)=1 AND s.TrangThai<>N'Đã hủy'
 AND s.GioBatDau<DATEADD(DAY,1,CONVERT(DATETIME2(0),@Ngay)) AND s.GioKetThuc>CONVERT(DATETIME2(0),@Ngay)
 ORDER BY s.GioBatDau,r.MaRap,s.MaPhong,s.MaSuatChieu;
END;
GO
