-- Mở cả file trong SSMS, bấm F5. Không cần bật SQLCMD Mode.
-- Không chạy cùng lúc với ứng dụng. Không seed mẫu, không tạo tài khoản/mật khẩu mặc định.
USE master;
GO
IF DB_ID(N'YeuMinhEmCinema_Test') IS NULL EXEC(N'CREATE DATABASE [YeuMinhEmCinema_Test]');
GO
USE YeuMinhEmCinema_Test;
GO
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
BEGIN TRY
BEGIN TRAN;
IF (SELECT compatibility_level FROM sys.databases WHERE name=DB_NAME())<140
 THROW 50991,N'Cần compatibility level từ 140. Hãy gửi lỗi để kiểm tra trước khi đổi cấu hình.',1;
DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Install',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50990,N'Có phiên khác đang cài đặt SQL.',1;

PRINT N'Đang chạy 00_TaoDatabase_Phim.sql';
EXEC sys.sp_executesql N'IF OBJECT_ID(N''dbo.Phim'', N''U'') IS NULL
BEGIN
    CREATE TABLE dbo.Phim (
        MaPhim INT IDENTITY(1,1) CONSTRAINT PK_Phim PRIMARY KEY,
        TenPhim NVARCHAR(200) NOT NULL,
        MoTa NVARCHAR(MAX) NULL,
        ThoiLuong INT NOT NULL CONSTRAINT CK_Phim_ThoiLuong CHECK (ThoiLuong > 0),
        NgayKhoiChieu DATE NOT NULL,
        GioiHanTuoi VARCHAR(10) NOT NULL,
        Poster NVARCHAR(500) NULL,
        Trailer NVARCHAR(500) NULL,
        TrangThai NVARCHAR(30) NOT NULL CONSTRAINT DF_Phim_TrangThai DEFAULT N''Sắp chiếu'',
        CONSTRAINT CK_Phim_TrangThai CHECK (TrangThai IN (N''Sắp chiếu'', N''Đang chiếu'', N''Ngừng chiếu''))
    );
END;';

PRINT N'Đang chạy 01_CauTruc_Rap_Phong_Ghe.sql';
EXEC sys.sp_executesql N'-- ============================================================================
-- HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM YEUMINHEM CINEMA
-- Script 01: Tạo cấu trúc bảng Rạp, Phòng chiếu, Loại ghế và Ghế
-- Yêu cầu:
--   - KHÔNG xóa database hiện có, KHÔNG xóa bảng Phim.
--   - Có thể chạy lại nhiều lần an toàn (Idempotent).
--   - Ràng buộc toàn vẹn: Khóa chính, Khóa ngoại, Tên phòng duy nhất theo rạp,
--     Vị trí ghế duy nhất theo phòng, Số ghế > 0.
--   - Sức chứa phòng được tính toán động từ danh sách ghế.
-- ============================================================================

USE [YeuMinhEmCinema_Test];';
EXEC sys.sp_executesql N'-- 1. BẢNG LOẠI GHẾ (LoaiGhe)
-- Quản lý các loại ghế trong rạp: Ghế thường, Ghế VIP, Ghế Sweetbox (đôi)...
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = ''LoaiGhe'')
BEGIN
    CREATE TABLE dbo.LoaiGhe (
        MaLoai INT IDENTITY(1,1) CONSTRAINT PK_LoaiGhe PRIMARY KEY,
        TenLoai NVARCHAR(50) NOT NULL CONSTRAINT UQ_LoaiGhe_TenLoai UNIQUE
    );
    PRINT N''-> Đã tạo bảng dbo.LoaiGhe thành công.'';
END
ELSE
BEGIN
    PRINT N''-> Bảng dbo.LoaiGhe đã tồn tại, bỏ qua tạo bảng.'';
END';
EXEC sys.sp_executesql N'-- 2. BẢNG CỤM RẠP (Rap)
-- Quản lý danh sách các cụm rạp trong hệ thống YeuMinhEm Cinema
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = ''Rap'')
BEGIN
    CREATE TABLE dbo.Rap (
        MaRap INT IDENTITY(1,1) CONSTRAINT PK_Rap PRIMARY KEY,
        TenRap NVARCHAR(200) NOT NULL,
        DiaChi NVARCHAR(500) NULL,
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_Rap_TrangThai DEFAULT N''Đang hoạt động''
    );
    PRINT N''-> Đã tạo bảng dbo.Rap thành công.'';
END
ELSE
BEGIN
    PRINT N''-> Bảng dbo.Rap đã tồn tại, bỏ qua tạo bảng.'';
END';
EXEC sys.sp_executesql N'-- 3. BẢNG PHÒNG CHIẾU (PhongChieu)
-- Quản lý phòng chiếu thuộc từng rạp.
-- Ràng buộc: Tên phòng không trùng trong cùng một rạp (UQ_PhongChieu_Rap_Ten).
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = ''PhongChieu'')
BEGIN
    CREATE TABLE dbo.PhongChieu (
        MaPhong INT IDENTITY(1,1) CONSTRAINT PK_PhongChieu PRIMARY KEY,
        MaRap INT NOT NULL,
        TenPhong NVARCHAR(100) NOT NULL,
        DinhDang NVARCHAR(50) NOT NULL CONSTRAINT DF_PhongChieu_DinhDang DEFAULT N''2D'',
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_PhongChieu_TrangThai DEFAULT N''Đang hoạt động'',
        CONSTRAINT FK_PhongChieu_Rap FOREIGN KEY (MaRap) REFERENCES dbo.Rap(MaRap),
        CONSTRAINT UQ_PhongChieu_Rap_Ten UNIQUE (MaRap, TenPhong)
    );
    PRINT N''-> Đã tạo bảng dbo.PhongChieu thành công.'';
END
ELSE
BEGIN
    PRINT N''-> Bảng dbo.PhongChieu đã tồn tại, bỏ qua tạo bảng.'';
END';
EXEC sys.sp_executesql N'-- Tạo index tìm kiếm phòng chiếu theo rạp để tối ưu truy vấn
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''IX_PhongChieu_MaRap'' AND object_id = OBJECT_ID(''dbo.PhongChieu''))
BEGIN
    CREATE NONCLUSTERED INDEX IX_PhongChieu_MaRap ON dbo.PhongChieu(MaRap);
END';
EXEC sys.sp_executesql N'-- 4. BẢNG GHẾ (Ghe)
-- Quản lý các vị trí ghế ngồi trong phòng chiếu.
-- Ràng buộc:
--   - Vị trí ghế không trùng trong cùng một phòng (UQ_Ghe_Phong_ViTri: MaPhong, HangGhe, SoGhe).
--   - Số ghế phải lớn hơn 0 (CK_Ghe_SoGhe: SoGhe > 0).
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = ''Ghe'')
BEGIN
    CREATE TABLE dbo.Ghe (
        MaGhe INT IDENTITY(1,1) CONSTRAINT PK_Ghe PRIMARY KEY,
        MaPhong INT NOT NULL,
        HangGhe VARCHAR(5) NOT NULL,
        SoGhe INT NOT NULL,
        MaLoaiGhe INT NOT NULL,
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_Ghe_TrangThai DEFAULT N''Hoạt động'',
        CONSTRAINT FK_Ghe_PhongChieu FOREIGN KEY (MaPhong) REFERENCES dbo.PhongChieu(MaPhong),
        CONSTRAINT FK_Ghe_LoaiGhe FOREIGN KEY (MaLoaiGhe) REFERENCES dbo.LoaiGhe(MaLoai),
        CONSTRAINT UQ_Ghe_Phong_ViTri UNIQUE (MaPhong, HangGhe, SoGhe),
        CONSTRAINT CK_Ghe_SoGhe CHECK (SoGhe > 0)
    );
    PRINT N''-> Đã tạo bảng dbo.Ghe thành công.'';
END
ELSE
BEGIN
    PRINT N''-> Bảng dbo.Ghe đã tồn tại, bỏ qua tạo bảng.'';
END';
EXEC sys.sp_executesql N'-- Tạo index tìm kiếm ghế theo phòng và loại ghế
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''IX_Ghe_MaPhong'' AND object_id = OBJECT_ID(''dbo.Ghe''))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Ghe_MaPhong ON dbo.Ghe(MaPhong);
END';
EXEC sys.sp_executesql N'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = ''IX_Ghe_MaLoaiGhe'' AND object_id = OBJECT_ID(''dbo.Ghe''))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Ghe_MaLoaiGhe ON dbo.Ghe(MaLoaiGhe);
END';
EXEC sys.sp_executesql N'-- 5. HÀM TÍNH SỨC CHỨA CỦA PHÒNG CHIẾU (Tính động từ danh sách ghế)
-- Đảm bảo sức chứa phòng được tính từ số lượng ghế thực tế trong bảng Ghe.
CREATE OR ALTER FUNCTION dbo.fn_LaySucChuaPhong(@MaPhong INT)
RETURNS INT
AS
BEGIN
    DECLARE @SucChua INT;
    SELECT @SucChua = COUNT(*)
    FROM dbo.Ghe
    WHERE MaPhong = @MaPhong;
    RETURN ISNULL(@SucChua, 0);
END;';
EXEC sys.sp_executesql N'-- 6. VIEW THỐNG KÊ CHI TIẾT PHÒNG CHIẾU VÀ SỨC CHỨA
-- Kết hợp thông tin Rạp, Phòng và tính toán tổng số ghế, số ghế hoạt động, số ghế hỏng.
CREATE OR ALTER VIEW dbo.v_ThongTinPhongChieu
AS
SELECT 
    p.MaPhong,
    p.MaRap,
    r.TenRap,
    r.DiaChi AS DiaChiRap,
    p.TenPhong,
    p.DinhDang,
    p.TrangThai AS TrangThaiPhong,
    r.TrangThai AS TrangThaiRap,
    COUNT(g.MaGhe) AS TongSoGhe,
    COUNT(CASE WHEN g.TrangThai = N''Hoạt động'' THEN 1 END) AS SoGheHoatDong,
    COUNT(CASE WHEN g.TrangThai <> N''Hoạt động'' THEN 1 END) AS SoGheHong
FROM dbo.PhongChieu p
INNER JOIN dbo.Rap r ON p.MaRap = r.MaRap
LEFT JOIN dbo.Ghe g ON p.MaPhong = g.MaPhong
GROUP BY 
    p.MaPhong,
    p.MaRap,
    r.TenRap,
    r.DiaChi,
    p.TenPhong,
    p.DinhDang,
    p.TrangThai,
    r.TrangThai;';
EXEC sys.sp_executesql N'PRINT N''======================================================'';
PRINT N''ĐÃ HOÀN THÀNH CẬP NHẬT CẤU TRÚC DATABASE CHO RẠP - PHÒNG - GHẾ.'';
PRINT N''======================================================'';';

PRINT N'Đang chạy 04_TaoBang_SuatChieu.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'IF OBJECT_ID(N''dbo.SuatChieu'', N''U'') IS NULL
BEGIN
    CREATE TABLE dbo.SuatChieu
    (
        MaSuatChieu INT IDENTITY(1,1)
            CONSTRAINT PK_SuatChieu PRIMARY KEY,

        MaPhim INT NOT NULL,
        MaPhong INT NOT NULL,

        GioBatDau DATETIME2(0) NOT NULL,
        GioKetThuc DATETIME2(0) NOT NULL,

        -- Thời gian dọn phòng sau khi phim kết thúc.
        PhutDonPhong INT NOT NULL
            CONSTRAINT DF_SuatChieu_PhutDonPhong DEFAULT 15,

        TrangThai NVARCHAR(30) NOT NULL
            CONSTRAINT DF_SuatChieu_TrangThai DEFAULT N''Mở bán'',

        CONSTRAINT FK_SuatChieu_Phim
            FOREIGN KEY (MaPhim)
            REFERENCES dbo.Phim(MaPhim),

        CONSTRAINT FK_SuatChieu_PhongChieu
            FOREIGN KEY (MaPhong)
            REFERENCES dbo.PhongChieu(MaPhong),

        CONSTRAINT CK_SuatChieu_ThoiGian
            CHECK (GioKetThuc > GioBatDau),

        CONSTRAINT CK_SuatChieu_PhutDonPhong
            CHECK (PhutDonPhong BETWEEN 0 AND 120),

        CONSTRAINT CK_SuatChieu_TrangThai
            CHECK (TrangThai IN (
                N''Mở bán'',
                N''Ngừng bán'',
                N''Đã hủy''
            ))
    );
END;';
EXEC sys.sp_executesql N'IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N''dbo.SuatChieu'')
      AND name = N''IX_SuatChieu_Phong_GioBatDau''
)
BEGIN
    CREATE INDEX IX_SuatChieu_Phong_GioBatDau
        ON dbo.SuatChieu(MaPhong, GioBatDau)
        INCLUDE (GioKetThuc, PhutDonPhong, TrangThai);
END;';
EXEC sys.sp_executesql N'SELECT * FROM dbo.SuatChieu;';

PRINT N'Đang chạy 05_ThemSuatChieu.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'-- Mọi thao tác ghi lịch dùng cùng khóa tổng trước khóa phòng/dòng.
-- Khóa tổng giúp thống nhất thứ tự khóa giữa thêm, sửa, hủy và sao chép.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoaLich
AS
BEGIN
    SET NOCOUNT ON;
    IF @@TRANCOUNT = 0 THROW 50100, N''Cần transaction để khóa lịch.'', 1;
    DECLARE @k INT;
    EXEC @k=sys.sp_getapplock @Resource=N''SuatChieu_Lich_Write'',
        @LockMode=''Exclusive'', @LockOwner=''Transaction'', @LockTimeout=10000;
    IF @k<0 THROW 50101, N''Lịch đang được cập nhật. Vui lòng thử lại.'', 1;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoaPhong @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    IF @MaPhong IS NULL THROW 50102, N''Chưa chọn phòng.'', 1;
    DECLARE @k INT, @res NVARCHAR(255)=N''SuatChieu_Phong_''+CONVERT(NVARCHAR(20),@MaPhong);
    EXEC @k=sys.sp_getapplock @Resource=@res,
        @LockMode=''Exclusive'', @LockOwner=''Transaction'', @LockTimeout=10000;
    IF @k<0 THROW 50103, N''Phòng đang được cập nhật. Vui lòng thử lại.'', 1;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraSuat
    @MaPhim INT, @MaPhong INT, @GioBatDau DATETIME2(0),
    @PhutDonPhong INT, @GioKetThuc DATETIME2(0) OUTPUT,
    @LoaiTru INT=NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @PhutDonPhong IS NULL OR @PhutDonPhong NOT BETWEEN 0 AND 120
        THROW 50002,N''Thời gian dọn phòng phải từ 0 đến 120 phút.'',1;
    IF @GioBatDau IS NULL OR @GioBatDau<=CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME()))
        THROW 50003,N''Giờ bắt đầu phải ở tương lai.'',1;
    DECLARE @phut INT, @ngay DATE, @tt NVARCHAR(30);
    SELECT @phut=ThoiLuong,@ngay=NgayKhoiChieu,@tt=TrangThai
    FROM dbo.Phim WITH(HOLDLOCK) WHERE MaPhim=@MaPhim;
    IF @phut IS NULL OR @phut<=0 THROW 50004,N''Phim không tồn tại hoặc thời lượng không hợp lệ.'',1;
    IF @tt IS NULL OR @tt NOT IN(N''Sắp chiếu'',N''Đang chiếu'')
        THROW 50005,N''Phim không ở trạng thái được phép xếp lịch.'',1;
    IF @ngay IS NULL OR CAST(@GioBatDau AS DATE)<@ngay
        THROW 50006,N''Suất chiếu không được trước ngày khởi chiếu.'',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu p WITH(HOLDLOCK)
        JOIN dbo.Rap r WITH(HOLDLOCK) ON r.MaRap=p.MaRap
        WHERE p.MaPhong=@MaPhong AND p.TrangThai=N''Đang hoạt động'' AND r.TrangThai=N''Đang hoạt động'')
        THROW 50007,N''Phòng hoặc rạp đã ngừng hoạt động hay không tồn tại.'',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WITH(HOLDLOCK) WHERE MaPhong=@MaPhong AND TrangThai=N''Hoạt động'')
        THROW 50008,N''Phòng chưa có ghế hoạt động.'',1;
    SET @GioKetThuc=DATEADD(MINUTE,@phut,@GioBatDau);
    IF EXISTS(SELECT 1 FROM dbo.SuatChieu WITH(UPDLOCK,HOLDLOCK)
        WHERE MaPhong=@MaPhong AND (@LoaiTru IS NULL OR MaSuatChieu<>@LoaiTru)
        AND TrangThai<>N''Đã hủy''
        AND GioBatDau<DATEADD(MINUTE,@PhutDonPhong,@GioKetThuc)
        AND DATEADD(MINUTE,PhutDonPhong,GioKetThuc)>@GioBatDau)
        THROW 50009,N''Trùng lịch phòng chiếu, bao gồm thời gian dọn phòng.'',1;
