-- Chỉ chạy database _Test. Mỗi ca có fixture riêng và rollback, không seed tài khoản thật.
USE YeuMinhEmCinema_Test;
GO
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50990,N'Chỉ chạy trên database _Test.',1;
GO
CREATE PROCEDURE #YMC_OrderFixture
 @a INT OUTPUT,@staff INT OUTPUT,@ve UNIQUEIDENTIFIER OUTPUT,@suat INT OUTPUT,@phong INT OUTPUT,
 @suatKhac INT OUTPUT,@phongKhac INT OUTPUT,@rap INT OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @tag VARCHAR(16)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@nv INT,@loai INT,@phim INT,@ghe INT,
 @start DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20),@don BIGINT,@req UNIQUEIDENTIFIER=NEWID();
 SET @ngay=CONVERT(DATE,@start);
 SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('ci_a_'+@tag,REPLICATE('X',80));SET @a=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.TaiKhoanVaiTro SELECT @a,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('ci_s_'+@tag,REPLICATE('X',80));SET @staff=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@staff,N'TEST soát vé');SET @nv=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='SOAT_VE';
 INSERT dbo.Rap(TenRap) VALUES(N'CHECKIN_'+@tag);SET @rap=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.NhanVienRap VALUES(@nv,@rap);
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang) VALUES(@rap,N'Phòng 1','CI_'+@tag);SET @phong=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang) VALUES(@rap,N'Phòng 2','CI_'+@tag);SET @phongKhac=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.LoaiGhe(TenLoai) VALUES(N'CI_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe) VALUES(@phong,'A',1,@loai);SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'CI_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@phim,@phong,@start,DATEADD(MINUTE,90,@start));SET @suat=CONVERT(INT,SCOPE_IDENTITY());
 -- Suất khác cùng phòng để chứng minh chỉ kiểm phòng là chưa đủ.
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@phim,@phong,DATEADD(HOUR,3,@start),DATEADD(MINUTE,270,@start));SET @suatKhac=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia) VALUES(@loai,'CI_'+@tag,@ln,@ngay,80000);
 -- TVP được biên dịch ở database caller, không ở tempdb chứa #procedure.
 EXEC sys.sp_executesql N'DECLARE @g dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb;
 INSERT @g VALUES(@ghe);
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@suat,''QUAY'',@g,@f,N''Khách kiểm thử'';',
 N'@ghe INT,@a INT,@req UNIQUEIDENTIFIER,@suat INT',@ghe,@a,@req,@suat;
 SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@req;
 DECLARE @pay VARCHAR(100)='CI_'+@tag;
 EXEC dbo.sp_YMC_XacNhanThanhToan @a,@don,@pay,'TIEN_MAT',80000;
 SELECT @ve=MaVe FROM dbo.Ve WHERE MaDonHang=@don;
