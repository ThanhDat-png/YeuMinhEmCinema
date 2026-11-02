USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_XacNhanThanhToan

@NguoiThucHien INT,@MaDonHang BIGINT,@MaGiaoDich VARCHAR(100),@PhuongThuc VARCHAR(20),@SoTien DECIMAL(18,0)

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20),@tong DECIMAL(18,0),@han DATETIME2(0),@suat INT,@batdau DATETIME2(0);
SELECT @rap=p.MaRap,@tt=d.TrangThai,@tong=d.TongTien,@han=d.HanThanhToanUtc,@suat=s.MaSuatChieu,@batdau=s.GioBatDau
FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn hàng.',1;
-- Cả tiền mặt và giao dịch online đều do nhân viên/backend đã được cấp quyền xác nhận.
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAN_VE',@rap;
SET @MaGiaoDich=LTRIM(RTRIM(@MaGiaoDich));
IF @MaGiaoDich IS NULL OR LEN(@MaGiaoDich)=0 OR @PhuongThuc IS NULL OR @PhuongThuc NOT IN('TIEN_MAT','CHUYEN_KHOAN','CONG_THANH_TOAN')
 THROW 50321,N'Thiếu mã giao dịch hoặc phương thức không hợp lệ.',1;
IF @SoTien IS NULL OR @SoTien<>@tong THROW 50322,N'Số tiền không khớp với đơn hàng.',1;
IF @tt='DA_THANH_TOAN'
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.ThanhToan WHERE MaDonHang=@MaDonHang AND MaGiaoDich=@MaGiaoDich AND PhuongThuc=@PhuongThuc AND SoTien=@SoTien)
  THROW 50323,N'Đơn đã được thanh toán bằng giao dịch khác.',1;
 SELECT * FROM dbo.Ve WHERE MaDonHang=@MaDonHang; COMMIT; RETURN;
END;
IF @tt<>'CHO_THANH_TOAN' OR @han<=SYSUTCDATETIME() OR @batdau<=dbo.fn_YMC_GioVietNam()
 THROW 50324,N'Đơn không còn chờ thanh toán hoặc đã hết hạn. Không ghi nhận thu tiền.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
WHERE s.MaSuatChieu=@suat AND s.TrangThai=N'Mở bán' AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động')
 THROW 50325,N'Suất hoặc rạp/phòng đã ngừng bán.',1;
IF EXISTS(SELECT 1 FROM dbo.ChiTietVe c JOIN dbo.Ghe g ON g.MaGhe=c.MaGhe WHERE c.MaDonHang=@MaDonHang AND g.TrangThai<>N'Hoạt động')
 THROW 50326,N'Ghế đã ngừng hoạt động.',1;
IF EXISTS(SELECT 1 FROM dbo.ChiTietVe c WHERE c.MaDonHang=@MaDonHang AND NOT EXISTS(
 SELECT 1 FROM dbo.GiuGhe g WHERE g.MaDonHang=c.MaDonHang AND g.MaGhe=c.MaGhe AND g.MaSuatChieu=@suat))
 THROW 50327,N'Đơn đã mất quyền giữ ghế.',1;
INSERT dbo.ThanhToan(MaDonHang,MaGiaoDich,PhuongThuc,SoTien,NguoiXacNhan) VALUES(@MaDonHang,@MaGiaoDich,@PhuongThuc,@SoTien,@NguoiThucHien);
UPDATE dbo.DonHang SET TrangThai='DA_THANH_TOAN' WHERE MaDonHang=@MaDonHang;
INSERT dbo.Ve(MaDonHang,MaGhe) SELECT MaDonHang,MaGhe FROM dbo.ChiTietVe WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.Ve WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_XemChiTietDon
@NguoiThucHien INT,@MaDonHang BIGINT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

DECLARE @rap INT;
SELECT @rap=p.MaRap FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn.',1;
IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
 WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_CA_NHAN';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_XEM',@rap;
SELECT * FROM dbo.DonHang WHERE MaDonHang=@MaDonHang;
SELECT c.*,v.MaVe,v.TrangThai AS TrangThaiVe FROM dbo.ChiTietVe c LEFT JOIN dbo.Ve v ON v.MaDonHang=c.MaDonHang AND v.MaGhe=c.MaGhe WHERE c.MaDonHang=@MaDonHang;
SELECT * FROM dbo.ChiTietDonFnb WHERE MaDonHang=@MaDonHang;
SELECT MaThanhToan,MaGiaoDich,PhuongThuc,SoTien,NgayThuUtc FROM dbo.ThanhToan WHERE MaDonHang=@MaDonHang;
SELECT MaHoanTien,MaGiaoDichHoan,SoTien,LyDo,NgayHoanUtc FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.ChiTietComboDaBan WHERE MaDonHang=@MaDonHang;

END;
GO
