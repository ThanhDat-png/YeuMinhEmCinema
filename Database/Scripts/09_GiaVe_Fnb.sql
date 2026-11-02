USE YeuMinhEmCinema;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N'dbo.GiaVe',N'U') IS NULL
BEGIN
    CREATE TABLE dbo.GiaVe(
        MaGiaVe INT IDENTITY PRIMARY KEY,
        MaLoaiGhe INT NOT NULL REFERENCES dbo.LoaiGhe(MaLoai),
        DinhDang NVARCHAR(50) NOT NULL,
        LoaiNgay NVARCHAR(20) NOT NULL CHECK(LoaiNgay IN(N'Ngày thường',N'Cuối tuần')),
        TuNgay DATE NOT NULL,DenNgay DATE NULL,
        DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0 AND DonGia<=1000000000),
        DangApDung BIT NOT NULL DEFAULT 1,
        PhienBan ROWVERSION,
        CHECK(DenNgay IS NULL OR DenNgay>=TuNgay),
        CHECK(LEN(LTRIM(RTRIM(DinhDang)))>0)
    );
    CREATE INDEX IX_GiaVe_Tra ON dbo.GiaVe(MaLoaiGhe,DinhDang,LoaiNgay,TuNgay) INCLUDE(DenNgay,DonGia,DangApDung);
END;
IF OBJECT_ID(N'dbo.FnbSanPham',N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FnbSanPham(
        MaSanPham INT IDENTITY PRIMARY KEY,
        MaHang VARCHAR(30) NOT NULL UNIQUE,
        TenSanPham NVARCHAR(150) NOT NULL,
        Nhom NVARCHAR(20) NOT NULL CHECK(Nhom IN(N'Bắp',N'Nước',N'Đồ ăn',N'Combo')),
        KichCo NVARCHAR(50) NOT NULL,
        DonGia DECIMAL(18,0) NOT NULL CHECK(DonGia>0 AND DonGia<=1000000000),
        DangBan BIT NOT NULL DEFAULT 1,
        PhienBan ROWVERSION,
        CHECK(LEN(LTRIM(RTRIM(TenSanPham)))>0)
    );
END;
IF OBJECT_ID(N'dbo.FnbComboChiTiet',N'U') IS NULL
    CREATE TABLE dbo.FnbComboChiTiet(
        MaCombo INT NOT NULL REFERENCES dbo.FnbSanPham(MaSanPham),
        MaThanhPhan INT NOT NULL REFERENCES dbo.FnbSanPham(MaSanPham),
        SoLuong INT NOT NULL CHECK(SoLuong BETWEEN 1 AND 99),
        PRIMARY KEY(MaCombo,MaThanhPhan),CHECK(MaCombo<>MaThanhPhan)
    );
COMMIT;
GO
IF TYPE_ID(N'dbo.YMC_FnbThanhPhan') IS NULL
    EXEC(N'CREATE TYPE dbo.YMC_FnbThanhPhan AS TABLE(MaThanhPhan INT PRIMARY KEY,SoLuong INT NOT NULL)');
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuGiaVe
    @MaGiaVe INT=NULL,@MaLoaiGhe INT,@DinhDang NVARCHAR(50),@LoaiNgay NVARCHAR(20),
    @TuNgay DATE,@DenNgay DATE=NULL,@DonGia DECIMAL(18,0),@DangApDung BIT,@PhienBan BINARY(8)=NULL
AS
BEGIN
    SET NOCOUNT ON;SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @k INT;
        EXEC @k=sys.sp_getapplock @Resource=N'YMC_GiaVe_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @k<0 THROW 50200,N'Bảng giá đang cập nhật. Thử lại.',1;
        SET @DinhDang=LTRIM(RTRIM(@DinhDang));
        IF @DinhDang IS NULL OR LEN(@DinhDang)=0 THROW 50201,N'Nhập định dạng chiếu.',1;
        IF NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WITH(HOLDLOCK) WHERE MaLoai=@MaLoaiGhe)
            THROW 50202,N'Loại ghế không tồn tại.',1;
        IF @LoaiNgay IS NULL OR @LoaiNgay NOT IN(N'Ngày thường',N'Cuối tuần')
            THROW 50203,N'Loại ngày không hợp lệ.',1;
        IF @TuNgay IS NULL OR (@DenNgay IS NOT NULL AND @DenNgay<@TuNgay)
            THROW 50204,N'Ngày kết thúc phải từ ngày bắt đầu trở đi.',1;
        IF @DonGia IS NULL OR @DonGia<=0 OR @DonGia>1000000000 OR @DangApDung IS NULL
            THROW 50205,N'Giá phải lớn hơn 0 và không quá 1 tỷ đồng.',1;
        IF @MaGiaVe IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.GiaVe WITH(UPDLOCK,HOLDLOCK)
            WHERE MaGiaVe=@MaGiaVe AND PhienBan=@PhienBan)
            THROW 50206,N'Bản giá đã đổi hoặc không tồn tại. Tải lại trước khi sửa.',1;
        IF @DangApDung=1 AND EXISTS(SELECT 1 FROM dbo.GiaVe WITH(UPDLOCK,HOLDLOCK)
            WHERE MaLoaiGhe=@MaLoaiGhe AND DinhDang=@DinhDang AND LoaiNgay=@LoaiNgay AND DangApDung=1
            AND (@MaGiaVe IS NULL OR MaGiaVe<>@MaGiaVe)
            AND TuNgay<=ISNULL(@DenNgay,CONVERT(DATE,'99991231'))
            AND ISNULL(DenNgay,CONVERT(DATE,'99991231'))>=@TuNgay)
            THROW 50207,N'Trùng khoảng áp dụng với một giá đang bật cùng loại ghế, định dạng và loại ngày.',1;
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
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuFnb
    @MaSanPham INT=NULL,@MaHang VARCHAR(30),@TenSanPham NVARCHAR(150),@Nhom NVARCHAR(20),
    @KichCo NVARCHAR(50),@DonGia DECIMAL(18,0),@DangBan BIT,
    @ThanhPhan dbo.YMC_FnbThanhPhan READONLY,@PhienBan BINARY(8)=NULL
