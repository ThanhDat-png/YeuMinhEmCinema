USE YeuMinhEmCinema;
GO

-- Xem trước và ghi dùng cùng truy vấn, chữ ký chống ghi khi nguồn đã thay đổi.
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
            THROW 50030,N'Chọn ngày nguồn và đích khác nhau.',1;
        IF @NgayDich<CAST(CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) AS DATE)
            THROW 50031,N'Ngày đích không được ở quá khứ.',1;
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
          AND sc.TrangThai<>N'Đã hủy' AND (@MaRap IS NULL OR pc.MaRap=@MaRap)
          AND (@MaPhong IS NULL OR sc.MaPhong=@MaPhong);
        IF NOT EXISTS(SELECT 1 FROM @src) THROW 50032,N'Không có suất nguồn để sao chép.',1;
        DECLARE @text NVARCHAR(MAX),@sig VARCHAR(64);
        SELECT @text=STRING_AGG(CONVERT(NVARCHAR(MAX),CONCAT(MaCu,':',MaPhim,':',MaPhong,':',
            CONVERT(VARCHAR(19),BatDau,126),':',CONVERT(VARCHAR(19),KetThuc,126),':',Don,':',TT)),N'|')
            WITHIN GROUP(ORDER BY MaCu) FROM @src;
        SET @sig=CONVERT(VARCHAR(64),HASHBYTES('SHA2_256',@text),2);
        IF @XemTruoc IS NULL THROW 50033,N'Chế độ sao chép không hợp lệ.',1;
        IF @XemTruoc=0 AND (@ChuKy IS NULL OR @ChuKy<>@sig)
            THROW 50034,N'Lịch nguồn đã đổi hoặc chưa xem trước. Vui lòng xem trước lại.',1;
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
            THROW 50035,N'Các suất nguồn chồng nhau sau khi tính lại thời lượng phim.',1;
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
                DATEADD(MINUTE,s.Don,s.KetThuc) AS GioSanSang,N'Mở bán' AS TrangThai,@sig AS ChuKy
            FROM @src s JOIN dbo.Phim p ON p.MaPhim=s.MaPhim
            JOIN dbo.PhongChieu pc ON pc.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=pc.MaRap
            ORDER BY s.BatDau,s.MaCu;
            COMMIT;
            RETURN;
        END;
        INSERT dbo.SuatChieu(MaPhim,MaPhong,GioBatDau,GioKetThuc,PhutDonPhong,TrangThai)
        SELECT MaPhim,MaPhong,BatDau,KetThuc,Don,N'Mở bán' FROM @src;
        DECLARE @n INT=@@ROWCOUNT;
        COMMIT;
        SELECT @n AS SoSuatDaTao;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