END;';
EXEC sys.sp_executesql N'-- Chặn sửa/hủy nếu có bảng nghiệp vụ trực tiếp trỏ tới mã suất.
-- Không giả định dbo.Ve tồn tại. Dùng tên schema/bảng/cột được quote.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX)=N'''',@co BIT=0;
    SELECT @sql=STRING_AGG(CONVERT(NVARCHAR(MAX),N''IF EXISTS(SELECT 1 FROM ''+QUOTENAME(s.name)+N''.''+QUOTENAME(t.name)+
        N'' WITH(UPDLOCK,HOLDLOCK) WHERE ''+QUOTENAME(c.name)+N''=@ma) SET @found=1;''),N'' '')
    FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
    JOIN sys.columns c ON c.object_id=t.object_id
    WHERE t.is_ms_shipped=0 AND t.object_id<>OBJECT_ID(N''dbo.SuatChieu'')
      AND c.name=N''MaSuatChieu'';
    IF LEN(@sql)>0 EXEC sys.sp_executesql @sql,N''@ma INT,@found BIT OUTPUT'',@ma=@MaSuatChieu,@found=@co OUTPUT;
    IF @co=1 THROW 50013,N''Suất có dữ liệu vé/đơn liên quan. Cần xử lý nghiệp vụ liên quan trước khi sửa hoặc hủy.'',1;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_ThemSuatChieu
    @MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.sp_YMC_KhoaLich;
        EXEC dbo.sp_YMC_KhoaPhong @MaPhong;
        DECLARE @ket DATETIME2(0);
        EXEC dbo.sp_YMC_KiemTraSuat @MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong,@ket OUTPUT;
        INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai)
        VALUES(@MaPhim,@MaPhong,@GioBatDau,@ket,@PhutDonPhong,N''Mở bán'');
        DECLARE @ma INT=CONVERT(INT,SCOPE_IDENTITY());
        COMMIT;
        SELECT @ma AS MaSuatChieu,@ket AS GioKetThuc;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;';

PRINT N'Đang chạy 06_SuaSuatChieu.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_SuaSuatChieu
    @MaSuatChieu INT,@MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.sp_YMC_KhoaLich;
        DECLARE @cu INT,@gio DATETIME2(0),@tt NVARCHAR(30);
        SELECT @cu=MaPhong,@gio=GioBatDau,@tt=TrangThai
        FROM dbo.SuatChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaSuatChieu=@MaSuatChieu;
        IF @cu IS NULL THROW 50010,N''Suất chiếu không tồn tại.'',1;
        IF @tt=N''Đã hủy'' THROW 50011,N''Không thể sửa suất đã hủy.'',1;
        IF @gio<=CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) THROW 50012,N''Không thể sửa suất đã bắt đầu.'',1;
        EXEC dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu;
        DECLARE @nho INT=CASE WHEN @cu<@MaPhong THEN @cu ELSE @MaPhong END;
        DECLARE @lon INT=CASE WHEN @cu<@MaPhong THEN @MaPhong ELSE @cu END;
        EXEC dbo.sp_YMC_KhoaPhong @nho;
        IF @lon<>@nho EXEC dbo.sp_YMC_KhoaPhong @lon;
        DECLARE @ket DATETIME2(0);
        EXEC dbo.sp_YMC_KiemTraSuat @MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong,@ket OUTPUT,@MaSuatChieu;
        UPDATE dbo.SuatChieu SET MaPhim=@MaPhim,MaPhong=@MaPhong,GioBatDau=@GioBatDau,
            GioKetThuc=@ket,PhutDonPhong=@PhutDonPhong WHERE MaSuatChieu=@MaSuatChieu;
        COMMIT;
        SELECT @ket AS GioKetThuc;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;';

PRINT N'Đang chạy 07_DoiTrangThaiSuatChieu.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_DoiTrangThaiSuatChieu @MaSuatChieu INT,@TrangThaiMoi NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.sp_YMC_KhoaLich;
        DECLARE @tt NVARCHAR(30),@phong INT,@gio DATETIME2(0);
        SELECT @tt=TrangThai,@phong=MaPhong,@gio=GioBatDau FROM dbo.SuatChieu WITH(UPDLOCK,HOLDLOCK)
        WHERE MaSuatChieu=@MaSuatChieu;
        IF @tt IS NULL THROW 50010,N''Suất chiếu không tồn tại.'',1;
        IF @TrangThaiMoi IS NULL OR @TrangThaiMoi NOT IN(N''Mở bán'',N''Ngừng bán'',N''Đã hủy'')
            THROW 50020,N''Trạng thái không hợp lệ.'',1;
        IF @tt=N''Đã hủy'' THROW 50022,N''Suất đã hủy không thể đổi trạng thái.'',1;
        IF @tt=@TrangThaiMoi THROW 50021,N''Suất đã ở trạng thái yêu cầu.'',1;
        IF @gio<=CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) THROW 50012,N''Không thể đổi trạng thái suất đã bắt đầu.'',1;
        EXEC dbo.sp_YMC_KhoaPhong @phong;
        IF @TrangThaiMoi=N''Đã hủy'' EXEC dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu;
        UPDATE dbo.SuatChieu SET TrangThai=@TrangThaiMoi WHERE MaSuatChieu=@MaSuatChieu;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;';

PRINT N'Đang chạy 08_SaoChepLich.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'-- Xem trước và ghi dùng cùng truy vấn, chữ ký chống ghi khi nguồn đã thay đổi.
CREATE OR ALTER PROCEDURE dbo.sp_SaoChepLich
    @NgayNguon DATE,@NgayDich DATE,@MaRap INT=NULL,@MaPhong INT=NULL,
    @XemTruoc BIT=1,@ChuKy VARCHAR(64)=NULL
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.sp_YMC_KhoaLich;
        IF @NgayNguon IS NULL OR @NgayDich IS NULL OR @NgayNguon=@NgayDich
            THROW 50030,N''Chọn ngày nguồn và đích khác nhau.'',1;
        IF @NgayDich<CAST(CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) AS DATE)
            THROW 50031,N''Ngày đích không được ở quá khứ.'',1;
        DECLARE @src TABLE(MaCu INT PRIMARY KEY,MaPhim INT,MaPhong INT,
            BatDau DATETIME2(0),KetThuc DATETIME2(0),Don INT,TT NVARCHAR(30));
        INSERT @src
        SELECT sc.MaSuatChieu,sc.MaPhim,sc.MaPhong,
            DATEADD(DAY,DATEDIFF(DAY,CAST(sc.GioBatDau AS DATE),@NgayDich),sc.GioBatDau),
            DATEADD(MINUTE,p.ThoiLuong,DATEADD(DAY,DATEDIFF(DAY,CAST(sc.GioBatDau AS DATE),@NgayDich),sc.GioBatDau)),
            sc.PhutDonPhong,sc.TrangThai
        FROM dbo.SuatChieu sc WITH(HOLDLOCK)
        JOIN dbo.Phim p WITH(HOLDLOCK) ON p.MaPhim=sc.MaPhim
        JOIN dbo.PhongChieu pc ON pc.MaPhong=sc.MaPhong
        WHERE sc.GioBatDau>=@NgayNguon AND sc.GioBatDau<DATEADD(DAY,1,@NgayNguon)
          AND sc.TrangThai<>N''Đã hủy'' AND (@MaRap IS NULL OR pc.MaRap=@MaRap)
          AND (@MaPhong IS NULL OR sc.MaPhong=@MaPhong);
        IF NOT EXISTS(SELECT 1 FROM @src) THROW 50032,N''Không có suất nguồn để sao chép.'',1;
        DECLARE @text NVARCHAR(MAX),@sig VARCHAR(64);
        SELECT @text=STRING_AGG(CONVERT(NVARCHAR(MAX),CONCAT(MaCu,'':'',MaPhim,'':'',MaPhong,'':'',
            CONVERT(VARCHAR(19),BatDau,126),'':'',CONVERT(VARCHAR(19),KetThuc,126),'':'',Don,'':'',TT)),N''|'')
            WITHIN GROUP(ORDER BY MaCu) FROM @src;
        SET @sig=CONVERT(VARCHAR(64),HASHBYTES(''SHA2_256'',@text),2);
        IF @XemTruoc IS NULL THROW 50033,N''Chế độ sao chép không hợp lệ.'',1;
        IF @XemTruoc=0 AND (@ChuKy IS NULL OR @ChuKy<>@sig)
            THROW 50034,N''Lịch nguồn đã đổi hoặc chưa xem trước. Vui lòng xem trước lại.'',1;
        DECLARE @ph INT;
        DECLARE cph CURSOR LOCAL FAST_FORWARD FOR SELECT DISTINCT MaPhong FROM @src ORDER BY MaPhong;
        OPEN cph; FETCH NEXT FROM cph INTO @ph;
        WHILE @@FETCH_STATUS=0
        BEGIN
            EXEC dbo.sp_YMC_KhoaPhong @ph;
            FETCH NEXT FROM cph INTO @ph;
        END;
        CLOSE cph; DEALLOCATE cph;
        -- Kiểm tra giao nhau giữa các suất của chính nhóm sau khi tính thời lượng mới.
        IF EXISTS(SELECT 1 FROM @src a JOIN @src b ON a.MaPhong=b.MaPhong AND a.MaCu<b.MaCu
            WHERE a.BatDau<DATEADD(MINUTE,b.Don,b.KetThuc)
              AND b.BatDau<DATEADD(MINUTE,a.Don,a.KetThuc))
            THROW 50035,N''Các suất nguồn chồng nhau sau khi tính lại thời lượng phim.'',1;
        DECLARE @mp INT,@bd DATETIME2(0),@don INT,@kt DATETIME2(0);
        DECLARE cs CURSOR LOCAL FAST_FORWARD FOR SELECT MaPhim,MaPhong,BatDau,Don FROM @src ORDER BY MaPhong,BatDau;
        OPEN cs; FETCH NEXT FROM cs INTO @mp,@ph,@bd,@don;
        WHILE @@FETCH_STATUS=0
        BEGIN
            EXEC dbo.sp_YMC_KiemTraSuat @mp,@ph,@bd,@don,@kt OUTPUT;
            FETCH NEXT FROM cs INTO @mp,@ph,@bd,@don;
        END;
        CLOSE cs; DEALLOCATE cs;
        IF @XemTruoc=1
        BEGIN
            SELECT s.MaCu AS MaSuatNguon,p.TenPhim,r.TenRap,pc.TenPhong,
                s.BatDau AS GioBatDau,s.KetThuc AS GioKetThuc,s.Don AS PhutDonPhong,
                DATEADD(MINUTE,s.Don,s.KetThuc) AS GioSanSang,N''Mở bán'' AS TrangThai,@sig AS ChuKy
            FROM @src s JOIN dbo.Phim p ON p.MaPhim=s.MaPhim
            JOIN dbo.PhongChieu pc ON pc.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=pc.MaRap
            ORDER BY s.BatDau,s.MaCu;
            COMMIT;
            RETURN;
        END;
        INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai)
        SELECT MaPhim,MaPhong,BatDau,KetThuc,Don,N''Mở bán'' FROM @src;
        DECLARE @n INT=@@ROWCOUNT;
        COMMIT;
        SELECT @n AS SoSuatDaTao;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;';

PRINT N'Đang chạy 09_GiaVe_Fnb.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N''dbo.GiaVe'',N''U'') IS NULL
BEGIN
    CREATE TABLE dbo.GiaVe(
        MaGiaVe INT IDENTITY PRIMARY KEY,
        MaLoaiGhe INT NOT NULL REFERENCES dbo.LoaiGhe(MaLoai),
        DinhDang NVARCHAR(50) NOT NULL,
        LoaiNgay NVARCHAR(20) NOT NULL CHECK(LoaiNgay IN(N''Ngày thường'',N''Cuối tuần'')),
        TuNgay DATE NOT NULL,DenNgay DATE NULL,
        DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0 AND DonGia<=1000000000),
        DangApDung BIT NOT NULL DEFAULT 1,
        PhienBan ROWVERSION,
        CHECK(DenNgay IS NULL OR DenNgay>=TuNgay),
        CHECK(LEN(LTRIM(RTRIM(DinhDang)))>0)
    );
    CREATE INDEX IX_GiaVe_Tra ON dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay) INCLUDE(DenNgay,DonGia,DangApDung);
END;
IF OBJECT_ID(N''dbo.FnbSanPham'',N''U'') IS NULL
BEGIN
    CREATE TABLE dbo.FnbSanPham(
        MaSanPham INT IDENTITY PRIMARY KEY,
        MaHang VARCHAR(30) NOT NULL UNIQUE,
        TenSanPham NVARCHAR(150) NOT NULL,
        Nhom NVARCHAR(20) NOT NULL CHECK(Nhom IN(N''Bắp'',N''Nước'',N''Đồ ăn'',N''Combo'')),
        KichCo NVARCHAR(50) NOT NULL,
        DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0 AND DonGia<=1000000000),
        DangBan BIT NOT NULL DEFAULT 1,
        PhienBan ROWVERSION,
        CHECK(LEN(LTRIM(RTRIM(TenSanPham)))>0)
    );
END;
IF OBJECT_ID(N''dbo.FnbComboChiTiet'',N''U'') IS NULL
    CREATE TABLE dbo.FnbComboChiTiet(
        MaCombo INT NOT NULL REFERENCES dbo.FnbSanPham(MaSanPham),
        MaThanhPhan INT NOT NULL REFERENCES dbo.FnbSanPham(MaSanPham),
        SoLuong INT NOT NULL CHECK(SoLuong BETWEEN 1 AND 99),
        PRIMARY KEY(MaCombo,MaThanhPhan),CHECK(MaCombo<>MaThanhPhan)
    );
COMMIT;';
EXEC sys.sp_executesql N'IF TYPE_ID(N''dbo.YMC_FnbThanhPhan'') IS NULL
    EXEC(N''CREATE TYPE dbo.YMC_FnbThanhPhan AS TABLE(MaThanhPhan INT PRIMARY KEY,SoLuong INT NOT NULL)'');';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuGiaVe
    @MaGiaVe INT=NULL,@MaLoaiGhe INT,@DinhDang NVARCHAR(50),@LoaiNgay NVARCHAR(20),
    @TuNgay DATE,@DenNgay DATE=NULL,@DonGia DECIMAL(18,0),@DangApDung BIT,@PhienBan BINARY(8)=NULL
AS
BEGIN
    SET NOCOUNT ON;SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @k INT;
        EXEC @k=sys.sp_getapplock @Resource=N''YMC_GiaVe_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
        IF @k<0 THROW 50200,N''Bảng giá đang cập nhật. Thử lại.'',1;
        SET @DinhDang=LTRIM(RTRIM(@DinhDang));
        IF @DinhDang IS NULL OR LEN(@DinhDang)=0 THROW 50201,N''Nhập định dạng chiếu.'',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WITH(HOLDLOCK) WHERE MaLoai=@MaLoaiGhe)
            THROW 50202,N''Loại ghế không tồn tại.'',1;
        IF @LoaiNgay IS NULL OR @LoaiNgay NOT IN(N''Ngày thường'',N''Cuối tuần'')
            THROW 50203,N''Loại ngày không hợp lệ.'',1;
        IF @TuNgay IS NULL OR (@DenNgay IS NOT NULL AND @DenNgay<@TuNgay)
            THROW 50204,N''Ngày kết thúc phải từ ngày bắt đầu trở đi.'',1;
        IF @DonGia IS NULL OR @DonGia<=0 OR @DonGia>1000000000 OR @DangApDung IS NULL
            THROW 50205,N''Giá phải lớn hơn 0 và không quá 1 tỷ đồng.'',1;
        IF @MaGiaVe IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.GiaVe WITH(UPDLOCK,HOLDLOCK)
            WHERE MaGiaVe=@MaGiaVe AND PhienBan=@PhienBan)
            THROW 50206,N''Bản giá đã đổi hoặc không tồn tại. Tải lại trước khi sửa.'',1;
        IF @DangApDung=1 AND EXISTS(SELECT 1 FROM dbo.GiaVe WITH(UPDLOCK,HOLDLOCK)
            WHERE MaLoaiGhe=@MaLoaiGhe AND DinhDang=@DinhDang AND LoaiNgay=@LoaiNgay AND DangApDung=1
            AND (@MaGiaVe IS NULL OR MaGiaVe<>@MaGiaVe)
            AND TuNgay<=ISNULL(@DenNgay,CONVERT(DATE,''99991231''))
            AND ISNULL(DenNgay,CONVERT(DATE,''99991231''))>=@TuNgay)
            THROW 50207,N''Trùng khoảng áp dụng với một giá đang bật cùng loại ghế, định dạng và loại ngày.'',1;
        IF @MaGiaVe IS NULL
        BEGIN
            INSERT dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay,DenNgay,DonGia,DangApDung)
            VALUES(@MaLoaiGhe,@DinhDang,@LoaiNgay,@TuNgay,@DenNgay,@DonGia,@DangApDung);
            SET @MaGiaVe=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE UPDATE dbo.GiaVe SET MaLoaiGhe=@MaLoaiGhe,DinhDang=@DinhDang,LoaiNgay=@LoaiNgay,
            TuNgay=@TuNgay,DenNgay=@DenNgay,DonGia=@DonGia,DangApDung=@DangApDung WHERE MaGiaVe=@MaGiaVe;
        COMMIT;SELECT @MaGiaVe AS MaGiaVe;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;THROW;
    END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuFnb
    @MaSanPham INT=NULL,@MaHang VARCHAR(30),@TenSanPham NVARCHAR(150),@Nhom NVARCHAR(20),
    @KichCo NVARCHAR(50),@DonGia DECIMAL(18,0),@DangBan BIT,
    @ThanhPhan dbo.YMC_FnbThanhPhan READONLY,@PhienBan BINARY(8)=NULL
AS
BEGIN
    SET NOCOUNT ON;SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @k INT;
        EXEC @k=sys.sp_getapplock @Resource=N''YMC_Fnb_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
        IF @k<0 THROW 50210,N''Menu đang cập nhật. Thử lại.'',1;
        SET @MaHang=UPPER(LTRIM(RTRIM(@MaHang)));SET @TenSanPham=LTRIM(RTRIM(@TenSanPham));
        IF @MaHang IS NULL OR LEN(@MaHang)=0 OR @MaHang COLLATE Latin1_General_100_BIN2 LIKE ''%[^A-Z0-9_-]%''
            THROW 50211,N''Mã hàng chỉ gồm chữ A–Z, số, dấu gạch dưới hoặc gạch ngang.'',1;
        IF @TenSanPham IS NULL OR LEN(@TenSanPham)=0 OR @KichCo IS NULL
            THROW 50212,N''Nhập tên sản phẩm và thông tin kích cỡ.'',1;
        IF @Nhom IS NULL OR @Nhom NOT IN(N''Bắp'',N''Nước'',N''Đồ ăn'',N''Combo'')
            THROW 50213,N''Nhóm sản phẩm không hợp lệ.'',1;
        IF @DonGia IS NULL OR @DonGia<=0 OR @DonGia>1000000000 OR @DangBan IS NULL
            THROW 50214,N''Đơn giá phải lớn hơn 0 và không quá 1 tỷ đồng.'',1;
        IF @MaSanPham IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.FnbSanPham WITH(UPDLOCK,HOLDLOCK)
            WHERE MaSanPham=@MaSanPham AND PhienBan=@PhienBan)
            THROW 50215,N''Sản phẩm đã đổi hoặc không tồn tại. Tải lại trước khi sửa.'',1;
        IF EXISTS(SELECT 1 FROM dbo.FnbSanPham WITH(UPDLOCK,HOLDLOCK)
            WHERE MaHang=@MaHang AND (@MaSanPham IS NULL OR MaSanPham<>@MaSanPham))
            THROW 50216,N''Mã hàng đã được sử dụng.'',1;
        IF @Nhom=N''Combo''
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM @ThanhPhan) THROW 50217,N''Combo phải có ít nhất một thành phần.'',1;
            IF EXISTS(SELECT 1 FROM @ThanhPhan t LEFT JOIN dbo.FnbSanPham p WITH(HOLDLOCK) ON p.MaSanPham=t.MaThanhPhan
                WHERE p.MaSanPham IS NULL OR p.Nhom=N''Combo'' OR t.MaThanhPhan=@MaSanPham
                OR t.SoLuong NOT BETWEEN 1 AND 99)
                THROW 50218,N''Thành phần không hợp lệ; không được lồng combo, tự tham chiếu hoặc số lượng ngoài 1–99.'',1;
            IF @DangBan=1 AND EXISTS(SELECT 1 FROM @ThanhPhan t JOIN dbo.FnbSanPham p WITH(HOLDLOCK)
                ON p.MaSanPham=t.MaThanhPhan WHERE p.DangBan=0)
                THROW 50219,N''Không bật combo có thành phần ngừng bán.'',1;
            IF EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet WITH(HOLDLOCK) WHERE MaThanhPhan=@MaSanPham)
                THROW 50220,N''Sản phẩm đang là thành phần combo khác, không được đổi thành combo.'',1;
        END
        ELSE IF EXISTS(SELECT 1 FROM @ThanhPhan)
            THROW 50221,N''Sản phẩm lẻ không có danh sách thành phần.'',1;
        IF @MaSanPham IS NULL
        BEGIN
            INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia,DangBan)
            VALUES(@MaHang,@TenSanPham,@Nhom,LTRIM(RTRIM(@KichCo)),@DonGia,@DangBan);
            SET @MaSanPham=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE UPDATE dbo.FnbSanPham SET MaHang=@MaHang,TenSanPham=@TenSanPham,Nhom=@Nhom,
            KichCo=LTRIM(RTRIM(@KichCo)),DonGia=@DonGia,DangBan=@DangBan WHERE MaSanPham=@MaSanPham;
        DELETE dbo.FnbComboChiTiet WHERE MaCombo=@MaSanPham;
        IF @Nhom=N''Combo'' INSERT dbo.FnbComboChiTiet(MaCombo,MaThanhPhan,SoLuong)
            SELECT @MaSanPham,MaThanhPhan,SoLuong FROM @ThanhPhan;
        COMMIT;SELECT @MaSanPham AS MaSanPham;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;THROW;
    END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER VIEW dbo.v_YMC_FnbMenu
AS
SELECT p.MaSanPham,p.MaHang,p.TenSanPham,p.Nhom,p.KichCo,p.DonGia,p.DangBan,p.PhienBan,
    CAST(CASE WHEN p.DangBan=0 THEN 0 WHEN p.Nhom<>N''Combo'' THEN 1
        WHEN NOT EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet c WHERE c.MaCombo=p.MaSanPham) THEN 0
        WHEN EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet c JOIN dbo.FnbSanPham tp ON tp.MaSanPham=c.MaThanhPhan
            WHERE c.MaCombo=p.MaSanPham AND (tp.DangBan=0 OR tp.Nhom=N''Combo'')) THEN 0 ELSE 1 END AS BIT) AS CoTheBan
FROM dbo.FnbSanPham p;';
EXEC sys.sp_executesql N'-- Giá bán vé lấy theo ngày chiếu và mỗi mã ghế, không theo ngày mua.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TraGiaTheoSuatGhe @MaSuatChieu INT,@MaGhe INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @loai INT,@dd NVARCHAR(50),@ngay DATE;
    SELECT @loai=g.MaLoaiGhe,@dd=p.DinhDang,@ngay=CAST(s.GioBatDau AS DATE)
    FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
    JOIN dbo.Rap r ON r.MaRap=p.MaRap
    JOIN dbo.Ghe g ON g.MaPhong=p.MaPhong AND g.MaGhe=@MaGhe
    WHERE s.MaSuatChieu=@MaSuatChieu AND s.TrangThai=N''Mở bán''
      AND s.GioBatDau>CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) AND g.TrangThai=N''Hoạt động''
      AND p.TrangThai=N''Đang hoạt động'' AND r.TrangThai=N''Đang hoạt động'';
    IF @loai IS NULL THROW 50230,N''Suất/ghế không hợp lệ hoặc không còn mở bán.'',1;
    DECLARE @ln NVARCHAR(20)=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,''19000101''),@ngay)%7+7)%7>=4 THEN N''Cuối tuần'' ELSE N''Ngày thường'' END;
    IF (SELECT COUNT(*) FROM dbo.GiaVe WHERE MaLoaiGhe=@loai AND DinhDang=@dd AND LoaiNgay=@ln
        AND DangApDung=1 AND TuNgay<=@ngay AND (DenNgay IS NULL OR DenNgay>=@ngay))<>1
        THROW 50231,N''Chưa có giá duy nhất cho loại ghế, định dạng và ngày chiếu này.'',1;
    SELECT MaGiaVe,DonGia,@ln AS LoaiNgay FROM dbo.GiaVe
    WHERE MaLoaiGhe=@loai AND DinhDang=@dd AND LoaiNgay=@ln AND DangApDung=1
      AND TuNgay<=@ngay AND (DenNgay IS NULL OR DenNgay>=@ngay);
END;';

PRINT N'Đang chạy 10_TaiKhoan_PhanQuyen.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'SET XACT_ABORT ON;
DECLARE @seed BIT=CASE WHEN OBJECT_ID(N''dbo.VaiTro'',N''U'') IS NULL THEN 1 ELSE 0 END;
BEGIN TRAN;
IF OBJECT_ID(N''dbo.VaiTro'',N''U'') IS NULL CREATE TABLE dbo.VaiTro(
 MaVaiTro INT IDENTITY PRIMARY KEY,TenVaiTro VARCHAR(50) NOT NULL UNIQUE,
 TenHienThi NVARCHAR(100) NOT NULL,MoTa NVARCHAR(500) NULL,DangHoatDong BIT NOT NULL DEFAULT 1);
IF OBJECT_ID(N''dbo.Quyen'',N''U'') IS NULL CREATE TABLE dbo.Quyen(
 MaQuyen VARCHAR(80) PRIMARY KEY,TenQuyen NVARCHAR(150) NOT NULL,NhomChucNang NVARCHAR(100) NOT NULL,MoTa NVARCHAR(500) NULL);
IF OBJECT_ID(N''dbo.VaiTroQuyen'',N''U'') IS NULL CREATE TABLE dbo.VaiTroQuyen(
 MaVaiTro INT REFERENCES dbo.VaiTro(MaVaiTro),MaQuyen VARCHAR(80) REFERENCES dbo.Quyen(MaQuyen),PRIMARY KEY(MaVaiTro,MaQuyen));
IF OBJECT_ID(N''dbo.TaiKhoan'',N''U'') IS NULL CREATE TABLE dbo.TaiKhoan(
 MaTaiKhoan INT IDENTITY PRIMARY KEY,TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
 MatKhauHash VARCHAR(1000) NOT NULL CHECK(LEN(LTRIM(RTRIM(MatKhauHash)))>0),Email NVARCHAR(254) NULL,
 DangHoatDong BIT NOT NULL DEFAULT 1,SoLanDangNhapSai INT NOT NULL DEFAULT 0 CHECK(SoLanDangNhapSai>=0),
 KhoaDenLuc DATETIME2(0) NULL,NgayTao DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 LanDangNhapCuoi DATETIME2(0) NULL,PhienBan ROWVERSION,
 CHECK(LEN(TenDangNhap) BETWEEN 3 AND 50 AND DATALENGTH(TenDangNhap)=DATALENGTH(LTRIM(RTRIM(TenDangNhap)))
 AND TenDangNhap COLLATE Latin1_General_100_BIN2 NOT LIKE ''%[^a-zA-Z0-9_.-]%''),
 CHECK(Email IS NULL OR LEN(LTRIM(RTRIM(Email)))>0));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N''dbo.TaiKhoan'') AND name=''UX_TaiKhoan_Email'')
 CREATE UNIQUE INDEX UX_TaiKhoan_Email ON dbo.TaiKhoan(Email) WHERE Email IS NOT NULL;
IF OBJECT_ID(N''dbo.TaiKhoanVaiTro'',N''U'') IS NULL CREATE TABLE dbo.TaiKhoanVaiTro(
 MaTaiKhoan INT REFERENCES dbo.TaiKhoan(MaTaiKhoan),MaVaiTro INT REFERENCES dbo.VaiTro(MaVaiTro),PRIMARY KEY(MaTaiKhoan,MaVaiTro));
INSERT dbo.VaiTro(TenVaiTro,TenHienThi,MoTa)
SELECT a,b,b FROM(VALUES(''ADMIN'',N''Quản trị viên''),(''QUAN_LY'',N''Quản lý rạp''),(''BAN_VE'',N''Nhân viên bán vé''),
 (''SOAT_VE'',N''Nhân viên soát vé''),(''KHACH_HANG'',N''Khách hàng''))v(a,b)
WHERE NOT EXISTS(SELECT 1 FROM dbo.VaiTro WHERE TenVaiTro=v.a);
INSERT dbo.Quyen(MaQuyen,TenQuyen,NhomChucNang)
SELECT a,b,c FROM(VALUES
 (''PHIM_XEM'',N''Xem phim'',N''Phim''),(''PHIM_QUAN_LY'',N''Quản lý phim'',N''Phim''),
 (''RAP_XEM'',N''Xem rạp'',N''Rạp''),(''RAP_QUAN_LY'',N''Quản lý rạp/phòng/ghế'',N''Rạp''),
 (''LICH_CHIEU_XEM'',N''Xem lịch'',N''Lịch''),(''LICH_CHIEU_QUAN_LY'',N''Quản lý lịch'',N''Lịch''),
 (''GIA_VE_XEM'',N''Xem giá vé'',N''Giá''),(''GIA_VE_QUAN_LY'',N''Quản lý giá'',N''Giá''),
 (''FNB_XEM'',N''Xem menu'',N''FNB''),(''FNB_QUAN_LY'',N''Quản lý menu'',N''FNB''),
 (''BAN_VE'',N''Bán vé tại quầy'',N''Đơn hàng''),(''DON_HANG_XEM'',N''Xem đơn theo rạp'',N''Đơn hàng''),
 (''DON_HANG_HUY'',N''Hủy đơn'',N''Đơn hàng''),(''HOAN_TIEN'',N''Hoàn tiền'',N''Đơn hàng''),
 (''VE_KIEM_TRA'',N''Kiểm vé'',N''Vé''),(''KHACH_HANG_XEM'',N''Xem khách hàng'',N''Khách hàng''),
 (''KHACH_HANG_QUAN_LY'',N''Quản lý khách hàng'',N''Khách hàng''),(''NHAN_VIEN_QUAN_LY'',N''Quản lý nhân viên'',N''Nhân viên''),
 (''TAI_KHOAN_QUAN_LY'',N''Quản lý tài khoản'',N''Tài khoản''),(''PHAN_QUYEN_QUAN_LY'',N''Phân quyền'',N''Tài khoản''),
 (''BAO_CAO_XEM'',N''Xem báo cáo'',N''Báo cáo''),(''DAT_VE_WEB'',N''Đặt vé online'',N''Web''),
 (''DON_HANG_CA_NHAN'',N''Xem đơn của mình'',N''Web''))v(a,b,c)
WHERE NOT EXISTS(SELECT 1 FROM dbo.Quyen WHERE MaQuyen=v.a);
IF @seed=1
BEGIN
INSERT dbo.VaiTroQuyen SELECT r.MaVaiTro,q.MaQuyen FROM dbo.VaiTro r CROSS JOIN dbo.Quyen q
WHERE r.TenVaiTro=''ADMIN'' AND NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen x WHERE x.MaVaiTro=r.MaVaiTro AND x.MaQuyen=q.MaQuyen);
INSERT dbo.VaiTroQuyen SELECT r.MaVaiTro,v.q FROM(VALUES
 (''QUAN_LY'',''PHIM_XEM''),(''QUAN_LY'',''RAP_XEM''),(''QUAN_LY'',''LICH_CHIEU_XEM''),(''QUAN_LY'',''LICH_CHIEU_QUAN_LY''),
 (''QUAN_LY'',''GIA_VE_XEM''),(''QUAN_LY'',''FNB_XEM''),(''QUAN_LY'',''BAN_VE''),(''QUAN_LY'',''DON_HANG_XEM''),
 (''QUAN_LY'',''DON_HANG_HUY''),(''QUAN_LY'',''HOAN_TIEN''),(''QUAN_LY'',''VE_KIEM_TRA''),(''QUAN_LY'',''KHACH_HANG_XEM''),(''QUAN_LY'',''BAO_CAO_XEM''),
 (''BAN_VE'',''PHIM_XEM''),(''BAN_VE'',''RAP_XEM''),(''BAN_VE'',''LICH_CHIEU_XEM''),(''BAN_VE'',''GIA_VE_XEM''),
 (''BAN_VE'',''FNB_XEM''),(''BAN_VE'',''BAN_VE''),(''BAN_VE'',''DON_HANG_XEM''),(''BAN_VE'',''KHACH_HANG_XEM''),
 (''SOAT_VE'',''VE_KIEM_TRA''),(''KHACH_HANG'',''DAT_VE_WEB''),(''KHACH_HANG'',''DON_HANG_CA_NHAN''))v(r,q)
JOIN dbo.VaiTro r ON r.TenVaiTro=v.r WHERE NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen x WHERE x.MaVaiTro=r.MaVaiTro AND x.MaQuyen=v.q);
END;
COMMIT;';
EXEC sys.sp_executesql N'CREATE OR ALTER VIEW dbo.v_YMC_QuyenTaiKhoan AS
SELECT DISTINCT t.MaTaiKhoan,q.MaQuyen FROM dbo.TaiKhoan t
JOIN dbo.TaiKhoanVaiTro tv ON tv.MaTaiKhoan=t.MaTaiKhoan
JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro JOIN dbo.VaiTroQuyen q ON q.MaVaiTro=v.MaVaiTro
WHERE t.DangHoatDong=1 AND v.DangHoatDong=1 AND (t.KhoaDenLuc IS NULL OR t.KhoaDenLuc<=SYSUTCDATETIME());';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayQuyenTaiKhoan @MaTaiKhoan INT AS
BEGIN SET NOCOUNT ON; SELECT q.* FROM dbo.v_YMC_QuyenTaiKhoan t JOIN dbo.Quyen q ON q.MaQuyen=t.MaQuyen WHERE t.MaTaiKhoan=@MaTaiKhoan; END;';
EXEC sys.sp_executesql N'-- Chỉ backend tin cậy gọi, sau khi kiểm tra mật khẩu bằng PasswordHasher của C#.
-- Không cấp quyền gọi trực tiếp cho trình duyệt hay người dùng cuối.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LayThongTinDangNhap @TenDangNhap VARCHAR(50) AS
BEGIN SET NOCOUNT ON; SELECT MaTaiKhoan,TenDangNhap,MatKhauHash,DangHoatDong,KhoaDenLuc,PhienBan
FROM dbo.TaiKhoan WHERE TenDangNhap=@TenDangNhap; END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_GhiNhanDangNhap
@MaTaiKhoan INT,@ThanhCong BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

IF @ThanhCong IS NULL THROW 50400,N''Thiếu kết quả xác thực.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoan WITH(UPDLOCK,HOLDLOCK) WHERE MaTaiKhoan=@MaTaiKhoan
AND PhienBan=@PhienBan AND DangHoatDong=1 AND (KhoaDenLuc IS NULL OR KhoaDenLuc<=SYSUTCDATETIME()))
 THROW 50401,N''Tài khoản đã đổi hoặc đang khóa. Xác thực lại.'',1;
UPDATE dbo.TaiKhoan SET
 SoLanDangNhapSai=CASE WHEN @ThanhCong=1 OR SoLanDangNhapSai>=4 THEN 0 ELSE SoLanDangNhapSai+1 END,
 KhoaDenLuc=CASE WHEN @ThanhCong=0 AND SoLanDangNhapSai>=4 THEN DATEADD(MINUTE,15,SYSUTCDATETIME()) ELSE NULL END,
 LanDangNhapCuoi=CASE WHEN @ThanhCong=1 THEN SYSUTCDATETIME() ELSE LanDangNhapCuoi END
WHERE MaTaiKhoan=@MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 11_KhachHang_NhanVien.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'SET XACT_ABORT ON;
BEGIN TRAN;
IF OBJECT_ID(N''dbo.KhachHang'',N''U'') IS NULL CREATE TABLE dbo.KhachHang(
 MaKhachHang INT IDENTITY PRIMARY KEY,MaTaiKhoan INT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 HoTen NVARCHAR(150) NOT NULL CHECK(LEN(LTRIM(RTRIM(HoTen)))>0),DienThoai VARCHAR(20) NULL,
 NgaySinh DATE NULL,DangHoatDong BIT NOT NULL DEFAULT 1,NgayTao DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),PhienBan ROWVERSION);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N''dbo.KhachHang'') AND name=''UX_KhachHang_TaiKhoan'')
 CREATE UNIQUE INDEX UX_KhachHang_TaiKhoan ON dbo.KhachHang(MaTaiKhoan) WHERE MaTaiKhoan IS NOT NULL;
IF OBJECT_ID(N''dbo.NhanVien'',N''U'') IS NULL CREATE TABLE dbo.NhanVien(
 MaNhanVien INT IDENTITY PRIMARY KEY,MaTaiKhoan INT NOT NULL UNIQUE REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 HoTen NVARCHAR(150) NOT NULL CHECK(LEN(LTRIM(RTRIM(HoTen)))>0),DienThoai VARCHAR(20) NULL,
 DangLamViec BIT NOT NULL DEFAULT 1,PhienBan ROWVERSION);
IF OBJECT_ID(N''dbo.NhanVienRap'',N''U'') IS NULL CREATE TABLE dbo.NhanVienRap(
 MaNhanVien INT REFERENCES dbo.NhanVien(MaNhanVien),MaRap INT REFERENCES dbo.Rap(MaRap),PRIMARY KEY(MaNhanVien,MaRap));
COMMIT;';
EXEC sys.sp_executesql N'-- ADMIN có phạm vi toàn hệ thống. Nhân viên khác phải được phân công rạp.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan INT,@MaQuyen VARCHAR(80),@MaRap INT=NULL AS
BEGIN
 SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.v_YMC_QuyenTaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan AND MaQuyen=@MaQuyen)
  THROW 50403,N''Tài khoản không có quyền hoặc đang bị khóa.'',1;
 IF @MaRap IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro
 WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro=''ADMIN'' AND v.DangHoatDong=1)
 AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien
 WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)
 THROW 50404,N''Bạn chưa được phân công làm việc tại rạp này.'',1;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoiTaoAdmin
@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@Email NVARCHAR(254)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N''YMC_Account_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @k<0 THROW 50405,N''Tài khoản đang cập nhật.'',1;
IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE v.TenVaiTro=''ADMIN'')
 THROW 50406,N''Đã có quản trị viên. Không thể khởi tạo lần nữa.'',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N''Phải truyền chuỗi băm do C# tạo, không dùng mật khẩu gốc.'',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash,Email) VALUES(@TenDangNhap,@MatKhauHash,NULLIF(LTRIM(RTRIM(@Email)),N''''));
