USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_GanVaiTro
@NguoiThucHien INT,@MaTaiKhoan INT,@TenVaiTro VARCHAR(50),@Cap BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHAN_QUYEN_QUAN_LY';
DECLARE @k INT,@vt INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
IF @Cap IS NULL OR @TenVaiTro IS NULL THROW 50530,N'Thiếu thông tin phân quyền.',1;
-- Giữ ADMIN cố định; bootstrap là đường duy nhất tạo ADMIN đầu tiên trong bản này.
IF @TenVaiTro='ADMIN' OR EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN')
 THROW 50531,N'Không chỉnh vai trò ADMIN bằng thủ tục này.',1;
IF @MaTaiKhoan=@NguoiThucHien THROW 50532,N'Không tự thay đổi vai trò của mình.',1;
SELECT @vt=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro AND DangHoatDong=1;
IF @vt IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan) THROW 50533,N'Tài khoản hoặc vai trò không tồn tại.',1;
IF @Cap=1 AND @TenVaiTro IN('QUAN_LY','BAN_VE','SOAT_VE') AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaTaiKhoan=@MaTaiKhoan AND DangLamViec=1)
 THROW 50534,N'Cần hồ sơ nhân viên đang làm việc trước khi cấp vai trò.',1;
IF @Cap=1 AND @TenVaiTro='KHACH_HANG' AND NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaTaiKhoan=@MaTaiKhoan AND DangHoatDong=1)
 THROW 50535,N'Cần hồ sơ khách hàng trước khi cấp vai trò.',1;
IF @Cap=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@MaTaiKhoan AND MaVaiTro=@vt) INSERT dbo.TaiKhoanVaiTro VALUES(@MaTaiKhoan,@vt);END
ELSE DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@MaTaiKhoan AND MaVaiTro=@vt;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapQuyenVaiTro
@NguoiThucHien INT,@TenVaiTro VARCHAR(50),@MaQuyen VARCHAR(80),@Cap BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHAN_QUYEN_QUAN_LY';
IF @TenVaiTro IS NULL OR @TenVaiTro='ADMIN' OR @Cap IS NULL THROW 50536,N'Không sửa quyền ADMIN hoặc thiếu thông tin.',1;
DECLARE @k INT,@vt INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
SELECT @vt=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro;
IF @vt IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Quyen WHERE MaQuyen=@MaQuyen) THROW 50537,N'Vai trò hoặc quyền không tồn tại.',1;
IF @Cap=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen WHERE MaVaiTro=@vt AND MaQuyen=@MaQuyen) INSERT dbo.VaiTroQuyen VALUES(@vt,@MaQuyen);END
ELSE DELETE dbo.VaiTroQuyen WHERE MaVaiTro=@vt AND MaQuyen=@MaQuyen;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatNhanVien
@NguoiThucHien INT,@MaNhanVien INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@DangLamViec BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'NHAN_VIEN_QUAN_LY';
IF EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaNhanVien=@MaNhanVien AND MaTaiKhoan=@NguoiThucHien) THROW 50538,N'Không tự sửa tình trạng nhân sự của mình.',1;
UPDATE dbo.NhanVien SET HoTen=@HoTen,DienThoai=@DienThoai,DangLamViec=@DangLamViec WHERE MaNhanVien=@MaNhanVien AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50539,N'Nhân viên đã đổi, hãy tải lại.',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_PhanCongRap
@NguoiThucHien INT,@MaNhanVien INT,@MaRap INT,@PhanCong BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'NHAN_VIEN_QUAN_LY';
IF @PhanCong IS NULL THROW 50540,N'Thiếu trạng thái phân công.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.NhanVien WITH(UPDLOCK,HOLDLOCK) WHERE MaNhanVien=@MaNhanVien) THROW 50541,N'Không tìm thấy nhân viên.',1;
IF @PhanCong=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.NhanVienRap WHERE MaNhanVien=@MaNhanVien AND MaRap=@MaRap) INSERT dbo.NhanVienRap VALUES(@MaNhanVien,@MaRap);END
ELSE DELETE dbo.NhanVienRap WHERE MaNhanVien=@MaNhanVien AND MaRap=@MaRap;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