AS
BEGIN
    SET NOCOUNT ON;SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @k INT;
        EXEC @k=sys.sp_getapplock @Resource=N'YMC_Fnb_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
        IF @k<0 THROW 50210,N'Menu đang cập nhật. Thử lại.',1;
        SET @MaHang=UPPER(LTRIM(RTRIM(@MaHang)));SET @TenSanPham=LTRIM(RTRIM(@TenSanPham));
        IF @MaHang IS NULL OR LEN(@MaHang)=0 OR @MaHang COLLATE Latin1_General_100_BIN2 LIKE '%[^A-Z0-9_-]%'
            THROW 50211,N'Mã hàng chỉ gồm chữ A–Z, số, dấu gạch dưới hoặc gạch ngang.',1;
        IF @TenSanPham IS NULL OR LEN(@TenSanPham)=0 OR @KichCo IS NULL
            THROW 50212,N'Nhập tên sản phẩm và thông tin kích cỡ.',1;
        IF @Nhom IS NULL OR @Nhom NOT IN(N'Bắp',N'Nước',N'Đồ ăn',N'Combo')
            THROW 50213,N'Nhóm sản phẩm không hợp lệ.',1;
        IF @DonGia IS NULL OR @DonGia<=0 OR @DonGia>1000000000 OR @DangBan IS NULL
            THROW 50214,N'Đơn giá phải lớn hơn 0 và không quá 1 tỷ đồng.',1;
        IF @MaSanPham IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.FnbSanPham WITH(UPDLOCK,HOLDLOCK)
            WHERE MaSanPham=@MaSanPham AND PhienBan=@PhienBan)
            THROW 50215,N'Sản phẩm đã đổi hoặc không tồn tại. Tải lại trước khi sửa.',1;
        IF EXISTS(SELECT 1 FROM dbo.FnbSanPham WITH(UPDLOCK,HOLDLOCK)
            WHERE MaHang=@MaHang AND (@MaSanPham IS NULL OR MaSanPham<>@MaSanPham))
            THROW 50216,N'Mã hàng đã được sử dụng.',1;
        IF @Nhom=N'Combo'
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM @ThanhPhan) THROW 50217,N'Combo phải có ít nhất một thành phần.',1;
            IF EXISTS(SELECT 1 FROM @ThanhPhan t LEFT JOIN dbo.FnbSanPham p WITH(HOLDLOCK) ON p.MaSanPham=t.MaThanhPhan
                WHERE p.MaSanPham IS NULL OR p.Nhom=N'Combo' OR t.MaThanhPhan=@MaSanPham
                OR t.SoLuong NOT BETWEEN 1 AND 99)
                THROW 50218,N'Thành phần không hợp lệ; không được lồng combo, tự tham chiếu hoặc số lượng ngoài 1–99.',1;
            IF @DangBan=1 AND EXISTS(SELECT 1 FROM @ThanhPhan t JOIN dbo.FnbSanPham p WITH(HOLDLOCK)
                ON p.MaSanPham=t.MaThanhPhan WHERE p.DangBan=0)
                THROW 50219,N'Không bật combo có thành phần ngừng bán.',1;
            IF EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet WITH(HOLDLOCK) WHERE MaThanhPhan=@MaSanPham)
                THROW 50220,N'Sản phẩm đang là thành phần combo khác, không được đổi thành combo.',1;
        END
        ELSE IF EXISTS(SELECT 1 FROM @ThanhPhan)
            THROW 50221,N'Sản phẩm lẻ không có danh sách thành phần.',1;
        IF @MaSanPham IS NULL
        BEGIN
            INSERT dbo.FnbSanPham(MaHang,TenSanPham,Nhom,KichCo,DonGia,DangBan)
            VALUES(@MaHang,@TenSanPham,@Nhom,LTRIM(RTRIM(@KichCo)),@DonGia,@DangBan);
            SET @MaSanPham=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE UPDATE dbo.FnbSanPham SET MaHang=@MaHang,TenSanPham=@TenSanPham,Nhom=@Nhom,
            KichCo=LTRIM(RTRIM(@KichCo)),DonGia=@DonGia,DangBan=@DangBan WHERE MaSanPham=@MaSanPham;
        DELETE dbo.FnbComboChiTiet WHERE MaCombo=@MaSanPham;
        IF @Nhom=N'Combo' INSERT dbo.FnbComboChiTiet(MaCombo,MaThanhPhan,SoLuong)
            SELECT @MaSanPham,MaThanhPhan,SoLuong FROM @ThanhPhan;
        COMMIT;SELECT @MaSanPham AS MaSanPham;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;THROW;
    END CATCH;