DECLARE @id INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.TaiKhoanVaiTro SELECT @id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=''ADMIN'';
SELECT @id AS MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_DangKyKhachHang
@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@HoTen NVARCHAR(150),@Email NVARCHAR(254)=NULL,@DienThoai VARCHAR(20)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N''YMC_Account_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @k<0 THROW 50405,N''Tài khoản đang cập nhật.'',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N''Thiếu chuỗi băm hợp lệ từ C#.'',1;
IF @HoTen IS NULL OR LEN(LTRIM(RTRIM(@HoTen)))=0 THROW 50408,N''Nhập họ tên.'',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash,Email) VALUES(@TenDangNhap,@MatKhauHash,NULLIF(LTRIM(RTRIM(@Email)),N''''));
DECLARE @id INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.KhachHang(MaTaiKhoan,HoTen,DienThoai) VALUES(@id,LTRIM(RTRIM(@HoTen)),@DienThoai);
INSERT dbo.TaiKhoanVaiTro SELECT @id,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=''KHACH_HANG'' AND DangHoatDong=1;
IF @@ROWCOUNT<>1 THROW 50409,N''Vai trò khách hàng chưa sẵn sàng.'',1;
SELECT @id AS MaTaiKhoan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoNhanVien
@NguoiThucHien INT,@TenDangNhap VARCHAR(50),@MatKhauHash VARCHAR(1000),@HoTen NVARCHAR(150),@MaRap INT,@TenVaiTro VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''NHAN_VIEN_QUAN_LY'';
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''TAI_KHOAN_QUAN_LY'';
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''PHAN_QUYEN_QUAN_LY'';
IF @TenVaiTro IS NULL OR @TenVaiTro NOT IN(''QUAN_LY'',''BAN_VE'',''SOAT_VE'') THROW 50410,N''Vai trò nhân viên không hợp lệ.'',1;
IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50407,N''Thiếu chuỗi băm từ C#.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.Rap WHERE MaRap=@MaRap AND TrangThai=N''Đang hoạt động'') THROW 50411,N''Rạp không hoạt động.'',1;
INSERT dbo.TaiKhoan(TenDangNhap,MatKhauHash) VALUES(@TenDangNhap,@MatKhauHash);
DECLARE @tk INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVien(MaTaiKhoan,HoTen) VALUES(@tk,@HoTen);
DECLARE @nv INT=CONVERT(INT,SCOPE_IDENTITY());
INSERT dbo.NhanVienRap VALUES(@nv,@MaRap);
INSERT dbo.TaiKhoanVaiTro SELECT @tk,MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro AND DangHoatDong=1;
IF @@ROWCOUNT<>1 THROW 50410,N''Vai trò chưa sẵn sàng.'',1;
SELECT @tk AS MaTaiKhoan,@nv AS MaNhanVien;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatKhachHang
@NguoiThucHien INT,@MaKhachHang INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@NgaySinh DATE=NULL,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

IF NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaKhachHang=@MaKhachHang AND MaTaiKhoan=@NguoiThucHien AND DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''KHACH_HANG_QUAN_LY'';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_CA_NHAN'';
IF @NgaySinh>CONVERT(DATE,DATEADD(HOUR,7,SYSUTCDATETIME())) THROW 50412,N''Ngày sinh không hợp lệ.'',1;
UPDATE dbo.KhachHang SET HoTen=@HoTen,DienThoai=@DienThoai,NgaySinh=@NgaySinh WHERE MaKhachHang=@MaKhachHang AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50413,N''Hồ sơ đã đổi. Tải lại.'',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 12_DonHang_Ve_ThanhToan.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'SET XACT_ABORT ON;
BEGIN TRAN;
IF OBJECT_ID(N''dbo.DonHang'',N''U'') IS NULL CREATE TABLE dbo.DonHang(
 MaDonHang BIGINT IDENTITY PRIMARY KEY,MaThamChieu UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() UNIQUE,
 MaYeuCau UNIQUEIDENTIFIER NOT NULL UNIQUE,MaSuatChieu INT NOT NULL REFERENCES dbo.SuatChieu(MaSuatChieu),
 MaKhachHang INT NULL REFERENCES dbo.KhachHang(MaKhachHang),NguoiTao INT NOT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 Kenh VARCHAR(10) NOT NULL CHECK(Kenh IN(''WEB'',''QUAY'')),
 TrangThai VARCHAR(20) NOT NULL DEFAULT ''CHO_THANH_TOAN'' CHECK(TrangThai IN(''CHO_THANH_TOAN'',''DA_THANH_TOAN'',''DA_HUY'',''HET_HAN'',''DA_HOAN_TIEN'')),
 NgayTaoUtc DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),HanThanhToanUtc DATETIME2(0) NOT NULL,
 TongTien DECIMAL(18,0) NOT NULL CHECK(TongTien>0),HoTenLienHe NVARCHAR(150) NOT NULL,DienThoaiLienHe VARCHAR(20) NULL,
 LyDoHuy NVARCHAR(500) NULL,PhienBan ROWVERSION);
IF OBJECT_ID(N''dbo.ChiTietVe'',N''U'') IS NULL CREATE TABLE dbo.ChiTietVe(
 MaDonHang BIGINT REFERENCES dbo.DonHang(MaDonHang),MaGhe INT REFERENCES dbo.Ghe(MaGhe),
 MaGiaVe INT NOT NULL REFERENCES dbo.GiaVe(MaGiaVe),DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0),
 TenPhim NVARCHAR(200) NOT NULL,TenRap NVARCHAR(200) NOT NULL,TenPhong NVARCHAR(100) NOT NULL,
 NhanGhe NVARCHAR(20) NOT NULL,GioBatDau DATETIME2(0) NOT NULL,PRIMARY KEY(MaDonHang,MaGhe));
IF OBJECT_ID(N''dbo.ChiTietDonFnb'',N''U'') IS NULL CREATE TABLE dbo.ChiTietDonFnb(
 MaDonHang BIGINT REFERENCES dbo.DonHang(MaDonHang),MaSanPham INT REFERENCES dbo.FnbSanPham(MaSanPham),
 TenSanPham NVARCHAR(150) NOT NULL,SoLuong INT NOT NULL CHECK(SoLuong BETWEEN 1 AND 99),
 DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0),PRIMARY KEY(MaDonHang,MaSanPham));
IF OBJECT_ID(N''dbo.ChiTietComboDaBan'',N''U'') IS NULL CREATE TABLE dbo.ChiTietComboDaBan(
 MaDonHang BIGINT NOT NULL,MaSanPham INT NOT NULL,MaThanhPhan INT NOT NULL REFERENCES dbo.FnbSanPham(MaSanPham),
 TenThanhPhan NVARCHAR(150) NOT NULL,SoLuongTrongCombo INT NOT NULL CHECK(SoLuongTrongCombo>0),
 PRIMARY KEY(MaDonHang,MaSanPham,MaThanhPhan),
 FOREIGN KEY(MaDonHang,MaSanPham) REFERENCES dbo.ChiTietDonFnb(MaDonHang,MaSanPham));
-- Chỗ đang giữ hoặc đã bán; khóa chính là ràng buộc chống bán trùng.
IF OBJECT_ID(N''dbo.GiuGhe'',N''U'') IS NULL CREATE TABLE dbo.GiuGhe(
 MaSuatChieu INT REFERENCES dbo.SuatChieu(MaSuatChieu),MaGhe INT REFERENCES dbo.Ghe(MaGhe),
 MaDonHang BIGINT NOT NULL REFERENCES dbo.DonHang(MaDonHang),PRIMARY KEY(MaSuatChieu,MaGhe));
IF OBJECT_ID(N''dbo.ThanhToan'',N''U'') IS NULL CREATE TABLE dbo.ThanhToan(
 MaThanhToan BIGINT IDENTITY PRIMARY KEY,MaDonHang BIGINT NOT NULL UNIQUE REFERENCES dbo.DonHang(MaDonHang),
 MaGiaoDich VARCHAR(100) NOT NULL UNIQUE,PhuongThuc VARCHAR(20) NOT NULL CHECK(PhuongThuc IN(''TIEN_MAT'',''CHUYEN_KHOAN'',''CONG_THANH_TOAN'')),
 SoTien DECIMAL(18,0) NOT NULL CHECK(SoTien>0),NgayThuUtc DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 NguoiXacNhan INT NOT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan));
IF OBJECT_ID(N''dbo.Ve'',N''U'') IS NULL CREATE TABLE dbo.Ve(
 MaVe UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() PRIMARY KEY,
 MaDonHang BIGINT NOT NULL,MaGhe INT NOT NULL,
 TrangThai VARCHAR(20) NOT NULL DEFAULT ''HIEU_LUC'' CHECK(TrangThai IN(''HIEU_LUC'',''DA_SU_DUNG'',''DA_HUY'')),
 NgayPhatHanhUtc DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 NgaySoatUtc DATETIME2(0) NULL,NguoiSoat INT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan),
 UNIQUE(MaDonHang,MaGhe),FOREIGN KEY(MaDonHang,MaGhe) REFERENCES dbo.ChiTietVe(MaDonHang,MaGhe));
IF OBJECT_ID(N''dbo.HoanTien'',N''U'') IS NULL CREATE TABLE dbo.HoanTien(
 MaHoanTien BIGINT IDENTITY PRIMARY KEY,MaDonHang BIGINT NOT NULL UNIQUE REFERENCES dbo.ThanhToan(MaDonHang),
 MaGiaoDichHoan VARCHAR(100) NOT NULL UNIQUE,SoTien DECIMAL(18,0) NOT NULL CHECK(SoTien>0),
 LyDo NVARCHAR(500) NOT NULL CHECK(LEN(LTRIM(RTRIM(LyDo)))>0),NgayHoanUtc DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 NguoiThucHien INT NOT NULL REFERENCES dbo.TaiKhoan(MaTaiKhoan));
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N''dbo.DonHang'') AND name=''IX_DonHang_Cho'')
 CREATE INDEX IX_DonHang_Cho ON dbo.DonHang(TrangThai,HanThanhToanUtc) INCLUDE(MaSuatChieu,MaKhachHang);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N''dbo.GiuGhe'') AND name=''IX_GiuGhe_Don'')
 CREATE INDEX IX_GiuGhe_Don ON dbo.GiuGhe(MaDonHang);
COMMIT;';
EXEC sys.sp_executesql N'IF TYPE_ID(N''dbo.YMC_DanhSachGhe'') IS NULL EXEC(N''CREATE TYPE dbo.YMC_DanhSachGhe AS TABLE(MaGhe INT PRIMARY KEY)'');
IF TYPE_ID(N''dbo.YMC_DanhSachFnb'') IS NULL EXEC(N''CREATE TYPE dbo.YMC_DanhSachFnb AS TABLE(MaSanPham INT PRIMARY KEY,SoLuong INT NOT NULL)'');';
EXEC sys.sp_executesql N'-- Giờ suất chiếu: giờ Việt Nam không kèm offset; thời điểm giao dịch: UTC.
CREATE OR ALTER FUNCTION dbo.fn_YMC_GioVietNam() RETURNS DATETIME2(0) AS
BEGIN RETURN CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())); END;';

PRINT N'Đang chạy 13_DatVe_GiuGhe.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_DonDepGheHetHan

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

UPDATE dbo.DonHang SET TrangThai=''HET_HAN''
WHERE TrangThai=''CHO_THANH_TOAN'' AND HanThanhToanUtc<=SYSUTCDATETIME();
DELETE g FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang
WHERE d.TrangThai IN(''HET_HAN'',''DA_HUY'',''DA_HOAN_TIEN'');

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoDonGiuGhe

@NguoiThucHien INT,@MaYeuCau UNIQUEIDENTIFIER,@MaSuatChieu INT,@Kenh VARCHAR(10),
@DanhSachGhe dbo.YMC_DanhSachGhe READONLY,@DanhSachFnb dbo.YMC_DanhSachFnb READONLY,
@HoTenLienHe NVARCHAR(150),@DienThoaiLienHe VARCHAR(20)=NULL,@MaKhachHang INT=NULL

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@phong INT,@phim INT,@batdau DATETIME2(0),@dd NVARCHAR(50),@ngay DATE,@loaiNgay NVARCHAR(20);
SELECT @rap=p.MaRap,@phong=s.MaPhong,@phim=s.MaPhim,@batdau=s.GioBatDau,@dd=p.DinhDang
FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
WHERE s.MaSuatChieu=@MaSuatChieu AND s.TrangThai=N''Mở bán'' AND s.GioBatDau>dbo.fn_YMC_GioVietNam()
AND p.TrangThai=N''Đang hoạt động'' AND r.TrangThai=N''Đang hoạt động'' AND f.TrangThai=N''Đang chiếu'';
IF @Kenh IS NULL OR @Kenh NOT IN(''WEB'',''QUAY'') THROW 50301,N''Kênh bán không hợp lệ.'',1;
IF @rap IS NULL THROW 50302,N''Suất chiếu không còn mở bán hoặc rạp/phòng/phim đã ngừng hoạt động.'',1;
IF @Kenh=''WEB''
BEGIN
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DAT_VE_WEB'';
 SET @MaKhachHang=NULL;
 SELECT @MaKhachHang=MaKhachHang FROM dbo.KhachHang WHERE MaTaiKhoan=@NguoiThucHien AND DangHoatDong=1;
 IF @MaKhachHang IS NULL THROW 50303,N''Không tìm thấy hồ sơ khách hàng đang hoạt động.'',1;
END
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''BAN_VE'',@rap;
IF @MaKhachHang IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaKhachHang=@MaKhachHang AND DangHoatDong=1)
 THROW 50303,N''Khách hàng không hợp lệ.'',1;
IF @MaYeuCau IS NULL THROW 50304,N''Thiếu mã yêu cầu chống tạo đơn lặp.'',1;
-- Một mã yêu cầu là một lệnh bất biến; muốn đổi nội dung phải dùng mã mới.
IF EXISTS(SELECT 1 FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau AND NguoiTao=@NguoiThucHien AND MaSuatChieu=@MaSuatChieu AND Kenh=@Kenh)
  THROW 50305,N''Mã yêu cầu đã được dùng cho giao dịch khác.'',1;
 SELECT MaDonHang,MaThamChieu,TrangThai,TongTien,HanThanhToanUtc FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau;
 COMMIT; RETURN;
END;
IF (SELECT COUNT(*) FROM @DanhSachGhe) NOT BETWEEN 1 AND 8 THROW 50306,N''Mỗi đơn phải có từ 1 đến 8 ghế.'',1;
IF @HoTenLienHe IS NULL OR LEN(LTRIM(RTRIM(@HoTenLienHe)))=0 THROW 50307,N''Nhập tên liên hệ.'',1;
IF (SELECT COUNT(*) FROM @DanhSachFnb)>20 OR EXISTS(SELECT 1 FROM @DanhSachFnb WHERE SoLuong NOT BETWEEN 1 AND 99)
 THROW 50308,N''Số lượng bắp nước không hợp lệ.'',1;
UPDATE dbo.DonHang SET TrangThai=''HET_HAN'' WHERE TrangThai=''CHO_THANH_TOAN'' AND HanThanhToanUtc<=SYSUTCDATETIME();
DELETE g FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang WHERE d.TrangThai IN(''HET_HAN'',''DA_HUY'',''DA_HOAN_TIEN'');
IF EXISTS(SELECT 1 FROM @DanhSachGhe x LEFT JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
 WHERE g.MaGhe IS NULL OR g.MaPhong<>@phong OR g.TrangThai<>N''Hoạt động'') THROW 50309,N''Ghế không hợp lệ hoặc đã ngừng sử dụng.'',1;
IF EXISTS(SELECT 1 FROM @DanhSachGhe x JOIN dbo.GiuGhe g ON g.MaGhe=x.MaGhe WHERE g.MaSuatChieu=@MaSuatChieu)
 THROW 50310,N''Một trong các ghế đã có người giữ hoặc đã bán.'',1;
-- Đồng bộ với thủ tục sửa bảng giá và menu của file 09.
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_GiaVe_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50311,N''Bảng giá đang cập nhật.'',1;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Fnb_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50312,N''Menu đang cập nhật.'',1;
SET @ngay=CONVERT(DATE,@batdau);
SET @loaiNgay=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,''19000101''),@ngay)%7+7)%7>=4 THEN N''Cuối tuần'' ELSE N''Ngày thường'' END;
IF EXISTS(SELECT x.MaGhe FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
 LEFT JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay
 AND v.DangApDung=1 AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay)
 GROUP BY x.MaGhe HAVING COUNT(v.MaGiaVe)<>1) THROW 50313,N''Chưa có bảng giá duy nhất cho các ghế đã chọn.'',1;
IF EXISTS(SELECT 1 FROM @DanhSachFnb x LEFT JOIN dbo.v_YMC_FnbMenu p ON p.MaSanPham=x.MaSanPham
 WHERE p.MaSanPham IS NULL OR p.CoTheBan=0) THROW 50314,N''Sản phẩm hoặc combo không còn bán.'',1;
DECLARE @tong DECIMAL(18,0),@don BIGINT,@han DATETIME2(0)=DATEADD(MINUTE,10,SYSUTCDATETIME());
IF @han>DATEADD(HOUR,-7,@batdau) SET @han=DATEADD(HOUR,-7,@batdau);
SELECT @tong=SUM(v.DonGia) FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay
AND v.DangApDung=1 AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay);
SELECT @tong=@tong+ISNULL(SUM(p.DonGia*x.SoLuong),0) FROM @DanhSachFnb x JOIN dbo.FnbSanPham p ON p.MaSanPham=x.MaSanPham;
INSERT dbo.DonHang(MaYeuCau,MaSuatChieu,MaKhachHang,NguoiTao,Kenh,HanThanhToanUtc,TongTien,HoTenLienHe,DienThoaiLienHe)
VALUES(@MaYeuCau,@MaSuatChieu,@MaKhachHang,@NguoiThucHien,@Kenh,@han,@tong,@HoTenLienHe,@DienThoaiLienHe);
SET @don=CONVERT(BIGINT,SCOPE_IDENTITY());
INSERT dbo.ChiTietVe(MaDonHang,MaGhe,MaGiaVe,DonGia,TenPhim,TenRap,TenPhong,NhanGhe,GioBatDau)
SELECT @don,g.MaGhe,v.MaGiaVe,v.DonGia,f.TenPhim,r.TenRap,p.TenPhong,CONCAT(g.HangGhe,g.SoGhe),@batdau
FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong
JOIN dbo.Rap r ON r.MaRap=p.MaRap CROSS JOIN dbo.Phim f
JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay AND v.DangApDung=1
AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay) WHERE f.MaPhim=@phim;
INSERT dbo.ChiTietDonFnb SELECT @don,p.MaSanPham,p.TenSanPham,x.SoLuong,p.DonGia FROM @DanhSachFnb x JOIN dbo.FnbSanPham p ON p.MaSanPham=x.MaSanPham;
INSERT dbo.ChiTietComboDaBan SELECT @don,c.MaCombo,c.MaThanhPhan,p.TenSanPham,c.SoLuong
FROM @DanhSachFnb x JOIN dbo.FnbComboChiTiet c ON c.MaCombo=x.MaSanPham JOIN dbo.FnbSanPham p ON p.MaSanPham=c.MaThanhPhan;
INSERT dbo.GiuGhe SELECT @MaSuatChieu,MaGhe,@don FROM @DanhSachGhe;
SELECT MaDonHang,MaThamChieu,TrangThai,TongTien,HanThanhToanUtc FROM dbo.DonHang WHERE MaDonHang=@don;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_SoDoGheTheoSuat
@MaSuatChieu INT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

SELECT g.MaGhe,g.HangGhe,g.SoGhe,l.TenLoai,
CASE WHEN g.TrangThai<>N''Hoạt động'' THEN N''Không sử dụng''
 WHEN d.TrangThai=''DA_THANH_TOAN'' THEN N''Đã bán''
 WHEN d.TrangThai=''CHO_THANH_TOAN'' AND d.HanThanhToanUtc>SYSUTCDATETIME() THEN N''Đang giữ'' ELSE N''Trống'' END AS TinhTrang
FROM dbo.SuatChieu s JOIN dbo.Ghe g ON g.MaPhong=s.MaPhong JOIN dbo.LoaiGhe l ON l.MaLoai=g.MaLoaiGhe
LEFT JOIN dbo.GiuGhe h ON h.MaSuatChieu=s.MaSuatChieu AND h.MaGhe=g.MaGhe LEFT JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
WHERE s.MaSuatChieu=@MaSuatChieu ORDER BY g.HangGhe,g.SoGhe;

END;';

PRINT N'Đang chạy 14_BanVe_ThanhToan.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_XacNhanThanhToan

@NguoiThucHien INT,@MaDonHang BIGINT,@MaGiaoDich VARCHAR(100),@PhuongThuc VARCHAR(20),@SoTien DECIMAL(18,0)

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@tt VARCHAR(20),@tong DECIMAL(18,0),@han DATETIME2(0),@suat INT,@batdau DATETIME2(0);
SELECT @rap=p.MaRap,@tt=d.TrangThai,@tong=d.TongTien,@han=d.HanThanhToanUtc,@suat=s.MaSuatChieu,@batdau=s.GioBatDau
FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N''Không tìm thấy đơn hàng.'',1;
-- Cả tiền mặt và giao dịch online đều do nhân viên/backend đã được cấp quyền xác nhận.
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''BAN_VE'',@rap;
SET @MaGiaoDich=LTRIM(RTRIM(@MaGiaoDich));
IF @MaGiaoDich IS NULL OR LEN(@MaGiaoDich)=0 OR @PhuongThuc IS NULL OR @PhuongThuc NOT IN(''TIEN_MAT'',''CHUYEN_KHOAN'',''CONG_THANH_TOAN'')
 THROW 50321,N''Thiếu mã giao dịch hoặc phương thức không hợp lệ.'',1;
IF @SoTien IS NULL OR @SoTien<>@tong THROW 50322,N''Số tiền không khớp với đơn hàng.'',1;
IF @tt=''DA_THANH_TOAN''
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.ThanhToan WHERE MaDonHang=@MaDonHang AND MaGiaoDich=@MaGiaoDich AND PhuongThuc=@PhuongThuc AND SoTien=@SoTien)
  THROW 50323,N''Đơn đã được thanh toán bằng giao dịch khác.'',1;
 SELECT * FROM dbo.Ve WHERE MaDonHang=@MaDonHang; COMMIT; RETURN;
END;
IF @tt<>''CHO_THANH_TOAN'' OR @han<=SYSUTCDATETIME() OR @batdau<=dbo.fn_YMC_GioVietNam()
 THROW 50324,N''Đơn không còn chờ thanh toán hoặc đã hết hạn. Không ghi nhận thu tiền.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
WHERE s.MaSuatChieu=@suat AND s.TrangThai=N''Mở bán'' AND p.TrangThai=N''Đang hoạt động'' AND r.TrangThai=N''Đang hoạt động'')
 THROW 50325,N''Suất hoặc rạp/phòng đã ngừng bán.'',1;
IF EXISTS(SELECT 1 FROM dbo.ChiTietVe c JOIN dbo.Ghe g ON g.MaGhe=c.MaGhe WHERE c.MaDonHang=@MaDonHang AND g.TrangThai<>N''Hoạt động'')
 THROW 50326,N''Ghế đã ngừng hoạt động.'',1;
IF EXISTS(SELECT 1 FROM dbo.ChiTietVe c WHERE c.MaDonHang=@MaDonHang AND NOT EXISTS(
 SELECT 1 FROM dbo.GiuGhe g WHERE g.MaDonHang=c.MaDonHang AND g.MaGhe=c.MaGhe AND g.MaSuatChieu=@suat))
 THROW 50327,N''Đơn đã mất quyền giữ ghế.'',1;
INSERT dbo.ThanhToan(MaDonHang,MaGiaoDich,PhuongThuc,SoTien,NguoiXacNhan) VALUES(@MaDonHang,@MaGiaoDich,@PhuongThuc,@SoTien,@NguoiThucHien);
UPDATE dbo.DonHang SET TrangThai=''DA_THANH_TOAN'' WHERE MaDonHang=@MaDonHang;
INSERT dbo.Ve(MaDonHang,MaGhe) SELECT MaDonHang,MaGhe FROM dbo.ChiTietVe WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.Ve WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_XemChiTietDon
@NguoiThucHien INT,@MaDonHang BIGINT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

DECLARE @rap INT;
SELECT @rap=p.MaRap FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N''Không tìm thấy đơn.'',1;
IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
 WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_CA_NHAN'';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_XEM'',@rap;
SELECT * FROM dbo.DonHang WHERE MaDonHang=@MaDonHang;
SELECT c.*,v.MaVe,v.TrangThai AS TrangThaiVe FROM dbo.ChiTietVe c LEFT JOIN dbo.Ve v ON v.MaDonHang=c.MaDonHang AND v.MaGhe=c.MaGhe WHERE c.MaDonHang=@MaDonHang;
SELECT * FROM dbo.ChiTietDonFnb WHERE MaDonHang=@MaDonHang;
SELECT MaThanhToan,MaGiaoDich,PhuongThuc,SoTien,NgayThuUtc FROM dbo.ThanhToan WHERE MaDonHang=@MaDonHang;
SELECT MaHoanTien,MaGiaoDichHoan,SoTien,LyDo,NgayHoanUtc FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.ChiTietComboDaBan WHERE MaDonHang=@MaDonHang;

END;';

PRINT N'Đang chạy 15_HuyDon_HoanTien.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_HuyDonChuaThanhToan
@NguoiThucHien INT,@MaDonHang BIGINT,@LyDo NVARCHAR(500)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@tt VARCHAR(20);
SELECT @rap=p.MaRap,@tt=d.TrangThai FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N''Không tìm thấy đơn.'',1;
IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_CA_NHAN'';
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_HUY'',@rap;
IF @tt=''DA_HUY'' BEGIN COMMIT;RETURN;END;
IF @tt<>''CHO_THANH_TOAN'' THROW 50330,N''Chỉ hủy trực tiếp đơn chưa thanh toán.'',1;
IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 THROW 50331,N''Nhập lý do hủy.'',1;
UPDATE dbo.DonHang SET TrangThai=''DA_HUY'',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_GhiNhanHoanTien
@NguoiThucHien INT,@MaDonHang BIGINT,@MaGiaoDichHoan VARCHAR(100),@LyDo NVARCHAR(500)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@tt VARCHAR(20),@batdau DATETIME2(0),@tong DECIMAL(18,0);
SELECT @rap=p.MaRap,@tt=d.TrangThai,@batdau=s.GioBatDau,@tong=d.TongTien FROM dbo.DonHang d
JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
IF @rap IS NULL THROW 50320,N''Không tìm thấy đơn.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''HOAN_TIEN'',@rap;
IF @tt=''DA_HOAN_TIEN''
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang AND MaGiaoDichHoan=@MaGiaoDichHoan)
 THROW 50332,N''Đơn đã hoàn bằng giao dịch khác.'',1;
 SELECT * FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;COMMIT;RETURN;
END;
IF @tt<>''DA_THANH_TOAN'' OR @batdau<=dbo.fn_YMC_GioVietNam() THROW 50333,N''Chỉ hoàn toàn bộ đơn đã thanh toán trước giờ chiếu.'',1;
IF EXISTS(SELECT 1 FROM dbo.Ve WHERE MaDonHang=@MaDonHang AND TrangThai=''DA_SU_DUNG'') THROW 50334,N''Đơn đã có vé sử dụng, không được hoàn.'',1;
IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 OR @MaGiaoDichHoan IS NULL OR LEN(LTRIM(RTRIM(@MaGiaoDichHoan)))=0
 THROW 50335,N''Nhập lý do và mã giao dịch hoàn thực tế.'',1;
-- Chỉ ghi nhận sau khi nhân viên/backend đã thực hiện hoàn tiền ngoài hệ thống.
INSERT dbo.HoanTien(MaDonHang,MaGiaoDichHoan,SoTien,LyDo,NguoiThucHien) VALUES(@MaDonHang,@MaGiaoDichHoan,@tong,@LyDo,@NguoiThucHien);
UPDATE dbo.DonHang SET TrangThai=''DA_HOAN_TIEN'',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
UPDATE dbo.Ve SET TrangThai=''DA_HUY'' WHERE MaDonHang=@MaDonHang;
DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;
SELECT * FROM dbo.HoanTien WHERE MaDonHang=@MaDonHang;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 16_KiemTraVe.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraVe
@NguoiThucHien INT,@MaVe UNIQUEIDENTIFIER,@XacNhanVaoRap BIT=0
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@tt VARCHAR(20),@don BIGINT,@batdau DATETIME2(0),@ketthuc DATETIME2(0);
SELECT @rap=p.MaRap,@tt=v.TrangThai,@don=v.MaDonHang,@batdau=s.GioBatDau,@ketthuc=s.GioKetThuc
FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE v.MaVe=@MaVe AND d.TrangThai=''DA_THANH_TOAN'' AND s.TrangThai<>N''Đã hủy'';
IF @rap IS NULL THROW 50340,N''Vé không tồn tại hoặc không hợp lệ.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''VE_KIEM_TRA'',@rap;
IF @tt<>''HIEU_LUC'' THROW 50341,N''Vé đã được sử dụng hoặc đã hủy.'',1;
IF @XacNhanVaoRap=1
BEGIN
 IF dbo.fn_YMC_GioVietNam()<DATEADD(MINUTE,-30,@batdau) OR dbo.fn_YMC_GioVietNam()>=@ketthuc
 THROW 50342,N''Chỉ cho vào từ 30 phút trước giờ chiếu đến trước khi suất kết thúc.'',1;
 UPDATE dbo.Ve SET TrangThai=''DA_SU_DUNG'',NgaySoatUtc=SYSUTCDATETIME(),NguoiSoat=@NguoiThucHien WHERE MaVe=@MaVe;
END;
SELECT v.MaVe,v.TrangThai,v.NgaySoatUtc,c.TenPhim,c.TenRap,c.TenPhong,c.NhanGhe,c.GioBatDau
FROM dbo.Ve v JOIN dbo.ChiTietVe c ON c.MaDonHang=v.MaDonHang AND c.MaGhe=v.MaGhe WHERE v.MaVe=@MaVe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 17_QuanLyDanhMuc.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuPhim
@NguoiThucHien INT,@MaPhim INT=NULL,@TenPhim NVARCHAR(200),@ThoiLuong INT,@NgayKhoiChieu DATE,
@GioiHanTuoi VARCHAR(10),@TrangThai NVARCHAR(30),@MoTa NVARCHAR(MAX)=NULL,@Poster NVARCHAR(500)=NULL,@Trailer NVARCHAR(500)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''PHIM_QUAN_LY'';
IF @TenPhim IS NULL OR LEN(LTRIM(RTRIM(@TenPhim)))=0 OR @ThoiLuong IS NULL OR @ThoiLuong NOT BETWEEN 1 AND 600
 THROW 50500,N''Tên phim và thời lượng 1–600 phút là bắt buộc.'',1;
IF @GioiHanTuoi IS NULL OR @GioiHanTuoi NOT IN(''P'',''K'',''T13'',''T16'',''T18'') THROW 50501,N''Giới hạn tuổi hợp lệ: P, K, T13, T16, T18.'',1;
IF @NgayKhoiChieu IS NULL OR @TrangThai IS NULL OR @TrangThai NOT IN(N''Sắp chiếu'',N''Đang chiếu'',N''Ngừng chiếu'') THROW 50502,N''Ngày khởi chiếu hoặc trạng thái không hợp lệ.'',1;
IF @MaPhim IS NULL
BEGIN
 INSERT dbo.Phim(TenPhim,MoTa,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai)
 VALUES(@TenPhim,@MoTa,@ThoiLuong,@NgayKhoiChieu,@GioiHanTuoi,@Poster,@Trailer,@TrangThai);
 SET @MaPhim=CONVERT(INT,SCOPE_IDENTITY());
END
ELSE
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.Phim WHERE MaPhim=@MaPhim) THROW 50503,N''Phim không tồn tại.'',1;
 IF EXISTS(SELECT 1 FROM dbo.SuatChieu WHERE MaPhim=@MaPhim AND TrangThai<>N''Đã hủy'' AND GioBatDau>dbo.fn_YMC_GioVietNam())
 AND EXISTS(SELECT 1 FROM dbo.Phim WHERE MaPhim=@MaPhim AND (ThoiLuong<>@ThoiLuong OR NgayKhoiChieu<>@NgayKhoiChieu OR TrangThai<>@TrangThai OR GioiHanTuoi<>@GioiHanTuoi))
 THROW 50504,N''Phim có lịch tương lai. Xử lý lịch trước khi đổi thời lượng, ngày chiếu, giới hạn tuổi hoặc trạng thái.'',1;
 UPDATE dbo.Phim SET TenPhim=@TenPhim,MoTa=@MoTa,ThoiLuong=@ThoiLuong,NgayKhoiChieu=@NgayKhoiChieu,
 GioiHanTuoi=@GioiHanTuoi,Poster=@Poster,Trailer=@Trailer,TrangThai=@TrangThai WHERE MaPhim=@MaPhim;
END;
SELECT @MaPhim AS MaPhim;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuRap
@NguoiThucHien INT,@MaRap INT=NULL,@TenRap NVARCHAR(200),@DiaChi NVARCHAR(500)=NULL,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''RAP_QUAN_LY'';
IF @TenRap IS NULL OR LEN(LTRIM(RTRIM(@TenRap)))=0 OR @TrangThai IS NULL OR @TrangThai NOT IN(N''Đang hoạt động'',N''Ngừng hoạt động'') THROW 50505,N''Tên rạp hoặc trạng thái không hợp lệ.'',1;
IF @MaRap IS NULL
BEGIN INSERT dbo.Rap(TenRap,DiaChi,TrangThai) VALUES(@TenRap,@DiaChi,@TrangThai);SET @MaRap=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF @TrangThai<>N''Đang hoạt động'' AND EXISTS(SELECT 1 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND s.TrangThai<>N''Đã hủy'' AND s.GioKetThuc>dbo.fn_YMC_GioVietNam())
 THROW 50506,N''Rạp có lịch chưa kết thúc. Xử lý lịch trước khi ngừng hoạt động.'',1;
 UPDATE dbo.Rap SET TenRap=@TenRap,DiaChi=@DiaChi,TrangThai=@TrangThai WHERE MaRap=@MaRap;
 IF @@ROWCOUNT<>1 THROW 50507,N''Không tìm thấy rạp.'',1;
END; SELECT @MaRap AS MaRap;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuPhong
@NguoiThucHien INT,@MaPhong INT=NULL,@MaRap INT,@TenPhong NVARCHAR(100),@DinhDang NVARCHAR(50),@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''RAP_QUAN_LY'';
IF @TenPhong IS NULL OR LEN(LTRIM(RTRIM(@TenPhong)))=0 OR @DinhDang IS NULL OR LEN(LTRIM(RTRIM(@DinhDang)))=0
 OR @TrangThai IS NULL OR @TrangThai NOT IN(N''Đang hoạt động'',N''Ngừng hoạt động'') THROW 50508,N''Thông tin phòng không hợp lệ.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.Rap WHERE MaRap=@MaRap AND TrangThai=N''Đang hoạt động'') THROW 50507,N''Rạp không hoạt động.'',1;
IF @MaPhong IS NULL
BEGIN INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@MaRap,@TenPhong,@DinhDang,@TrangThai);SET @MaPhong=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.SuatChieu WHERE MaPhong=@MaPhong AND TrangThai<>N''Đã hủy'' AND GioKetThuc>dbo.fn_YMC_GioVietNam())
 AND EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong AND (MaRap<>@MaRap OR DinhDang<>@DinhDang OR TrangThai<>@TrangThai))
 THROW 50509,N''Phòng có lịch chưa kết thúc, chưa thể chuyển rạp/định dạng/trạng thái.'',1;
 UPDATE dbo.PhongChieu SET MaRap=@MaRap,TenPhong=@TenPhong,DinhDang=@DinhDang,TrangThai=@TrangThai WHERE MaPhong=@MaPhong;
 IF @@ROWCOUNT<>1 THROW 50510,N''Không tìm thấy phòng.'',1;
END;SELECT @MaPhong AS MaPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuGhe
@NguoiThucHien INT,@MaGhe INT=NULL,@MaPhong INT,@HangGhe VARCHAR(5),@SoGhe INT,@MaLoaiGhe INT,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''RAP_QUAN_LY'';
IF @HangGhe IS NULL OR LEN(LTRIM(RTRIM(@HangGhe)))=0 OR @SoGhe IS NULL OR @SoGhe<1 OR @TrangThai IS NULL
 OR @TrangThai NOT IN(N''Hoạt động'',N''Hỏng/Ngừng sử dụng'') THROW 50511,N''Thông tin ghế không hợp lệ.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50512,N''Phòng hoặc loại ghế không tồn tại.'',1;
IF @MaGhe IS NULL
BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,@HangGhe,@SoGhe,@MaLoaiGhe,@TrangThai);SET @MaGhe=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE g.MaGhe=@MaGhe AND s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND (d.TrangThai=''DA_THANH_TOAN'' OR (d.TrangThai=''CHO_THANH_TOAN'' AND d.HanThanhToanUtc>SYSUTCDATETIME())))
 THROW 50513,N''Ghế đang giữ hoặc có vé chưa kết thúc suất, chưa được sửa.'',1;
 IF EXISTS(SELECT 1 FROM dbo.ChiTietVe WHERE MaGhe=@MaGhe) AND EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaGhe=@MaGhe AND MaPhong<>@MaPhong)
 THROW 50514,N''Ghế có lịch sử giao dịch không được chuyển phòng.'',1;
 UPDATE dbo.Ghe SET MaPhong=@MaPhong,HangGhe=@HangGhe,SoGhe=@SoGhe,MaLoaiGhe=@MaLoaiGhe,TrangThai=@TrangThai WHERE MaGhe=@MaGhe;
 IF @@ROWCOUNT<>1 THROW 50515,N''Không tìm thấy ghế.'',1;
END; SELECT @MaGhe AS MaGhe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuLoaiGhe
@NguoiThucHien INT,@MaLoai INT=NULL,@TenLoai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''RAP_QUAN_LY'';
IF @TenLoai IS NULL OR LEN(LTRIM(RTRIM(@TenLoai)))=0 THROW 50516,N''Nhập tên loại ghế.'',1;
IF @MaLoai IS NULL BEGIN INSERT dbo.LoaiGhe(TenLoai) VALUES(@TenLoai);SET @MaLoai=CONVERT(INT,SCOPE_IDENTITY());END
ELSE BEGIN UPDATE dbo.LoaiGhe SET TenLoai=@TenLoai WHERE MaLoai=@MaLoai;IF @@ROWCOUNT<>1 THROW 50517,N''Không tìm thấy loại ghế.'',1;END;
SELECT @MaLoai AS MaLoai;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiTrangThaiTaiKhoan
@NguoiThucHien INT,@MaTaiKhoan INT,@DangHoatDong BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''TAI_KHOAN_QUAN_LY'';
IF @MaTaiKhoan=@NguoiThucHien THROW 50520,N''Không tự vô hiệu hóa tài khoản của mình.'',1;
DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N''YMC_Account_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @k<0 THROW 50405,N''Tài khoản đang cập nhật.'',1;
-- Chỉ ADMIN được thay đổi tài khoản ADMIN; tránh tài khoản đặc quyền tùy biến vượt cấp.
IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro=''ADMIN'')
 THROW 50521,N''Bản đồ án không cho vô hiệu hóa ADMIN qua màn hình này.'',1;
UPDATE dbo.TaiKhoan SET DangHoatDong=@DangHoatDong WHERE MaTaiKhoan=@MaTaiKhoan AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50522,N''Tài khoản đã đổi, hãy tải lại.'',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiMatKhau
@MaTaiKhoan INT,@MatKhauHashMoi VARCHAR(1000),@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

-- Backend phải xác thực mật khẩu cũ hoặc luồng khôi phục trước khi gọi.
IF @MatKhauHashMoi IS NULL OR LEN(@MatKhauHashMoi)<40 THROW 50407,N''Thiếu chuỗi băm mật khẩu từ C#.'',1;
UPDATE dbo.TaiKhoan SET MatKhauHash=@MatKhauHashMoi,SoLanDangNhapSai=0,KhoaDenLuc=NULL
WHERE MaTaiKhoan=@MaTaiKhoan AND DangHoatDong=1 AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50522,N''Tài khoản đã đổi hoặc ngừng hoạt động.'',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 18_BaoCao_ThongKe.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_BaoCaoDoanhThu
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''BAO_CAO_XEM'',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>=''99991231''
 THROW 50600,N''Chọn rạp và khoảng ngày hợp lệ.'',1;
DECLARE @tu DATETIME2(0)=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay)),
 @den DATETIME2(0)=DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)));
;WITH dong AS(
 SELECT CONVERT(DATE,DATEADD(HOUR,7,t.NgayThuUtc)) Ngay,t.SoTien TienThu,CONVERT(DECIMAL(18,0),0) TienHoan
 FROM dbo.ThanhToan t JOIN dbo.DonHang d ON d.MaDonHang=t.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND t.NgayThuUtc>=@tu AND t.NgayThuUtc<@den
 UNION ALL SELECT CONVERT(DATE,DATEADD(HOUR,7,h.NgayHoanUtc)),0,h.SoTien FROM dbo.HoanTien h
 JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
 JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND h.NgayHoanUtc>=@tu AND h.NgayHoanUtc<@den)
SELECT Ngay,SUM(TienThu) TienDaThu,SUM(TienHoan) TienDaHoan,SUM(TienThu-TienHoan) DoanhThuThuan FROM dong GROUP BY Ngay ORDER BY Ngay;

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKePhim
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''BAO_CAO_XEM'',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>=''99991231'' THROW 50600,N''Khoảng ngày không hợp lệ.'',1;
;WITH suat AS(
 SELECT s.MaSuatChieu,s.MaPhim,(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=s.MaPhong AND g.TrangThai=N''Hoạt động'') SucChua
 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND s.TrangThai<>N''Đã hủy''
 AND s.GioBatDau>=@TuNgay AND s.GioBatDau<DATEADD(DAY,1,@DenNgay)),ban AS(
 SELECT d.MaSuatChieu,COUNT(*) SoVe,SUM(c.DonGia) TienVe FROM dbo.DonHang d JOIN dbo.ChiTietVe c ON c.MaDonHang=d.MaDonHang
 WHERE d.TrangThai=''DA_THANH_TOAN'' GROUP BY d.MaSuatChieu)
SELECT f.MaPhim,f.TenPhim,COUNT(*) SoSuat,SUM(s.SucChua) TongGheHienTai,SUM(ISNULL(b.SoVe,0)) VeDaBan,
SUM(ISNULL(b.TienVe,0)) TienVe,CAST(100.0*SUM(ISNULL(b.SoVe,0))/NULLIF(SUM(s.SucChua),0) AS DECIMAL(8,2)) TyLeLapDay
FROM suat s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim LEFT JOIN ban b ON b.MaSuatChieu=s.MaSuatChieu GROUP BY f.MaPhim,f.TenPhim;

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_ThongKeFnb
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''BAO_CAO_XEM'',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>=''99991231'' THROW 50600,N''Khoảng ngày không hợp lệ.'',1;
SELECT c.MaSanPham,c.TenSanPham,SUM(c.SoLuong) SoLuong,SUM(c.SoLuong*c.DonGia) TienBan
FROM dbo.ChiTietDonFnb c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang JOIN dbo.ThanhToan t ON t.MaDonHang=d.MaDonHang
JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
WHERE p.MaRap=@MaRap AND d.TrangThai=''DA_THANH_TOAN''
AND t.NgayThuUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
AND t.NgayThuUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)))
GROUP BY c.MaSanPham,c.TenSanPham ORDER BY SoLuong DESC;

END;';

PRINT N'Đang chạy 19_TruyVan_Web.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebDanhSachPhim
@TrangThai NVARCHAR(30)=NULL,@TuKhoa NVARCHAR(200)=NULL,@Trang INT=1,@KichThuocTrang INT=12
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N''Phân trang không hợp lệ.'',1;
SELECT MaPhim,TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai,COUNT(*) OVER() TongKetQua
FROM dbo.Phim WHERE TrangThai IN(N''Đang chiếu'',N''Sắp chiếu'') AND (@TrangThai IS NULL OR TrangThai=@TrangThai)
AND (@TuKhoa IS NULL OR CHARINDEX(@TuKhoa,TenPhim)>0) ORDER BY NgayKhoiChieu DESC,MaPhim DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebChiTietPhim
@MaPhim INT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

SELECT MaPhim,TenPhim,MoTa,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai FROM dbo.Phim
WHERE MaPhim=@MaPhim AND TrangThai IN(N''Đang chiếu'',N''Sắp chiếu'');

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebLichChieu
@MaPhim INT,@Ngay DATE,@MaRap INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

IF @Ngay IS NULL OR @Ngay>=''99991231'' THROW 50611,N''Ngày không hợp lệ.'',1;
SELECT s.MaSuatChieu,r.MaRap,r.TenRap,r.DiaChi,p.TenPhong,p.DinhDang,s.GioBatDau,s.GioKetThuc,
(SELECT COUNT(*) FROM dbo.Ghe g WHERE g.MaPhong=p.MaPhong AND g.TrangThai=N''Hoạt động'' AND NOT EXISTS(
 SELECT 1 FROM dbo.GiuGhe h JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
 WHERE h.MaSuatChieu=s.MaSuatChieu AND h.MaGhe=g.MaGhe AND(d.TrangThai=''DA_THANH_TOAN'' OR(d.TrangThai=''CHO_THANH_TOAN'' AND d.HanThanhToanUtc>SYSUTCDATETIME())))) SoGheTrong
FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
JOIN dbo.Phim f ON f.MaPhim=s.MaPhim WHERE s.MaPhim=@MaPhim AND (@MaRap IS NULL OR r.MaRap=@MaRap)
AND s.TrangThai=N''Mở bán'' AND s.GioBatDau>dbo.fn_YMC_GioVietNam() AND s.GioBatDau>=@Ngay AND s.GioBatDau<DATEADD(DAY,1,@Ngay)
AND p.TrangThai=N''Đang hoạt động'' AND r.TrangThai=N''Đang hoạt động'' AND f.TrangThai=N''Đang chiếu'' ORDER BY r.MaRap,s.GioBatDau;

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebDonHangCuaToi
@MaTaiKhoan INT,@Trang INT=1,@KichThuocTrang INT=20
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan,''DON_HANG_CA_NHAN'';
IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N''Phân trang không hợp lệ.'',1;
SELECT d.MaDonHang,d.MaThamChieu,d.TrangThai,d.TongTien,d.NgayTaoUtc,d.HanThanhToanUtc,COUNT(*) OVER() TongKetQua
FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
WHERE k.MaTaiKhoan=@MaTaiKhoan AND k.DangHoatDong=1 ORDER BY d.MaDonHang DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_DanhSachDonAdmin
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@TrangThai VARCHAR(20)=NULL,@Trang INT=1,@KichThuocTrang INT=50
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''DON_HANG_XEM'',@MaRap;
IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>=''99991231'' THROW 50600,N''Chọn rạp và khoảng ngày.'',1;
IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100 THROW 50610,N''Phân trang không hợp lệ.'',1;
SELECT d.*,COUNT(*) OVER() TongKetQua FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND (@TrangThai IS NULL OR d.TrangThai=@TrangThai)
AND d.NgayTaoUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
AND d.NgayTaoUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay))) ORDER BY d.MaDonHang DESC
OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;

END;';

PRINT N'Đang chạy 21_QuanTriTaiKhoan.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_GanVaiTro
@NguoiThucHien INT,@MaTaiKhoan INT,@TenVaiTro VARCHAR(50),@Cap BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''PHAN_QUYEN_QUAN_LY'';
DECLARE @k INT,@vt INT;
EXEC @k=sys.sp_getapplock @Resource=N''YMC_Account_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @k<0 THROW 50405,N''Tài khoản đang cập nhật.'',1;
IF @Cap IS NULL OR @TenVaiTro IS NULL THROW 50530,N''Thiếu thông tin phân quyền.'',1;
-- Giữ ADMIN cố định; bootstrap là đường duy nhất tạo ADMIN đầu tiên trong bản này.
IF @TenVaiTro=''ADMIN'' OR EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro=''ADMIN'')
 THROW 50531,N''Không chỉnh vai trò ADMIN bằng thủ tục này.'',1;
IF @MaTaiKhoan=@NguoiThucHien THROW 50532,N''Không tự thay đổi vai trò của mình.'',1;
SELECT @vt=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro AND DangHoatDong=1;
IF @vt IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.TaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan) THROW 50533,N''Tài khoản hoặc vai trò không tồn tại.'',1;
IF @Cap=1 AND @TenVaiTro IN(''QUAN_LY'',''BAN_VE'',''SOAT_VE'') AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaTaiKhoan=@MaTaiKhoan AND DangLamViec=1)
 THROW 50534,N''Cần hồ sơ nhân viên đang làm việc trước khi cấp vai trò.'',1;
IF @Cap=1 AND @TenVaiTro=''KHACH_HANG'' AND NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaTaiKhoan=@MaTaiKhoan AND DangHoatDong=1)
 THROW 50535,N''Cần hồ sơ khách hàng trước khi cấp vai trò.'',1;
IF @Cap=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@MaTaiKhoan AND MaVaiTro=@vt) INSERT dbo.TaiKhoanVaiTro VALUES(@MaTaiKhoan,@vt);END
ELSE DELETE dbo.TaiKhoanVaiTro WHERE MaTaiKhoan=@MaTaiKhoan AND MaVaiTro=@vt;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapQuyenVaiTro
@NguoiThucHien INT,@TenVaiTro VARCHAR(50),@MaQuyen VARCHAR(80),@Cap BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''PHAN_QUYEN_QUAN_LY'';
IF @TenVaiTro IS NULL OR @TenVaiTro=''ADMIN'' OR @Cap IS NULL THROW 50536,N''Không sửa quyền ADMIN hoặc thiếu thông tin.'',1;
DECLARE @k INT,@vt INT;
EXEC @k=sys.sp_getapplock @Resource=N''YMC_Account_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @k<0 THROW 50405,N''Tài khoản đang cập nhật.'',1;
SELECT @vt=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro;
IF @vt IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Quyen WHERE MaQuyen=@MaQuyen) THROW 50537,N''Vai trò hoặc quyền không tồn tại.'',1;
IF @Cap=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.VaiTroQuyen WHERE MaVaiTro=@vt AND MaQuyen=@MaQuyen) INSERT dbo.VaiTroQuyen VALUES(@vt,@MaQuyen);END
ELSE DELETE dbo.VaiTroQuyen WHERE MaVaiTro=@vt AND MaQuyen=@MaQuyen;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatNhanVien
@NguoiThucHien INT,@MaNhanVien INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@DangLamViec BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''NHAN_VIEN_QUAN_LY'';
IF EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaNhanVien=@MaNhanVien AND MaTaiKhoan=@NguoiThucHien) THROW 50538,N''Không tự sửa tình trạng nhân sự của mình.'',1;
UPDATE dbo.NhanVien SET HoTen=@HoTen,DienThoai=@DienThoai,DangLamViec=@DangLamViec WHERE MaNhanVien=@MaNhanVien AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50539,N''Nhân viên đã đổi, hãy tải lại.'',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_PhanCongRap
@NguoiThucHien INT,@MaNhanVien INT,@MaRap INT,@PhanCong BIT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''NHAN_VIEN_QUAN_LY'';
IF @PhanCong IS NULL THROW 50540,N''Thiếu trạng thái phân công.'',1;
IF NOT EXISTS(SELECT 1 FROM dbo.NhanVien WITH(UPDLOCK,HOLDLOCK) WHERE MaNhanVien=@MaNhanVien) THROW 50541,N''Không tìm thấy nhân viên.'',1;
IF @PhanCong=1 BEGIN IF NOT EXISTS(SELECT 1 FROM dbo.NhanVienRap WHERE MaNhanVien=@MaNhanVien AND MaRap=@MaRap) INSERT dbo.NhanVienRap VALUES(@MaNhanVien,@MaRap);END
ELSE DELETE dbo.NhanVienRap WHERE MaNhanVien=@MaNhanVien AND MaRap=@MaRap;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';

PRINT N'Đang chạy 22_TichHop_PhanQuyen_Lich_Gia.sql';
EXEC sys.sp_executesql N'USE YeuMinhEmCinema_Test;';
EXEC sys.sp_executesql N'SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminThemSuatChieu
@NguoiThucHien INT,@MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT;SELECT @rap=MaRap FROM dbo.PhongChieu WHERE MaPhong=@MaPhong;
IF @rap IS NULL THROW 50510,N''Không tìm thấy phòng.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''LICH_CHIEU_QUAN_LY'',@rap;
EXEC dbo.sp_ThemSuatChieu @MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminSuaSuatChieu
@NguoiThucHien INT,@MaSuatChieu INT,@MaPhim INT,@MaPhong INT,@GioBatDau DATETIME2(0),@PhutDonPhong INT=15
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT,@rapMoi INT;
SELECT @rap=p.MaRap FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE s.MaSuatChieu=@MaSuatChieu;
SELECT @rapMoi=MaRap FROM dbo.PhongChieu WHERE MaPhong=@MaPhong;
IF @rap IS NULL OR @rapMoi IS NULL THROW 50510,N''Không tìm thấy suất hoặc phòng.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''LICH_CHIEU_QUAN_LY'',@rap;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''LICH_CHIEU_QUAN_LY'',@rapMoi;
EXEC dbo.sp_SuaSuatChieu @MaSuatChieu,@MaPhim,@MaPhong,@GioBatDau,@PhutDonPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminDoiTrangThaiSuat
@NguoiThucHien INT,@MaSuatChieu INT,@TrangThaiMoi NVARCHAR(30)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

DECLARE @rap INT;SELECT @rap=p.MaRap FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE s.MaSuatChieu=@MaSuatChieu;
IF @rap IS NULL THROW 50010,N''Không tìm thấy suất.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''LICH_CHIEU_QUAN_LY'',@rap;
EXEC dbo.sp_DoiTrangThaiSuatChieu @MaSuatChieu,@TrangThaiMoi;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminSaoChepLich
@NguoiThucHien INT,@NgayNguon DATE,@NgayDich DATE,@MaRap INT,@MaPhong INT=NULL,@XemTruoc BIT=1,@ChuKy VARCHAR(64)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N''YMC_Booking_Write'',@LockMode=''Exclusive'',@LockOwner=''Transaction'',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N''Hệ thống đặt vé đang bận. Vui lòng thử lại.'',1;

IF @MaRap IS NULL THROW 50507,N''Chọn rạp trước khi sao chép.'',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''LICH_CHIEU_QUAN_LY'',@MaRap;
IF @MaPhong IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong AND MaRap=@MaRap) THROW 50510,N''Phòng không thuộc rạp.'',1;
EXEC dbo.sp_SaoChepLich @NgayNguon,@NgayDich,@MaRap,@MaPhong,@XemTruoc,@ChuKy;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminLuuGiaVe
@NguoiThucHien INT,@MaGiaVe INT=NULL,@MaLoaiGhe INT,@DinhDang NVARCHAR(50),@LoaiNgay NVARCHAR(20),@TuNgay DATE,@DenNgay DATE=NULL,@DonGia DECIMAL(18,0),@DangApDung BIT,@PhienBan BINARY(8)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''GIA_VE_QUAN_LY'';
EXEC dbo.sp_YMC_LuuGiaVe @MaGiaVe,@MaLoaiGhe,@DinhDang,@LoaiNgay,@TuNgay,@DenNgay,@DonGia,@DangApDung,@PhienBan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminLuuFnb
@NguoiThucHien INT,@MaSanPham INT=NULL,@MaHang VARCHAR(30),@TenSanPham NVARCHAR(150),@Nhom NVARCHAR(20),@KichCo NVARCHAR(50),@DonGia DECIMAL(18,0),@DangBan BIT,@ThanhPhan dbo.YMC_FnbThanhPhan READONLY,@PhienBan BINARY(8)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,''FNB_QUAN_LY'';
EXEC dbo.sp_YMC_LuuFnb @MaSanPham,@MaHang,@TenSanPham,@Nhom,@KichCo,@DonGia,@DangBan,@ThanhPhan,@PhienBan;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;';
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu INT AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM dbo.DonHang WITH(UPDLOCK,HOLDLOCK) WHERE MaSuatChieu=@MaSuatChieu
 AND(TrangThai=''DA_THANH_TOAN'' OR(TrangThai=''CHO_THANH_TOAN'' AND HanThanhToanUtc>SYSUTCDATETIME())))
 THROW 50013,N''Suất có đơn đã thanh toán hoặc đang giữ ghế. Xử lý đơn trước khi sửa/hủy.'',1;
 DECLARE @sql NVARCHAR(MAX)=N'''',@co BIT=0;
 SELECT @sql=STRING_AGG(CONVERT(NVARCHAR(MAX),N''IF EXISTS(SELECT 1 FROM ''+QUOTENAME(s.name)+N''.''+QUOTENAME(t.name)+
 N'' WITH(UPDLOCK,HOLDLOCK) WHERE ''+QUOTENAME(c.name)+N''=@ma) SET @found=1;''),N'' '')
 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id JOIN sys.columns c ON c.object_id=t.object_id
 WHERE t.is_ms_shipped=0 AND t.object_id NOT IN(OBJECT_ID(N''dbo.SuatChieu''),OBJECT_ID(N''dbo.DonHang''),OBJECT_ID(N''dbo.GiuGhe'')) AND c.name=N''MaSuatChieu'';
 IF LEN(@sql)>0 EXEC sys.sp_executesql @sql,N''@ma INT,@found BIT OUTPUT'',@ma=@MaSuatChieu,@found=@co OUTPUT;
 IF @co=1 THROW 50013,N''Suất có dữ liệu liên quan ngoài đơn hàng. Cần kiểm tra trước khi sửa/hủy.'',1;
END;';

COMMIT;
PRINT N'HOÀN TẤT CẤU TRÚC SQL. Dữ liệu mẫu chưa được thêm.';
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
GO

-- Bổ sung WinForms 23, chạy cuối cùng.
USE YeuMinhEmCinema_Test;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER FUNCTION dbo.fn_YMC_CoPhamViRap(@MaTaiKhoan INT,@MaRap INT) RETURNS BIT AS
BEGIN
 DECLARE @ok BIT=0;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan t WHERE t.MaTaiKhoan=@MaTaiKhoan AND t.DangHoatDong=1 AND(t.KhoaDenLuc IS NULL OR t.KhoaDenLuc<=SYSUTCDATETIME()))
 AND(EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 OR EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)) SET @ok=1;
 RETURN @ok;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoKhachTaiQuay @NguoiThucHien INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@NgaySinh DATE=NULL AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'KHACH_HANG_QUAN_LY';
 IF @HoTen IS NULL OR LEN(LTRIM(RTRIM(@HoTen)))=0 THROW 50700,N'Nhập họ tên khách.',1;
 IF @NgaySinh>CONVERT(DATE,dbo.fn_YMC_GioVietNam()) THROW 50701,N'Ngày sinh không hợp lệ.',1;
 INSERT dbo.KhachHang(HoTen,DienThoai,NgaySinh) VALUES(LTRIM(RTRIM(@HoTen)),@DienThoai,@NgaySinh);
 SELECT CONVERT(INT,SCOPE_IDENTITY()) MaKhachHang;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiTrangThaiKhach @NguoiThucHien INT,@MaKhachHang INT,@DangHoatDong BIT,@PhienBan BINARY(8) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'KHACH_HANG_QUAN_LY';
 UPDATE dbo.KhachHang SET DangHoatDong=@DangHoatDong WHERE MaKhachHang=@MaKhachHang AND PhienBan=@PhienBan;
 IF @@ROWCOUNT<>1 THROW 50702,N'Hồ sơ đã thay đổi. Tải lại.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminDatLaiMatKhau @NguoiThucHien INT,@MaTaiKhoan INT,@MatKhauHash VARCHAR(1000),@PhienBan BINARY(8) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'TAI_KHOAN_QUAN_LY';
 IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50703,N'Thiếu hash mật khẩu.',1;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN')
 THROW 50704,N'ADMIN phải tự đổi mật khẩu bằng mật khẩu hiện tại.',1;
 UPDATE dbo.TaiKhoan SET MatKhauHash=@MatKhauHash,SoLanDangNhapSai=0,KhoaDenLuc=NULL WHERE MaTaiKhoan=@MaTaiKhoan AND PhienBan=@PhienBan;
 IF @@ROWCOUNT<>1 THROW 50705,N'Tài khoản đã đổi, hãy tải lại.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoGheTheoLo @NguoiThucHien INT,@MaPhong INT,@SoHang INT,@SoGheMoiHang INT,@MaLoaiGhe INT AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY
 BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
 IF @SoHang IS NULL OR @SoHang NOT BETWEEN 1 AND 26 OR @SoGheMoiHang IS NULL OR @SoGheMoiHang NOT BETWEEN 1 AND 50 THROW 50706,N'Giới hạn 1–26 hàng, 1–50 ghế/hàng.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Phòng/loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu WHERE s.MaPhong=@MaPhong AND s.GioKetThuc>dbo.fn_YMC_GioVietNam()
 AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50708,N'Phòng có đơn/vé chưa kết thúc, không thay đổi sức chứa lúc này.',1;
 DECLARE @h INT=1,@s INT,@them INT=0;
 WHILE @h<=@SoHang BEGIN SET @s=1;WHILE @s<=@SoGheMoiHang BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong AND HangGhe=CHAR(64+@h) AND SoGhe=@s)
 BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,CHAR(64+@h),@s,@MaLoaiGhe,N'Hoạt động');SET @them+=1;END;
 SET @s+=1;END;SET @h+=1;END;
 COMMIT;SELECT @them SoGheDaTao,@SoHang*@SoGheMoiHang-@them SoGheBoQua;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatLoGhe @NguoiThucHien INT,@Ghe dbo.YMC_DanhSachGhe READONLY,@MaLoaiGhe INT=NULL,@TrangThai NVARCHAR(50)=NULL AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
 IF NOT EXISTS(SELECT 1 FROM @Ghe) OR(@MaLoaiGhe IS NULL AND @TrangThai IS NULL) THROW 50709,N'Chọn ghế và thông tin cần cập nhật.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x LEFT JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe WHERE g.MaGhe IS NULL) THROW 50710,N'Ghế không tồn tại.',1;
 IF @TrangThai IS NOT NULL AND @TrangThai NOT IN(N'Hoạt động',N'Hỏng/Ngừng sử dụng') THROW 50711,N'Trạng thái ghế không hợp lệ.',1;
 IF @MaLoaiGhe IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x JOIN dbo.GiuGhe g ON g.MaGhe=x.MaGhe JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50712,N'Có ghế đang giữ hoặc vé chưa kết thúc. Không sửa cả lô.',1;
 UPDATE g SET MaLoaiGhe=ISNULL(@MaLoaiGhe,g.MaLoaiGhe),TrangThai=ISNULL(@TrangThai,g.TrangThai) FROM dbo.Ghe g JOIN @Ghe x ON x.MaGhe=g.MaGhe;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
