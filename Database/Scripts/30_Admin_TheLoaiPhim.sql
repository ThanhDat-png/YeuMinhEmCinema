-- T07: chỉ cộng thêm danh mục thể loại; không đổi Phim, giao dịch hay hợp đồng Web.
USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID(N'dbo.TheLoai',N'U') IS NULL
BEGIN
 CREATE TABLE dbo.TheLoai(
  MaTheLoai INT IDENTITY(1,1) CONSTRAINT PK_TheLoai PRIMARY KEY,
  TenTheLoai NVARCHAR(100) COLLATE Vietnamese_100_CI_AS NOT NULL,
  MoTa NVARCHAR(1000) NULL,
  DangSuDung BIT NOT NULL CONSTRAINT DF_TheLoai_DangSuDung DEFAULT 1,
  CONSTRAINT UQ_TheLoai_Ten UNIQUE(TenTheLoai),
  CONSTRAINT CK_TheLoai_Ten CHECK(LEN(LTRIM(RTRIM(TenTheLoai)))>0 AND DATALENGTH(TenTheLoai)=DATALENGTH(LTRIM(RTRIM(TenTheLoai))))
 );
END;
IF OBJECT_ID(N'dbo.PhimTheLoai',N'U') IS NULL
BEGIN
 CREATE TABLE dbo.PhimTheLoai(
  MaPhim INT NOT NULL CONSTRAINT FK_PhimTheLoai_Phim REFERENCES dbo.Phim(MaPhim),
  MaTheLoai INT NOT NULL CONSTRAINT FK_PhimTheLoai_TheLoai REFERENCES dbo.TheLoai(MaTheLoai),
  CONSTRAINT PK_PhimTheLoai PRIMARY KEY(MaPhim,MaTheLoai)
 );
 CREATE INDEX IX_PhimTheLoai_TheLoai ON dbo.PhimTheLoai(MaTheLoai,MaPhim);
