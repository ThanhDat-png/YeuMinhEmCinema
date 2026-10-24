USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_HuyDonChuaThanhToan
@NguoiThucHien INT,@MaDonHang BIGINT,@LyDo NVARCHAR(500)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20);
SELECT @rap=p.MaRap,@tt=d.TrangThai FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn.',1;
IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_CA_NHAN';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_HUY',@rap;
IF @tt='DA_HUY' BEGIN COMMIT;RETURN;END;
IF @tt<>'CHO_THANH_TOAN' THROW 50330,N'Chỉ hủy trực tiếp đơn chưa thanh toán.',1;
IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 THROW 50331,N'Nhập lý do hủy.',1;
UPDATE dbo.DonHang SET TrangThai='DA_HUY',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_GhiNhanHoanTien
@NguoiThucHien INT,@MaDonHang BIGINT,@MaGiaoDichHoan VARCHAR(100),@LyDo NVARCHAR(500)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20),@batdau DATETIME2(0),@tong DECIMAL(18,0);
SELECT @rap=p.MaRap,@tt=d.TrangThai,@batdau=s.GioBatDau,@tong=d.TongTien FROM dbo.DonHang d
JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'HOAN_TIEN',@rap;
IF @tt='DA_HOAN_TIEN'
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang AND MaGiaoDichHoan=@MaGiaoDichHoan)
 THROW 50332,N'Đơn đã hoàn bằng giao dịch khác.',1;
 SELECT * FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;COMMIT;RETURN;
END;
IF @tt<>'DA_THANH_TOAN' OR @batdau<=dbo.fn_YMC_GioVietNam() THROW 50333,N'Chỉ hoàn toàn bộ đơn đã thanh toán trước giờ chiếu.',1;
IF EXISTS(SELECT 1 FROM dbo.Ve WHERE MaDonHang=@MaDonHang AND TrangThai='DA_SU_DUNG') THROW 50334,N'Đơn đã có vé sử dụng, không được hoàn.',1;
IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 OR @MaGiaoDichHoan IS NULL OR LEN(LTRIM(RTRIM(@MaGiaoDichHoan)))=0
 THROW 50335,N'Nhập lý do và mã giao dịch hoàn thực tế.',1;
-- Chỉ ghi nhận sau khi nhân viên/backend đã thực hiện hoàn tiền ngoài hệ thống.
INSERT dbo.HoanTien(MaDonHang,MaGiaoDichHoan,SoTien,LyDo,NguoiThucHien) VALUES(@MaDonHang,@MaGiaoDichHoan,@tong,@LyDo,@NguoiThucHien);
UPDATE dbo.DonHang SET TrangThai='DA_HOAN_TIEN',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
UPDATE dbo.Ve SET TrangThai='DA_HUY' WHERE MaDonHang=@MaDonHang;
DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
