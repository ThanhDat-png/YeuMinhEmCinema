USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
-- Không đổi schema hay hợp đồng thanh toán. Chỉ mở rộng tra cứu Admin.
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DanhSachDonAdmin
@NguoiThucHien INT,@MaRap INT,@TuNgay DATE,@DenNgay DATE,@TrangThai VARCHAR(20)=NULL,@Trang INT=1,@KichThuocTrang INT=50,
@TuKhoa NVARCHAR(100)=NULL,@TongKetQua INT=NULL OUTPUT
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_XEM',@MaRap;
 IF @MaRap IS NULL OR @TuNgay IS NULL OR @DenNgay IS NULL OR @DenNgay<@TuNgay OR @DenNgay>='99991231'
  THROW 50600,N'Chọn rạp và khoảng ngày.',1;
 IF @Trang IS NULL OR @Trang<1 OR @Trang>1000000 OR @KichThuocTrang IS NULL OR @KichThuocTrang NOT BETWEEN 1 AND 100
  THROW 50610,N'Phân trang không hợp lệ.',1;
 SET @TuKhoa=NULLIF(LTRIM(RTRIM(@TuKhoa)),N'');
 DECLARE @id BIGINT=TRY_CONVERT(BIGINT,@TuKhoa),@guid UNIQUEIDENTIFIER;
 -- Chỉ nhận toàn bộ GUID, không để SQL tự cắt chuỗi dài rồi chuyển đổi thành GUID.
 IF LEN(@TuKhoa)=36 SET @guid=TRY_CONVERT(UNIQUEIDENTIFIER,@TuKhoa);
 -- Chụp tập kết quả một lần để tổng và dữ liệu trang nhất quán trong cùng lần tải.
 SELECT d.* INTO #DonLoc FROM dbo.DonHang d
 JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
 WHERE p.MaRap=@MaRap AND (@TrangThai IS NULL OR d.TrangThai=@TrangThai)
 AND d.NgayTaoUtc>=DATEADD(HOUR,-7,CONVERT(DATETIME2(0),@TuNgay))
 AND d.NgayTaoUtc<DATEADD(HOUR,-7,DATEADD(DAY,1,CONVERT(DATETIME2(0),@DenNgay)))
 AND (@TuKhoa IS NULL OR d.MaDonHang=@id OR d.MaThamChieu=@guid
 OR EXISTS(SELECT 1 FROM dbo.ThanhToan t WHERE t.MaDonHang=d.MaDonHang AND t.MaGiaoDich=@TuKhoa)
 OR EXISTS(SELECT 1 FROM dbo.Ve v WHERE v.MaDonHang=d.MaDonHang AND v.MaVe=@guid));
 SELECT @TongKetQua=COUNT(*) FROM #DonLoc;
 SELECT d.*,@TongKetQua TongKetQua FROM #DonLoc d ORDER BY d.MaDonHang DESC
 OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;
END;
GO
