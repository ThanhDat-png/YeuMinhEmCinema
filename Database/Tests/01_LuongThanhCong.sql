-- CHỈ CHẠY TRÊN BẢN SAO DATABASE. Hash X chỉ là fixture, không phải tài khoản dùng thực tế.
USE YeuMinhEmCinema_Test;
GO
IF DB_NAME() NOT LIKE N'%[_]Test' THROW 50980,N'Chỉ chạy kiểm thử trên database có hậu tố _Test.',1;
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

-- Lặp yêu cầu tạo đơn không sinh đơn mới.
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g,@f,N'Khách kiểm thử';
IF (SELECT COUNT(*) FROM dbo.DonHang WHERE MaYeuCau=@request)<>1 THROW 50901,N'FAIL: tạo đơn lặp.',1;
DECLARE @txn VARCHAR(100)='PAY_'+@tag,@refund VARCHAR(100)='REF_'+@tag;
EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don,@txn,'TIEN_MAT',80000;
EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don,@txn,'TIEN_MAT',80000;
IF (SELECT COUNT(*) FROM dbo.Ve WHERE MaDonHang=@don)<>1 THROW 50902,N'FAIL: số vé sau callback lặp.',1;
SELECT @maVe=MaVe FROM dbo.Ve WHERE MaDonHang=@don;
EXEC dbo.sp_YMC_KiemTraVe @admin,@maVe,1;
IF NOT EXISTS(SELECT 1 FROM dbo.Ve WHERE MaVe=@maVe AND TrangThai='DA_SU_DUNG') THROW 50903,N'FAIL: kiểm vé.',1;
SET @request=NEWID();
EXEC dbo.sp_YMC_TaoDonGiuGhe @admin,@request,@suat,'QUAY',@g2,@f,N'Khách hoàn tiền';
SELECT @don2=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@request;
SET @txn='PAY2_'+@tag;
EXEC dbo.sp_YMC_XacNhanThanhToan @admin,@don2,@txn,'TIEN_MAT',80000;
EXEC dbo.sp_YMC_GhiNhanHoanTien @admin,@don2,@refund,N'Kiểm thử hoàn';
EXEC dbo.sp_YMC_GhiNhanHoanTien @admin,@don2,@refund,N'Kiểm thử hoàn';
IF EXISTS(SELECT 1 FROM dbo.GiuGhe WHERE MaDonHang=@don2) THROW 50904,N'FAIL: chưa giải phóng ghế hoàn.',1;
IF (SELECT COUNT(*) FROM dbo.HoanTien WHERE MaDonHang=@don2)<>1 THROW 50905,N'FAIL: hoàn tiền lặp.',1;
EXEC dbo.sp_YMC_BaoCaoDoanhThu @admin,@rap,@ngay,@ngay;
ROLLBACK;
PRINT N'PASS: tạo đơn lặp, thanh toán lặp, phát hành vé, kiểm vé, hoàn tiền lặp, giải phóng ghế. Dữ liệu thử đã rollback.';

END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
