-- Chỉ Test. Mỗi ca tự tạo dữ liệu và rollback, gồm cả điều chỉnh timestamp để kiểm ngày VN.
USE YeuMinhEmCinema_Test;
GO
SET NOCOUNT ON; SET XACT_ABORT ON;
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50990,N'Chỉ chạy trên database _Test.',1;
GO
CREATE PROCEDURE #YMC_ReportFixture
 @a INT OUTPUT,@manager INT OUTPUT,@viewer INT OUTPUT,@rap INT OUTPUT,@rapOther INT OUTPUT,
 @movieA INT OUTPUT,@movieB INT OUTPUT,@showA INT OUTPUT,@showB INT OUTPUT,@cancel INT OUTPUT,
 @d0 DATE OUTPUT,@showDate DATE OUTPUT,@orderA BIGINT OUTPUT,@orderB BIGINT OUTPUT,@orderC BIGINT OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @tag VARCHAR(12)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),12),@room INT,@roomOther INT,@type INT,@price INT,@pop INT,@water INT,@movieOther INT,@showOther INT,@nv INT,@id INT;
 SET @d0=DATEADD(DAY,-3,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));SET @showDate=DATEADD(DAY,10,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('rp_a_'+@tag,REPLICATE('X',80));SET @a=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @a,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('rp_m_'+@tag,REPLICATE('X',80));SET @manager=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @manager,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY';
 INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@manager,N'TEST Report manager');SET @nv=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('rp_v_'+@tag,REPLICATE('X',80));SET @viewer=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @viewer,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='BAN_VE';
 INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@viewer,N'TEST Report no rights');SET @id=SCOPE_IDENTITY();
 INSERT dbo.Rap(TenRap) VALUES(N'TEST_REPORT_'+@tag);SET @rap=SCOPE_IDENTITY();
 INSERT dbo.Rap(TenRap) VALUES(N'TEST_REPORT_OTHER_'+@tag);SET @rapOther=SCOPE_IDENTITY();
 INSERT dbo.NhanVienRap VALUES(@nv,@rap),(@id,@rap);
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang) VALUES(@rap,N'TEST phòng báo cáo','RP_'+@tag);SET @room=SCOPE_IDENTITY();
 INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang) VALUES(@rapOther,N'TEST phòng ngoài','RP_'+@tag);SET @roomOther=SCOPE_IDENTITY();
 INSERT dbo.LoaiGhe(TenLoai) VALUES(N'RP_'+@tag);SET @type=SCOPE_IDENTITY();
 INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe) VALUES(@room,'A',1,@type),(@room,'A',2,@type),(@room,'A',3,@type),(@roomOther,'A',1,@type);
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Report Phim A '+@tag,90,@showDate,'P',N'Đang chiếu');SET @movieA=SCOPE_IDENTITY();
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Report Phim B '+@tag,90,@showDate,'P',N'Đang chiếu');SET @movieB=SCOPE_IDENTITY();
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST Report Phim Ngoài '+@tag,90,@showDate,'P',N'Đang chiếu');SET @movieOther=SCOPE_IDENTITY();
 DECLARE @start DATETIME2(0)=DATEADD(HOUR,16,CONVERT(DATETIME2(0),@showDate));
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@movieA,@room,@start,DATEADD(MINUTE,90,@start));SET @showA=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@movieB,@room,DATEADD(HOUR,2,@start),DATEADD(MINUTE,210,@start));SET @showB=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,TrangThai) VALUES(@movieA,@room,DATEADD(HOUR,4,@start),DATEADD(MINUTE,330,@start),N'Đã hủy');SET @cancel=SCOPE_IDENTITY();
 INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@movieOther,@roomOther,@start,DATEADD(MINUTE,90,@start));SET @showOther=SCOPE_IDENTITY();
 DECLARE @ln NVARCHAR(20)=CASE WHEN(DATEDIFF(DAY,CONVERT(DATE,'19000101'),@showDate)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
 INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia) VALUES(@type,'RP_'+@tag,@ln,@showDate,80000);SET @price=SCOPE_IDENTITY();
 INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia) VALUES('RP_P_'+@tag,N'TEST Bắp báo cáo',N'Bắp',N'M',30000);SET @pop=SCOPE_IDENTITY();
 INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia) VALUES('RP_W_'+@tag,N'TEST Nước báo cáo',N'Nước',N'M',20000);SET @water=SCOPE_IDENTITY();
 -- Compile TVP in caller DB, not tempdb of #procedure. Orders use real reserve/pay/refund procedures.
 EXEC sys.sp_executesql N'
 DECLARE @g dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@req UNIQUEIDENTIFIER=NEWID(),@pay VARCHAR(100);
 INSERT @g SELECT MaGhe FROM dbo.Ghe WHERE MaPhong=@room AND SoGhe IN(1,2);INSERT @f VALUES(@pop,1),(@water,2);
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@sa,''QUAY'',@g,@f,N''TEST report A'';
 SELECT @oa=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@req;SET @pay=''RP_A_''+@tag;
 EXEC dbo.sp_YMC_XacNhanThanhToan @a,@oa,@pay,''TIEN_MAT'',230000;
 DELETE @g;DELETE @f;INSERT @g SELECT MaGhe FROM dbo.Ghe WHERE MaPhong=@room AND SoGhe=3;INSERT @f VALUES(@pop,1);SET @req=NEWID();
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@sa,''QUAY'',@g,@f,N''TEST report B'';
 SELECT @ob=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@req;SET @pay=''RP_B_''+@tag;
 EXEC dbo.sp_YMC_XacNhanThanhToan @a,@ob,@pay,''TIEN_MAT'',110000;
 DELETE @g;DELETE @f;INSERT @g SELECT MaGhe FROM dbo.Ghe WHERE MaPhong=@room AND SoGhe=1;INSERT @f VALUES(@water,2);SET @req=NEWID();
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@sb,''QUAY'',@g,@f,N''TEST report C'';
 SELECT @oc=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@req;SET @pay=''RP_C_''+@tag;
 EXEC dbo.sp_YMC_XacNhanThanhToan @a,@oc,@pay,''TIEN_MAT'',120000;
 DELETE @g;DELETE @f;INSERT @g SELECT MaGhe FROM dbo.Ghe WHERE MaPhong=@roomOther;SET @req=NEWID();
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@so,''QUAY'',@g,@f,N''TEST report outside'';
 DECLARE @od BIGINT=(SELECT MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@req);SET @pay=''RP_D_''+@tag;
 EXEC dbo.sp_YMC_XacNhanThanhToan @a,@od,@pay,''TIEN_MAT'',80000;
 SET @pay=''RP_REF_''+@tag;EXEC dbo.sp_YMC_GhiNhanHoanTien @a,@oa,@pay,N''TEST report refund'';
 -- An unpaid order must not enter any income/ticket counts.
 DELETE @g;INSERT @g SELECT MaGhe FROM dbo.Ghe WHERE MaPhong=@room AND SoGhe=1;SET @req=NEWID();
 EXEC dbo.sp_YMC_TaoDonGiuGhe @a,@req,@sa,''QUAY'',@g,@f,N''TEST report pending'';
 ',N'@a INT,@room INT,@roomOther INT,@pop INT,@water INT,@sa INT,@sb INT,@so INT,@tag VARCHAR(12),@oa BIGINT OUTPUT,@ob BIGINT OUTPUT,@oc BIGINT OUTPUT',
 @a,@room,@roomOther,@pop,@water,@showA,@showB,@showOther,@tag,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @base DATETIME2(0)=CONVERT(DATETIME2(0),@d0);
 UPDATE dbo.ThanhToan SET NgayThuUtc=CASE WHEN MaDonHang=@orderB THEN DATEADD(MINUTE,1035,@base) ELSE DATEADD(HOUR,15,@base) END
 WHERE MaDonHang IN(@orderA,@orderB,@orderC);
 UPDATE t SET NgayThuUtc=DATEADD(HOUR,15,@base) FROM dbo.ThanhToan t JOIN dbo.DonHang d ON d.MaDonHang=t.MaDonHang
 JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther;
 UPDATE dbo.HoanTien SET NgayHoanUtc=DATEADD(MINUTE,2465,@base) WHERE MaDonHang=@orderA;
 -- Current prices are intentionally different from snapshots after sale.
 UPDATE dbo.GiaVe SET DonGia=999000 WHERE MaGiaVe=@price;
 UPDATE dbo.FnbSanPham SET DonGia=777000 WHERE MaSanPham IN(@pop,@water);
