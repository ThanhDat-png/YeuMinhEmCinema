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
-- Thu hồi rạp chặn sửa rạp
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuRap @Manager,@RapB,N'Không được sửa',NULL,N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn sửa rạp',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn sửa rạp';
END CATCH;
GO
-- Thu hồi rạp chặn sửa phòng
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuPhong @Manager,@PhongB,@RapB,N'Không được sửa','2D',N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn sửa phòng',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn sửa phòng';
END CATCH;
GO
-- Thu hồi rạp chặn tạo phòng
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuPhong @NguoiThucHien=@Manager,@MaRap=@RapB,@TenPhong=N'Mới',@DinhDang='2D',@TrangThai=N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn tạo phòng',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn tạo phòng';
END CATCH;
GO
-- Chuyển phòng phải kiểm rạp cũ
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuPhong @Manager,@PhongB,@RapA,N'Chuyển trái phép','2D',N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Chuyển phòng phải kiểm rạp cũ',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Chuyển phòng phải kiểm rạp cũ';
END CATCH;
GO
-- Chuyển phòng phải kiểm rạp đích
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuPhong @Manager,@PhongA,@RapB,N'Chuyển trái phép','2D',N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Chuyển phòng phải kiểm rạp đích',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Chuyển phòng phải kiểm rạp đích';
END CATCH;
GO
-- Thu hồi rạp chặn sửa ghế đơn
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuGhe @Manager,@GheB,@PhongB,'A',1,@Loai,N'Hỏng/Ngừng sử dụng';
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn sửa ghế đơn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn sửa ghế đơn';
END CATCH;
GO
-- Thu hồi rạp chặn thêm ghế đơn
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuGhe @NguoiThucHien=@Manager,@MaPhong=@PhongB,@HangGhe='A',@SoGhe=2,@MaLoaiGhe=@Loai,@TrangThai=N'Hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn thêm ghế đơn',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn thêm ghế đơn';
END CATCH;
GO
-- Chuyển ghế phải kiểm rạp cũ
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuGhe @Manager,@GheB,@PhongA,'B',2,@Loai,N'Hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Chuyển ghế phải kiểm rạp cũ',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Chuyển ghế phải kiểm rạp cũ';
END CATCH;
GO
-- Chuyển ghế phải kiểm rạp đích
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuGhe @Manager,@GheA,@PhongB,'B',2,@Loai,N'Hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Chuyển ghế phải kiểm rạp đích',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Chuyển ghế phải kiểm rạp đích';
END CATCH;
GO
-- Thu hồi rạp chặn tạo sơ đồ lô
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_TaoGheTheoLo @Manager,@PhongB,2,3,@Loai;
 ROLLBACK;
 THROW 50999,N'FAIL: Thu hồi rạp chặn tạo sơ đồ lô',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Thu hồi rạp chặn tạo sơ đồ lô';
END CATCH;
GO
-- Lô ghế ngoài phạm vi bị từ chối
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 DECLARE @g dbo.YMC_DanhSachGhe;INSERT @g VALUES(@GheB);EXEC dbo.sp_YMC_CapNhatLoGhe @Manager,@g,NULL,N'Hỏng/Ngừng sử dụng';
 ROLLBACK;
 THROW 50999,N'FAIL: Lô ghế ngoài phạm vi bị từ chối',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Lô ghế ngoài phạm vi bị từ chối';
END CATCH;
GO
-- Lô trộn hai rạp bị từ chối toàn bộ
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 DECLARE @g dbo.YMC_DanhSachGhe;INSERT @g VALUES(@GheA),(@GheB);EXEC dbo.sp_YMC_CapNhatLoGhe @Manager,@g,NULL,N'Hỏng/Ngừng sử dụng';
 ROLLBACK;
 THROW 50999,N'FAIL: Lô trộn hai rạp bị từ chối toàn bộ',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Lô trộn hai rạp bị từ chối toàn bộ';
