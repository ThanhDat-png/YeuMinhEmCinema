-- ============================================================================
-- HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM YEUMINHEM CINEMA
-- Script 02: Nạp dữ liệu mẫu ban đầu cho Loại ghế, Rạp, Phòng chiếu và Ghế
-- Yêu cầu:
--   - KHÔNG làm mất dữ liệu hiện có.
--   - Chạy lại không thêm trùng lặp (Idempotent bằng IF NOT EXISTS).
--   - Đồng bộ dữ liệu đúng với các cụm rạp và phòng chiếu minh họa trước đây.
-- ============================================================================

USE [YeuMinhEmCinema];
GO

-- 1. NẠP DỮ LIỆU BẢNG LoaiGhe
IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế thường')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế thường');

IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế VIP')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế VIP');

IF NOT EXISTS (SELECT 1 FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế Sweetbox')
    INSERT INTO dbo.LoaiGhe (TenLoai) VALUES (N'Ghế Sweetbox');

PRINT N'-> Đã kiểm tra/nạp dữ liệu bảng LoaiGhe.';
GO

-- 2. NẠP DỮ LIỆU BẢNG Rap
IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Landmark 81')
BEGIN
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai)
    VALUES (N'Cụm rạp YeuMinhEm Landmark 81', N'Tầng B1, Vincom Landmark 81, 720A Điện Biên Phủ, P.22, Bình Thạnh, TP.HCM', N'Đang hoạt động');
END

IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Vincom Đồng Khởi')
BEGIN
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai)
    VALUES (N'Cụm rạp YeuMinhEm Vincom Đồng Khởi', N'Tầng 3, Vincom Center Đồng Khởi, 72 Lê Thánh Tôn, Bến Nghé, Quận 1, TP.HCM', N'Đang hoạt động');
END

IF NOT EXISTS (SELECT 1 FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Thủ Đức')
BEGIN
    INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai)
    VALUES (N'Cụm rạp YeuMinhEm Thủ Đức', N'Tầng 4, Vincom Plaza Thủ Đức, 216 Võ Văn Ngân, Bình Thọ, TP.Thủ Đức, TP.HCM', N'Đang hoạt động');
END

PRINT N'-> Đã kiểm tra/nạp dữ liệu bảng Rap.';
GO

-- 3. NẠP DỮ LIỆU BẢNG PhongChieu
DECLARE @MaRapLandmark INT = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Landmark 81');
DECLARE @MaRapDongKhoi INT = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Vincom Đồng Khởi');
DECLARE @MaRapThuDuc INT   = (SELECT TOP 1 MaRap FROM dbo.Rap WHERE TenRap = N'Cụm rạp YeuMinhEm Thủ Đức');

-- Phòng thuộc Landmark 81
IF @MaRapLandmark IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 01', N'2D Digital', N'Đang hoạt động');

    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 02', N'3D RealD', N'Đang hoạt động');

    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapLandmark AND TenPhong = N'Phòng 03')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapLandmark, N'Phòng 03', N'IMAX Laser', N'Đang hoạt động');
END

-- Phòng thuộc Đồng Khởi
IF @MaRapDongKhoi IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapDongKhoi AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapDongKhoi, N'Phòng 01', N'2D Dolby Atmos', N'Đang hoạt động');

    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapDongKhoi AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapDongKhoi, N'Phòng 02', N'Gold Class', N'Đang hoạt động');
END

-- Phòng thuộc Thủ Đức
IF @MaRapThuDuc IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapThuDuc AND TenPhong = N'Phòng 01')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapThuDuc, N'Phòng 01', N'2D Standard', N'Đang hoạt động');

    IF NOT EXISTS (SELECT 1 FROM dbo.PhongChieu WHERE MaRap = @MaRapThuDuc AND TenPhong = N'Phòng 02')
        INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai) VALUES (@MaRapThuDuc, N'Phòng 02', N'2D Standard', N'Đang hoạt động');
END

PRINT N'-> Đã kiểm tra/nạp dữ liệu bảng PhongChieu.';
GO

-- 4. NẠP DỮ LIỆU SƠ ĐỒ GHẾ (Ghe)
-- Tạo ghế cho từng phòng chiếu với cấu trúc rõ ràng:
-- Hàng đầu: Ghế thường
-- Hàng giữa: Ghế VIP
-- Hàng cuối: Ghế Sweetbox
-- Một vài ghế được đánh dấu 'Hỏng/Ngừng sử dụng' để kiểm thử tính năng.

