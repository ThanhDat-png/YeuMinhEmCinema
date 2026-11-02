-- Kiểm thử hồi quy phạm vi Admin. Chạy bằng sqlcmd -I -b -f 65001 trên Test.
-- Từng ca tự tạo fixture trong transaction và rollback; không thay tài khoản người dùng.
USE YeuMinhEmCinema_Test;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET QUOTED_IDENTIFIER ON;
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50980,N'Chỉ chạy database Test.',1;
GO
CREATE PROCEDURE #YMC_ScopeFixture
 @Admin INT OUTPUT,@Manager INT OUTPUT,@Viewer INT OUTPUT,
 @RapA INT OUTPUT,@RapB INT OUTPUT,@RapC INT OUTPUT,
 @PhongA INT OUTPUT,@PhongB INT OUTPUT,@PhongC INT OUTPUT,
 @Loai INT OUTPUT,@GheA INT OUTPUT,@GheB INT OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @tag VARCHAR(32)='scope_'+LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),12),@nv INT,@vnv INT;
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@tag+'_ad',REPLICATE('X',80));SET @Admin=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @Admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@tag+'_ql',REPLICATE('X',80));SET @Manager=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @Manager,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 INSERT dbo.VaiTroQuyen SELECT MaVaiTro,'RAP_QUAN_LY' FROM dbo.VaiTro v WHERE TenVaiTro='QUAN_LY'
 AND NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen q WHERE q.MaVaiTro=v.MaVaiTro AND q.MaQuyen='RAP_QUAN_LY');
 INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@Manager,N'Quản lý fixture');SET @nv=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@tag+'_view',REPLICATE('X',80));SET @Viewer=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @Viewer,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='BAN_VE';
 INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@Viewer,N'Chỉ xem fixture');SET @vnv=SCOPE_IDENTITY();
 INSERT dbo.Rap(TenRap,TrangThai) VALUES(@tag+'_A',N'Đang hoạt động');SET @RapA=SCOPE_IDENTITY();
 INSERT dbo.Rap(TenRap,TrangThai) VALUES(@tag+'_B',N'Đang hoạt động');SET @RapB=SCOPE_IDENTITY();
 INSERT dbo.Rap(TenRap,TrangThai) VALUES(@tag+'_C',N'Đang hoạt động');SET @RapC=SCOPE_IDENTITY();
 INSERT dbo.NhanVienRap VALUES(@nv,@RapA),(@nv,@RapB),(@nv,@RapC),(@vnv,@RapA);
 -- Mô phỏng dữ liệu form đã mở trước đó nhưng phân công B vừa bị thu hồi.
 DELETE dbo.NhanVienRap WHERE MaNhanVien=@nv AND MaRap=@RapB;
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@RapA,'A','2D',N'Đang hoạt động');SET @PhongA=SCOPE_IDENTITY();
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@RapB,'B','2D',N'Đang hoạt động');SET @PhongB=SCOPE_IDENTITY();
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@RapC,'C','2D',N'Đang hoạt động');SET @PhongC=SCOPE_IDENTITY();
 INSERT dbo.LoaiGhe(TenLoai) VALUES(@tag);SET @Loai=SCOPE_IDENTITY();
 INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@PhongA,'A',1,@Loai,N'Hoạt động');SET @GheA=SCOPE_IDENTITY();
 INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@PhongB,'A',1,@Loai,N'Hoạt động');SET @GheB=SCOPE_IDENTITY();