END CATCH;
GO
-- Quản lý không tạo rạp toàn cục
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuRap @NguoiThucHien=@Manager,@TenRap=N'Không được tạo',@TrangThai=N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Quản lý không tạo rạp toàn cục',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Quản lý không tạo rạp toàn cục';
END CATCH;
GO
-- Quản lý không sửa loại ghế dùng chung
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuLoaiGhe @Manager,@Loai,N'Không được sửa';
 ROLLBACK;
 THROW 50999,N'FAIL: Quản lý không sửa loại ghế dùng chung',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Quản lý không sửa loại ghế dùng chung';
END CATCH;
GO
-- Quản lý không tạo loại ghế dùng chung
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuLoaiGhe @NguoiThucHien=@Manager,@TenLoai=N'Không được tạo';
 ROLLBACK;
 THROW 50999,N'FAIL: Quản lý không tạo loại ghế dùng chung',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Quản lý không tạo loại ghế dùng chung';
END CATCH;
GO
-- Chỉ có quyền xem không được sửa
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 EXEC dbo.sp_YMC_LuuPhong @Viewer,@PhongA,@RapA,N'Không được sửa','2D',N'Đang hoạt động';
 ROLLBACK;
 THROW 50999,N'FAIL: Chỉ có quyền xem không được sửa',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Chỉ có quyền xem không được sửa';
END CATCH;
GO
-- Tài khoản bị khóa không được ghi
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@Manager;EXEC dbo.sp_YMC_TaoGheTheoLo @Manager,@PhongA,2,3,@Loai;
 ROLLBACK;
 THROW 50999,N'FAIL: Tài khoản bị khóa không được ghi',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50403 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Tài khoản bị khóa không được ghi';
END CATCH;
GO
-- Nhân viên ngừng làm việc không được ghi
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 UPDATE dbo.NhanVien SET DangLamViec=0 WHERE MaTaiKhoan=@Manager;EXEC dbo.sp_YMC_TaoGheTheoLo @Manager,@PhongA,2,3,@Loai;
 ROLLBACK;
 THROW 50999,N'FAIL: Nhân viên ngừng làm việc không được ghi',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50404 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Nhân viên ngừng làm việc không được ghi';
END CATCH;
GO
-- Lô có ghế không tồn tại bị từ chối
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;

 DECLARE @g dbo.YMC_DanhSachGhe;INSERT @g VALUES(@GheA),(-1);EXEC dbo.sp_YMC_CapNhatLoGhe @Manager,@g,NULL,N'Hỏng/Ngừng sử dụng';
 ROLLBACK;
 THROW 50999,N'FAIL: Lô có ghế không tồn tại bị từ chối',1;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 IF ERROR_NUMBER()<>50710 THROW;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@Manager) THROW 50998,N'Fixture chưa rollback.',1;
 PRINT N'PASS: Lô có ghế không tồn tại bị từ chối';
END CATCH;
GO
-- Quản lý vẫn sửa được dữ liệu rạp được phân công
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


EXEC dbo.sp_YMC_LuuRap @Manager,@RapA,N'Đã sửa rạp',NULL,N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuPhong @Manager,@PhongA,@RapA,N'Đã sửa phòng','2D',N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuGhe @Manager,@GheA,@PhongA,'A',1,@Loai,N'Hoạt động';
DECLARE @g dbo.YMC_DanhSachGhe;INSERT @g VALUES(@GheA);
EXEC dbo.sp_YMC_CapNhatLoGhe @Manager,@g,NULL,N'Hỏng/Ngừng sử dụng';
IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaGhe=@GheA AND TrangThai=N'Hỏng/Ngừng sử dụng') THROW 50999,N'Không lưu ghế hợp lệ.',1;

 ROLLBACK;
 PRINT N'PASS: Quản lý vẫn sửa được dữ liệu rạp được phân công';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
-- Quản lý thêm phòng và ghế trong phạm vi
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


EXEC dbo.sp_YMC_LuuPhong @NguoiThucHien=@Manager,@MaRap=@RapA,@TenPhong=N'Phòng thêm',@DinhDang='2D',@TrangThai=N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuGhe @NguoiThucHien=@Manager,@MaPhong=@PhongA,@HangGhe='B',@SoGhe=2,@MaLoaiGhe=@Loai,@TrangThai=N'Hoạt động';
IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaPhong=@PhongA AND HangGhe='B' AND SoGhe=2) THROW 50999,N'Không thêm ghế hợp lệ.',1;

 ROLLBACK;
 PRINT N'PASS: Quản lý thêm phòng và ghế trong phạm vi';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
