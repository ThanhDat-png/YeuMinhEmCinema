USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER FUNCTION dbo.fn_YMC_CoPhamViRap(@MaTaiKhoan INT,@MaRap INT) RETURNS BIT AS
BEGIN
 DECLARE @ok BIT=0;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoan t WHERE t.MaTaiKhoan=@MaTaiKhoan AND t.DangHoatDong=1 AND(t.KhoaDenLuc IS NULL OR t.KhoaDenLuc<=SYSUTCDATETIME()))
 AND(EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 OR EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)) SET @ok=1;
 RETURN @ok;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoKhachTaiQuay @NguoiThucHien INT,@HoTen NVARCHAR(150),@DienThoai VARCHAR(20)=NULL,@NgaySinh DATE=NULL AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'KHACH_HANG_QUAN_LY';
 IF @HoTen IS NULL OR LEN(LTRIM(RTRIM(@HoTen)))=0 THROW 50700,N'Nhập họ tên khách.',1;
 IF @NgaySinh>CONVERT(DATE,dbo.fn_YMC_GioVietNam()) THROW 50701,N'Ngày sinh không hợp lệ.',1;
 INSERT dbo.KhachHang(HoTen,DienThoai,NgaySinh) VALUES(LTRIM(RTRIM(@HoTen)),@DienThoai,@NgaySinh);
 SELECT CONVERT(INT,SCOPE_IDENTITY()) MaKhachHang;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiTrangThaiKhach @NguoiThucHien INT,@MaKhachHang INT,@DangHoatDong BIT,@PhienBan BINARY(8) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'KHACH_HANG_QUAN_LY';
 UPDATE dbo.KhachHang SET DangHoatDong=@DangHoatDong WHERE MaKhachHang=@MaKhachHang AND PhienBan=@PhienBan;
 IF @@ROWCOUNT<>1 THROW 50702,N'Hồ sơ đã thay đổi. Tải lại.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_AdminDatLaiMatKhau @NguoiThucHien INT,@MaTaiKhoan INT,@MatKhauHash VARCHAR(1000),@PhienBan BINARY(8) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'TAI_KHOAN_QUAN_LY';
 IF @MatKhauHash IS NULL OR LEN(@MatKhauHash)<40 THROW 50703,N'Thiếu hash mật khẩu.',1;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN')
 THROW 50704,N'ADMIN phải tự đổi mật khẩu bằng mật khẩu hiện tại.',1;
 UPDATE dbo.TaiKhoan SET MatKhauHash=@MatKhauHash,SoLanDangNhapSai=0,KhoaDenLuc=NULL WHERE MaTaiKhoan=@MaTaiKhoan AND PhienBan=@PhienBan;
 IF @@ROWCOUNT<>1 THROW 50705,N'Tài khoản đã đổi, hãy tải lại.',1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_TaoGheTheoLo @NguoiThucHien INT,@MaPhong INT,@SoHang INT,@SoGheMoiHang INT,@MaLoaiGhe INT AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY
 BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
 IF @SoHang IS NULL OR @SoHang NOT BETWEEN 1 AND 26 OR @SoGheMoiHang IS NULL OR @SoGheMoiHang NOT BETWEEN 1 AND 50 THROW 50706,N'Giới hạn 1–26 hàng, 1–50 ghế/hàng.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Phòng/loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu WHERE s.MaPhong=@MaPhong AND s.GioKetThuc>dbo.fn_YMC_GioVietNam()
 AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50708,N'Phòng có đơn/vé chưa kết thúc, không thay đổi sức chứa lúc này.',1;
 DECLARE @h INT=1,@s INT,@them INT=0;
 WHILE @h<=@SoHang BEGIN SET @s=1;WHILE @s<=@SoGheMoiHang BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.Ghe WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong AND HangGhe=CHAR(64+@h) AND SoGhe=@s)
 BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,CHAR(64+@h),@s,@MaLoaiGhe,N'Hoạt động');SET @them+=1;END;
 SET @s+=1;END;SET @h+=1;END;
 COMMIT;SELECT @them SoGheDaTao,@SoHang*@SoGheMoiHang-@them SoGheBoQua;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_CapNhatLoGhe @NguoiThucHien INT,@Ghe dbo.YMC_DanhSachGhe READONLY,@MaLoaiGhe INT=NULL,@TrangThai NVARCHAR(50)=NULL AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
 IF NOT EXISTS(SELECT 1 FROM @Ghe) OR(@MaLoaiGhe IS NULL AND @TrangThai IS NULL) THROW 50709,N'Chọn ghế và thông tin cần cập nhật.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x LEFT JOIN dbo.Ghe g ON g.MaGhe=x.MaGhe WHERE g.MaGhe IS NULL) THROW 50710,N'Ghế không tồn tại.',1;
 IF @TrangThai IS NOT NULL AND @TrangThai NOT IN(N'Hoạt động',N'Hỏng/Ngừng sử dụng') THROW 50711,N'Trạng thái ghế không hợp lệ.',1;
 IF @MaLoaiGhe IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50707,N'Loại ghế không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM @Ghe x JOIN dbo.GiuGhe g ON g.MaGhe=x.MaGhe JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND(d.TrangThai='DA_THANH_TOAN' OR(d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME()))) THROW 50712,N'Có ghế đang giữ hoặc vé chưa kết thúc. Không sửa cả lô.',1;
 UPDATE g SET MaLoaiGhe=ISNULL(@MaLoaiGhe,g.MaLoaiGhe),TrangThai=ISNULL(@TrangThai,g.TrangThai) FROM dbo.Ghe g JOIN @Ghe x ON x.MaGhe=g.MaGhe;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