END;
IF TYPE_ID(N'dbo.YMC_DanhSachTheLoai') IS NULL
 EXEC(N'CREATE TYPE dbo.YMC_DanhSachTheLoai AS TABLE(MaTheLoai INT PRIMARY KEY)');
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayTheLoaiAdmin @NguoiThucHien INT
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_XEM';
 SELECT t.MaTheLoai,t.TenTheLoai,t.MoTa,t.DangSuDung,
  (SELECT COUNT(*) FROM dbo.PhimTheLoai p WHERE p.MaTheLoai=t.MaTheLoai) SoPhim
 FROM dbo.TheLoai t ORDER BY t.TenTheLoai,t.MaTheLoai;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuTheLoai
 @NguoiThucHien INT,@MaTheLoai INT=NULL,@TenTheLoai NVARCHAR(MAX),@MoTa NVARCHAR(MAX)=NULL,@DangSuDung BIT=1
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 BEGIN TRY
  BEGIN TRAN;
  EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_QUAN_LY';
  DECLARE @lock INT;
  EXEC @lock=sys.sp_getapplock @Resource=N'YMC_Genre_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
  IF @lock<0 THROW 50730,N'Danh mục thể loại đang bận. Hãy thử lại.',1;
  SET @TenTheLoai=LTRIM(RTRIM(@TenTheLoai));
  SET @MoTa=NULLIF(LTRIM(RTRIM(@MoTa)),N'');
  IF @TenTheLoai IS NULL OR LEN(@TenTheLoai)=0 OR DATALENGTH(@TenTheLoai)>200
   OR CHARINDEX(NCHAR(9),@TenTheLoai)>0 OR CHARINDEX(NCHAR(10),@TenTheLoai)>0 OR CHARINDEX(NCHAR(13),@TenTheLoai)>0
   OR DATALENGTH(@MoTa)>2000 OR @DangSuDung IS NULL
   THROW 50731,N'Tên thể loại bắt buộc, tối đa 100 ký tự, không xuống dòng; mô tả tối đa 1000 ký tự và phải chọn trạng thái.',1;
  IF @MaTheLoai IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.TheLoai WHERE MaTheLoai=@MaTheLoai)
   THROW 50732,N'Thể loại không tồn tại. Hãy tải lại.',1;
  IF EXISTS(SELECT 1 FROM dbo.TheLoai WHERE TenTheLoai=@TenTheLoai COLLATE Vietnamese_100_CI_AS AND (@MaTheLoai IS NULL OR MaTheLoai<>@MaTheLoai))
   THROW 50733,N'Tên thể loại đã tồn tại (kể cả thể loại ngừng sử dụng).',1;
  IF @MaTheLoai IS NULL
  BEGIN
   INSERT dbo.TheLoai(TenTheLoai,MoTa,DangSuDung) VALUES(@TenTheLoai,@MoTa,@DangSuDung);
   SET @MaTheLoai=CONVERT(INT,SCOPE_IDENTITY());
  END
  ELSE UPDATE dbo.TheLoai SET TenTheLoai=@TenTheLoai,MoTa=@MoTa,DangSuDung=@DangSuDung WHERE MaTheLoai=@MaTheLoai;
  COMMIT;
  SELECT @MaTheLoai MaTheLoai;
 END TRY
 BEGIN CATCH
  IF @@TRANCOUNT>0 ROLLBACK;
  THROW;
 END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayTheLoaiCuaPhim @NguoiThucHien INT,@MaPhim INT
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_XEM';
 IF NOT EXISTS(SELECT 1 FROM dbo.Phim WHERE MaPhim=@MaPhim) THROW 50734,N'Phim không tồn tại.',1;
 SELECT t.MaTheLoai,t.TenTheLoai,t.DangSuDung,CONVERT(BIT,CASE WHEN p.MaPhim IS NULL THEN 0 ELSE 1 END) DaGan
 FROM dbo.TheLoai t LEFT JOIN dbo.PhimTheLoai p ON p.MaTheLoai=t.MaTheLoai AND p.MaPhim=@MaPhim
 WHERE t.DangSuDung=1 OR p.MaPhim IS NOT NULL ORDER BY t.TenTheLoai,t.MaTheLoai;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_GanTheLoaiPhim
 @NguoiThucHien INT,@MaPhim INT,@DanhSach dbo.YMC_DanhSachTheLoai READONLY
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 BEGIN TRY
  BEGIN TRAN;
  EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_QUAN_LY';
  DECLARE @lock INT;
  EXEC @lock=sys.sp_getapplock @Resource=N'YMC_Genre_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
  IF @lock<0 THROW 50730,N'Danh mục thể loại đang bận. Hãy thử lại.',1;
  IF NOT EXISTS(SELECT 1 FROM dbo.Phim WITH(UPDLOCK,HOLDLOCK) WHERE MaPhim=@MaPhim) THROW 50734,N'Phim không tồn tại.',1;
  IF EXISTS(SELECT 1 FROM @DanhSach d LEFT JOIN dbo.TheLoai t ON t.MaTheLoai=d.MaTheLoai WHERE t.MaTheLoai IS NULL)
   THROW 50732,N'Thể loại không tồn tại. Hãy tải lại.',1;
  -- Giữ được liên kết ngừng sử dụng đã có, nhưng không được thêm liên kết mới tới nó.
  IF EXISTS(SELECT 1 FROM @DanhSach d JOIN dbo.TheLoai t ON t.MaTheLoai=d.MaTheLoai
   WHERE t.DangSuDung=0 AND NOT EXISTS(SELECT 1 FROM dbo.PhimTheLoai p WHERE p.MaPhim=@MaPhim AND p.MaTheLoai=d.MaTheLoai))
   THROW 50735,N'Không thể gán mới thể loại đã ngừng sử dụng. Hãy tải lại danh sách.',1;
  DELETE p FROM dbo.PhimTheLoai p WHERE p.MaPhim=@MaPhim AND NOT EXISTS(SELECT 1 FROM @DanhSach d WHERE d.MaTheLoai=p.MaTheLoai);
  INSERT dbo.PhimTheLoai(MaPhim,MaTheLoai)
   SELECT @MaPhim,d.MaTheLoai FROM @DanhSach d WHERE NOT EXISTS(SELECT 1 FROM dbo.PhimTheLoai p WHERE p.MaPhim=@MaPhim AND p.MaTheLoai=d.MaTheLoai);
  COMMIT;
 END TRY
 BEGIN CATCH
  IF @@TRANCOUNT>0 ROLLBACK;
  THROW;
 END CATCH;
END;
GO
-- Chỉ Admin dùng thủ tục mới này. Không đổi bất kỳ thủ tục Web/luồng lưu phim cũ nào.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayPhimKemTheLoaiAdmin
 @NguoiThucHien INT,@TuKhoa NVARCHAR(200)=NULL,@TrangThai NVARCHAR(30)=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_XEM';
 SELECT f.*,ISNULL(g.TheLoai,N'') TheLoai FROM dbo.Phim f
 OUTER APPLY(SELECT STRING_AGG(CONVERT(NVARCHAR(MAX),t.TenTheLoai+CASE WHEN t.DangSuDung=0 THEN N' (ngừng sử dụng)' ELSE N'' END),N', ')
  WITHIN GROUP(ORDER BY t.TenTheLoai,t.MaTheLoai) TheLoai
  FROM dbo.PhimTheLoai p JOIN dbo.TheLoai t ON t.MaTheLoai=p.MaTheLoai WHERE p.MaPhim=f.MaPhim) g
 WHERE (@TuKhoa IS NULL OR CHARINDEX(@TuKhoa,f.TenPhim)>0) AND (@TrangThai IS NULL OR f.TrangThai=@TrangThai)
 ORDER BY f.MaPhim DESC;
END;
GO
PRINT N'Đã bổ sung SQL 30: thể loại Admin, giữ nguyên hợp đồng Web và phim cũ.';
GO