END;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(100),@don);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Tìm mã đơn',1;
ROLLBACK;
PRINT N'PASS: Tìm mã đơn';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(100),@ve);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Tìm GUID vé',1;
ROLLBACK;
PRINT N'PASS: Tìm GUID vé';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SELECT @key=CONVERT(NVARCHAR(100),MaThamChieu) FROM dbo.DonHang WHERE MaDonHang=@don;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Tìm GUID tham chiếu đơn',1;
ROLLBACK;
PRINT N'PASS: Tìm GUID tham chiếu đơn';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SELECT @key=MaGiaoDich FROM dbo.ThanhToan WHERE MaDonHang=@don;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Tìm mã giao dịch thu',1;
ROLLBACK;
PRINT N'PASS: Tìm mã giao dịch thu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=N'  '+CONVERT(NVARCHAR(30),@don)+N'  ';
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Cắt khoảng trắng quanh mã',1;
ROLLBACK;
PRINT N'PASS: Cắt khoảng trắng quanh mã';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,N'   ',@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Từ khóa rỗng giữ danh sách',1;
ROLLBACK;
PRINT N'PASS: Từ khóa rỗng giữ danh sách';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,N'NOT_FOUND_!%_[]',@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Không có mã phù hợp',1;
ROLLBACK;
PRINT N'PASS: Không có mã phù hợp';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SELECT @key=LEFT(MaGiaoDich,4)+N'%' FROM dbo.ThanhToan WHERE MaDonHang=@don;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Không hiểu wildcard như tìm gần đúng',1;
ROLLBACK;
PRINT N'PASS: Không hiểu wildcard như tìm gần đúng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(36),@ve)+N'_duoi';
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: GUID có đuôi không được cắt thành vé',1;
ROLLBACK;
PRINT N'PASS: GUID có đuôi không được cắt thành vé';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,N'9999999999999999999999999999999',@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Mã số vượt BIGINT không gây lỗi',1;
ROLLBACK;
PRINT N'PASS: Mã số vượt BIGINT không gây lỗi';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(100),@don);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,'DA_HUY',1,50,@key,@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Mã kết hợp trạng thái',1;
ROLLBACK;
PRINT N'PASS: Mã kết hợp trạng thái';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(100),@don);SET @ngay=DATEADD(DAY,-2,@ngay);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Mã kết hợp ngày tạo',1;
ROLLBACK;
PRINT N'PASS: Mã kết hợp ngày tạo';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DECLARE @newrap INT;INSERT dbo.Rap(TenRap) VALUES(N'TEST_LOOKUP_OTHER');SET @newrap=CONVERT(INT,SCOPE_IDENTITY());UPDATE dbo.PhongChieu SET MaRap=@newrap WHERE MaPhong=@phong;SET @key=CONVERT(NVARCHAR(100),@ve);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>0 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(0/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 0-(1-1)*50<50 THEN 0-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Mã ngoài phạm vi rạp không lộ dữ liệu',1;
ROLLBACK;
PRINT N'PASS: Mã ngoài phạm vi rạp không lộ dữ liệu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DELETE FROM dbo.NhanVienRap WHERE MaRap=@rap;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,NULL,@count OUTPUT;
THROW 50994,N'FAIL: Thu hồi phân công rạp',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Thu hồi phân công rạp';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,NULL,@count OUTPUT;
THROW 50994,N'FAIL: Thu hồi quyền xem đơn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Thu hồi quyền xem đơn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@staff;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,NULL,@count OUTPUT;
THROW 50994,N'FAIL: Tài khoản ngừng hoạt động',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Tài khoản ngừng hoạt động';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,0,50,NULL,@count OUTPUT;
THROW 50994,N'FAIL: Trang 0 bị từ chối',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50610 THROW;
 PRINT N'PASS: Trang 0 bị từ chối';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,101,NULL,@count OUTPUT;
THROW 50994,N'FAIL: Kích thước trang sai',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50610 THROW;
 PRINT N'PASS: Kích thước trang sai';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
SET @key=CONVERT(NVARCHAR(100),@don);
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @a,@rap,@ngay,@ngay,NULL,1,50,@key,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(1-1)*50<50 THEN 1-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Admin vẫn tìm được đơn',1;
ROLLBACK;
PRINT N'PASS: Admin vẫn tìm được đơn';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,2,50,NULL,@count OUTPUT;
IF @count<>1 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 2<=CEILING(1/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 1-(2-1)*50<50 THEN 1-(2-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Trang rỗng vẫn trả tổng qua output',1;
ROLLBACK;
PRINT N'PASS: Trang rỗng vẫn trả tổng qua output';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DECLARE @i INT=0;
WHILE @i<50
BEGIN
 INSERT dbo.DonHang(MaYeuCau,MaSuatChieu,NguoiTao,Kenh,TrangThai,HanThanhToanUtc,TongTien,HoTenLienHe)
 VALUES(NEWID(),@suat,@a,'QUAY','DA_HUY',SYSUTCDATETIME(),80000,N'TEST_PAGE');
 SET @i+=1;
END;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50,NULL,@count OUTPUT;
IF @count<>51 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 1<=CEILING(51/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 51-(1-1)*50<50 THEN 51-(1-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Trang đầu 50 trên 51 đơn, thứ tự ổn định',1;IF EXISTS(SELECT 1 FROM #Result WHERE MaDonHang=@don) THROW 50994,N'FAIL: trang đầu chứa đơn cũ nhất.',1;
ROLLBACK;
PRINT N'PASS: Trang đầu 50 trên 51 đơn, thứ tự ổn định';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DECLARE @i INT=0;
WHILE @i<50
BEGIN
 INSERT dbo.DonHang(MaYeuCau,MaSuatChieu,NguoiTao,Kenh,TrangThai,HanThanhToanUtc,TongTien,HoTenLienHe)
 VALUES(NEWID(),@suat,@a,'QUAY','DA_HUY',SYSUTCDATETIME(),80000,N'TEST_PAGE');
 SET @i+=1;
END;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,2,50,NULL,@count OUTPUT;
IF @count<>51 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 2<=CEILING(51/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 51-(2-1)*50<50 THEN 51-(2-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Trang cuối một đơn',1;IF NOT EXISTS(SELECT 1 FROM #Result WHERE MaDonHang=@don) THROW 50994,N'FAIL: trang cuối không có đơn cũ nhất.',1;
ROLLBACK;
PRINT N'PASS: Trang cuối một đơn';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
DECLARE @i INT=0;
WHILE @i<50
BEGIN
 INSERT dbo.DonHang(MaYeuCau,MaSuatChieu,NguoiTao,Kenh,TrangThai,HanThanhToanUtc,TongTien,HoTenLienHe)
 VALUES(NEWID(),@suat,@a,'QUAY','DA_HUY',SYSUTCDATETIME(),80000,N'TEST_PAGE');
 SET @i+=1;
END;

INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,3,50,NULL,@count OUTPUT;
IF @count<>51 OR (SELECT COUNT(*) FROM #Result)<>CASE WHEN 3<=CEILING(51/CONVERT(DECIMAL(10,2),50)) THEN CASE WHEN 51-(3-1)*50<50 THEN 51-(3-1)*50 ELSE 50 END ELSE 0 END THROW 50994,N'FAIL: Trang vượt cuối vẫn có tổng 51',1;
ROLLBACK;
PRINT N'PASS: Trang vượt cuối vẫn có tổng 51';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_OrderFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 -- Vai trò QUAN_LY có DON_HANG_XEM; SOAT_VE mặc định không có quyền này.
 DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
 INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 DECLARE @don BIGINT=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve),@ngay DATE=CONVERT(DATE,dbo.fn_YMC_GioVietNam()),@key NVARCHAR(100),@count INT;
 SELECT TOP(0) d.MaDonHang+CONVERT(BIGINT,0) MaDonHang,d.MaThamChieu,d.MaYeuCau,d.MaSuatChieu,d.MaKhachHang,d.NguoiTao,d.Kenh,d.TrangThai,
 d.NgayTaoUtc,d.HanThanhToanUtc,d.TongTien,d.HoTenLienHe,d.DienThoaiLienHe,d.LyDoHuy,CONVERT(BINARY(8),d.PhienBan) PhienBan,
 CONVERT(INT,0) TongKetQua INTO #Result FROM dbo.DonHang d;
INSERT #Result EXEC dbo.sp_YMC_DanhSachDonAdmin @staff,@rap,@ngay,@ngay,NULL,1,50;
IF (SELECT COUNT(*) FROM #Result)<>1 OR NOT EXISTS(SELECT 1 FROM #Result WHERE MaDonHang=@don AND TongKetQua=1) THROW 50994,N'FAIL: caller cũ.',1;
ROLLBACK;
PRINT N'PASS: caller cũ không truyền từ khóa/output vẫn dùng được';
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
GO
DROP PROCEDURE #YMC_OrderFixture;
PRINT N'Hoàn tất 24 ca tra cứu; fixture đã rollback.';
GO