IF TYPE_ID(N'dbo.YMC_MaQuyen') IS NULL EXEC(N'CREATE TYPE dbo.YMC_MaQuyen AS TABLE(MaQuyen VARCHAR(80) PRIMARY KEY)');
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuBoQuyenVaiTro @NguoiThucHien INT,@TenVaiTro VARCHAR(50),@Quyen dbo.YMC_MaQuyen READONLY AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHAN_QUYEN_QUAN_LY';
 IF @TenVaiTro IS NULL OR @TenVaiTro='ADMIN' THROW 50713,N'Không sửa bộ quyền ADMIN.',1;
 DECLARE @k INT,@v INT;
 EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
 IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
 SELECT @v=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro;
 IF @v IS NULL OR EXISTS(SELECT 1 FROM @Quyen x LEFT JOIN dbo.Quyen q ON q.MaQuyen=x.MaQuyen WHERE q.MaQuyen IS NULL) THROW 50714,N'Vai trò hoặc quyền không tồn tại.',1;
 DELETE dbo.VaiTroQuyen WHERE MaVaiTro=@v;
 INSERT dbo.VaiTroQuyen SELECT @v,MaQuyen FROM @Quyen;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_HuyDonChuaThanhToan @NguoiThucHien INT,@MaDonHang BIGINT,@LyDo NVARCHAR(500) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 DECLARE @k INT,@rap INT,@tt VARCHAR(20),@owner INT,@kenh VARCHAR(10);
 EXEC @k=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
 IF @k<0 THROW 50300,N'Hệ thống đang bận.',1;
 SELECT @rap=p.MaRap,@tt=d.TrangThai,@owner=d.NguoiTao,@kenh=d.Kenh FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
 IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn.',1;
 IF @owner=@NguoiThucHien AND @kenh='QUAY' EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAN_VE',@rap;
 ELSE IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_CA_NHAN';
 ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_HUY',@rap;
 IF @tt='DA_HUY' BEGIN COMMIT;RETURN;END;
 IF @tt<>'CHO_THANH_TOAN' THROW 50330,N'Chỉ hủy trực tiếp đơn chưa thanh toán.',1;
 IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 THROW 50331,N'Nhập lý do hủy.',1;
 UPDATE dbo.DonHang SET TrangThai='DA_HUY',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
 DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan INT,@MaQuyen VARCHAR(80),@MaRap INT=NULL AS
