USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DonDepGheHetHan

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

UPDATE dbo.DonHang SET TrangThai='HET_HAN'
WHERE TrangThai='CHO_THANH_TOAN' AND HanThanhToanUtc<=SYSUTCDATETIME();
DELETE g FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang
WHERE d.TrangThai IN('HET_HAN','DA_HUY','DA_HOAN_TIEN');

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoDonGiuGhe

@NguoiThucHien INT,@MaYeuCau UNIQUEIDENTIFIER,@MaSuatChieu INT,@Kenh VARCHAR(10),
@DanhSachGhe dbo.YMC_DanhSachGhe READONLY,@DanhSachFnb dbo.YMC_DanhSachFnb READONLY,
@HoTenLienHe NVARCHAR(150),@DienThoaiLienHe VARCHAR(20)=NULL,@MaKhachHang INT=NULL

AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @rap INT,@phong INT,@phim INT,@batdau DATETIME2(0),@dd NVARCHAR(50),@ngay DATE,@loaiNgay NVARCHAR(20);
SELECT @rap=p.MaRap,@phong=s.MaPhong,@phim=s.MaPhim,@batdau=s.GioBatDau,@dd=p.DinhDang
FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
WHERE s.MaSuatChieu=@MaSuatChieu AND s.TrangThai=N'Mở bán' AND s.GioBatDau>dbo.fn_YMC_GioVietNam()
AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động' AND f.TrangThai=N'Đang chiếu';
IF @Kenh IS NULL OR @Kenh NOT IN('WEB','QUAY') THROW 50301,N'Kênh bán không hợp lệ.',1;
IF @rap IS NULL THROW 50302,N'Suất chiếu không còn mở bán hoặc rạp/phòng/phim đã ngừng hoạt động.',1;
IF @Kenh='WEB'
BEGIN
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DAT_VE_WEB';
 SET @MaKhachHang=NULL;
 SELECT @MaKhachHang=MaKhachHang FROM dbo.KhachHang WHERE MaTaiKhoan=@NguoiThucHien AND DangHoatDong=1;
 IF @MaKhachHang IS NULL THROW 50303,N'Không tìm thấy hồ sơ khách hàng đang hoạt động.',1;
END
ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAN_VE',@rap;
IF @MaKhachHang IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.KhachHang WHERE MaKhachHang=@MaKhachHang AND DangHoatDong=1)
 THROW 50303,N'Khách hàng không hợp lệ.',1;
IF @MaYeuCau IS NULL THROW 50304,N'Thiếu mã yêu cầu chống tạo đơn lặp.',1;
-- Một mã yêu cầu là một lệnh bất biến; muốn đổi nội dung phải dùng mã mới.
IF EXISTS(SELECT 1 FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau AND NguoiTao=@NguoiThucHien AND MaSuatChieu=@MaSuatChieu AND Kenh=@Kenh)
  THROW 50305,N'Mã yêu cầu đã được dùng cho giao dịch khác.',1;
 SELECT MaDonHang,MaThamChieu,TrangThai,TongTien,HanThanhToanUtc FROM dbo.DonHang WHERE MaYeuCau=@MaYeuCau;
 COMMIT; RETURN;
END;
IF (SELECT COUNT(*) FROM @DanhSachGhe) NOT BETWEEN 1 AND 8 THROW 50306,N'Mỗi đơn phải có từ 1 đến 8 ghế.',1;
IF @HoTenLienHe IS NULL OR LEN(LTRIM(RTRIM(@HoTenLienHe)))=0 THROW 50307,N'Nhập tên liên hệ.',1;
IF (SELECT COUNT(*) FROM @DanhSachFnb)>20 OR EXISTS(SELECT 1 FROM @DanhSachFnb WHERE SoLuong NOT BETWEEN 1 AND 99)
 THROW 50308,N'Số lượng bắp nước không hợp lệ.',1;
UPDATE dbo.DonHang SET TrangThai='HET_HAN' WHERE TrangThai='CHO_THANH_TOAN' AND HanThanhToanUtc<=SYSUTCDATETIME();
DELETE g FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang WHERE d.TrangThai IN('HET_HAN','DA_HUY','DA_HOAN_TIEN');
IF EXISTS(SELECT 1 FROM @DanhSachGhe x LEFT JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
 WHERE g.MaGhe IS NULL OR g.MaPhong<>@phong OR g.TrangThai<>N'Hoạt động') THROW 50309,N'Ghế không hợp lệ hoặc đã ngừng sử dụng.',1;
IF EXISTS(SELECT 1 FROM @DanhSachGhe x JOIN dbo.GiuGhe g ON g.MaGhe=x.MaGhe WHERE g.MaSuatChieu=@MaSuatChieu)
 THROW 50310,N'Một trong các ghế đã có người giữ hoặc đã bán.',1;
