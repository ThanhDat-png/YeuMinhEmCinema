-- Dữ liệu minh họa, tùy chọn. Chạy sau script tạo dbo.Phim.
USE [YeuMinhEmCinema];
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Phim WHERE TenPhim = N'Phim minh họa')
    INSERT INTO dbo.Phim (TenPhim, MoTa, ThoiLuong, NgayKhoiChieu, GioiHanTuoi, TrangThai)
    VALUES (N'Phim minh họa', N'Dữ liệu thử chức năng quản lý phim.', 120, '20261022', 'T13', N'Đang chiếu');
GO
