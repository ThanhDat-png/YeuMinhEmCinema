-- CHỈ CHẠY DATABASE TEST. Tự tạo fixture và rollback cả ca thử.
USE YeuMinhEmCinema_Test;
GO
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50980,N'Chỉ chạy trên database _Test.',1;
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;
DECLARE @tag VARCHAR(16)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),16),@a INT,@staff INT,@nv INT,@rap INT,@rap2 INT,@phong INT,@loai INT,@phim INT,@suat INT,@ghe INT;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('ad_'+@tag,REPLICATE('X',80));SET @a=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @a,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('nv_'+@tag,REPLICATE('X',80));SET @staff=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@staff,N'Nhân viên thử');SET @nv=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @staff,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='BAN_VE';
INSERT dbo.Rap(TenRap) VALUES(N'TEST_1_'+@tag);SET @rap=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.Rap(TenRap) VALUES(N'TEST_2_'+@tag);SET @rap2=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVienRap VALUES(@nv,@rap);
IF dbo.fn_YMC_CoPhamViRap(@staff,@rap)<>1 OR dbo.fn_YMC_CoPhamViRap(@staff,@rap2)<>0 THROW 50981,N'FAIL: phạm vi rạp.',1;
INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang) VALUES(@rap,N'TEST','TEST_'+@tag);SET @phong=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.LoaiGhe(TenLoai) VALUES(N'TEST_'+@tag);SET @loai=CONVERT(INT,SCOPE_IDENTITY());
EXEC dbo.sp_YMC_TaoGheTheoLo @a,@phong,2,3,@loai;
EXEC dbo.sp_YMC_TaoGheTheoLo @a,@phong,2,3,@loai;
IF(SELECT COUNT(*) FROM dbo.Ghe WHERE MaPhong=@phong)<>6 THROW 50982,N'FAIL: tạo ghế lặp.',1;
DECLARE @start DATETIME2(0)=DATEADD(MINUTE,20,dbo.fn_YMC_GioVietNam()),@ngay DATE,@ln NVARCHAR(20);
SET @ngay=CONVERT(DATE,@start);SET @ln=CASE WHEN(DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(N'TEST_'+@tag,90,@ngay,'P',N'Đang chiếu');SET @phim=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc) VALUES(@phim,@phong,@start,DATEADD(MINUTE,90,@start));SET @suat=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DonGia) VALUES(@loai,'TEST_'+@tag,@ln,@ngay,80000);
SELECT TOP(1) @ghe=MaGhe FROM dbo.Ghe WHERE MaPhong=@phong ORDER BY MaGhe;
DECLARE @g dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb,@q UNIQUEIDENTIFIER=NEWID(),@don BIGINT;
INSERT @g VALUES(@ghe);
EXEC dbo.sp_YMC_TaoDonGiuGhe @staff,@q,@suat,'QUAY',@g,@f,N'Khách thử';
SELECT @don=MaDonHang FROM dbo.DonHang WHERE MaYeuCau=@q;
EXEC dbo.sp_YMC_HuyDonChuaThanhToan @staff,@don,N'Nhân viên hủy đơn tự tạo';
IF EXISTS(SELECT 1 FROM dbo.GiuGhe WHERE MaDonHang=@don) THROW 50983,N'FAIL: chưa giải phóng ghế.',1;
PRINT N'PASS: phạm vi rạp, tạo ghế lặp, nhân viên tự hủy đơn quầy chưa trả.';
-- Mong đợi 50404; CATCH rollback fixture.
EXEC dbo.sp_YMC_YeuCauQuyen @staff,'BAN_VE',@rap2;
THROW 50984,N'FAIL: cho phép rạp không phân công.',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 PRINT N'PASS: chặn thao tác rạp khác; toàn bộ fixture đã rollback.';
END CATCH;
GO
