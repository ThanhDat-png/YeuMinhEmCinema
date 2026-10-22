-- CHỈ KIỂM TRA, KHÔNG THAY ĐỔI DỮ LIỆU.
USE YeuMinhEmCinema;
GO
SELECT r.MaRap, r.TenRap, r.DiaChi, r.TrangThai,
       (SELECT COUNT(*) FROM dbo.PhongChieu p WHERE p.MaRap=r.MaRap) AS SoPhong
FROM dbo.Rap r ORDER BY r.MaRap;
SELECT MaPhong, MaRap, TenPhong, DinhDang, TrangThai
FROM dbo.PhongChieu ORDER BY MaRap, MaPhong;
SELECT MaLoai, TenLoai FROM dbo.LoaiGhe ORDER BY MaLoai;
SELECT TenRap, COUNT(*) AS SoBanGhi
FROM dbo.Rap GROUP BY TenRap HAVING COUNT(*) > 1;
-- Tên sai mã hóa có thể khác tên đúng nên không xuất hiện trong nhóm trùng ở trên.
SELECT MaRap, TenPhong, COUNT(*) AS SoBanGhi
FROM dbo.PhongChieu GROUP BY MaRap, TenPhong HAVING COUNT(*) > 1;