BEGIN
 SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.v_YMC_QuyenTaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan AND MaQuyen=@MaQuyen)
 THROW 50403,N'Tài khoản không có quyền hoặc đang khóa.',1;
 DECLARE @admin BIT=0;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1) SET @admin=1;
 IF @admin=0 AND @MaQuyen NOT IN('DAT_VE_WEB','DON_HANG_CA_NHAN') AND EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaTaiKhoan=@MaTaiKhoan AND DangLamViec=0)
 THROW 50404,N'Hồ sơ nhân viên đã ngừng làm việc.',1;
 IF @MaRap IS NOT NULL AND @admin=0 AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)
 THROW 50404,N'Bạn không được phân công rạp này.',1;
END;
GO
PRINT N'Đã cập nhật SQL 23 cho WinForms. Không xóa hoặc seed lại dữ liệu.';
GO

-- SQL 25: luôn áp dụng cuối để cài mới có cùng bản vá với nâng cấp.
-- Nâng cấp sau SQL 23. Chỉ thay định nghĩa thủ tục Admin; không seed hoặc xóa dữ liệu.
-- Giữ nguyên tham số và các result set cho caller hiện có.
USE YeuMinhEmCinema_Test;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID(N'dbo.fn_YMC_CoPhamViRap',N'FN') IS NULL
 THROW 50992,N'Cần cài SQL 23 trước SQL 25.',1;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuRap
@NguoiThucHien INT,@MaRap INT=NULL,@TenRap NVARCHAR(200),@DiaChi NVARCHAR(500)=NULL,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

-- Tạo rạp là thao tác danh mục toàn hệ thống; sửa rạp phải còn được phân công.
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@MaRap;
IF @MaRap IS NULL AND NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@NguoiThucHien AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 THROW 50404,N'Chỉ Admin được tạo rạp mới.',1;
IF @TenRap IS NULL OR LEN(LTRIM(RTRIM(@TenRap)))=0 OR @TrangThai IS NULL OR @TrangThai NOT IN(N'Đang hoạt động',N'Ngừng hoạt động') THROW 50505,N'Tên rạp hoặc trạng thái không hợp lệ.',1;
IF @MaRap IS NULL
BEGIN INSERT dbo.Rap(TenRap,DiaChi,TrangThai) VALUES(@TenRap,@DiaChi,@TrangThai);SET @MaRap=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF @TrangThai<>N'Đang hoạt động' AND EXISTS(SELECT 1 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND s.TrangThai<>N'Đã hủy' AND s.GioKetThuc>dbo.fn_YMC_GioVietNam())
 THROW 50506,N'Rạp có lịch chưa kết thúc. Xử lý lịch trước khi ngừng hoạt động.',1;
 UPDATE dbo.Rap SET TenRap=@TenRap,DiaChi=@DiaChi,TrangThai=@TrangThai WHERE MaRap=@MaRap;
 IF @@ROWCOUNT<>1 THROW 50507,N'Không tìm thấy rạp.',1;
