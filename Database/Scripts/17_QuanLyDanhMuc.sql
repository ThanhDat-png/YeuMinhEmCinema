USE YeuMinhEmCinema;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuPhim
@NguoiThucHien INT,@MaPhim INT=NULL,@TenPhim NVARCHAR(200),@ThoiLuong INT,@NgayKhoiChieu DATE,
@GioiHanTuoi VARCHAR(10),@TrangThai NVARCHAR(30),@MoTa NVARCHAR(MAX)=NULL,@Poster NVARCHAR(500)=NULL,@Trailer NVARCHAR(500)=NULL
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'PHIM_QUAN_LY';
IF @TenPhim IS NULL OR LEN(LTRIM(RTRIM(@TenPhim)))=0 OR @ThoiLuong IS NULL OR @ThoiLuong NOT BETWEEN 1 AND 600
 THROW 50500,N'Tên phim và thời lượng 1–600 phút là bắt buộc.',1;
IF @GioiHanTuoi IS NULL OR @GioiHanTuoi NOT IN('P','K','T13','T16','T18') THROW 50501,N'Giới hạn tuổi hợp lệ: P, K, T13, T16, T18.',1;
IF @NgayKhoiChieu IS NULL OR @TrangThai IS NULL OR @TrangThai NOT IN(N'Sắp chiếu',N'Đang chiếu',N'Ngừng chiếu') THROW 50502,N'Ngày khởi chiếu hoặc trạng thái không hợp lệ.',1;
IF @MaPhim IS NULL
BEGIN
 INSERT dbo.Phim(TenPhim,MoTa,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,Poster,Trailer,TrangThai)
 VALUES(@TenPhim,@MoTa,@ThoiLuong,@NgayKhoiChieu,@GioiHanTuoi,@Poster,@Trailer,@TrangThai);
 SET @MaPhim=CONVERT(INT,SCOPE_IDENTITY());
END
ELSE
BEGIN
 IF NOT EXISTS(SELECT 1 FROM dbo.Phim WHERE MaPhim=@MaPhim) THROW 50503,N'Phim không tồn tại.',1;
 IF EXISTS(SELECT 1 FROM dbo.SuatChieu WHERE MaPhim=@MaPhim AND TrangThai<>N'Đã hủy' AND GioBatDau>dbo.fn_YMC_GioVietNam())
 AND EXISTS(SELECT 1 FROM dbo.Phim WHERE MaPhim=@MaPhim AND (ThoiLuong<>@ThoiLuong OR NgayKhoiChieu<>@NgayKhoiChieu OR TrangThai<>@TrangThai OR GioiHanTuoi<>@GioiHanTuoi))
 THROW 50504,N'Phim có lịch tương lai. Xử lý lịch trước khi đổi thời lượng, ngày chiếu, giới hạn tuổi hoặc trạng thái.',1;
 UPDATE dbo.Phim SET TenPhim=@TenPhim,MoTa=@MoTa,ThoiLuong=@ThoiLuong,NgayKhoiChieu=@NgayKhoiChieu,
 GioiHanTuoi=@GioiHanTuoi,Poster=@Poster,Trailer=@Trailer,TrangThai=@TrangThai WHERE MaPhim=@MaPhim;
END;
SELECT @MaPhim AS MaPhim;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuRap
@NguoiThucHien INT,@MaRap INT=NULL,@TenRap NVARCHAR(200),@DiaChi NVARCHAR(500)=NULL,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

-- Tạo rạp là thao tác danh mục toàn hệ thống; sửa rạp phải còn được phân công.
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@MaRap;
IF @MaRap IS NULL AND NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@NguoiThucHien AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 THROW 50404,N'Chỉ Admin được tạo rạp mới.',1;
IF @TenRap IS NULL OR LEN(LTRIM(RTRIM(@TenRap)))=0 OR @TrangThai IS NULL OR @TrangThai NOT IN(N'Đang hoạt động',N'Ngừng hoạt động') THROW 50505,N'Tên rạp hoặc trạng thái không hợp lệ.',1;
IF @MaRap IS NULL
BEGIN INSERT dbo.Rap(TenRap,DiaChi,TrangThai) VALUES(@TenRap,@DiaChi,@TrangThai);SET @MaRap=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF @TrangThai<>N'Đang hoạt động' AND EXISTS(SELECT 1 FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong WHERE p.MaRap=@MaRap AND s.TrangThai<>N'Đã hủy' AND s.GioKetThuc>dbo.fn_YMC_GioVietNam())
 THROW 50506,N'Rạp có lịch chưa kết thúc. Xử lý lịch trước khi ngừng hoạt động.',1;
 UPDATE dbo.Rap SET TenRap=@TenRap,DiaChi=@DiaChi,TrangThai=@TrangThai WHERE MaRap=@MaRap;
 IF @@ROWCOUNT<>1 THROW 50507,N'Không tìm thấy rạp.',1;