DECLARE @LoaiThuong INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế thường');
DECLARE @LoaiVip    INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế VIP');
DECLARE @LoaiDoi    INT = (SELECT TOP 1 MaLoai FROM dbo.LoaiGhe WHERE TenLoai = N'Ghế Sweetbox');

-- Hàm/thủ tục nội bộ chèn ghế nếu chưa có
DECLARE @MaPhong INT;
DECLARE @HangChar CHAR(1);
DECLARE @HangIndex INT;
DECLARE @SoIndex INT;
DECLARE @SoHang INT;
DECLARE @SoGheMoiHang INT;
DECLARE @LoaiGheChon INT;
DECLARE @TrangThaiGhe NVARCHAR(50);

-- Danh sách phòng cần tạo ghế mẫu
DECLARE curPhong CURSOR FOR
    SELECT p.MaPhong, p.TenPhong, p.DinhDang
    FROM dbo.PhongChieu p;

OPEN curPhong;
FETCH NEXT FROM curPhong INTO @MaPhong, @HangChar, @TrangThaiGhe; -- Tạm dùng biến

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Xác định số hàng và số ghế mỗi hàng dựa theo loại phòng
    DECLARE @TenPhongHienTai NVARCHAR(100);
    DECLARE @DinhDangHienTai NVARCHAR(50);
    SELECT @TenPhongHienTai = TenPhong, @DinhDangHienTai = DinhDang FROM dbo.PhongChieu WHERE MaPhong = @MaPhong;

    IF @DinhDangHienTai LIKE N'%IMAX%'
    BEGIN
        SET @SoHang = 10;       -- A -> J
        SET @SoGheMoiHang = 12; -- 120 ghế
    END
    ELSE IF @DinhDangHienTai LIKE N'%Gold Class%'
    BEGIN
        SET @SoHang = 4;        -- A -> D
        SET @SoGheMoiHang = 10; -- 40 ghế
    END
    ELSE IF @TenPhongHienTai = N'Phòng 01' AND @DinhDangHienTai LIKE N'%Dolby Atmos%'
    BEGIN
        SET @SoHang = 7;        -- A -> G
        SET @SoGheMoiHang = 10; -- 70 ghế
    END
    ELSE IF @TenPhongHienTai = N'Phòng 01'
    BEGIN
        SET @SoHang = 6;        -- A -> F
        SET @SoGheMoiHang = 10; -- 60 ghế
    END
    ELSE
    BEGIN
        SET @SoHang = 8;        -- A -> H
        SET @SoGheMoiHang = 10; -- 80 ghế
    END

    SET @HangIndex = 1;
    WHILE @HangIndex <= @SoHang
    BEGIN
        SET @HangChar = CHAR(64 + @HangIndex); -- 'A', 'B', 'C', ...

        -- Xác định loại ghế theo hàng
        IF @HangIndex <= 2
            SET @LoaiGheChon = @LoaiThuong;
        ELSE IF @HangIndex = @SoHang
            SET @LoaiGheChon = @LoaiDoi;
        ELSE
            SET @LoaiGheChon = @LoaiVip;

        SET @SoIndex = 1;
        WHILE @SoIndex <= @SoGheMoiHang
        BEGIN
            -- Giả lập 1 vài ghế hỏng/ngừng sử dụng ở một số phòng để kiểm tra giao diện
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

PRINT N'-> Đã kiểm tra/nạp sơ đồ ghế mẫu thành công.';
GO

-- 5. KIỂM TRA TỔNG HỢP SAU KHI NẠP DỮ LIỆU
PRINT N'======================================================';
PRINT N'DANH SÁCH RẠP VÀ PHÒNG CHIẾU HIỆN CÓ KÈM SỨC CHỨA:';
SELECT 
    TenRap AS [Tên rạp],
    TenPhong AS [Phòng chiếu],
    DinhDang AS [Định dạng],
    TrangThaiPhong AS [Trạng thái],
    TongSoGhe AS [Sức chứa],
    SoGheHoatDong AS [Ghế hoạt động],
    SoGheHong AS [Ghế hỏng/Ngừng]
FROM dbo.v_ThongTinPhongChieu
ORDER BY MaRap, MaPhong;
PRINT N'======================================================';
GO