END;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.TaiKhoan SET TenDangNhap='staff_code_test' WHERE MaTaiKhoan=@Viewer;
SET @key=CONVERT(NVARCHAR(200),@nv);
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF NOT EXISTS(SELECT 1 FROM @employees WHERE MaNhanVien=@nv) THROW 50995,N'FAIL: Nhân viên theo mã hồ sơ',1;
ROLLBACK;PRINT N'PASS: Nhân viên theo mã hồ sơ';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'0901234567';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF NOT EXISTS(SELECT 1 FROM @employees WHERE MaNhanVien=@nv) THROW 50995,N'FAIL: Nhân viên theo SĐT đầy đủ',1;
ROLLBACK;PRINT N'PASS: Nhân viên theo SĐT đầy đủ';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'123456';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF NOT EXISTS(SELECT 1 FROM @employees WHERE MaNhanVien=@nv) THROW 50995,N'FAIL: Nhân viên theo một phần SĐT',1;
ROLLBACK;PRINT N'PASS: Nhân viên theo một phần SĐT';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'Tìm Nhân Viên';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF NOT EXISTS(SELECT 1 FROM @employees WHERE MaNhanVien=@nv) THROW 50995,N'FAIL: Nhân viên theo tên Unicode',1;
ROLLBACK;PRINT N'PASS: Nhân viên theo tên Unicode';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.TaiKhoan SET TenDangNhap='staff_search_unique' WHERE MaTaiKhoan=@Viewer;
SET @key=N'staff_search_unique';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF (SELECT COUNT(*) FROM @employees)<>1 THROW 50995,N'FAIL: Nhân viên theo tên đăng nhập',1;
ROLLBACK;PRINT N'PASS: Nhân viên theo tên đăng nhập';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.TaiKhoan SET TenDangNhap='admin_no_employee_unique' WHERE MaTaiKhoan=@Admin;
SET @key=N'admin_no_employee_unique';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF (SELECT COUNT(*) FROM @employees)<>1 THROW 50995,N'FAIL: Mã tài khoản không có hồ sơ vẫn tìm được',1;
ROLLBACK;PRINT N'PASS: Mã tài khoản không có hồ sơ vẫn tìm được';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'%_[]';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF (SELECT COUNT(*) FROM @employees)<>0 THROW 50995,N'FAIL: Ký tự wildcard không mở rộng tìm nhân viên',1;
ROLLBACK;PRINT N'PASS: Ký tự wildcard không mở rộng tìm nhân viên';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'999999999999999999999';
INSERT @employees EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin,@key;
IF (SELECT COUNT(*) FROM @employees)<>0 THROW 50995,N'FAIL: Nhân viên số vượt INT trả rỗng',1;
ROLLBACK;PRINT N'PASS: Nhân viên số vượt INT trả rỗng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
EXEC dbo.sp_YMC_TimNhanVienAdmin @Viewer;
THROW 50995,N'FAIL: Nhân viên thiếu quyền bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Nhân viên thiếu quyền bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@Admin;EXEC dbo.sp_YMC_TimNhanVienAdmin @Admin;
THROW 50995,N'FAIL: Nhân viên khóa actor bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Nhân viên khóa actor bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=CONVERT(NVARCHAR(200),@PhongA);
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF (SELECT COUNT(*) FROM @rooms)<>1 OR NOT EXISTS(SELECT 1 FROM @rooms WHERE MaPhong=@PhongA AND SucChua=1) THROW 50995,N'FAIL: Chỉ xem tìm phòng theo mã',1;
ROLLBACK;PRINT N'PASS: Chỉ xem tìm phòng theo mã';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'Phòng thường';
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF (SELECT COUNT(*) FROM @rooms)<>1 THROW 50995,N'FAIL: Chỉ xem tìm tên Unicode',1;
ROLLBACK;PRINT N'PASS: Chỉ xem tìm tên Unicode';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=CONVERT(NVARCHAR(200),@PhongB);
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF EXISTS(SELECT 1 FROM @rooms) THROW 50995,N'FAIL: Phòng ngoài phạm vi không trả kết quả',1;
ROLLBACK;PRINT N'PASS: Phòng ngoài phạm vi không trả kết quả';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=N'  ';
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF EXISTS(SELECT 1 FROM @rooms WHERE MaRap<>@RapA) OR NOT EXISTS(SELECT 1 FROM @rooms WHERE MaPhong=@PhongA) THROW 50995,N'FAIL: Phòng từ khóa rỗng vẫn lọc phạm vi',1;
ROLLBACK;PRINT N'PASS: Phòng từ khóa rỗng vẫn lọc phạm vi';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

