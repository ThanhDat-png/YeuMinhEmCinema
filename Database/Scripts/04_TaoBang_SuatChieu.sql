USE YeuMinhEmCinema;
GO

IF OBJECT_ID(N'dbo.SuatChieu', N'U') IS NULL
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
            CONSTRAINT DF_SuatChieu_TrangThai DEFAULT N'Mở bán',

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
                N'Mở bán',
                N'Ngừng bán',
                N'Đã hủy'
            ))
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.SuatChieu')
      AND name = N'IX_SuatChieu_Phong_GioBatDau'
)
BEGIN
    CREATE INDEX IX_SuatChieu_Phong_GioBatDau
        ON dbo.SuatChieu(MaPhong, GioBatDau)
        INCLUDE (GioKetThuc, PhutDonPhong, TrangThai);
END;
GO

SELECT * FROM dbo.SuatChieu;