-- Chạy file này trước các script Rạp - Phòng - Ghế.
-- Chỉ tạo nếu chưa tồn tại; không xóa hoặc thay thế dữ liệu đang có.
USE master;
GO
IF DB_ID(N'YeuMinhEmCinema') IS NULL
    EXEC(N'CREATE DATABASE [YeuMinhEmCinema]');
GO
USE [YeuMinhEmCinema];
GO
IF OBJECT_ID(N'dbo.Phim', N'U') IS NULL
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
        TrangThai NVARCHAR(30) NOT NULL CONSTRAINT DF_Phim_TrangThai DEFAULT N'Sắp chiếu',
        CONSTRAINT CK_Phim_TrangThai CHECK (TrangThai IN (N'Sắp chiếu', N'Đang chiếu', N'Ngừng chiếu'))
    );
END;
GO