-- Chuyển phòng giữa hai rạp đều được phân công
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


EXEC dbo.sp_YMC_LuuPhong @Manager,@PhongA,@RapC,N'Phòng chuyển','2D',N'Đang hoạt động';
IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@PhongA AND MaRap=@RapC) THROW 50999,N'Không chuyển phòng hợp lệ.',1;

 ROLLBACK;
 PRINT N'PASS: Chuyển phòng giữa hai rạp đều được phân công';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
-- Chuyển ghế giữa hai rạp đều được phân công
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


EXEC dbo.sp_YMC_LuuGhe @Manager,@GheA,@PhongC,'B',2,@Loai,N'Hoạt động';
IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaGhe=@GheA AND MaPhong=@PhongC) THROW 50999,N'Không chuyển ghế hợp lệ.',1;

 ROLLBACK;
 PRINT N'PASS: Chuyển ghế giữa hai rạp đều được phân công';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
-- Tạo sơ đồ trong phạm vi chạy lặp không trùng
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


DECLARE @r TABLE(SoGheDaTao INT,SoGheBoQua INT);
INSERT @r EXEC dbo.sp_YMC_TaoGheTheoLo @Manager,@PhongA,2,3,@Loai;
IF NOT EXISTS(SELECT 1 FROM @r WHERE SoGheDaTao=5 AND SoGheBoQua=1) THROW 50999,N'Sai kết quả tạo ghế.',1;
DELETE @r;
INSERT @r EXEC dbo.sp_YMC_TaoGheTheoLo @Manager,@PhongA,2,3,@Loai;
IF NOT EXISTS(SELECT 1 FROM @r WHERE SoGheDaTao=0 AND SoGheBoQua=6) THROW 50999,N'Tạo lặp sinh ghế trùng.',1;

 ROLLBACK;
 PRINT N'PASS: Tạo sơ đồ trong phạm vi chạy lặp không trùng';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
-- Admin giữ quyền toàn hệ thống và danh mục dùng chung
BEGIN TRY
 BEGIN TRAN;
 DECLARE @Admin INT,@Manager INT,@Viewer INT,@RapA INT,@RapB INT,@RapC INT,@PhongA INT,@PhongB INT,@PhongC INT,@Loai INT,@GheA INT,@GheB INT;
EXEC #YMC_ScopeFixture @Admin OUTPUT,@Manager OUTPUT,@Viewer OUTPUT,@RapA OUTPUT,@RapB OUTPUT,@RapC OUTPUT,@PhongA OUTPUT,@PhongB OUTPUT,@PhongC OUTPUT,@Loai OUTPUT,@GheA OUTPUT,@GheB OUTPUT;


EXEC dbo.sp_YMC_LuuRap @Admin,@RapB,N'Admin sửa rạp',NULL,N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuRap @NguoiThucHien=@Admin,@TenRap=N'Admin tạo rạp',@TrangThai=N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuPhong @Admin,@PhongB,@RapB,N'Admin sửa phòng','2D',N'Đang hoạt động';
EXEC dbo.sp_YMC_LuuGhe @Admin,@GheB,@PhongB,'A',1,@Loai,N'Hoạt động';
EXEC dbo.sp_YMC_TaoGheTheoLo @Admin,@PhongB,2,3,@Loai;
EXEC dbo.sp_YMC_LuuLoaiGhe @Admin,@Loai,N'Admin sửa loại ghế';
EXEC dbo.sp_YMC_LuuLoaiGhe @NguoiThucHien=@Admin,@TenLoai=N'Admin tạo loại ghế';

 ROLLBACK;
 PRINT N'PASS: Admin giữ quyền toàn hệ thống và danh mục dùng chung';
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
GO
DROP PROCEDURE #YMC_ScopeFixture;
PRINT N'PASS: toàn bộ kiểm thử Admin phạm vi rạp; fixture đã rollback.';
GO
