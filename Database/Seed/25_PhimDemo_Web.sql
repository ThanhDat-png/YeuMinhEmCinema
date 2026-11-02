-- Tùy chọn: 16 phim hư cấu để thử tìm kiếm, phân trang, poster và chi tiết.
-- Chạy trong SSMS trên database bạn muốn dùng thử. Không sửa hoặc xóa phim có sẵn.
USE YeuMinhEmCinema;
GO
SET XACT_ABORT ON;
BEGIN TRAN;
DECLARE @HomNay DATE=CONVERT(DATE,DATEADD(HOUR,7,SYSUTCDATETIME()));
INSERT dbo.Phim(TenPhim,MoTa,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,TrangThai)
SELECT v.Ten,v.MoTa,v.Phut,v.Ngay,v.Tuoi,v.Poster,v.TrangThai
FROM (VALUES
(N'[DEMO] Chuyến Tàu Bình Minh',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',92,DATEADD(DAY,-1,@HomNay),'T13',N'/images/demo/phim-01.svg',N'Đang chiếu'),
(N'[DEMO] Thành Phố Không Ngủ',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',94,DATEADD(DAY,-2,@HomNay),'T13',N'/images/demo/phim-02.svg',N'Đang chiếu'),
(N'[DEMO] Mùa Hè Bên Cửa Sổ',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',96,DATEADD(DAY,-3,@HomNay),'T13',N'/images/demo/phim-03.svg',N'Đang chiếu'),
(N'[DEMO] Tín Hiệu Từ Sao Hỏa',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',98,DATEADD(DAY,-4,@HomNay),'T13',N'/images/demo/phim-04.svg',N'Đang chiếu'),
(N'[DEMO] Khu Rừng Bí Mật',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',100,DATEADD(DAY,-5,@HomNay),'T13',N'/images/demo/phim-05.svg',N'Đang chiếu'),
(N'[DEMO] Ngày Mai Gặp Lại',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',102,DATEADD(DAY,-6,@HomNay),'T13',N'/images/demo/phim-06.svg',N'Đang chiếu'),
(N'[DEMO] Bản Nhạc Cuối Thu',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',104,DATEADD(DAY,-7,@HomNay),'T13',N'/images/demo/phim-07.svg',N'Đang chiếu'),
(N'[DEMO] Đường Đua Ánh Sáng',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',106,DATEADD(DAY,-8,@HomNay),'T13',N'/images/demo/phim-08.svg',N'Đang chiếu'),
(N'[DEMO] Người Giữ Những Vì Sao',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',108,DATEADD(DAY,-9,@HomNay),'T13',N'/images/demo/phim-09.svg',N'Đang chiếu'),
(N'[DEMO] Hành Trình Qua Mây',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',110,DATEADD(DAY,-10,@HomNay),'T13',N'/images/demo/phim-10.svg',N'Đang chiếu'),
(N'[DEMO] Cánh Cửa Thứ Mười Hai',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',112,DATEADD(DAY,-11,@HomNay),'T13',N'/images/demo/phim-11.svg',N'Đang chiếu'),
(N'[DEMO] Biển Gọi Tên Em',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',114,DATEADD(DAY,-12,@HomNay),'T13',N'/images/demo/phim-12.svg',N'Đang chiếu'),
(N'[DEMO] Thư Gửi Tương Lai',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',116,DATEADD(DAY,13,@HomNay),'T13',N'/images/demo/phim-13.svg',N'Sắp chiếu'),
(N'[DEMO] Vũ Điệu Trong Mưa',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',118,DATEADD(DAY,14,@HomNay),'T13',N'/images/demo/phim-14.svg',N'Sắp chiếu'),
(N'[DEMO] Miền Ký Ức',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',120,DATEADD(DAY,15,@HomNay),'T13',N'/images/demo/phim-15.svg',N'Sắp chiếu'),
(N'[DEMO] Chuyến Phiêu Lưu Nhỏ',N'Phim hư cấu dùng thử giao diện và đặt vé YeuMinhEm Cinema.',122,DATEADD(DAY,16,@HomNay),'T13',N'/images/demo/phim-16.svg',N'Sắp chiếu')
) v(Ten,MoTa,Phut,Ngay,Tuoi,Poster,TrangThai)
WHERE NOT EXISTS(SELECT 1 FROM dbo.Phim p WITH(UPDLOCK,HOLDLOCK) WHERE p.TenPhim=v.Ten);
COMMIT;
SELECT MaPhim,TenPhim,TrangThai FROM dbo.Phim WHERE TenPhim LIKE N'[[]DEMO] %';
GO