END;
GO
CREATE OR ALTER VIEW dbo.v_YMC_FnbMenu
AS
SELECT p.MaSanPham,p.MaHang,p.TenSanPham,p.Nhom,p.KichCo,p.DonGia,p.DangBan,p.PhienBan,
    CAST(CASE WHEN p.DangBan=0 THEN 0 WHEN p.Nhom<>N'Combo' THEN 1
        WHEN NOT EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet c WHERE c.MaCombo=p.MaSanPham) THEN 0
        WHEN EXISTS(SELECT 1 FROM dbo.FnbComboChiTiet c JOIN dbo.FnbSanPham tp ON tp.MaSanPham=c.MaThanhPhan
            WHERE c.MaCombo=p.MaSanPham AND (tp.DangBan=0 OR tp.Nhom=N'Combo')) THEN 0 ELSE 1 END AS BIT) AS CoTheBan
FROM dbo.FnbSanPham p;
GO
-- Giá bán vé lấy theo ngày chiếu và mỗi mã ghế, không theo ngày mua.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TraGiaTheoSuatGhe @MaSuatChieu INT,@MaGhe INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @loai INT,@dd NVARCHAR(50),@ngay DATE;
    SELECT @loai=g.MaLoaiGhe,@dd=p.DinhDang,@ngay=CAST(s.GioBatDau AS DATE)
    FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
    JOIN dbo.Rap r ON r.MaRap=p.MaRap
    JOIN dbo.Ghe g ON g.MaPhong=p.MaPhong AND g.MaGhe=@MaGhe
    WHERE s.MaSuatChieu=@MaSuatChieu AND s.TrangThai=N'Mở bán'
      AND s.GioBatDau>CONVERT(DATETIME2(0),DATEADD(HOUR,7,SYSUTCDATETIME())) AND g.TrangThai=N'Hoạt động'
      AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động';
    IF @loai IS NULL THROW 50230,N'Suất/ghế không hợp lệ hoặc không còn mở bán.',1;
    DECLARE @ln NVARCHAR(20)=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
    IF (SELECT COUNT(*) FROM dbo.GiaVe WHERE MaLoaiGhe=@loai AND DinhDang=@dd AND LoaiNgay=@ln
        AND DangApDung=1 AND TuNgay<=@ngay AND (DenNgay IS NULL OR DenNgay>=@ngay))<>1
        THROW 50231,N'Chưa có giá duy nhất cho loại ghế, định dạng và ngày chiếu này.',1;
    SELECT MaGiaVe,DonGia,@ln AS LoaiNgay FROM dbo.GiaVe
    WHERE MaLoaiGhe=@loai AND DinhDang=@dd AND LoaiNgay=@ln AND DangApDung=1
      AND TuNgay<=@ngay AND (DenNgay IS NULL OR DenNgay>=@ngay);
END;
GO
