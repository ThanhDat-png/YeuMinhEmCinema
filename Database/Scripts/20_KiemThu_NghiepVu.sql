USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Chỉ đọc dữ liệu; mỗi truy vấn trả về 0 dòng là đạt kiểm tra tương ứng.
SELECT N'Đơn thanh toán thiếu/sai số tiền' Loi,d.MaDonHang FROM dbo.DonHang d LEFT JOIN dbo.ThanhToan t ON t.MaDonHang=d.MaDonHang
WHERE d.TrangThai IN('DA_THANH_TOAN','DA_HOAN_TIEN') AND(t.MaThanhToan IS NULL OR t.SoTien<>d.TongTien);
SELECT N'Tổng đơn không khớp chi tiết' Loi,d.MaDonHang FROM dbo.DonHang d WHERE d.TongTien<>
 ISNULL((SELECT SUM(c.DonGia) FROM dbo.ChiTietVe c WHERE c.MaDonHang=d.MaDonHang),0)
 +ISNULL((SELECT SUM(c.DonGia*c.SoLuong) FROM dbo.ChiTietDonFnb c WHERE c.MaDonHang=d.MaDonHang),0);
SELECT N'Giữ ghế sai phòng/suất' Loi,g.* FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang
JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu JOIN dbo.Ghe h ON h.MaGhe=g.MaGhe WHERE d.MaSuatChieu<>g.MaSuatChieu OR h.MaPhong<>s.MaPhong;
SELECT N'Ve hieu luc thieu cho' Loi,v.MaVe FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang
WHERE v.TrangThai IN('HIEU_LUC','DA_SU_DUNG') AND NOT EXISTS(SELECT 1 FROM dbo.GiuGhe g WHERE g.MaDonHang=v.MaDonHang AND g.MaGhe=v.MaGhe AND g.MaSuatChieu=d.MaSuatChieu);
SELECT N'Ve da soat thieu nhan vien/thoi gian' Loi,MaVe FROM dbo.Ve WHERE TrangThai='DA_SU_DUNG' AND(NguoiSoat IS NULL OR NgaySoatUtc IS NULL);
SELECT N'Hoan tien khong khop' Loi,h.MaHoanTien FROM dbo.HoanTien h JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang WHERE d.TrangThai<>'DA_HOAN_TIEN' OR h.SoTien<>d.TongTien;
SELECT N'Don da thanh toan thieu ve' Loi,c.MaDonHang,c.MaGhe FROM dbo.ChiTietVe c JOIN dbo.DonHang d ON d.MaDonHang=c.MaDonHang
WHERE d.TrangThai='DA_THANH_TOAN' AND NOT EXISTS(SELECT 1 FROM dbo.Ve v WHERE v.MaDonHang=c.MaDonHang AND v.MaGhe=c.MaGhe AND v.TrangThai IN('HIEU_LUC','DA_SU_DUNG'));
GO