END; SELECT @MaRap AS MaRap;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuPhong
@NguoiThucHien INT,@MaPhong INT=NULL,@MaRap INT,@TenPhong NVARCHAR(100),@DinhDang NVARCHAR(50),@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

-- Kiểm tra cả rạp hiện tại và rạp đích, kể cả khi form đã mở trước lúc thu hồi rạp.
IF @MaRap IS NULL THROW 50507,N'Không tìm thấy rạp.',1;
IF @MaPhong IS NOT NULL
BEGIN
 DECLARE @RapCu INT;
 SELECT @RapCu=MaRap FROM dbo.PhongChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong;
 IF @RapCu IS NULL THROW 50510,N'Không tìm thấy phòng.',1;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapCu;
END;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@MaRap;
IF @TenPhong IS NULL OR LEN(LTRIM(RTRIM(@TenPhong)))=0 OR @DinhDang IS NULL OR LEN(LTRIM(RTRIM(@DinhDang)))=0
 OR @TrangThai IS NULL OR @TrangThai NOT IN(N'Đang hoạt động',N'Ngừng hoạt động') THROW 50508,N'Thông tin phòng không hợp lệ.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.Rap WHERE MaRap=@MaRap AND TrangThai=N'Đang hoạt động') THROW 50507,N'Rạp không hoạt động.',1;
