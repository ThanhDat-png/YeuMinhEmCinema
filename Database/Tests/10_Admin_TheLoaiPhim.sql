-- T07: chỉ Test; mỗi ca có fixture riêng và rollback (kể cả quyền, trạng thái).
USE YeuMinhEmCinema_Test;
GO
SET NOCOUNT ON; SET XACT_ABORT ON; SET QUOTED_IDENTIFIER ON;
IF DB_NAME() NOT LIKE '%[_]Test' THROW 50990,N'Chỉ chạy trên database _Test.',1;
GO
CREATE PROCEDURE #GenreFixture @a INT OUTPUT,@v INT OUTPUT,@n INT OUTPUT,@f INT OUTPUT,@old INT OUTPUT,@g INT OUTPUT,@h INT OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @tag VARCHAR(12)=LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),12);
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('genre_a_'+@tag,REPLICATE('X',80));SET @a=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @a,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='ADMIN';
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('genre_v_'+@tag,REPLICATE('X',80));SET @v=SCOPE_IDENTITY();
 INSERT dbo.TaiKhoanVaiTro SELECT @v,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='BAN_VE';
 INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES('genre_n_'+@tag,REPLICATE('X',80));SET @n=SCOPE_IDENTITY();
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES('Genre_'+@tag,90,CONVERT(DATE,dbo.fn_YMC_GioVietNam()),'P',N'Đang chiếu');SET @f=SCOPE_IDENTITY();
 INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi) VALUES('Old_'+@tag,90,'20260101','P');SET @old=SCOPE_IDENTITY();
 INSERT dbo.TheLoai(TenTheLoai,MoTa) VALUES(N'TEST hành động '+@tag,N'Mô tả tiếng Việt');SET @g=SCOPE_IDENTITY();
 INSERT dbo.TheLoai(TenTheLoai) VALUES(N'TEST hài '+@tag);SET @h=SCOPE_IDENTITY();