SET @key=CONVERT(NVARCHAR(200),@PhongB);
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Admin,@key,NULL;
IF (SELECT COUNT(*) FROM @rooms)<>1 THROW 50995,N'FAIL: Admin tìm được phòng ngoài phân công',1;
ROLLBACK;PRINT N'PASS: Admin tìm được phòng ngoài phân công';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.PhongChieu SET TrangThai=N'Ngừng hoạt động' WHERE MaPhong=@PhongA;
SET @key=N'Phòng thường';
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF (SELECT COUNT(*) FROM @rooms)<>1 THROW 50995,N'FAIL: Phòng ngừng hoạt động vẫn tra cứu được',1;
ROLLBACK;PRINT N'PASS: Phòng ngừng hoạt động vẫn tra cứu được';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
DELETE dbo.NhanVienRap WHERE MaNhanVien=@nv;
SET @key=N'Phòng thường';
INSERT @rooms EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,@key,NULL;
IF EXISTS(SELECT 1 FROM @rooms) THROW 50995,N'FAIL: Thu hồi rạp thì danh sách phòng rỗng',1;
ROLLBACK;PRINT N'PASS: Thu hồi rạp thì danh sách phòng rỗng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer,NULL,@RapB;
THROW 50995,N'FAIL: Chọn rạp ngoài phân công bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chọn rạp ngoài phân công bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
EXEC dbo.sp_YMC_LuuPhong @Viewer,@PhongA,@RapA,N'Không được sửa','2D',N'Đang hoạt động';
THROW 50995,N'FAIL: Chỉ xem không được ghi phòng',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chỉ xem không được ghi phòng';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
EXEC dbo.sp_YMC_TaoGheTheoLo @Viewer,@PhongA,1,2,@Loai;
THROW 50995,N'FAIL: Chỉ xem không được tạo ghế',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chỉ xem không được tạo ghế';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
DELETE q FROM dbo.VaiTroQuyen q JOIN dbo.VaiTro v ON v.MaVaiTro=q.MaVaiTro WHERE v.TenVaiTro='BAN_VE' AND q.MaQuyen='RAP_XEM';EXEC dbo.sp_YMC_TraCuuPhongAdmin @Viewer;
THROW 50995,N'FAIL: Thu hồi RAP_XEM bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Thu hồi RAP_XEM bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF (SELECT COUNT(*) FROM @shows)<>1 OR NOT EXISTS(SELECT 1 FROM @shows WHERE MaSuatChieu=@s) THROW 50995,N'FAIL: Quầy tìm phim Unicode đúng rạp/ngày',1;
ROLLBACK;PRINT N'PASS: Quầy tìm phim Unicode đúng rạp/ngày';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'100%_[Đặc biệt]';
IF (SELECT COUNT(*) FROM @shows)<>1 THROW 50995,N'FAIL: Quầy tìm literal ký tự phần trăm ngoặc',1;
ROLLBACK;PRINT N'PASS: Quầy tìm literal ký tự phần trăm ngoặc';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Không có tên phim này';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không có phim phù hợp',1;
ROLLBACK;PRINT N'PASS: Quầy không có phim phù hợp';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
SET @ngay=DATEADD(DAY,1,@ngay);
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy đổi ngày không giữ suất cũ',1;
ROLLBACK;PRINT N'PASS: Quầy đổi ngày không giữ suất cũ';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.SuatChieu SET TrangThai=N'Ngừng bán' WHERE MaSuatChieu=@s;
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả suất ngừng bán',1;
ROLLBACK;PRINT N'PASS: Quầy không trả suất ngừng bán';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.SuatChieu SET TrangThai=N'Đã hủy' WHERE MaSuatChieu=@s;
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả suất hủy',1;
ROLLBACK;PRINT N'PASS: Quầy không trả suất hủy';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.PhongChieu SET TrangThai=N'Ngừng hoạt động' WHERE MaPhong=@PhongA;
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả phòng ngừng hoạt động',1;
ROLLBACK;PRINT N'PASS: Quầy không trả phòng ngừng hoạt động';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.Phim SET TrangThai=N'Ngừng chiếu' WHERE MaPhim=@f;
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả phim ngừng chiếu',1;
ROLLBACK;PRINT N'PASS: Quầy không trả phim ngừng chiếu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.Rap SET TrangThai=N'Ngừng hoạt động' WHERE MaRap=@RapA;
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả rạp ngừng hoạt động',1;
ROLLBACK;PRINT N'PASS: Quầy không trả rạp ngừng hoạt động';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
UPDATE dbo.SuatChieu SET GioBatDau=DATEADD(MINUTE,-10,dbo.fn_YMC_GioVietNam()),GioKetThuc=DATEADD(MINUTE,80,dbo.fn_YMC_GioVietNam()) WHERE MaSuatChieu=@s;SET @ngay=CONVERT(DATE,dbo.fn_YMC_GioVietNam());
INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'Tìm Phim';
IF EXISTS(SELECT 1 FROM @shows) THROW 50995,N'FAIL: Quầy không trả suất đã bắt đầu',1;
ROLLBACK;PRINT N'PASS: Quầy không trả suất đã bắt đầu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));

