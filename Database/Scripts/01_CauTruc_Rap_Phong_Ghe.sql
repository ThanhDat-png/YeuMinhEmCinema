-- ============================================================================
-- HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM YEUMINHEM CINEMA
-- Script 01: Tạo cấu trúc bảng Rạp, Phòng chiếu, Loại ghế và Ghế
-- Yêu cầu:
--   - KHÔNG xóa database hiện có, KHÔNG xóa bảng Phim.
--   - Có thể chạy lại nhiều lần an toàn (Idempotent).
--   - Ràng buộc toàn vẹn: Khóa chính, Khóa ngoại, Tên phòng duy nhất theo rạp,
--     Vị trí ghế duy nhất theo phòng, Số ghế > 0.
--   - Sức chứa phòng được tính toán động từ danh sách ghế.
-- ============================================================================

USE [YeuMinhEmCinema];
GO

-- 1. BẢNG LOẠI GHẾ (LoaiGhe)
-- Quản lý các loại ghế trong rạp: Ghế thường, Ghế VIP, Ghế Sweetbox (đôi)...
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LoaiGhe')
BEGIN
    CREATE TABLE dbo.LoaiGhe (
        MaLoai INT IDENTITY(1,1) CONSTRAINT PK_LoaiGhe PRIMARY KEY,
        TenLoai NVARCHAR(50) NOT NULL CONSTRAINT UQ_LoaiGhe_TenLoai UNIQUE
    );
    PRINT N'-> Đã tạo bảng dbo.LoaiGhe thành công.';
END
ELSE
BEGIN
    PRINT N'-> Bảng dbo.LoaiGhe đã tồn tại, bỏ qua tạo bảng.';
END
GO

-- 2. BẢNG CỤM RẠP (Rap)
-- Quản lý danh sách các cụm rạp trong hệ thống YeuMinhEm Cinema
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Rap')
BEGIN
    CREATE TABLE dbo.Rap (
        MaRap INT IDENTITY(1,1) CONSTRAINT PK_Rap PRIMARY KEY,
        TenRap NVARCHAR(200) NOT NULL,
        DiaChi NVARCHAR(500) NULL,
        TrangThai NVARCHAR(50) NOT NULL CONSTRAINT DF_Rap_TrangThai DEFAULT N'Đang hoạt động'
    );
    PRINT N'-> Đã tạo bảng dbo.Rap thành công.';
END
ELSE
BEGIN
    PRINT N'-> Bảng dbo.Rap đã tồn tại, bỏ qua tạo bảng.';
END
GO

-- 3. BẢNG PHÒNG CHIẾU (PhongChieu)
-- Quản lý phòng chiếu thuộc từng rạp.
-- Ràng buộc: Tên phòng không trùng trong cùng một rạp (UQ_PhongChieu_Rap_Ten).
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
    PRINT N'-> Đã tạo bảng dbo.PhongChieu thành công.';
END
ELSE
BEGIN
    PRINT N'-> Bảng dbo.PhongChieu đã tồn tại, bỏ qua tạo bảng.';
END
GO

-- Tạo index tìm kiếm phòng chiếu theo rạp để tối ưu truy vấn
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PhongChieu_MaRap' AND object_id = OBJECT_ID('dbo.PhongChieu'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_PhongChieu_MaRap ON dbo.PhongChieu(MaRap);
END
GO

-- 4. BẢNG GHẾ (Ghe)
-- Quản lý các vị trí ghế ngồi trong phòng chiếu.
-- Ràng buộc:
--   - Vị trí ghế không trùng trong cùng một phòng (UQ_Ghe_Phong_ViTri: MaPhong, HangGhe, SoGhe).
--   - Số ghế phải lớn hơn 0 (CK_Ghe_SoGhe: SoGhe > 0).
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
    PRINT N'-> Đã tạo bảng dbo.Ghe thành công.';
END
ELSE
BEGIN
    PRINT N'-> Bảng dbo.Ghe đã tồn tại, bỏ qua tạo bảng.';
END
GO

-- Tạo index tìm kiếm ghế theo phòng và loại ghế
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

-- 5. HÀM TÍNH SỨC CHỨA CỦA PHÒNG CHIẾU (Tính động từ danh sách ghế)
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
END;
GO

-- 6. VIEW THỐNG KÊ CHI TIẾT PHÒNG CHIẾU VÀ SỨC CHỨA
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

PRINT N'======================================================';
PRINT N'ĐÃ HOÀN THÀNH CẬP NHẬT CẤU TRÚC DATABASE CHO RẠP - PHÒNG - GHẾ.';
PRINT N'======================================================';