END;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ret EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,N'  TEST Hoạt hình mới  ',N' Phim cho gia đình ',1;IF NOT EXISTS(SELECT 1 FROM dbo.TheLoai t JOIN @ret r ON r.MaTheLoai=t.MaTheLoai WHERE t.TenTheLoai=N'TEST Hoạt hình mới' AND MoTa=N'Phim cho gia đình' AND DangSuDung=1) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tạo, trim tên, mô tả Unicode';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
EXEC dbo.sp_YMC_LuuTheLoai @a,@g,N'TEST thể loại đã sửa',N'Mô tả đã sửa',1;IF NOT EXISTS(SELECT 1 FROM dbo.TheLoai WHERE MaTheLoai=@g AND TenTheLoai=N'TEST thể loại đã sửa' AND MoTa=N'Mô tả đã sửa') THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Sửa tên và mô tả';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g),(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;IF (SELECT COUNT(*) FROM dbo.PhimTheLoai WHERE MaPhim=@f)<>2 THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Gán nhiều thể loại, không trùng khi lưu lại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; DELETE @ids; INSERT @ids VALUES(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;IF EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim=@f AND MaTheLoai=@g) OR NOT EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim=@f AND MaTheLoai=@h) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Thay đổi thể loại đã gán';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; DELETE @ids; EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; INSERT @assigned EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @a,@old;IF EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim IN(@old,@f)) OR EXISTS(SELECT 1 FROM @assigned WHERE DaGan=1) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Bỏ hết thể loại và phim cũ không bắt buộc có thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; SELECT @name=TenTheLoai FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @a,@g,@name,NULL,0; EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; INSERT @assigned EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @v,@f;IF NOT EXISTS(SELECT 1 FROM @assigned WHERE MaTheLoai=@g AND DangSuDung=0 AND DaGan=1) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Ngừng sử dụng giữ liên kết cũ, giữ lại khi lưu phim';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; UPDATE dbo.TheLoai SET DangSuDung=0 WHERE MaTheLoai=@g; DELETE @ids; EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; INSERT @assigned EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @a,@f;IF EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim=@f) OR EXISTS(SELECT 1 FROM @assigned WHERE MaTheLoai=@g) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Bỏ liên kết với thể loại ngừng sử dụng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
SELECT @name=TenTheLoai FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @a,@g,@name,NULL,0; EXEC dbo.sp_YMC_LuuTheLoai @a,@g,@name,NULL,1; INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@old,@ids;IF NOT EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim=@old AND MaTheLoai=@g) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Sử dụng lại cho phép gán mới';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g),(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids; INSERT @genres EXEC dbo.sp_YMC_LayTheLoaiAdmin @v; INSERT @assigned EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @v,@f;IF (SELECT SoPhim FROM @genres WHERE MaTheLoai=@g)<>1 OR (SELECT COUNT(*) FROM @assigned WHERE DaGan=1)<>2 THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Chỉ xem đọc danh mục và phim';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,N'   ';
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tên rỗng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,NULL;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tên NULL';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SET @name=REPLICATE(N'A',101); EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,@name;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tên quá 100 ký tự';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SET @name=N'Test'+NCHAR(10); EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,@name;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tên có ký tự xuống dòng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SET @desc=REPLICATE(N'A',1001); EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,N'TEST dài',@desc;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Mô tả quá 1000 ký tự';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,N'TEST null',NULL,NULL;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50731 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Trạng thái NULL';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SELECT @name=N'  '+UPPER(TenTheLoai)+N'  ' FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,@name;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50733 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Tên trùng không phân biệt hoa thường và khoảng trắng biên';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SELECT @name=TenTheLoai FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @a,@h,@name;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50733 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Sửa thành tên trùng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
UPDATE dbo.TheLoai SET DangSuDung=0 WHERE MaTheLoai=@g; SELECT @name=TenTheLoai FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @a,NULL,@name;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50733 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Không dùng lại tên thể loại đã ngừng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LuuTheLoai @a,-1,N'TEST no id';
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50732 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Sửa mã thể loại không tồn tại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
INSERT @ids VALUES(@g),(-1); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50732 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Gán mã thể loại không tồn tại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,-1,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50734 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Gán phim không tồn tại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @a,-1;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50734 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Đọc phim không tồn tại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
UPDATE dbo.TheLoai SET DangSuDung=0 WHERE MaTheLoai=@g; INSERT @ids VALUES(@g),(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50735 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Không gán mới thể loại ngừng sử dụng';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
INSERT @assigned EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @a,@f; UPDATE dbo.TheLoai SET DangSuDung=0 WHERE MaTheLoai=@h; INSERT @ids VALUES(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50735 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Thể loại bị ngừng sau khi mở form';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LuuTheLoai @v,NULL,N'TEST forbidden';
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Chỉ xem không tạo thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
SELECT @name=TenTheLoai FROM dbo.TheLoai WHERE MaTheLoai=@g; EXEC dbo.sp_YMC_LuuTheLoai @v,@g,@name,NULL,0;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Chỉ xem không sửa/ngừng thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @v,@f,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Chỉ xem không gán thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LayTheLoaiAdmin @n;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Không quyền không đọc danh mục';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @n,@f;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Không quyền không đọc thể loại phim';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LayPhimKemTheLoaiAdmin @n;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Không quyền không đọc phim kèm thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
EXEC dbo.sp_YMC_LayTheLoaiAdmin @a; DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@a; INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Thu hồi quyền khi form đang mở';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
UPDATE dbo.TaiKhoan SET DangHoatDong=0 WHERE MaTaiKhoan=@a; EXEC dbo.sp_YMC_LayTheLoaiAdmin @a;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Khóa tài khoản chặn đọc';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
INSERT dbo.NhanVien(MaTaiKhoan,HoTen,DangLamViec) VALUES(@v,N'TEST ngừng việc',0); EXEC dbo.sp_YMC_LayTheLoaiCuaPhim @v,@f;
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50404 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Nhân viên ngừng việc chặn đọc';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
BEGIN TRY
DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@n; INSERT dbo.TaiKhoanVaiTro SELECT @n,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro='QUAN_LY'; EXEC dbo.sp_YMC_LuuTheLoai @n,NULL,N'TEST global';
END TRY
BEGIN CATCH
 IF ERROR_NUMBER()<>50403 THROW;
 SET @caught=1;
END CATCH;
IF @caught=0 THROW 50992,N'Phải từ chối thao tác này.',1;
IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Vai trò quản lý rạp không được tự cấp quyền quản lý phim chung';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g),(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
DECLARE @movies TABLE(MaPhim INT,TenPhim NVARCHAR(200),MoTa NVARCHAR(MAX),ThoiLuong INT,NgayKhoiChieu DATE,GioiHanTuoi VARCHAR(10),Poster NVARCHAR(500),Trailer NVARCHAR(500),TrangThai NVARCHAR(30),TheLoai NVARCHAR(MAX));
INSERT @movies EXEC dbo.sp_YMC_LayPhimKemTheLoaiAdmin @v;
IF (SELECT COUNT(*) FROM @movies WHERE MaPhim=@f)<>1 OR NOT EXISTS(SELECT 1 FROM @movies WHERE MaPhim=@old AND TheLoai=N'') OR NOT EXISTS(SELECT 1 FROM @movies WHERE MaPhim=@f AND CHARINDEX(N', ',TheLoai)>0) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Admin gộp nhiều thể loại thành một dòng phim';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g),(@h); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
SELECT @name=TenPhim FROM dbo.Phim WHERE MaPhim=@f;
DECLARE @web TABLE(MaPhim INT,TenPhim NVARCHAR(200),ThoiLuong INT,NgayKhoiChieu DATE,GioiHanTuoi VARCHAR(10),Poster NVARCHAR(500),Trailer NVARCHAR(500),TrangThai NVARCHAR(30),TongKetQua INT);
DECLARE @detail TABLE(MaPhim INT,TenPhim NVARCHAR(200),MoTa NVARCHAR(MAX),ThoiLuong INT,NgayKhoiChieu DATE,GioiHanTuoi VARCHAR(10),Poster NVARCHAR(500),Trailer NVARCHAR(500),TrangThai NVARCHAR(30));
INSERT @web EXEC dbo.sp_YMC_WebDanhSachPhim NULL,@name,1,100;
INSERT @detail EXEC dbo.sp_YMC_WebChiTietPhim @f;
IF (SELECT COUNT(*) FROM @web WHERE MaPhim=@f)<>1 OR (SELECT COUNT(*) FROM @detail WHERE MaPhim=@f)<>1 THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Web danh sách và chi tiết giữ một phim dù nhiều thể loại';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
BEGIN TRY
 BEGIN TRAN;
DECLARE @a INT,@v INT,@n INT,@f INT,@old INT,@g INT,@h INT;
EXEC #GenreFixture @a OUTPUT,@v OUTPUT,@n OUTPUT,@f OUTPUT,@old OUTPUT,@g OUTPUT,@h OUTPUT;
DECLARE @ids dbo.YMC_DanhSachTheLoai;
DECLARE @ret TABLE(MaTheLoai INT);
DECLARE @name NVARCHAR(MAX),@desc NVARCHAR(MAX),@caught BIT=0;
DECLARE @genres TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),MoTa NVARCHAR(1000),DangSuDung BIT,SoPhim INT);
DECLARE @assigned TABLE(MaTheLoai INT,TenTheLoai NVARCHAR(100),DangSuDung BIT,DaGan BIT);
INSERT @ids VALUES(@g); EXEC dbo.sp_YMC_GanTheLoaiPhim @a,@f,@ids;
INSERT @ret EXEC dbo.sp_YMC_LuuPhim @NguoiThucHien=@a,@MaPhim=@f,@TenPhim=N'TEST phim đã sửa',@ThoiLuong=90,@NgayKhoiChieu='20260101',@GioiHanTuoi='P',@TrangThai=N'Đang chiếu';
IF NOT EXISTS(SELECT 1 FROM @ret WHERE MaTheLoai=@f) OR NOT EXISTS(SELECT 1 FROM dbo.PhimTheLoai WHERE MaPhim=@f AND MaTheLoai=@g) THROW 50991,N'Không đạt điều kiện nghiệm thu.',1;

IF @@TRANCOUNT>0 ROLLBACK;
PRINT N'PASS: Lưu phim cũ vẫn giữ liên kết, trả mã theo hợp đồng cũ';
END TRY
BEGIN CATCH
 IF @@TRANCOUNT>0 ROLLBACK;
 THROW;
END CATCH;
GO