INSERT @shows EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay,N'  ';
IF (SELECT COUNT(*) FROM @shows)<>1 THROW 50995,N'FAIL: Quầy bỏ từ khóa lấy mọi suất hợp lệ',1;
ROLLBACK;PRINT N'PASS: Quầy bỏ từ khóa lấy mọi suất hợp lệ';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapB,@ngay;
THROW 50995,N'FAIL: Quầy ngoài rạp bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Quầy ngoài rạp bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
 EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;
 DECLARE @nv INT=(SELECT MaNhanVien FROM dbo.NhanVien WHERE MaTaiKhoan=@Viewer),@key NVARCHAR(200),@f INT,@s INT,@other INT,@ngay DATE=DATEADD(DAY,1,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 UPDATE dbo.NhanVien SET HoTen=N'TEST Tìm Nhân Viên',DienThoai='0901234567' WHERE MaNhanVien=@nv;
 UPDATE dbo.PhongChieu SET TenPhong=N'TEST Phòng thường' WHERE MaPhong=@PhongA;
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Tìm Phim 100%_[Đặc biệt]',90,@ngay,'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongA,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @s=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@f,@PhongB,DATEADD(HOUR,16,CONVERT(DATETIME2(0),@ngay)),DATEADD(MINUTE,1050,CONVERT(DATETIME2(0),@ngay)));SET @other=SCOPE_IDENTITY();
 DECLARE @employees TABLE(MaTaiKhoan INT,TenDangNhap VARCHAR(50),Email NVARCHAR(254),DangHoatDong BIT,KhoaDenLuc DATETIME2(0),TaiKhoanPhienBan BINARY(8),MaNhanVien INT,HoTen NVARCHAR(150),DienThoai VARCHAR(20),DangLamViec BIT,NhanVienPhienBan BINARY(8),VaiTro NVARCHAR(MAX),RapLamViec NVARCHAR(MAX));
 DECLARE @rooms TABLE(MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),DinhDang VARCHAR(20),TrangThai NVARCHAR(30),SucChua INT,SoGheHoatDong INT,SoGheHong INT);
 DECLARE @shows TABLE(MaSuatChieu INT,TenHienThi NVARCHAR(MAX));
DELETE q FROM dbo.VaiTroQuyen q JOIN dbo.VaiTro v ON v.MaVaiTro=q.MaVaiTro WHERE v.TenVaiTro='BAN_VE' AND q.MaQuyen='BAN_VE';EXEC dbo.sp_YMC_TimSuatTaiQuay @Viewer,@RapA,@ngay;
THROW 50995,N'FAIL: Thu hồi quyền bán vé bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Thu hồi quyền bán vé bị chặn';
END CATCH;
GO
DROP PROCEDURE #YMC_ScopeFixture;
PRINT N'Hoàn tất 34 ca tìm kiếm; fixture và mọi thay đổi quyền đã rollback.';
GO
