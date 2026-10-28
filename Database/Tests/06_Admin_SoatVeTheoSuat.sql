-- Chỉ chạy database _Test. Mỗi ca có fixture riêng và rollback, không seed tài khoản thật.
USE YeuMinhEmCinema_Test;
GO
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50990,N'Chỉ chạy trên database _Test.',1;
GO
CREATE PROCEDURE #YMC_CheckinFixture
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
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,0,@suat,@phong;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai='HIEU_LUC' AND NgaySoatUtc IS NULL) THROW 50991,N'Tra cứu làm đổi vé.',1;
 ROLLBACK;
 PRINT N'PASS: Đúng suất/phòng cho phép tra cứu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai='DA_SU_DUNG' AND NguoiSoat=@staff AND NgaySoatUtc IS NOT NULL) THROW 50991,N'Không ghi nhận soát.',1;
 ROLLBACK;
 PRINT N'PASS: Đúng suất/phòng xác nhận và ghi người soát';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,0,@suatKhac,@phong;
 THROW 50991,N'FAIL: Sai suất cùng phòng bị chặn (xác nhận=0)',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50343 THROW;
 PRINT N'PASS: Sai suất cùng phòng bị chặn (xác nhận=0)';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,0,@suat,@phongKhac;
 THROW 50991,N'FAIL: Sai phòng cùng rạp bị chặn (xác nhận=0)',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50344 THROW;
 PRINT N'PASS: Sai phòng cùng rạp bị chặn (xác nhận=0)';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suatKhac,@phong;
 THROW 50991,N'FAIL: Sai suất cùng phòng bị chặn (xác nhận=1)',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50343 THROW;
 PRINT N'PASS: Sai suất cùng phòng bị chặn (xác nhận=1)';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phongKhac;
 THROW 50991,N'FAIL: Sai phòng cùng rạp bị chặn (xác nhận=1)',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50344 THROW;
 PRINT N'PASS: Sai phòng cùng rạp bị chặn (xác nhận=1)';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suatKhac,@phongKhac;
 THROW 50991,N'FAIL: Cả suất và phòng sai',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50343 THROW;
 PRINT N'PASS: Cả suất và phòng sai';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,0,@phong;
 THROW 50991,N'FAIL: Mã suất không tồn tại',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50343 THROW;
 PRINT N'PASS: Mã suất không tồn tại';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,0;
 THROW 50991,N'FAIL: Mã phòng không tồn tại',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50344 THROW;
 PRINT N'PASS: Mã phòng không tồn tại';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,0;
IF EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai<>'HIEU_LUC') THROW 50991,N'Caller cũ đổi vé.',1;
 ROLLBACK;
 PRINT N'PASS: Caller cũ tra cứu không thêm tham số';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai='DA_SU_DUNG') THROW 50991,N'Caller cũ không soát được.',1;
 ROLLBACK;
 PRINT N'PASS: Caller cũ vẫn xác nhận';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai='DA_SU_DUNG') THROW 50991,N'Không soát được.',1;
 ROLLBACK;
 PRINT N'PASS: Chỉ truyền suất vẫn dùng được';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,NULL,@phongKhac;
 THROW 50991,N'FAIL: Chỉ truyền phòng sai vẫn bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50344 THROW;
 PRINT N'PASS: Chỉ truyền phòng sai vẫn bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
SET @ve=NEWID();
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Vé không tồn tại',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50340 THROW;
 PRINT N'PASS: Vé không tồn tại';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Chặn soát trùng',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50341 THROW;
 PRINT N'PASS: Chặn soát trùng';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.Ve SET TrangThai='DA_HUY' WHERE MaVe=@ve;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Vé bị hủy',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50341 THROW;
 PRINT N'PASS: Vé bị hủy';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.DonHang SET TrangThai='CHO_THANH_TOAN' WHERE MaDonHang=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve);
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Đơn chưa thanh toán',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50340 THROW;
 PRINT N'PASS: Đơn chưa thanh toán';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.DonHang SET TrangThai='DA_HOAN_TIEN' WHERE MaDonHang=(SELECT MaDonHang FROM dbo.Ve WHERE MaVe=@ve);
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Đơn đã hoàn tiền',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50340 THROW;
 PRINT N'PASS: Đơn đã hoàn tiền';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.SuatChieu SET TrangThai=N'Đã hủy' WHERE MaSuatChieu=@suat;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Suất bị hủy',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50340 THROW;
 PRINT N'PASS: Suất bị hủy';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.SuatChieu SET GioBatDau=DATEADD(MINUTE,40,dbo.fn_YMC_GioVietNam()),GioKetThuc=DATEADD(MINUTE,130,dbo.fn_YMC_GioVietNam()) WHERE MaSuatChieu=@suat;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Trước cửa vào hơn 30 phút',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50342 THROW;
 PRINT N'PASS: Trước cửa vào hơn 30 phút';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.SuatChieu SET GioBatDau=DATEADD(MINUTE,-100,dbo.fn_YMC_GioVietNam()),GioKetThuc=DATEADD(MINUTE,-10,dbo.fn_YMC_GioVietNam()) WHERE MaSuatChieu=@suat;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Suất đã kết thúc',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50342 THROW;
 PRINT N'PASS: Suất đã kết thúc';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.SuatChieu SET GioBatDau=DATEADD(MINUTE,-20,dbo.fn_YMC_GioVietNam()),GioKetThuc=DATEADD(MINUTE,70,dbo.fn_YMC_GioVietNam()) WHERE MaSuatChieu=@suat;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND TrangThai='DA_SU_DUNG') THROW 50991,N'Đổi khung giờ hiện tại.',1;
 ROLLBACK;
 PRINT N'PASS: Giữ luật hiện tại: sau 20 phút vẫn được vào';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
