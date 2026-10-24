USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraVe
@NguoiThucHien INT,@MaVe UNIQUEIDENTIFIER,@XacNhanVaoRap BIT=0
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20),@don BIGINT,@batdau DATETIME2(0),@ketthuc DATETIME2(0);
SELECT @rap=p.MaRap,@tt=v.TrangThai,@don=v.MaDonHang,@batdau=s.GioBatDau,@ketthuc=s.GioKetThuc
FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE v.MaVe=@MaVe AND d.TrangThai='DA_THANH_TOAN' AND s.TrangThai<>N'Đã hủy';
IF @rap IS NULL THROW 50340,N'Vé không tồn tại hoặc không hợp lệ.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'VE_KIEM_TRA',@rap;
IF @tt<>'HIEU_LUC' THROW 50341,N'Vé đã được sử dụng hoặc đã hủy.',1;
IF @XacNhanVaoRap=1
BEGIN
 IF dbo.fn_YMC_GioVietNam()<DATEADD(MINUTE,-30,@batdau) OR dbo.fn_YMC_GioVietNam()>=@ketthuc
 THROW 50342,N'Chỉ cho vào từ 30 phút trước giờ chiếu đến trước khi suất kết thúc.',1;
 UPDATE dbo.Ve SET TrangThai='DA_SU_DUNG',NgaySoatUtc=SYSUTCDATETIME(),NguoiSoat=@NguoiThucHien WHERE MaVe=@MaVe;
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
