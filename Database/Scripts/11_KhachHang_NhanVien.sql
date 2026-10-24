USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

SET XACT_ABORT ON;
BEGIN TRAN;
IF OBJECT_ID(N'dbo.KhachHang',N'U') IS NULL CREATE TABLE dbo.KhachHang(
 MaKhachHang INT IDENTITY PRIMARY KEY,MaTaiKhoan INT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 HoTen NVARCHAR(150) NOT NULL CHECK(LEN(LTRIM(RTRIM(HoTen)))>0),DienThoai VARCHAR(20) NULL,
 NgaySinh DATE NULL,DangHoatDong BIT NOT NULL DEFAULT 1,NgayTao DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),PhienBan ROWVERSION);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.KhachHang') AND name='UX_KhachHang_TaiKhoan')
 CREATE UNIQUE INDEX UX_KhachHang_TaiKhoan ON dbo.KhachHang(MaTaiKhoan) WHERE MaTaiKhoan IS NOT NULL;
IF OBJECT_ID(N'dbo.NhanVien',N'U') IS NULL CREATE TABLE dbo.NhanVien(
 MaNhanVien INT IDENTITY PRIMARY KEY,MaTaiKhoan INT NOT NULL UNIQUE REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 HoTen NVARCHAR(150) NOT NULL CHECK(LEN(LTRIM(RTRIM(HoTen)))>0),DienThoai VARCHAR(20) NULL,
 DangLamViec BIT NOT NULL DEFAULT 1,PhienBan ROWVERSION);
IF OBJECT_ID(N'dbo.NhanVienRap',N'U') IS NULL CREATE TABLE dbo.NhanVienRap(
 MaNhanVien INT REFERENCES dbo.NhanVien(MaNhanVien),MaRap INT REFERENCES dbo.Rap(MaRap),PRIMARY KEY(MaNhanVien,MaRap));
COMMIT;
GO
-- ADMIN có phạm vi toàn hệ thống. Nhân viên khác phải được phân công rạp.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan INT,@MaQuyen VARCHAR(80),@MaRap INT=NULL AS
BEGIN
 SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.v_YMC_QuyenTaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan AND MaQuyen=@MaQuyen)
  THROW 50403,N'Tài khoản không có quyền hoặc đang bị khóa.',1;
 IF @MaRap IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro
 WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien
 WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)
 THROW 50404,N'Bạn chưa được phân công làm việc tại rạp này.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoiTaoAdmin
@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@Email NVARCHAR(254)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE v.TenVaiTro='ADMIN')
 THROW 50406,N'Đã có quản trị viên. Không thể khởi tạo lần nữa.',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N'Phải truyền chuỗi băm do C# tạo, không dùng mật khẩu gốc.',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash,Email) VALUES(@TenDangNhap,@MatKhauHash,NULLIF(LTRIM(RTRIM(@Email)),N''));
DECLARE @id INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
SELECT @id AS MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DangKyKhachHang
@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@HoTen NVARCHAR(150),@Email NVARCHAR(254)=NULL,@DienThoai VARCHAR(20)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N'Thiếu chuỗi băm hợp lệ từ C#.',1;
IF @HoTen IS NULL OR LEN(LTRIM(RTRIM(@HoTen)))=0 THROW 50408,N'Nhập họ tên.',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash,Email) VALUES(@TenDangNhap,@MatKhauHash,NULLIF(LTRIM(RTRIM(@Email)),N''));
DECLARE @id INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.KhachHang(MaTaiKhoan,HoTen,DienThoai) VALUES(@id,LTRIM(RTRIM(@HoTen)),@DienThoai);
INSERT dbo.TaiKhoanVaiTro SELECT @id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='KHACH_HANG' AND DangHoatDong=1;
IF @@ROWCOUNT<>1 THROW 50409,N'Vai trò khách hàng chưa sẵn sàng.',1;
SELECT @id AS MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoNhanVien
@NguoiThucHien INT,@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@HoTen NVARCHAR(150),@MaRap INT,@TenVaiTro VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'NHAN_VIEN_QUAN_LY';
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'TAI_KHOAN_QUAN_LY';
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHAN_QUYEN_QUAN_LY';
IF @TenVaiTro IS NULL OR @TenVaiTro NOT IN('QUAN_LY','BAN_VE','SOAT_VE') THROW 50410,N'Vai trò nhân viên không hợp lệ.',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N'Thiếu chuỗi băm từ C#.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.Rap WHERE MaRap=@MaRap AND TrangThai=N'Đang hoạt động') THROW 50411,N'Rạp không hoạt động.',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@TenDangNhap,@MatKhauHash);
DECLARE @tk INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@tk,@HoTen);
DECLARE @nv INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVienRap VALUES(@nv,@MaRap);
INSERT dbo.TaiKhoanVaiTro SELECT @tk,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro AND DangHoatDong=1;
IF @@ROWCOUNT<>1 THROW 50410,N'Vai trò chưa sẵn sàng.',1;
SELECT @tk AS MaTaiKhoan,@nv AS MaNhanVien;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatKhachHang
@NguoiThucHien INT,@MaKhachHang INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@NgaySinh DATE=NULL,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

IF NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaKhachHang=@MaKhachHang AND MaTaiKhoan=@NguoiThucHien AND DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'KHACH_HANG_QUAN_LY';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_CA_NHAN';
IF @NgaySinh>CONVERT(DATE,DATEADD(HOUR,7,SYSUTCDATETIME())) THROW 50412,N'Ngày sinh không hợp lệ.',1;
UPDATE dbo.KhachHang SET HoTen=@HoTen,DienThoai=@DienThoai,NgaySinh=@NgaySinh WHERE MaKhachHang=@MaKhachHang AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50413,N'Hồ sơ đã đổi. Tải lại.',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