DELETE nr FROM dbo.NhanVienRap nr JOIN dbo.NhanVien n ON n.MaNhanVien=nr.MaNhanVien WHERE n.MaTaiKhoan=@staff;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Thu hồi rạp khi form đang mở',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Thu hồi rạp khi form đang mở';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@staff;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Tài khoản ngừng hoạt động',1;
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
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.TaiKhoan SET KhoaDenLuc=DATEADD(HOUR,1,SYSUTCDATETIME()) WHERE MaTaiKhoan=@staff;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Tài khoản đang khóa',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Tài khoản đang khóa';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
UPDATE dbo.NhanVien SET DangLamViec=0 WHERE MaTaiKhoan=@staff;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Nhân viên ngừng việc',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Nhân viên ngừng việc';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@staff;
EXEC dbo.sp_YMC_KiemTraVe @staff,@ve,1,@suat,@phong;
 THROW 50991,N'FAIL: Thu hồi quyền soát',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Thu hồi quyền soát';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;

EXEC dbo.sp_YMC_KiemTraVe @a,@ve,1,@suat,@phong;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@ve AND NguoiSoat=@a) THROW 50991,N'Admin không soát được.',1;
 ROLLBACK;
 PRINT N'PASS: Admin toàn cục vẫn soát được';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@staff INT,@ve UNIQUEIDENTIFIER,@suat INT,@phong INT,@suatKhac INT,@phongKhac INT,@rap INT;
 EXEC #YMC_CheckinFixture @a OUTPUT,@staff OUTPUT,@ve OUTPUT,@suat OUTPUT,@phong OUTPUT,@suatKhac OUTPUT,@phongKhac OUTPUT,@rap OUTPUT;
 DECLARE @date DATE='20300102',@otherRap INT,@otherRoom INT,@otherShow INT,@night INT;
 INSERT dbo.Rap(TenRap) VALUES(N'CHECKIN_SCOPE_OTHER');SET @otherRap=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.PhongChieu(MaRap,TenPhong) VALUES(@otherRap,N'Khác rạp');SET @otherRoom=CONVERT(INT,SCOPE_IDENTITY());
 DECLARE @film INT=(SELECT MaPhim FROM dbo.SuatChieu WHERE MaSuatChieu=@suat);
 UPDATE dbo.SuatChieu SET GioBatDau='20300102 18:00',GioKetThuc='20300102 19:30' WHERE MaSuatChieu=@suat;
 UPDATE dbo.SuatChieu SET GioBatDau='20300102 21:00',GioKetThuc='20300102 22:30',TrangThai=N'Đã hủy' WHERE MaSuatChieu=@suatKhac;
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@film,@otherRoom,'20300102 18:00','20300102 19:30');SET @otherShow=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@film,@phong,'20300101 23:30','20300102 01:00');SET @night=CONVERT(INT,SCOPE_IDENTITY());
 DECLARE @t TABLE(MaSuatChieu INT,MaPhong INT,MaRap INT,TenRap NVARCHAR(200),TenPhong NVARCHAR(100),TenPhim NVARCHAR(200),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0));
 INSERT @t EXEC dbo.sp_YMC_LaySuatSoatVe @staff,@date;
 IF NOT EXISTS(SELECT 1 FROM @t WHERE MaSuatChieu=@suat) OR NOT EXISTS(SELECT 1 FROM @t WHERE MaSuatChieu=@night)
 OR EXISTS(SELECT 1 FROM @t WHERE MaSuatChieu IN(@suatKhac,@otherShow) OR MaRap<>@rap) THROW 50992,N'FAIL: danh sách suất theo quyền soát, rạp, hủy và qua đêm.',1;
 PRINT N'PASS: tài khoản chỉ soát vé tải được suất đúng rạp, bỏ suất hủy, gồm suất qua đêm';
 DELETE @t;
 INSERT @t EXEC dbo.sp_YMC_LaySuatSoatVe @a,@date;
 IF NOT EXISTS(SELECT 1 FROM @t WHERE MaSuatChieu=@otherShow) THROW 50992,N'FAIL: danh sách Admin toàn cục.',1;
 PRINT N'PASS: Admin tải suất toàn cục';
 DELETE nr FROM dbo.NhanVienRap nr JOIN dbo.NhanVien n ON n.MaNhanVien=nr.MaNhanVien WHERE n.MaTaiKhoan=@staff;
 DELETE @t;
 INSERT @t EXEC dbo.sp_YMC_LaySuatSoatVe @staff,@date;
 IF EXISTS(SELECT 1 FROM @t) THROW 50992,N'FAIL: danh sách không cập nhật thu hồi rạp.',1;
 PRINT N'PASS: tải lại không còn suất sau thu hồi rạp';
 ROLLBACK;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
DROP PROCEDURE #YMC_CheckinFixture;
PRINT N'Hoàn tất 31 ca; toàn bộ fixture đã rollback.';
GO
