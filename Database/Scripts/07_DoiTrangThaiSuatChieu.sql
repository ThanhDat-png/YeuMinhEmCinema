USE YeuMinhEmCinema;
GO

CREATE OR ALTER PROCEDURE dbo.sp_DoiTrangThaiSuatChieu @MaSuatChieu INT,@TrangThaiMoi NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.sp_YMC_KhoaLich;
        DECLARE @tt NVARCHAR(30),@phong INT,@gio DATETIME2(0);
        SELECT @tt=TrangThai,@phong=MaPhong,@gio=GioBatDau FROM dbo.SuatChieu WITH(UPDLOCK,HOLDLOCK)
        WHERE MaSuatChieu=@MaSuatChieu;
        IF @tt IS NULL THROW 50010,N'Suất chiếu không tồn tại.',1;
        IF @TrangThaiMoi IS NULL OR @TrangThaiMoi NOT IN(N'Mở bán',N'Ngừng bán',N'Đã hủy')
            THROW 50020,N'Trạng thái không hợp lệ.',1;
        IF @tt=N'Đã hủy' THROW 50022,N'Suất đã hủy không thể đổi trạng thái.',1;
        IF @tt=@TrangThaiMoi THROW 50021,N'Suất đã ở trạng thái yêu cầu.',1;
        IF @gio<=SYSDATETIME() THROW 50012,N'Không thể đổi trạng thái suất đã bắt đầu.',1;
        EXEC dbo.sp_YMC_KhoaPhong @phong;
        IF @TrangThaiMoi=N'Đã hủy' EXEC dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu;
        UPDATE dbo.SuatChieu SET TrangThai=@TrangThaiMoi WHERE MaSuatChieu=@MaSuatChieu;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