IF TYPE_ID(N'dbo.YMC_MaQuyen') IS NULL EXEC(N'CREATE TYPE dbo.YMC_MaQuyen AS TABLE(MaQuyen VARCHAR(80) PRIMARY KEY)');
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuBoQuyenVaiTro @NguoiThucHien INT,@TenVaiTro VARCHAR(50),@Quyen dbo.YMC_MaQuyen READONLY AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHAN_QUYEN_QUAN_LY';
 IF @TenVaiTro IS NULL OR @TenVaiTro='ADMIN' THROW 50713,N'Không sửa bộ quyền ADMIN.',1;
 DECLARE @k INT,@v INT;
 EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
 IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
 SELECT @v=MaVaiTro FROM dbo.VaiTro WHERE TenVaiTro=@TenVaiTro;
 IF @v IS NULL OR EXISTS(SELECT 1 FROM @Quyen x LEFT JOIN dbo.Quyen q ON q.MaQuyen=x.MaQuyen WHERE q.MaQuyen IS NULL) THROW 50714,N'Vai trò hoặc quyền không tồn tại.',1;
 DELETE dbo.VaiTroQuyen WHERE MaVaiTro=@v;
 INSERT dbo.VaiTroQuyen SELECT @v,MaQuyen FROM @Quyen;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_YMC_HuyDonChuaThanhToan @NguoiThucHien INT,@MaDonHang BIGINT,@LyDo NVARCHAR(500) AS
BEGIN
 SET NOCOUNT ON;SET XACT_ABORT ON;
 BEGIN TRY BEGIN TRAN;
 EXEC dbo.sp_YMC_KhoaLich;
 DECLARE @k INT,@rap INT,@tt VARCHAR(20),@owner INT,@kenh VARCHAR(10);
 EXEC @k=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
 IF @k<0 THROW 50300,N'Hệ thống đang bận.',1;
 SELECT @rap=p.MaRap,@tt=d.TrangThai,@owner=d.NguoiTao,@kenh=d.Kenh FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE d.MaDonHang=@MaDonHang;
 IF @rap IS NULL THROW 50320,N'Không tìm thấy đơn.',1;
 IF @owner=@NguoiThucHien AND @kenh='QUAY' EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'BAN_VE',@rap;
 ELSE IF EXISTS(SELECT 1 FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang WHERE d.MaDonHang=@MaDonHang AND k.MaTaiKhoan=@NguoiThucHien AND k.DangHoatDong=1)
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_CA_NHAN';
 ELSE EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'DON_HANG_HUY',@rap;
 IF @tt='DA_HUY' BEGIN COMMIT;RETURN;END;
 IF @tt<>'CHO_THANH_TOAN' THROW 50330,N'Chỉ hủy trực tiếp đơn chưa thanh toán.',1;
 IF @LyDo IS NULL OR LEN(LTRIM(RTRIM(@LyDo)))=0 THROW 50331,N'Nhập lý do hủy.',1;
 UPDATE dbo.DonHang SET TrangThai='DA_HUY',LyDoHuy=@LyDo WHERE MaDonHang=@MaDonHang;
 DELETE dbo.GiuGhe WHERE MaDonHang=@MaDonHang;
 COMMIT;
 END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK;THROW;END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_YeuCauQuyen @MaTaiKhoan INT,@MaQuyen VARCHAR(80),@MaRap INT=NULL AS
BEGIN
 SET NOCOUNT ON;
 IF NOT EXISTS(SELECT 1 FROM dbo.v_YMC_QuyenTaiKhoan WHERE MaTaiKhoan=@MaTaiKhoan AND MaQuyen=@MaQuyen)
 THROW 50403,N'Tài khoản không có quyền hoặc đang khóa.',1;
 DECLARE @admin BIT=0;
 IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1) SET @admin=1;
 IF @admin=0 AND @MaQuyen NOT IN('DAT_VE_WEB','DON_HANG_CA_NHAN') AND EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaTaiKhoan=@MaTaiKhoan AND DangLamViec=0)
 THROW 50404,N'Hồ sơ nhân viên đã ngừng làm việc.',1;
 IF @MaRap IS NOT NULL AND @admin=0 AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien n JOIN dbo.NhanVienRap r ON r.MaNhanVien=n.MaNhanVien WHERE n.MaTaiKhoan=@MaTaiKhoan AND n.DangLamViec=1 AND r.MaRap=@MaRap)
 THROW 50404,N'Bạn không được phân công rạp này.',1;
END;
GO
PRINT N'Đã cập nhật SQL 23 cho WinForms. Không xóa hoặc seed lại dữ liệu.';
GO
