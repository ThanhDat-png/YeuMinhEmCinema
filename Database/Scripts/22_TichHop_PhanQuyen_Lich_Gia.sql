USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminThemSuatChieu
@NguoiThucHien INT,@MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT;SELECT @rap=MaRap FROM dbo.PhongChieu WHERE MaPhong=@MaPhong;
IF @rap IS NULL THROW 50510,N'Không tìm thấy phòng.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'LICH_CHIEU_QUAN_LY',@rap;
EXEC dbo.sp_ThemSuatChieu @MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminSuaSuatChieu
@NguoiThucHien INT,@MaSuatChieu INT,@MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@rapMoi INT;
SELECT @rap=p.MaRap FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE s.MaSuatChieu=@MaSuatChieu;
SELECT @rapMoi=MaRap FROM dbo.PhongChieu WHERE MaPhong=@MaPhong;
IF @rap IS NULL OR @rapMoi IS NULL THROW 50510,N'Không tìm thấy suất hoặc phòng.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'LICH_CHIEU_QUAN_LY',@rap;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'LICH_CHIEU_QUAN_LY',@rapMoi;
EXEC dbo.sp_SuaSuatChieu @MaSuatChieu,@MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminDoiTrangThaiSuat
@NguoiThucHien INT,@MaSuatChieu INT,@TrangThaiMoi NVARCHAR(30)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT;SELECT @rap=p.MaRap FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE s.MaSuatChieu=@MaSuatChieu;
IF @rap IS NULL THROW 50010,N'Không tìm thấy suất.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'LICH_CHIEU_QUAN_LY',@rap;
EXEC dbo.sp_DoiTrangThaiSuatChieu @MaSuatChieu,@TrangThaiMoi;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminSaoChepLich
@NguoiThucHien INT,@NgayNguon DATE,@NgayDich DATE,@MaRap INT,@MaPhong INT=NULL,@XemTruoc BIT=1,@ChuKy VARCHAR(64)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

IF @MaRap IS NULL THROW 50507,N'Chọn rạp trước khi sao chép.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'LICH_CHIEU_QUAN_LY',@MaRap;
IF @MaPhong IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong AND MaRap=@MaRap) THROW 50510,N'Phòng không thuộc rạp.',1;
EXEC dbo.sp_SaoChepLich @NgayNguon,@NgayDich,@MaRap,@MaPhong,@XemTruoc,@ChuKy;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminLuuGiaVe
@NguoiThucHien INT,@MaGiaVe INT=NULL,@MaLoaiGhe INT,@DinhDang NVARCHAR(50),@LoaiNgay NVARCHAR(20),@TuNgay DATE,@DenNgay DATE=NULL,@DonGia DECIMAL(18,0),@DangApDung BIT,@PhienBan BINARY(8)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'GIA_VE_QUAN_LY';
EXEC dbo.sp_YMC_LuuGiaVe @MaGiaVe,@MaLoaiGhe,@DinhDang,@LoaiNgay,@TuNgay,@DenNgay,@DonGia,@DangApDung,@PhienBan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminLuuFnb
@NguoiThucHien INT,@MaSanPham INT=NULL,@MaHang VARCHAR(30),@TenSanPham NVARCHAR(150),@Nhom NVARCHAR(20),@KichCo NVARCHAR(50),@DonGia DECIMAL(18,0),@DangBan BIT,@ThanhPhan dbo.YMC_FnbThanhPhan READONLY,@PhienBan BINARY(8)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'FNB_QUAN_LY';
EXEC dbo.sp_YMC_LuuFnb @MaSanPham,@MaHang,@TenSanPham,@Nhom,@KichCo,@DonGia,@DangBan,@ThanhPhan,@PhienBan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu INT AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM dbo.DonHang WITH(UPDLOCK,HOLDLOCK) WHERE MaSuatChieu=@MaSuatChieu
 AND(TrangThai='DA_THANH_TOAN' OR(TrangThai='CHO_THANH_TOAN' AND HanThanhToanUtc>SYSUTCDATETIME())))
 THROW 50013,N'Suất có đơn đã thanh toán hoặc đang giữ ghế. Xử lý đơn trước khi sửa/hủy.',1;
 DECLARE @sql NVARCHAR(MAX)=N'',@co BIT=0;
 SELECT @sql=STRING_AGG(CONVERT(NVARCHAR(MAX),N'IF EXISTS(SELECT 1 FROM '+QUOTENAME(s.name)+N'.'+QUOTENAME(t.name)+
 N' WITH(UPDLOCK,HOLDLOCK) WHERE '+QUOTENAME(c.name)+N'=@ma) SET @found=1;'),N' ')
 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id JOIN sys.columns c ON c.object_id=t.object_id
 WHERE t.is_ms_shipped=0 AND t.object_id NOT IN(OBJECT_ID(N'dbo.SuatChieu'),OBJECT_ID(N'dbo.DonHang'),OBJECT_ID(N'dbo.GiuGhe')) AND c.name=N'MaSuatChieu';
 IF LEN(@sql)>0 EXEC sys.sp_executesql @sql,N'@ma INT,@found BIT OUTPUT',@ma=@MaSuatChieu,@found=@co OUTPUT;
 IF @co=1 THROW 50013,N'Suất có dữ liệu liên quan ngoài đơn hàng. Cần kiểm tra trước khi sửa/hủy.',1;
END;
GO
