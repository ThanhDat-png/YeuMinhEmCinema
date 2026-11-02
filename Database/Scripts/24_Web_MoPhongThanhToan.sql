-- Chạy riêng sau SQL 23 trong database YeuMinhEmCinema. Không seed, không sửa thủ tục Admin.
-- Chạy lại chỉ cập nhật định nghĩa procedure. Backend chỉ gọi khi Development và cấu hình bật.
-- SQL không tự biết môi trường ASP.NET: không cấp EXECUTE trực tiếp cho người dùng cuối.
USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_WebMoPhongThanhToan
    @MaTaiKhoan INT,
    @MaDonHang BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Dùng cùng thứ tự khóa với tạo đơn/thu tiền ở quầy để chống bán và thanh toán trùng.
        EXEC dbo.sp_YMC_KhoaLich;
        DECLARE @k INT;
        EXEC @k = sys.sp_getapplock
            @Resource = N'YMC_Booking_Write', @LockMode = 'Exclusive',
            @LockOwner = 'Transaction', @LockTimeout = 10000;
        IF @k < 0
        BEGIN
            THROW 50300, N'Hệ thống đang bận. Vui lòng thử lại.', 1;
        END;
        EXEC dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan, 'DAT_VE_WEB';
        EXEC dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan, 'DON_HANG_CA_NHAN';

        DECLARE @tt VARCHAR(20), @tong DECIMAL(18,0), @han DATETIME2(0),
            @suat INT, @batdau DATETIME2(0), @ma VARCHAR(100);
        SELECT @tt = d.TrangThai, @tong = d.TongTien, @han = d.HanThanhToanUtc,
            @suat = d.MaSuatChieu, @batdau = s.GioBatDau
        FROM dbo.DonHang d
        JOIN dbo.KhachHang kh ON kh.MaKhachHang = d.MaKhachHang
        JOIN dbo.SuatChieu s ON s.MaSuatChieu = d.MaSuatChieu
        WHERE d.MaDonHang = @MaDonHang AND d.Kenh = 'WEB'
            AND kh.MaTaiKhoan = @MaTaiKhoan AND kh.DangHoatDong = 1;
        IF @tt IS NULL
        BEGIN
            THROW 50800, N'Không tìm thấy đơn Web của bạn.', 1;
        END;
        SET @ma = CONCAT('MOPHONG-WEB-', @MaDonHang);
        -- Gửi lại cùng yêu cầu chỉ trả vé cũ; không tạo thêm giao dịch.
        IF @tt = 'DA_THANH_TOAN'
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM dbo.ThanhToan
                WHERE MaDonHang = @MaDonHang AND MaGiaoDich = @ma AND SoTien = @tong)
            BEGIN
                THROW 50801, N'Đơn đã được thanh toán qua giao dịch khác.', 1;
            END;
            SELECT MaVe FROM dbo.Ve WHERE MaDonHang = @MaDonHang;
            COMMIT;
            RETURN;
        END;
        IF @tt <> 'CHO_THANH_TOAN' OR @han <= SYSUTCDATETIME() OR @batdau <= dbo.fn_YMC_GioVietNam()
        BEGIN
            THROW 50324, N'Đơn đã hủy, hết hạn hoặc không còn chờ thanh toán.', 1;
        END;
        IF NOT EXISTS(SELECT 1 FROM dbo.SuatChieu s
            JOIN dbo.PhongChieu p ON p.MaPhong = s.MaPhong
            JOIN dbo.Rap r ON r.MaRap = p.MaRap
            JOIN dbo.Phim f ON f.MaPhim = s.MaPhim
            WHERE s.MaSuatChieu = @suat AND s.TrangThai = N'Mở bán'
                AND p.TrangThai = N'Đang hoạt động' AND r.TrangThai = N'Đang hoạt động'
                AND f.TrangThai = N'Đang chiếu')
        BEGIN
            THROW 50325, N'Suất chiếu không còn được phép bán.', 1;
        END;
        IF EXISTS(SELECT 1 FROM dbo.ChiTietVe c JOIN dbo.Ghe g ON g.MaGhe = c.MaGhe
            WHERE c.MaDonHang = @MaDonHang AND (g.TrangThai <> N'Hoạt động' OR NOT EXISTS(
                SELECT 1 FROM dbo.GiuGhe h WHERE h.MaDonHang = c.MaDonHang
                    AND h.MaGhe = c.MaGhe AND h.MaSuatChieu = @suat)))
        BEGIN
            THROW 50327, N'Ghế không còn hoạt động hoặc đơn đã mất quyền giữ ghế.', 1;
        END;
        -- Giá là snapshot đã tính bởi sp_YMC_TaoDonGiuGhe, không nhận số tiền từ client.
        INSERT dbo.ThanhToan(MaDonHang, MaGiaoDich, PhuongThuc, SoTien, NguoiXacNhan)
        VALUES(@MaDonHang, @ma, 'CONG_THANH_TOAN', @tong, @MaTaiKhoan);
        UPDATE dbo.DonHang SET TrangThai = 'DA_THANH_TOAN' WHERE MaDonHang = @MaDonHang;
        INSERT dbo.Ve(MaDonHang, MaGhe)
        SELECT MaDonHang, MaGhe FROM dbo.ChiTietVe WHERE MaDonHang = @MaDonHang;
        SELECT MaVe FROM dbo.Ve WHERE MaDonHang = @MaDonHang;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END;
        THROW;
    END CATCH;
END;
GO
