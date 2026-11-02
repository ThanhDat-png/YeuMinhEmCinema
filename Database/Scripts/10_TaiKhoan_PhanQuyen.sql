USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

SET XACT_ABORT ON;
DECLARE @seed BIT=CASE WHEN OBJECT_ID(N'dbo.VaiTro',N'U') IS NULL THEN 1 ELSE 0 END;
BEGIN TRAN;
IF OBJECT_ID(N'dbo.VaiTro',N'U') IS NULL CREATE TABLE dbo.VaiTro(
 MaVaiTro INT IDENTITY PRIMARY KEY,TenVaiTro VARCHAR(50) NOT NULL UNIQUE,
 TenHienThi NVARCHAR(100) NOT NULL,MoTa NVARCHAR(500) NULL,DangHoatDong BIT NOT NULL DEFAULT 1);
IF OBJECT_ID(N'dbo.Quyen',N'U') IS NULL CREATE TABLE dbo.Quyen(
 MaQuyen VARCHAR(80) PRIMARY KEY,TenQuyen NVARCHAR(150) NOT NULL,NhomChucNang NVARCHAR(100) NOT NULL,MoTa NVARCHAR(500) NULL);
IF OBJECT_ID(N'dbo.VaiTroQuyen',N'U') IS NULL CREATE TABLE dbo.VaiTroQuyen(
 MaVaiTro INT REFERENCES dbo.VaiTro(MaVaiTro),MaQuyen VARCHAR(80) REFERENCES dbo.Quyen(MaQuyen),PRIMARY KEY(MaVaiTro,MaQuyen));
IF OBJECT_ID(N'dbo.TaiKhoan',N'U') IS NULL CREATE TABLE dbo.TaiKhoan(
 MaTaiKhoan INT IDENTITY PRIMARY KEY,TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
 MatKhauHash VARCHAR(1000) NOT NULL CHECK(LEN(LTRIM(RTRIM(MatKhauHash)))>0),Email NVARCHAR(254) NULL,
 DangHoatDong BIT NOT NULL DEFAULT 1,SoLanDangNhapSai INT NOT NULL DEFAULT 0 CHECK(SoLanDangNhapSai>=0),
 KhoaDenLuc DATETIME2(0) NULL,NgayTao DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 LanDangNhapCuoi DATETIME2(0) NULL,PhienBan ROWVERSION,
 CHECK(LEN(TenDangNhap) BETWEEN 3 AND 50 AND DATALENGTH(TenDangNhap)=DATALENGTH(LTRIM(RTRIM(TenDangNhap)))
 AND TenDangNhap COLLATE Latin1_General_100_BIN2 NOT LIKE '%[^a-zA-Z0-9_.-]%'),
 CHECK(Email IS NULL OR LEN(LTRIM(RTRIM(Email)))>0));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.TaiKhoan') AND name='UX_TaiKhoan_Email')
 CREATE UNIQUE INDEX UX_TaiKhoan_Email ON dbo.TaiKhoan(Email) WHERE Email IS NOT NULL;
IF OBJECT_ID(N'dbo.TaiKhoanVaiTro',N'U') IS NULL CREATE TABLE dbo.TaiKhoanVaiTro(
 MaTaiKhoan INT REFERENCES dbo.TaiKhoan(MaTaiKhoan),MaVaiTro INT REFERENCES dbo.VaiTro(MaVaiTro),PRIMARY KEY(MaTaiKhoan,MaVaiTro));
INSERT dbo.VaiTro(TenVaiTro,TenHienThi,MoTa)
SELECT a,b,b FROM(VALUES('ADMIN',N'Quản trị viên'),('QUAN_LY',N'Quản lý rạp'),('BAN_VE',N'Nhân viên bán vé'),
 ('SOAT_VE',N'Nhân viên soát vé'),('KHACH_HANG',N'Khách hàng'))v(a,b)
WHERE NOT EXISTS(SELECT 1 FROM dbo.VaiTro WHERE TenVaiTro=v.a);
INSERT dbo.Quyen(MaQuyen,TenQuyen,NhomChucNang)
SELECT a,b,c FROM(VALUES
 ('PHIM_XEM',N'Xem phim',N'Phim'),('PHIM_QUAN_LY',N'Quản lý phim',N'Phim'),
 ('RAP_XEM',N'Xem rạp',N'Rạp'),('RAP_QUAN_LY',N'Quản lý rạp/phòng/ghế',N'Rạp'),
 ('LICH_CHIEU_XEM',N'Xem lịch',N'Lịch'),('LICH_CHIEU_QUAN_LY',N'Quản lý lịch',N'Lịch'),
 ('GIA_VE_XEM',N'Xem giá vé',N'Giá'),('GIA_VE_QUAN_LY',N'Quản lý giá',N'Giá'),
 ('FNB_XEM',N'Xem menu',N'FNB'),('FNB_QUAN_LY',N'Quản lý menu',N'FNB'),
 ('BAN_VE',N'Bán vé tại quầy',N'Đơn hàng'),('DON_HANG_XEM',N'Xem đơn theo rạp',N'Đơn hàng'),
 ('DON_HANG_HUY',N'Hủy đơn',N'Đơn hàng'),('HOAN_TIEN',N'Hoàn tiền',N'Đơn hàng'),
 ('VE_KIEM_TRA',N'Kiểm vé',N'Vé'),('KHACH_HANG_XEM',N'Xem khách hàng',N'Khách hàng'),
 ('KHACH_HANG_QUAN_LY',N'Quản lý khách hàng',N'Khách hàng'),('NHAN_VIEN_QUAN_LY',N'Quản lý nhân viên',N'Nhân viên'),
 ('TAI_KHOAN_QUAN_LY',N'Quản lý tài khoản',N'Tài khoản'),('PHAN_QUYEN_QUAN_LY',N'Phân quyền',N'Tài khoản'),
 ('BAO_CAO_XEM',N'Xem báo cáo',N'Báo cáo'),('DAT_VE_WEB',N'Đặt vé online',N'Web'),
 ('DON_HANG_CA_NHAN',N'Xem đơn của mình',N'Web'))v(a,b,c)