END; SELECT @MaRap AS MaRap;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuPhong
@NguoiThucHien INT,@MaPhong INT=NULL,@MaRap INT,@TenPhong NVARCHAR(100),@DinhDang NVARCHAR(50),@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

-- Kiểm tra cả rạp hiện tại và rạp đích, kể cả khi form đã mở trước lúc thu hồi rạp.
IF @MaRap IS NULL THROW 50507,N'Không tìm thấy rạp.',1;
IF @MaPhong IS NOT NULL
BEGIN
 DECLARE @RapCu INT;
 SELECT @RapCu=MaRap FROM dbo.PhongChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong;
 IF @RapCu IS NULL THROW 50510,N'Không tìm thấy phòng.',1;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapCu;
END;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@MaRap;
IF @TenPhong IS NULL OR LEN(LTRIM(RTRIM(@TenPhong)))=0 OR @DinhDang IS NULL OR LEN(LTRIM(RTRIM(@DinhDang)))=0
 OR @TrangThai IS NULL OR @TrangThai NOT IN(N'Đang hoạt động',N'Ngừng hoạt động') THROW 50508,N'Thông tin phòng không hợp lệ.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.Rap WHERE MaRap=@MaRap AND TrangThai=N'Đang hoạt động') THROW 50507,N'Rạp không hoạt động.',1;
IF @MaPhong IS NULL
BEGIN INSERT dbo.PhongChieu(MaRap,TenPhong,DinhDang,TrangThai) VALUES(@MaRap,@TenPhong,@DinhDang,@TrangThai);SET @MaPhong=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.SuatChieu WHERE MaPhong=@MaPhong AND TrangThai<>N'Đã hủy' AND GioKetThuc>dbo.fn_YMC_GioVietNam())
 AND EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong AND (MaRap<>@MaRap OR DinhDang<>@DinhDang OR TrangThai<>@TrangThai))
 THROW 50509,N'Phòng có lịch chưa kết thúc, chưa thể chuyển rạp/định dạng/trạng thái.',1;
 UPDATE dbo.PhongChieu SET MaRap=@MaRap,TenPhong=@TenPhong,DinhDang=@DinhDang,TrangThai=@TrangThai WHERE MaPhong=@MaPhong;
 IF @@ROWCOUNT<>1 THROW 50510,N'Không tìm thấy phòng.',1;
END;SELECT @MaPhong AS MaPhong;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuGhe
@NguoiThucHien INT,@MaGhe INT=NULL,@MaPhong INT,@HangGhe VARCHAR(5),@SoGhe INT,@MaLoaiGhe INT,@TrangThai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

DECLARE @lockResult INT;
EXEC dbo.sp_YMC_KhoaLich;
EXEC @lockResult=sys.sp_getapplock @Resource=N'YMC_Booking_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @lockResult<0 THROW 50300,N'Hệ thống đặt vé đang bận. Vui lòng thử lại.',1;

DECLARE @RapDich INT,@RapCu INT;
SELECT @RapDich=MaRap FROM dbo.PhongChieu WITH(UPDLOCK,HOLDLOCK) WHERE MaPhong=@MaPhong;
IF @RapDich IS NULL THROW 50512,N'Phòng không tồn tại.',1;
IF @MaGhe IS NOT NULL
BEGIN
 SELECT @RapCu=p.MaRap FROM dbo.Ghe g WITH(UPDLOCK,HOLDLOCK)
 JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong WHERE g.MaGhe=@MaGhe;
 IF @RapCu IS NULL THROW 50515,N'Không tìm thấy ghế.',1;
 EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapCu;
END;
EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY',@RapDich;
IF @HangGhe IS NULL OR LEN(LTRIM(RTRIM(@HangGhe)))=0 OR @SoGhe IS NULL OR @SoGhe<1 OR @TrangThai IS NULL
 OR @TrangThai NOT IN(N'Hoạt động',N'Hỏng/Ngừng sử dụng') THROW 50511,N'Thông tin ghế không hợp lệ.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE MaPhong=@MaPhong) OR NOT EXISTS(SELECT 1 FROM dbo.LoaiGhe WHERE MaLoai=@MaLoaiGhe) THROW 50512,N'Phòng hoặc loại ghế không tồn tại.',1;
