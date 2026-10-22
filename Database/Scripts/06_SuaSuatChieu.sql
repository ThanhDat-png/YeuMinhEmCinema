USE YeuMinhEmCinema;
GO

CREATE OR ALTER PROCEDURE dbo.sp_SuaSuatChieu
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
        IF @cu IS NULL THROW 50010,N'Suất chiếu không tồn tại.',1;
        IF @tt=N'Đã hủy' THROW 50011,N'Không thể sửa suất đã hủy.',1;
        IF @gio<=SYSDATETIME() THROW 50012,N'Không thể sửa suất đã bắt đầu.',1;
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
END;
GO
