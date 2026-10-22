USE YeuMinhEmCinema;
GO

-- Mọi thao tác ghi lịch dùng cùng khóa tổng trước khóa phòng/dòng.
-- Khóa tổng giúp thống nhất thứ tự khóa giữa thêm, sửa, hủy và sao chép.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoaLich
AS
BEGIN
    SET NOCOUNT ON;
    IF @@TRANCOUNT = 0 THROW 50100, N'Cần transaction để khóa lịch.', 1;
    DECLARE @k INT;
    EXEC @k=sys.sp_getapplock @Resource=N'SuatChieu_Lich_Write',
        @LockMode='Exclusive', @LockOwner='Transaction', @LockTimeout=10000;
    IF @k<0 THROW 50101, N'Lịch đang được cập nhật. Vui lòng thử lại.', 1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KhoaPhong @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    IF @MaPhong IS NULL THROW 50102, N'Chưa chọn phòng.', 1;
    DECLARE @k INT, @res NVARCHAR(255)=N'SuatChieu_Phong_'+CONVERT(NVARCHAR(20),@MaPhong);
    EXEC @k=sys.sp_getapplock @Resource=@res,
        @LockMode='Exclusive', @LockOwner='Transaction', @LockTimeout=10000;
    IF @k<0 THROW 50103, N'Phòng đang được cập nhật. Vui lòng thử lại.', 1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraSuat
    @MaPhim INT, @MaPhong INT, @GioBatDau DATETIME2(0),
    @PhutDonPhong INT, @GioKetThuc DATETIME2(0) OUTPUT,
    @LoaiTru INT=NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @PhutDonPhong IS NULL OR @PhutDonPhong NOT BETWEEN 0 AND 120
        THROW 50002,N'Thời gian dọn phòng phải từ 0 đến 120 phút.',1;
    IF @GioBatDau IS NULL OR @GioBatDau<=SYSDATETIME()
        THROW 50003,N'Giờ bắt đầu phải ở tương lai.',1;
    DECLARE @phut INT, @ngay DATE, @tt NVARCHAR(30);
    SELECT @phut=ThoiLuong,@ngay=NgayKhoiChieu,@tt=TrangThai
    FROM dbo.Phim WITH(HOLDLOCK) WHERE MaPhim=@MaPhim;
    IF @phut IS NULL OR @phut<=0 THROW 50004,N'Phim không tồn tại hoặc thời lượng không hợp lệ.',1;
    IF @tt IS NULL OR @tt NOT IN(N'Sắp chiếu',N'Đang chiếu')
        THROW 50005,N'Phim không ở trạng thái được phép xếp lịch.',1;
    IF @ngay IS NULL OR CAST(@GioBatDau AS DATE)<@ngay
        THROW 50006,N'Suất chiếu không được trước ngày khởi chiếu.',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu p WITH(HOLDLOCK)
        JOIN dbo.Rap r WITH(HOLDLOCK) ON r.MaRap=p.MaRap
        WHERE p.MaPhong=@MaPhong AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động')
        THROW 50007,N'Phòng hoặc rạp đã ngừng hoạt động hay không tồn tại.',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WITH(HOLDLOCK) WHERE MaPhong=@MaPhong AND TrangThai=N'Hoạt động')
        THROW 50008,N'Phòng chưa có ghế hoạt động.',1;
    SET @GioKetThuc=DATEADD(MINUTE,@phut,@GioBatDau);
    IF EXISTS(SELECT 1 FROM dbo.SuatChieu WITH(UPDLOCK,HOLDLOCK)
        WHERE MaPhong=@MaPhong AND (@LoaiTru IS NULL OR MaSuatChieu<>@LoaiTru)
        AND TrangThai<>N'Đã hủy'
        AND GioBatDau<DATEADD(MINUTE,@PhutDonPhong,@GioKetThuc)
        AND DATEADD(MINUTE,PhutDonPhong,GioKetThuc)>@GioBatDau)
        THROW 50009,N'Trùng lịch phòng chiếu, bao gồm thời gian dọn phòng.',1;
END;
GO
-- Chặn sửa/hủy nếu có bảng nghiệp vụ trực tiếp trỏ tới mã suất.
-- Không giả định dbo.Ve tồn tại. Dùng tên schema/bảng/cột được quote.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_KiemTraLienQuan @MaSuatChieu INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX)=N'',@co BIT=0;
    SELECT @sql=STRING_AGG(CONVERT(NVARCHAR(MAX),N'IF EXISTS(SELECT 1 FROM '+QUOTENAME(s.name)+N'.'+QUOTENAME(t.name)+
        N' WITH(UPDLOCK,HOLDLOCK) WHERE '+QUOTENAME(c.name)+N'=@ma) SET @found=1;'),N' ')
    FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
    JOIN sys.columns c ON c.object_id=t.object_id
    WHERE t.is_ms_shipped=0 AND t.object_id<>OBJECT_ID(N'dbo.SuatChieu')
      AND c.name=N'MaSuatChieu';
    IF LEN(@sql)>0 EXEC sys.sp_executesql @sql,N'@ma INT,@found BIT OUTPUT',@ma=@MaSuatChieu,@found=@co OUTPUT;
    IF @co=1 THROW 50013,N'Suất có dữ liệu vé/đơn liên quan. Cần xử lý nghiệp vụ liên quan trước khi sửa hoặc hủy.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThemSuatChieu
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
        VALUES(@MaPhim,@MaPhong,@GioBatDau,@ket,@PhutDonPhong,N'Mở bán');
        DECLARE @ma INT=CONVERT(INT,SCOPE_IDENTITY());
        COMMIT;
        SELECT @ma AS MaSuatChieu,@ket AS GioKetThuc;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