END;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d0,@d0; IF (SELECT COUNT(*) FROM @daily)<>1 OR NOT EXISTS(SELECT 1 FROM @daily WHERE ThuVe=240000 AND ThuFnb=110000 AND TienDaThu=350000 AND TienDaHoan=0 AND DoanhThuThuan=350000) THROW 50996,N'FAIL: daily snapshots.',1;
ROLLBACK;PRINT N'PASS: Ngày thu tách vé F&B, không nhân dòng, không tính lại giá';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d1,@d1; IF NOT EXISTS(SELECT 1 FROM @daily WHERE ThuVe=80000 AND ThuFnb=30000 AND TienDaThu=110000) THROW 50996,N'FAIL: VN day.',1;
ROLLBACK;PRINT N'PASS: Ranh giới ngày Việt Nam UTC+7';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d2,@d2; IF NOT EXISTS(SELECT 1 FROM @daily WHERE ThuVe=0 AND ThuFnb=0 AND TienDaThu=0 AND TienDaHoan=230000 AND DoanhThuThuan=-230000) THROW 50996,N'FAIL: refund date.',1;
ROLLBACK;PRINT N'PASS: Ngày chỉ hoàn có thuần âm và không lặp thu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d0,@d2; INSERT @old EXEC dbo.sp_YMC_BaoCaoDoanhThu @a,@rap,@d0,@d2; IF EXISTS(SELECT Ngay,TienDaThu,TienDaHoan,DoanhThuThuan FROM @daily EXCEPT SELECT * FROM @old) OR EXISTS(SELECT * FROM @old EXCEPT SELECT Ngay,TienDaThu,TienDaHoan,DoanhThuThuan FROM @daily) OR (SELECT SUM(DoanhThuThuan) FROM @daily)<>230000 THROW 50996,N'FAIL: legacy reconcile.',1;
ROLLBACK;PRINT N'PASS: Tổng toàn kỳ và báo cáo cũ khớp';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d0,@d2,@movieA; IF (SELECT SUM(ThuVe) FROM @daily)<>240000 OR (SELECT SUM(ThuFnb) FROM @daily)<>100000 OR (SELECT SUM(TienDaThu) FROM @daily)<>340000 OR (SELECT SUM(TienDaHoan) FROM @daily)<>230000 THROW 50996,N'FAIL: film filter.',1;
ROLLBACK;PRINT N'PASS: Lọc phim theo ngày giao dịch';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@showDate,@showDate;IF EXISTS(SELECT 1 FROM @daily) THROW 50996,N'FAIL: cash basis date.',1;
ROLLBACK;PRINT N'PASS: Ngày chiếu không thay cho ngày thu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @shows EXEC dbo.sp_YMC_BaoCaoTheoSuat @a,@rap,@showDate,@showDate;IF (SELECT COUNT(*) FROM @shows)<>3 OR NOT EXISTS(SELECT 1 FROM @shows WHERE MaSuatChieu=@showA AND VePhatHanh=3 AND VeDaHoan=2 AND VeChuaHoan=1 AND ThuVe=240000 AND ThuFnb=100000 AND TienDaThu=340000 AND TienDaHoan=230000 AND DoanhThuThuan=110000) OR NOT EXISTS(SELECT 1 FROM @shows WHERE MaSuatChieu=@showB AND TienDaThu=120000 AND DoanhThuThuan=120000) OR NOT EXISTS(SELECT 1 FROM @shows WHERE MaSuatChieu=@cancel AND TienDaThu=0 AND VePhatHanh=0) THROW 50996,N'FAIL: show aggregation.',1;
ROLLBACK;PRINT N'PASS: Từng suất cộng đơn một lần, có suất hủy và đơn chưa trả không tính';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @shows EXEC dbo.sp_YMC_BaoCaoTheoSuat @a,@rap,@showDate,@showDate,@movieA;IF (SELECT COUNT(*) FROM @shows)<>2 OR EXISTS(SELECT 1 FROM @shows WHERE MaPhim<>@movieA) THROW 50996,N'FAIL: show film filter.',1;
ROLLBACK;PRINT N'PASS: Suất lọc phim vẫn giữ cả suất hủy không tiền';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @shows EXEC dbo.sp_YMC_BaoCaoTheoSuat @a,@rap,@d0,@d2;IF EXISTS(SELECT 1 FROM @shows) THROW 50996,N'FAIL: show date basis.',1;
ROLLBACK;PRINT N'PASS: Ngày thu không thay cho ngày chiếu';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @list EXEC dbo.sp_YMC_LayPhimBaoCao @manager,@rap;IF (SELECT COUNT(*) FROM @list)<>2 OR EXISTS(SELECT 1 FROM @list WHERE MaPhim=@outsideFilm) THROW 50996,N'FAIL: movie list scope.',1;
ROLLBACK;PRINT N'PASS: Tên phim ngoài rạp không lọt danh sách lọc';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @shows EXEC dbo.sp_YMC_BaoCaoTheoSuat @a,@rap,@showDate,@showDate,@outsideFilm;INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d0,@d2,@outsideFilm;IF EXISTS(SELECT 1 FROM @shows) OR EXISTS(SELECT 1 FROM @daily) THROW 50996,N'FAIL: outside film.',1;
ROLLBACK;PRINT N'PASS: Lọc phim không thuộc rạp trả rỗng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @films EXEC dbo.sp_YMC_ThongKePhim @a,@rap,@showDate,@showDate,@movieA;IF (SELECT COUNT(*) FROM @films)<>1 OR NOT EXISTS(SELECT 1 FROM @films WHERE SoSuat=1 AND VeDaBan=1 AND TienVe=80000) THROW 50996,N'FAIL: legacy film meaning.',1;
ROLLBACK;PRINT N'PASS: Báo cáo phim cũ giữ đơn chưa hoàn và giá snapshot';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @products EXEC dbo.sp_YMC_ThongKeFnb @a,@rap,@d0,@d0;IF (SELECT SUM(TienBan) FROM @products)<>40000 OR (SELECT SUM(SoLuong) FROM @products)<>2 THROW 50996,N'FAIL: legacy FNB meaning.',1;
ROLLBACK;PRINT N'PASS: Báo cáo F&B cũ giữ loại đơn đã hoàn sau kỳ xem';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @products EXEC dbo.sp_YMC_ThongKeFnb @a,@rap,@d1,@d1,@movieA;IF (SELECT SUM(TienBan) FROM @products)<>30000 THROW 50996,N'FAIL: legacy FNB film.',1;
ROLLBACK;PRINT N'PASS: F&B cũ lọc phim nhưng không đổi đơn giá đã chốt';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @films EXEC dbo.sp_YMC_ThongKePhim @a,@rap,@showDate,@showDate;IF (SELECT SUM(TienVe) FROM @films)<>160000 THROW 50996,N'FAIL: legacy film caller.',1;
ROLLBACK;PRINT N'PASS: Báo cáo phim cũ caller bốn tham số vẫn dùng được';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
INSERT @daily EXEC dbo.sp_YMC_BaoCaoThuChiTiet @manager,@rap,@d0,@d2;IF (SELECT SUM(TienDaThu) FROM @daily)<>460000 THROW 50996,N'FAIL: manager scope.',1;
ROLLBACK;PRINT N'PASS: Quản lý có phân công xem đủ tiền của rạp';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoThuChiTiet @manager,@rapOther,@d0,@d2;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoThuChiTiet',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoThuChiTiet';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoThuChiTiet @viewer,@rap,@d0,@d2;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoThuChiTiet',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoThuChiTiet';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoTheoSuat @manager,@rapOther,@showDate,@showDate;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoTheoSuat',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoTheoSuat';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoTheoSuat @viewer,@rap,@showDate,@showDate;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoTheoSuat',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoTheoSuat';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoDoanhThu @manager,@rapOther,@d0,@d2;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoDoanhThu',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_BaoCaoDoanhThu';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoDoanhThu @viewer,@rap,@d0,@d2;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoDoanhThu',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_BaoCaoDoanhThu';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_ThongKePhim @manager,@rapOther,@showDate,@showDate;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_ThongKePhim',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_ThongKePhim';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_ThongKePhim @viewer,@rap,@showDate,@showDate;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_ThongKePhim',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_ThongKePhim';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_ThongKeFnb @manager,@rapOther,@d0,@d2;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_ThongKeFnb',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_ThongKeFnb';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_ThongKeFnb @viewer,@rap,@d0,@d2;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_ThongKeFnb',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_ThongKeFnb';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_LayPhimBaoCao @manager,@rapOther;
THROW 50996,N'FAIL: Chặn ngoài rạp tại SQL: sp_YMC_LayPhimBaoCao',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Chặn ngoài rạp tại SQL: sp_YMC_LayPhimBaoCao';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_LayPhimBaoCao @viewer,@rap;
THROW 50996,N'FAIL: Chặn thiếu quyền tại SQL: sp_YMC_LayPhimBaoCao',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Chặn thiếu quyền tại SQL: sp_YMC_LayPhimBaoCao';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
DELETE nr FROM dbo.NhanVienRap nr JOIN dbo.NhanVien n ON n.MaNhanVien=nr.MaNhanVien WHERE n.MaTaiKhoan=@manager;EXEC dbo.sp_YMC_BaoCaoThuChiTiet @manager,@rap,@d0,@d2;
THROW 50996,N'FAIL: Thu hồi phân công khi form mở bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: Thu hồi phân công khi form mở bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@manager;EXEC dbo.sp_YMC_BaoCaoTheoSuat @manager,@rap,@showDate,@showDate;
THROW 50996,N'FAIL: Khóa tài khoản khi form mở bị chặn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 PRINT N'PASS: Khóa tài khoản khi form mở bị chặn';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoThuChiTiet @a,@rap,@d2,@d0;
THROW 50996,N'FAIL: Khoảng ngày ngược bị từ chối',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50600 THROW;
 PRINT N'PASS: Khoảng ngày ngược bị từ chối';
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
 DECLARE @a INT,@manager INT,@viewer INT,@rap INT,@rapOther INT,@movieA INT,@movieB INT,@showA INT,@showB INT,@cancel INT,@d0 DATE,@showDate DATE,@orderA BIGINT,@orderB BIGINT,@orderC BIGINT;
 EXEC #YMC_ReportFixture @a OUTPUT,@manager OUTPUT,@viewer OUTPUT,@rap OUTPUT,@rapOther OUTPUT,@movieA OUTPUT,@movieB OUTPUT,@showA OUTPUT,@showB OUTPUT,@cancel OUTPUT,@d0 OUTPUT,@showDate OUTPUT,@orderA OUTPUT,@orderB OUTPUT,@orderC OUTPUT;
 DECLARE @d1 DATE=DATEADD(DAY,1,@d0),@d2 DATE=DATEADD(DAY,2,@d0),@outsideFilm INT=(SELECT s.MaPhim FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@rapOther);
 DECLARE @daily TABLE(Ngay DATE,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @old TABLE(Ngay DATE,TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @shows TABLE(MaSuatChieu INT,MaPhim INT,TenPhim NVARCHAR(200),TenRap NVARCHAR(200),TenPhong NVARCHAR(100),GioBatDau DATETIME2(0),GioKetThuc DATETIME2(0),TrangThai NVARCHAR(30),VePhatHanh INT,VeDaHoan INT,VeChuaHoan INT,ThuVe DECIMAL(38,0),ThuFnb DECIMAL(38,0),TienDaThu DECIMAL(38,0),TienDaHoan DECIMAL(38,0),DoanhThuThuan DECIMAL(38,0));
 DECLARE @films TABLE(MaPhim INT,TenPhim NVARCHAR(200),SoSuat INT,TongGheHienTai INT,VeDaBan INT,TienVe DECIMAL(38,0),TyLeLapDay DECIMAL(8,2));
 DECLARE @products TABLE(MaSanPham INT,TenSanPham NVARCHAR(150),SoLuong INT,TienBan DECIMAL(38,0));
 DECLARE @list TABLE(MaPhim INT,TenPhim NVARCHAR(200));
EXEC dbo.sp_YMC_BaoCaoTheoSuat @a,@rap,NULL,@showDate;
THROW 50996,N'FAIL: Ngày NULL bị từ chối',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50600 THROW;
 PRINT N'PASS: Ngày NULL bị từ chối';
END CATCH;
GO
DROP PROCEDURE #YMC_ReportFixture;
PRINT N'Hoàn tất 32 ca báo cáo, fixture đã rollback.';
GO