-- Đồng bộ với thủ tục sửa bảng giá và menu của file 09.
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_GiaVe_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50311,N'Bảng giá đang cập nhật.',1;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Fnb_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50312,N'Menu đang cập nhật.',1;
SET @ngay=CONVERT(DATE,@batdau);
SET @loaiNgay=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@ngay)%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END;
IF EXISTS(SELECT x.MaGhe FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
 LEFT JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay
 AND v.DangApDung=1 AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay)
 GROUP BY x.MaGhe HAVING COUNT(v.MaGiaVe)<>1) THROW 50313,N'Chưa có bảng giá duy nhất cho các ghế đã chọn.',1;
IF EXISTS(SELECT 1 FROM @DanhSachFnb x LEFT JOIN dbo.v_YMC_FnbMenu p ON p.MaSanPham=x.MaSanPham
 WHERE p.MaSanPham IS NULL OR p.CoTheBan=0) THROW 50314,N'Sản phẩm hoặc combo không còn bán.',1;
DECLARE @tong DECIMAL(18,0),@don BIGINT,@han DATETIME2(0)=DATEADD(MINUTE,10,SYSUTCDATETIME());
IF @han>DATEADD(HOUR,-7,@batdau) SET @han=DATEADD(HOUR,-7,@batdau);
SELECT @tong=SUM(v.DonGia) FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe
JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay
AND v.DangApDung=1 AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay);
SELECT @tong=@tong+ISNULL(SUM(p.DonGia*x.SoLuong),0) FROM @DanhSachFnb x JOIN dbo.FnbSanPham p ON p.MaSanPham=x.MaSanPham;
INSERT dbo.DonHang(MaYeuCau,MaSuatChieu,MaKhachHang,NguoiTao,Kenh,HanThanhToanUtc,TongTien,HoTenLienHe,DienThoaiLienHe)
VALUES(@MaYeuCau,@MaSuatChieu,@MaKhachHang,@NguoiThucHien,@Kenh,@han,@tong,@HoTenLienHe,@DienThoaiLienHe);
SET @don=CONVERT(BIGINT,SCOPE_IDENTITY());
INSERT dbo.ChiTietVe(MaDonHang,MaGhe,MaGiaVe,DonGia,TenPhim,TenRap,TenPhong,NhanGhe,GioBatDau)
SELECT @don,g.MaGhe,v.MaGiaVe,v.DonGia,f.TenPhim,r.TenRap,p.TenPhong,CONCAT(g.HangGhe,g.SoGhe),@batdau
FROM @DanhSachGhe x JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong
JOIN dbo.Rap r ON r.MaRap=p.MaRap CROSS JOIN dbo.Phim f
JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=@dd AND v.LoaiNgay=@loaiNgay AND v.DangApDung=1
AND v.TuNgay<=@ngay AND (v.DenNgay IS NULL OR v.DenNgay>=@ngay) WHERE f.MaPhim=@phim;
INSERT dbo.ChiTietDonFnb SELECT @don,p.MaSanPham,p.TenSanPham,x.SoLuong,p.DonGia FROM @DanhSachFnb x JOIN dbo.FnbSanPham p ON p.MaSanPham=x.MaSanPham;
INSERT dbo.ChiTietComboDaBan SELECT @don,c.MaCombo,c.MaThanhPhan,p.TenSanPham,c.SoLuong
FROM @DanhSachFnb x JOIN dbo.FnbComboChiTiet c ON c.MaCombo=x.MaSanPham JOIN dbo.FnbSanPham p ON p.MaSanPham=c.MaThanhPhan;
INSERT dbo.GiuGhe SELECT @MaSuatChieu,MaGhe,@don FROM @DanhSachGhe;
SELECT MaDonHang,MaThamChieu,TrangThai,TongTien,HanThanhToanUtc FROM dbo.DonHang WHERE MaDonHang=@don;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_SoDoGheTheoSuat
@MaSuatChieu INT
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;

SELECT g.MaGhe,g.HangGhe,g.SoGhe,l.TenLoai,
CASE WHEN g.TrangThai<>N'Hoạt động' THEN N'Không sử dụng'
 WHEN d.TrangThai='DA_THANH_TOAN' THEN N'Đã bán'
 WHEN d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME() THEN N'Đang giữ' ELSE N'Trống' END AS TinhTrang
FROM dbo.SuatChieu s JOIN dbo.Ghe g ON g.MaPhong=s.MaPhong JOIN dbo.LoaiGhe l ON l.MaLoai=g.MaLoaiGhe
LEFT JOIN dbo.GiuGhe h ON h.MaSuatChieu=s.MaSuatChieu AND h.MaGhe=g.MaGhe LEFT JOIN dbo.DonHang d ON d.MaDonHang=h.MaDonHang
WHERE s.MaSuatChieu=@MaSuatChieu ORDER BY g.HangGhe,g.SoGhe;

END;
GO
