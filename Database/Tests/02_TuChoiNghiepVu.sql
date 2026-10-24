USE YeuMinhEmCinema;
GO
-- Giữ trùng ghế; lỗi mong đợi 50310. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
DECLARE @r2 UNIQUEIDENTIFIER=NEWID();EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@r2,@suat,'QUAY',@g,@f,N'Trùng ghế';
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50310 THROW;
PRINT N'PASS: Giữ trùng ghế';
END CATCH;
GO
-- Thanh toán sai số tiền; lỗi mong đợi 50322. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don,'BAD_AMOUNT','TIEN_MAT',1;
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50322 THROW;
PRINT N'PASS: Thanh toán sai số tiền';
END CATCH;
GO
-- Sửa lịch khi có đơn giữ; lỗi mong đợi 50013. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
EXEC dbo.sp_YMC_KiemTraLienQuan @suat;
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50013 THROW;
PRINT N'PASS: Sửa lịch khi có đơn giữ';
END CATCH;
GO
-- Kiểm vé lần hai; lỗi mong đợi 50341. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
DECLARE @txn VARCHAR(100)='PAY_'+@tag;EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don,@txn,'TIEN_MAT',80000;SELECT @maVe=MaVe FROM dbo.Ve WHERE MaDonHang=@don;EXEC dbo.sp_YMC_KiemTraVe @admin,@maVe,1;EXEC dbo.sp_YMC_KiemTraVe @admin,@maVe,1;
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50341 THROW;
PRINT N'PASS: Kiểm vé lần hai';
END CATCH;
GO
-- Thanh toán hết hạn; lỗi mong đợi 50324. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
UPDATE dbo.DonHang SET HanThanhToanUtc=DATEADD(SECOND,-1,SYSUTCDATETIME()) WHERE MaDonHang=@don;EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don,'EXPIRED','TIEN_MAT',80000;
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50324 THROW;
PRINT N'PASS: Thanh toán hết hạn';
END CATCH;
GO
-- Truy cập đơn người khác; lỗi mong đợi 50403. Mỗi ca có fixture và rollback riêng.
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @tag VARCHAR(20)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@admin INT,@rap INT,@phong INT,@loai INT,@phim INT,@ghe INT,@ghe2 INT,@suat INT,
 @don BIGINT,@don2 BIGINT,@maVe UNIQUEIDENTIFIER,@batdau DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@batdau);
SET @ln=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('test_'+@tag,REPLICATE('X',80));SET @admin=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @admin,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.Rap(TenRap,TrangThai) VALUES(N'TEST_'+@tag,N'Đang hoạt động');SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@rap,N'TEST','TEST_'+@tag,N'Đang hoạt động');SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',1,@loai,N'Hoạt động');SET @ghe=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@phong,'A',2,@loai,N'Hoạt động');SET @ghe2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai) VALUES(@phim,@phong,@batdau,DATEADD(MINUTE,90,@batdau),15,N'Mở bán');SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia,DangApDung) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000,1);
DECLARE @g dbo.YMC_DanhSachGhe,@g2 dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@request UNIQUEIDENTIFIER=NEWID();
INSERT @g VALUES(@ghe);INSERT @g2 VALUES(@ghe2);
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
DECLARE @other INT;INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('other_'+@tag,REPLICATE('X',80));SET @other=CONVERT(INT,SCOPE_IDENTITY());EXEC dbo.sp_YMC_XemChiTietDon @other,@don;
ROLLBACK;THROW 50999,N'FAIL: đáng lẽ phải bị từ chối.',1;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
IF ERROR_NUMBER()<>50403 THROW;
PRINT N'PASS: Truy cập đơn người khác';
END CATCH;
GO