IF @MaPhong IS NULL
BEGIN INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@MaRap,@TenPhong,@DinhDang,@TrangThai);SET @MaPhong=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.SuatChieu WHERE MaPhong=@MaPhong AND TrangThai<>N'Đã hủy' AND GioKetThuc>dbo.fn_YMC_GioVietNam())
 AND EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong AND (MaRap<>@MaRap OR DinhDang<>@DinhDang OR TrangThai<>@TrangThai))
 THROW 50509,N'Phòng có lịch chưa kết thúc, chưa thể chuyển rạp/định dạng/trạng thái.',1;
 UPDATE dbo.PhongChieu SET MaRap=@MaRap,TenPhong=@TenPhong,DinhDang=@DinhDang,TrangThai=@TrangThai WHERE MaPhong=@MaPhong;
 IF @@ROWCOUNT<>1 THROW 50510,N'Không tìm thấy phòng.',1;
END;SELECT @MaPhong AS MaPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuGhe
@NguoiThucHien INT,@MaGhe INT=NULL,@MaPhong INT,@HangGhe VARCHAR(5),@SoGhe INT,@MaLoaiGhe INT,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @RapDich INT,@RapCu INT;
SELECT @RapDich=MaRap FROM dbo.PhongChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong;
IF @RapDich IS NULL THROW 50512,N'Phòng không tồn tại.',1;
IF @MaGhe IS NOT NULL
BEGIN
 SELECT @RapCu=p.MaRap FROM dbo.Ghe g WITH(UPDLOCK,HOLDLOCK)
 JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong WHERE g.MaGhe=@MaGhe;
 IF @RapCu IS NULL THROW 50515,N'Không tìm thấy ghế.',1;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapCu;
END;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapDich;
IF @HangGhe IS NULL OR LEN(LTRIM(RTRIM(@HangGhe)))=0 OR @SoGhe IS NULL OR @SoGhe<1 OR @TrangThai IS NULL
 OR @TrangThai NOT IN(N'Hoạt động',N'Hỏng/Ngừng sử dụng') THROW 50511,N'Thông tin ghế không hợp lệ.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50512,N'Phòng hoặc loại ghế không tồn tại.',1;
IF @MaGhe IS NULL
BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,@HangGhe,@SoGhe,@MaLoaiGhe,@TrangThai);SET @MaGhe=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE g.MaGhe=@MaGhe AND s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND (d.TrangThai='DA_THANH_TOAN' OR (d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME())))
 THROW 50513,N'Ghế đang giữ hoặc có vé chưa kết thúc suất, chưa được sửa.',1;
 IF EXISTS(SELECT 1 FROM dbo.ChiTietVe WHERE MaGhe=@MaGhe) AND EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaGhe=@MaGhe AND MaPhong<>@MaPhong)
 THROW 50514,N'Ghế có lịch sử giao dịch không được chuyển phòng.',1;
 UPDATE dbo.Ghe SET MaPhong=@MaPhong,HangGhe=@HangGhe,SoGhe=@SoGhe,MaLoaiGhe=@MaLoaiGhe,TrangThai=@TrangThai WHERE MaGhe=@MaGhe;
 IF @@ROWCOUNT<>1 THROW 50515,N'Không tìm thấy ghế.',1;
END; SELECT @MaGhe AS MaGhe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuLoaiGhe
@NguoiThucHien INT,@MaLoai INT=NULL,@TenLoai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
-- Loại ghế dùng chung mọi rạp, không thuộc riêng một phân công.
IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@NguoiThucHien AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 THROW 50404,N'Chỉ Admin được quản lý loại ghế dùng chung.',1;
IF @TenLoai IS NULL OR LEN(LTRIM(RTRIM(@TenLoai)))=0 THROW 50516,N'Nhập tên loại ghế.',1;
IF @MaLoai IS NULL BEGIN INSERT dbo.LoaiGhe(TenLoai) VALUES(@TenLoai);SET @MaLoai=CONVERT(INT,SCOPE_IDENTITY());END
ELSE BEGIN UPDATE dbo.LoaiGhe SET TenLoai=@TenLoai WHERE MaLoai=@MaLoai;IF @@ROWCOUNT<>1 THROW 50517,N'Không tìm thấy loại ghế.',1;END;
SELECT @MaLoai AS MaLoai;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoGheTheoLo @NguoiThucHien INT,@MaPhong INT,@SoHang INT,@SoGheMoiHang INT,@MaLoaiGhe INT AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY
 BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 DECLARE @RapPhong INT;
 SELECT @RapPhong=MaRap FROM dbo.PhongChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong;
 IF @RapPhong IS NULL THROW 50707,N'Phòng không tồn tại.',1;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapPhong;
 IF @SoHang IS NULL OR @SoHang NOT BETWEEN 1 AND 26 OR @SoGheMoiHang IS NULL OR @SoGheMoiHang NOT BETWEEN 1 AND 50 THROW 50706,N'Giới hạn 1–26 hàng, 1–50 ghế/hàng.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Phòng/loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu WHERE s.MaPhong=@MaPhong AND s.GioKetThuc>dbo.fn_YMC_GioVietNam()
 AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50708,N'Phòng có đơn/vé chưa kết thúc, không thay đổi sức chứa lúc này.',1;
 DECLARE @h INT=1,@s INT,@them INT=0;
 WHILE @h<=@SoHang BEGIN SET @s=1;WHILE @s<=@SoGheMoiHang BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong AND HangGhe=CHAR(64+@h) AND SoGhe=@s)
 BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,CHAR(64+@h),@s,@MaLoaiGhe,N'Hoạt động');SET @them+=1;END;
 SET @s+=1;END;SET @h+=1;END;
 COMMIT;SELECT @them SoGheDaTao,@SoHang*@SoGheMoiHang-@them SoGheBoQua;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatLoGhe @NguoiThucHien INT,@Ghe dbo.YMC_DanhSachGhe READONLY,@MaLoaiGhe INT=NULL,@TrangThai NVARCHAR(50)=NULL AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
 IF NOT EXISTS(SELECT 1 FROM @Ghe) OR(@MaLoaiGhe IS NULL AND @TrangThai IS NULL) THROW 50709,N'Chọn ghế và thông tin cần cập nhật.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x LEFT JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe WHERE g.MaGhe IS NULL) THROW 50710,N'Ghế không tồn tại.',1;
 -- Từ chối nguyên lô nếu có một ghế ngoài phạm vi; không chỉ kiểm ghế đầu tiên.
 IF EXISTS(SELECT 1 FROM @Ghe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
 JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong
 WHERE dbo.fn_YMC_CoPhamViRap(@NguoiThucHien,p.MaRap)<>1)
 THROW 50404,N'Có ghế thuộc rạp chưa được phân công. Không cập nhật cả lô.',1;
 IF @TrangThai IS NOT NULL AND @TrangThai NOT IN(N'Hoạt động',N'Hỏng/Ngừng sử dụng') THROW 50711,N'Trạng thái ghế không hợp lệ.',1;
 IF @MaLoaiGhe IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x JOIN dbo.GiuGhe g ON g.MaGhe=x.MaGhe JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50712,N'Có ghế đang giữ hoặc vé chưa kết thúc. Không sửa cả lô.',1;
 UPDATE g SET MaLoaiGhe=ISNULL(@MaLoaiGhe,g.MaLoaiGhe),TrangThai=ISNULL(@TrangThai,g.TrangThai) FROM dbo.Ghe g JOIN @Ghe x ON x.MaGhe=g.MaGhe;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO

PRINT N'Đã cập nhật SQL 25: kiểm phạm vi rạp khi ghi danh mục Admin.';
GO

-- SQL 26: Soát vé đúng suất/phòng, giữ tương thích caller cũ.
USE YeuMinhEmCinema_Test;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraVe
@NguoiThucHien INT,@MaVe UNIQUEIDENTIFIER,@XacNhanVaoRap BIT=0,
@MaSuatChieu INT=NULL,@MaPhong INT=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@tt VARCHAR(20),@don BIGINT,@batdau DATETIME2(0),@ketthuc DATETIME2(0),@suat INT,@phong INT;
SELECT @suat=s.MaSuatChieu,@phong=s.MaPhong,@rap=p.MaRap,@tt=v.TrangThai,@don=v.MaDonHang,@batdau=s.GioBatDau,@ketthuc=s.GioKetThuc
FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu
JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE v.MaVe=@MaVe AND d.TrangThai='DA_THANH_TOAN' AND s.TrangThai<>N'Đã hủy';
IF @rap IS NULL THROW 50340,N'Vé không tồn tại hoặc không hợp lệ.',1;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'VE_KIEM_TRA',@rap;
IF @MaSuatChieu IS NOT NULL AND @MaSuatChieu<>@suat
 THROW 50343,N'Vé không thuộc suất chiếu đang soát. Hãy kiểm tra lại suất đã chọn.',1;
IF @MaPhong IS NOT NULL AND @MaPhong<>@phong
 THROW 50344,N'Vé không thuộc phòng đang soát. Hãy kiểm tra lại phòng đã chọn.',1;
IF @tt<>'HIEU_LUC' THROW 50341,N'Vé đã được sử dụng hoặc đã hủy.',1;
IF @XacNhanVaoRap=1
BEGIN
 IF dbo.fn_YMC_GioVietNam()<DATEADD(MINUTE,-30,@batdau) OR dbo.fn_YMC_GioVietNam()>=@ketthuc
 THROW 50342,N'Chỉ cho vào từ 30 phút trước giờ chiếu đến trước khi suất kết thúc.',1;
 UPDATE dbo.Ve SET TrangThai='DA_SU_DUNG',NgaySoatUtc=SYSUTCDATETIME(),NguoiSoat=@NguoiThucHien WHERE MaVe=@MaVe AND TrangThai='HIEU_LUC';
 IF @@ROWCOUNT<>1 THROW 50341,N'Vé đã được sử dụng hoặc đã hủy.',1;
END;
SELECT v.MaVe,v.TrangThai,v.NgaySoatUtc,c.TenPhim,c.TenRap,c.TenPhong,c.NhanGhe,c.GioBatDau
FROM dbo.Ve v JOIN dbo.ChiTietVe c ON c.MaDonHang=v.MaDonHang AND c.MaGhe=v.MaGhe WHERE v.MaVe=@MaVe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO

-- Danh sách chỉ dành cho quyền soát vé; không yêu cầu quyền quản lý lịch. Bao gồm suất qua đêm.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LaySuatSoatVe
@NguoiThucHien INT,@Ngay DATE=NULL
AS
BEGIN
 SET NOCOUNT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'VE_KIEM_TRA';
 SET @Ngay=COALESCE(@Ngay,CONVERT(DATE,dbo.fn_YMC_GioVietNam()));
 SELECT s.MaSuatChieu,s.MaPhong,p.MaRap,r.TenRap,p.TenPhong,f.TenPhim,s.GioBatDau,s.GioKetThuc
 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
 JOIN dbo.Rap r ON r.MaRap=p.MaRap JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
 WHERE dbo.fn_YMC_CoPhamViRap(@NguoiThucHien,p.MaRap)=1 AND s.TrangThai<>N'Đã hủy'
 AND s.GioBatDau<DATEADD(DAY,1,CONVERT(DATETIME2(0),@Ngay)) AND s.GioKetThuc>CONVERT(DATETIME2(0),@Ngay)
 ORDER BY s.GioBatDau,r.MaRap,s.MaPhong,s.MaSuatChieu;
END;
GO

-- SQL27: Tra cứu đơn theo mã và tổng kết quả ngoài trang rỗng.
USE YeuMinhEmCinema_Test;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DanhSachDonAdmin
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@TrangThai VARCHAR(20)=NULL,@Trang INT=1,@KichThuocTrang INT=50,
@TuKhoa NVARCHAR(100)=NULL,@TongKetQua INT=NULL OUTPUT
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_XEM',@MaRap;
 IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231'
  THROW 50600,N'Chọn rạp và khoảng ngày.',1;
 IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100
  THROW 50610,N'Phân trang không hợp lệ.',1;
 SET @TuKhoa=NULLIF(LTRIM(RTRIM(@TuKhoa)),N'');
 DECLARE @id BIGINT=TRY_CONVERT(BIGINT,@TuKhoa),@guid UNIQUEIDENTIFIER;
 -- Chỉ nhận toàn bộ GUID, không để SQL tự cắt chuỗi dài rồi chuyển đổi thành GUID.
 IF LEN(@TuKhoa)=36 SET @guid=TRY_CONVERT(UNIQUEIDENTIFIER,@TuKhoa);
 -- Chụp tập kết quả một lần để tổng và dữ liệu trang nhất quán trong cùng lần tải.
 SELECT d.* INTO #DonLoc FROM dbo.DonHang d
 JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
 WHERE p.MaRap=@MaRap AND (@TrangThai IS NULL OR d.TrangThai=@TrangThai)
 AND d.NgayTaoUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
 AND d.NgayTaoUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)))
 AND (@TuKhoa IS NULL OR d.MaDonHang=@id OR d.MaThamChieu=@guid
 OR EXISTS(SELECT 1 FROM dbo.ThanhToan t WHERE t.MaDonHang=d.MaDonHang AND t.MaGiaoDich=@TuKhoa)
 OR EXISTS(SELECT 1 FROM dbo.Ve v WHERE v.MaDonHang=d.MaDonHang AND v.MaVe=@guid));
 SELECT @TongKetQua=COUNT(*) FROM #DonLoc;
 SELECT d.*,@TongKetQua TongKetQua FROM #DonLoc d ORDER BY d.MaDonHang DESC
 OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;
END;
GO