WHERE NOT EXISTS(SELECT 1 FROM dbo.Quyen WHERE MaQuyen=v.a);
IF @seed=1
BEGIN
INSERT dbo.VaiTroQuyen SELECT r.MaVaiTro,q.MaQuyen FROM dbo.VaiTro r CROSS JOIN dbo.Quyen q
WHERE r.TenVaiTro='ADMIN' AND NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen x WHERE x.MaVaiTro=r.MaVaiTro AND x.MaQuyen=q.MaQuyen);
INSERT dbo.VaiTroQuyen SELECT r.MaVaiTro,v.q FROM(VALUES
 ('QUAN_LY','PHIM_XEM'),('QUAN_LY','RAP_XEM'),('QUAN_LY','LICH_CHIEU_XEM'),('QUAN_LY','LICH_CHIEU_QUAN_LY'),
 ('QUAN_LY','GIA_VE_XEM'),('QUAN_LY','FNB_XEM'),('QUAN_LY','BAN_VE'),('QUAN_LY','DON_HANG_XEM'),
 ('QUAN_LY','DON_HANG_HUY'),('QUAN_LY','HOAN_TIEN'),('QUAN_LY','VE_KIEM_TRA'),('QUAN_LY','KHACH_HANG_XEM'),('QUAN_LY','BAO_CAO_XEM'),
 ('BAN_VE','PHIM_XEM'),('BAN_VE','RAP_XEM'),('BAN_VE','LICH_CHIEU_XEM'),('BAN_VE','GIA_VE_XEM'),
 ('BAN_VE','FNB_XEM'),('BAN_VE','BAN_VE'),('BAN_VE','DON_HANG_XEM'),('BAN_VE','KHACH_HANG_XEM'),
 ('SOAT_VE','VE_KIEM_TRA'),('KHACH_HANG','DAT_VE_WEB'),('KHACH_HANG','DON_HANG_CA_NHAN'))v(r,q)
JOIN dbo.VaiTro r ON r.TenVaiTro=v.r WHERE NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen x WHERE x.MaVaiTro=r.MaVaiTro AND x.MaQuyen=v.q);
END;
COMMIT;
GO
CREATE OR ALTER VIEW dbo.v_YMC_QuyenTaiKhoan AS
SELECT DISTINCT t.MaTaiKhoan,q.MaQuyen FROM dbo.TaiKhoan t
JOIN dbo.TaiKhoanVaiTro tv ON tv.MaTaiKhoan=t.MaTaiKhoan
JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro JOIN dbo.VaiTroQuyen q ON q.MaVaiTro=v.MaVaiTro
WHERE t.DangHoatDong=1 AND v.DangHoatDong=1 AND (t.KhoaDenLuc IS NULL OR t.KhoaDenLuc<=SYSUTCDATETIME());
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayQuyenTaiKhoan @MaTaiKhoan INT AS
BEGIN SET NOCOUNT ON; SELECT q.* FROM dbo.v_YMC_QuyenTaiKhoan t JOIN dbo.Quyen q ON q.MaQuyen=t.MaQuyen WHERE t.MaTaiKhoan=@MaTaiKhoan; END;
GO
-- Chỉ backend tin cậy gọi, sau khi kiểm tra mật khẩu bằng PasswordHasher của C#.
-- Không cấp quyền gọi trực tiếp cho trình duyệt hay người dùng cuối.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayThongTinDangNhap @TenDangNhap VARCHAR(50) AS
BEGIN SET NOCOUNT ON; SELECT MaTaiKhoan,TenDangNhap,MatKhauHash,DangHoatDong,KhoaDenLuc,PhienBan
FROM dbo.TaiKhoan WHERE TenDangNhap=@TenDangNhap; END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_GhiNhanDangNhap
@MaTaiKhoan INT,@ThanhCong BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

IF @ThanhCong IS NULL THROW 50400,N'Thiếu kết quả xác thực.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoan WITH(UPDLOCK,HOLDLOCK) WHERE MaTaiKhoan=@MaTaiKhoan
AND PhienBan=@PhienBan AND DangHoatDong=1 AND (KhoaDenLuc IS NULL OR KhoaDenLuc<=SYSUTCDATETIME()))
 THROW 50401,N'Tài khoản đã đổi hoặc đang khóa. Xác thực lại.',1;
UPDATE dbo.TaiKhoan SET
 SoLanDangNhapSai=CASE WHEN @ThanhCong=1 OR SoLanDangNhapSai>=4 THEN 0 ELSE SoLanDangNhapSai+1 END,
 KhoaDenLuc=CASE WHEN @ThanhCong=0 AND SoLanDangNhapSai>=4 THEN DATEADD(MINUTE,15,SYSUTCDATETIME()) ELSE NULL END,
 LanDangNhapCuoi=CASE WHEN @ThanhCong=1 THEN SYSUTCDATETIME() ELSE LanDangNhapCuoi END
WHERE MaTaiKhoan=@MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