IF @MaGhe IS NULL
BEGIN INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@MaPhong,@HangGhe,@SoGhe,@MaLoaiGhe,@TrangThai);SET @MaGhe=CONVERT(INT,SCOPE_IDENTITY());END
ELSE
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.GiuGhe g JOIN dbo.DonHang d ON d.MaDonHang=g.MaDonHang JOIN dbo.SuatChieu s ON s.MaSuatChieu=g.MaSuatChieu
 WHERE g.MaGhe=@MaGhe AND s.GioKetThuc>dbo.fn_YMC_GioVietNam() AND (d.TrangThai='DA_THANH_TOAN' OR (d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc>SYSUTCDATETIME())))
 THROW 50513,N'Ghế đang giữ hoặc có vé chưa kết thúc suất, chưa được sửa.',1;
 IF EXISTS(SELECT 1 FROM dbo.ChiTietVe WHERE MaGhe=@MaGhe) AND EXISTS(SELECT 1 FROM dbo.Ghe WHERE MaGhe=@MaGhe AND MaPhong<>@MaPhong)
 THROW 50514,N'Ghế có lịch sử giao dịch không được chuyển phòng.',1;
 UPDATE dbo.Ghe SET MaPhong=@MaPhong,HangGhe=@HangGhe,SoGhe=@SoGhe,MaLoaiGhe=@MaLoaiGhe,TrangThai=@TrangThai WHERE MaGhe=@MaGhe;
 IF @@ROWCOUNT<>1 THROW 50515,N'Không tìm thấy ghế.',1;
END; SELECT @MaGhe AS MaGhe;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_LuuLoaiGhe
@NguoiThucHien INT,@MaLoai INT=NULL,@TenLoai NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'RAP_QUAN_LY';
-- Loại ghế dùng chung mọi rạp, không thuộc riêng một phân công.
IF NOT EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@NguoiThucHien AND v.TenVaiTro='ADMIN' AND v.DangHoatDong=1)
 THROW 50404,N'Chỉ Admin được quản lý loại ghế dùng chung.',1;
IF @TenLoai IS NULL OR LEN(LTRIM(RTRIM(@TenLoai)))=0 THROW 50516,N'Nhập tên loại ghế.',1;
IF @MaLoai IS NULL BEGIN INSERT dbo.LoaiGhe(TenLoai) VALUES(@TenLoai);SET @MaLoai=CONVERT(INT,SCOPE_IDENTITY());END
ELSE BEGIN UPDATE dbo.LoaiGhe SET TenLoai=@TenLoai WHERE MaLoai=@MaLoai;IF @@ROWCOUNT<>1 THROW 50517,N'Không tìm thấy loại ghế.',1;END;
SELECT @MaLoai AS MaLoai;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiTrangThaiTaiKhoan
@NguoiThucHien INT,@MaTaiKhoan INT,@DangHoatDong BIT,@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

EXEC dbo.sp_YMC_YeuCauQuyen @NguoiThucHien,'TAI_KHOAN_QUAN_LY';
IF @MaTaiKhoan=@NguoiThucHien THROW 50520,N'Không tự vô hiệu hóa tài khoản của mình.',1;
DECLARE @k INT;
EXEC @k=sys.sp_getapplock @Resource=N'YMC_Account_Write',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @k<0 THROW 50405,N'Tài khoản đang cập nhật.',1;
-- Chỉ ADMIN được thay đổi tài khoản ADMIN; tránh tài khoản đặc quyền tùy biến vượt cấp.
IF EXISTS(SELECT 1 FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@MaTaiKhoan AND v.TenVaiTro='ADMIN')
 THROW 50521,N'Bản đồ án không cho vô hiệu hóa ADMIN qua màn hình này.',1;
UPDATE dbo.TaiKhoan SET DangHoatDong=@DangHoatDong WHERE MaTaiKhoan=@MaTaiKhoan AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50522,N'Tài khoản đã đổi, hãy tải lại.',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_YMC_DoiMatKhau
@MaTaiKhoan INT,@MatKhauHashMoi VARCHAR(1000),@PhienBan BINARY(8)
AS
BEGIN
SET NOCOUNT ON; SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRAN;

-- Backend phải xác thực mật khẩu cũ hoặc luồng khôi phục trước khi gọi.
IF @MatKhauHashMoi IS NULL OR LEN(@MatKhauHashMoi)<40 THROW 50407,N'Thiếu chuỗi băm mật khẩu từ C#.',1;
UPDATE dbo.TaiKhoan SET MatKhauHash=@MatKhauHashMoi,SoLanDangNhapSai=0,KhoaDenLuc=NULL
WHERE MaTaiKhoan=@MaTaiKhoan AND DangHoatDong=1 AND PhienBan=@PhienBan;
IF @@ROWCOUNT<>1 THROW 50522,N'Tài khoản đã đổi hoặc ngừng hoạt động.',1;

COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
END;
GO
