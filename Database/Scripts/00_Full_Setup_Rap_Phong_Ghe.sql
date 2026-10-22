-- ============================================================================
-- HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM YEUMINHEM CINEMA
-- Script 00: TOÀN BỘ CẤU TRÚC VÀ DỮ LIỆU MẪU RẠP - PHÒNG - GHẾ
-- (File gộp để tiện mở và bấm Execute một lần duy nhất trong SQL Server Management Studio)
-- ============================================================================

USE [YeuMinhEmCinema];
GO

-- ==========================================
-- PHẦN 1: CẤU TRÚC BẢNG VÀ RÀNG BUỘC
-- ==========================================

-- 1. Bảng Loại ghế
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LoaiGhe')
BEGIN
    CREATE TABLE dbo.LoaiGhe (
        MaLoai INT IDENTITY(1,1) CONSTRAINT PK_LoaiGhe PRIMARY KEY,
        TenLoai NVARCHAR(50) NOT NULL CONSTRAINT UQ_LoaiGhe_TenLoai UNIQUE
    );
    PRINT N'-> Đã tạo bảng dbo.LoaiGhe.';
END
GO

-- 2. Bảng Cụm rạp
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Rap')
BEGIN
    CREATE TABLE dbo.Rap (
        MaRap INT IDENTITY(1,1) CONSTRAINT PK_Rap PRIMARY KEY,
        TenRap NVARCHAR(200) NOT NULL,
        DiaChi NVARCHAR(500) NULL,
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_Rap_TrangThai DEFAULT N'Đang hoạt động'
    );
    PRINT N'-> Đã tạo bảng dbo.Rap.';
END
GO

-- 3. Bảng Phòng chiếu
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PhongChieu')
BEGIN
    CREATE TABLE dbo.PhongChieu (
        MaPhong INT IDENTITY(1,1) CONSTRAINT PK_PhongChieu PRIMARY KEY,
        MaRap INT NOT NULL,
        TenPhong NVARCHAR(100) NOT NULL,
        DinhDang NVARCHAR(50) NOT NULL CONSTRAINT DF_PhongChieu_DinhDang DEFAULT N'2D',
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_PhongChieu_TrangThai DEFAULT N'Đang hoạt động',
        CONSTRAINT FK_PhongChieu_Rap FOREIGN KEY (MaRap) REFERENCES dbo.Rap(MaRap),
        CONSTRAINT UQ_PhongChieu_Rap_Ten UNIQUE (MaRap, TenPhong)
    );
    PRINT N'-> Đã tạo bảng dbo.PhongChieu.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PhongChieu_MaRap' AND object_id = OBJECT_ID('dbo.PhongChieu'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_PhongChieu_MaRap ON dbo.PhongChieu(MaRap);
END
GO

-- 4. Bảng Ghế
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Ghe')
BEGIN
    CREATE TABLE dbo.Ghe (
        MaGhe INT IDENTITY(1,1) CONSTRAINT PK_Ghe PRIMARY KEY,
        MaPhong INT NOT NULL,
        HangGhe VARCHAR(5) NOT NULL,
        SoGhe INT NOT NULL,
        MaLoaiGhe INT NOT NULL,
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_Ghe_TrangThai DEFAULT N'Hoạt động',
        CONSTRAINT FK_Ghe_PhongChieu FOREIGN KEY (MaPhong) REFERENCES dbo.PhongChieu(MaPhong),
        CONSTRAINT FK_Ghe_LoaiGhe FOREIGN KEY (MaLoaiGhe) REFERENCES dbo.LoaiGhe(MaLoai),
        CONSTRAINT UQ_Ghe_Phong_ViTri UNIQUE (MaPhong, HangGhe, SoGhe),
        CONSTRAINT CK_Ghe_SoGhe CHECK (SoGhe > 0)
    );
    PRINT N'-> Đã tạo bảng dbo.Ghe.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Ghe_MaPhong' AND object_id = OBJECT_ID('dbo.Ghe'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Ghe_MaPhong ON dbo.Ghe(MaPhong);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Ghe_MaLoaiGhe' AND object_id = OBJECT_ID('dbo.Ghe'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Ghe_MaLoaiGhe ON dbo.Ghe(MaLoaiGhe);
END
GO

-- 5. Hàm tính sức chứa
CREATE OR ALTER FUNCTION dbo.fn_LaySucChuaPhong(@MaPhong INT)
RETURNS INT
AS
BEGIN
    DECLARE @SucChua INT;
    SELECT @SucChua = COUNT(*)
    FROM dbo.Ghe
    WHERE MaPhong = @MaPhong;
    RETURN ISNULL(@SucChua, 0);
END;
GO

-- 6. View thống kê
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
    COUNT(CASE WHEN g.TrangThai = N'Hoạt động' THEN 1 END) AS SoGheHoatDong,
    COUNT(CASE WHEN g.TrangThai <> N'Hoạt động' THEN 1 END) AS SoGheHong
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
    r.TrangThai;
GO

-- ==========================================
-- PHẦN 2: NẠP DỮ LIỆU MẪU BAN ĐẦU
-- ==========================================

-- Loại ghế
IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế thường')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế thường');

IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế VIP')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế VIP');

IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế Sweetbox')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế Sweetbox');

-- Cụm rạp
IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Landmark 81')
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai) VALUES (N'Cụm rạp YeuMinhEm Landmark 81', N'Tầng B1, Vincom Landmark 81, 720A Điện Biên Phủ, P.22, Bình Thạnh, TP.HCM', N'Đang hoạt động');

IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Vincom Đồng Khởi')
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai) VALUES (N'Cụm rạp YeuMinhEm Vincom Đồng Khởi', N'Tầng 3, Vincom Center Đồng Khởi, 72 Lê Thánh Tôn, Bến Nghé, Quận 1, TP.HCM', N'Đang hoạt động');

IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Thủ Đức')
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai) VALUES (N'Cụm rạp YeuMinhEm Thủ Đức', N'Tầng 4, Vincom Plaza Thủ Đức, 216 Võ Văn Ngân, Bình Thọ, TP.Thủ Đức, TP.HCM', N'Đang hoạt động');

-- Phòng chiếu
DECLARE @MaRapLandmark INT = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Landmark 81');
DECLARE @MaRapDongKhoi INT = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Vincom Đồng Khởi');
DECLARE @MaRapThuDuc INT   = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Thủ Đức');

IF @MaRapLandmark IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 01', N'2D Digital', N'Đang hoạt động');
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 02', N'3D RealD', N'Đang hoạt động');
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 03')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 03', N'IMAX Laser', N'Đang hoạt động');
END

IF @MaRapDongKhoi IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapDongKhoi AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapDongKhoi, N'Phòng 01', N'2D Dolby Atmos', N'Đang hoạt động');
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapDongKhoi AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapDongKhoi, N'Phòng 02', N'Gold Class', N'Đang hoạt động');
END

IF @MaRapThuDuc IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapThuDuc AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapThuDuc, N'Phòng 01', N'2D Standard', N'Đang hoạt động');
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapThuDuc AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapThuDuc, N'Phòng 02', N'2D Standard', N'Đang hoạt động');
END

-- Nạp ghế mẫu
DECLARE @LoaiThuong INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế thường');
DECLARE @LoaiVip    INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế VIP');
DECLARE @LoaiDoi    INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế Sweetbox');

DECLARE @MaPhong INT;
DECLARE @HangChar CHAR(1);
DECLARE @HangIndex INT;
DECLARE @SoIndex INT;
DECLARE @SoHang INT;
DECLARE @SoGheMoiHang INT;
DECLARE @LoaiGheChon INT;
DECLARE @TrangThaiGhe NVARCHAR(50);

DECLARE curPhong CURSOR FOR
    SELECT p.MaPhong, p.TenPhong, p.DinhDang
    FROM dbo.PhongChieu p;

OPEN curPhong;
FETCH NEXT FROM curPhong INTO @MaPhong, @HangChar, @TrangThaiGhe;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @TenPhongHienTai NVARCHAR(100);
    DECLARE @DinhDangHienTai NVARCHAR(50);
    SELECT @TenPhongHienTai = TenPhong, @DinhDangHienTai = DinhDang FROM dbo.PhongChieu WHERE MaPhong = @MaPhong;

    IF @DinhDangHienTai LIKE N'%IMAX%'
    BEGIN
        SET @SoHang = 10;
        SET @SoGheMoiHang = 12;
    END
    ELSE IF @DinhDangHienTai LIKE N'%Gold Class%'
    BEGIN
        SET @SoHang = 4;
        SET @SoGheMoiHang = 10;
    END
    ELSE IF @TenPhongHienTai = N'Phòng 01' AND @DinhDangHienTai LIKE N'%Dolby Atmos%'
    BEGIN
        SET @SoHang = 7;
        SET @SoGheMoiHang = 10;
    END
    ELSE IF @TenPhongHienTai = N'Phòng 01'
    BEGIN
        SET @SoHang = 6;
        SET @SoGheMoiHang = 10;
    END
    ELSE
    BEGIN
        SET @SoHang = 8;
        SET @SoGheMoiHang = 10;
    END

    SET @HangIndex = 1;
    WHILE @HangIndex <= @SoHang
    BEGIN
        SET @HangChar = CHAR(64 + @HangIndex);

        IF @HangIndex <= 2
            SET @LoaiGheChon = @LoaiThuong;
        ELSE IF @HangIndex = @SoHang
            SET @LoaiGheChon = @LoaiDoi;
        ELSE
            SET @LoaiGheChon = @LoaiVip;

        SET @SoIndex = 1;
        WHILE @SoIndex <= @SoGheMoiHang
        BEGIN
            IF (@MaPhong = 1 AND @HangChar = 'C' AND (@SoIndex = 5 OR @SoIndex = 6))
                OR (@MaPhong = 4 AND @HangChar = 'D' AND @SoIndex = 7)
            BEGIN
                SET @TrangThaiGhe = N'Hỏng/Ngừng sử dụng';
            END
            ELSE
            BEGIN
                SET @TrangThaiGhe = N'Hoạt động';
            END

            IF NOT EXISTS (SELECT 1 FROM dbo.Ghe WHERE MaPhong = @MaPhong AND HangGhe = @HangChar AND SoGhe = @SoIndex)
            BEGIN
                INSERT INTO dbo.Ghe (MaPhong, HangGhe, SoGhe, MaLoaiGhe, TrangThai)
                VALUES (@MaPhong, @HangChar, @SoIndex, @LoaiGheChon, @TrangThaiGhe);
            END

            SET @SoIndex = @SoIndex + 1;
        END

        SET @HangIndex = @HangIndex + 1;
    END

    FETCH NEXT FROM curPhong INTO @MaPhong, @HangChar, @TrangThaiGhe;
END

CLOSE curPhong;
DEALLOCATE curPhong;

PRINT N'======================================================';
PRINT N'ĐÃ CHẠY HOÀN TẤT THIẾT LẬP CƠ SỞ DỮ LIỆU VÀ DỮ LIỆU MẪU!';
PRINT N'======================================================';
GO
