-- Chỉ đọc; kiểm sự tồn tại đối tượng, không thay đổi schema/dữ liệu hoặc xác nhận toàn bộ nghiệp vụ.
-- Đổi USE dưới đây sang đúng database cần kiểm tra; kiểm thử trong phiên chỉ dùng Test.
USE YeuMinhEmCinema;
GO
SELECT SERVERPROPERTY('ProductVersion') PhienBanSQL,compatibility_level FROM sys.databases WHERE name=DB_NAME();
SELECT v.TenBang BangConThieu FROM(VALUES(N'Phim'),(N'Rap'),(N'PhongChieu'),(N'LoaiGhe'),(N'Ghe'),(N'SuatChieu'),(N'GiaVe'),(N'FnbSanPham'),(N'FnbComboChiTiet'),(N'TaiKhoan'),(N'VaiTro'),(N'Quyen'),(N'TaiKhoanVaiTro'),(N'VaiTroQuyen'),(N'KhachHang'),(N'NhanVien'),(N'NhanVienRap'),(N'DonHang'),(N'ChiTietVe'),(N'ChiTietDonFnb'),(N'ChiTietComboDaBan'),(N'GiuGhe'),(N'ThanhToan'),(N'Ve'),(N'HoanTien'),(N'TheLoai'),(N'PhimTheLoai'))v(TenBang) WHERE OBJECT_ID(N'dbo.'+v.TenBang,N'U') IS NULL;
SELECT v.TenProc ProcedureConThieu FROM(VALUES(N'sp_DoiTrangThaiSuatChieu'),(N'sp_SaoChepLich'),(N'sp_SuaSuatChieu'),(N'sp_ThemSuatChieu'),(N'sp_YMC_AdminDoiTrangThaiSuat'),(N'sp_YMC_AdminLuuFnb'),(N'sp_YMC_AdminLuuGiaVe'),(N'sp_YMC_AdminSaoChepLich'),(N'sp_YMC_AdminSuaSuatChieu'),(N'sp_YMC_AdminThemSuatChieu'),(N'sp_YMC_BaoCaoDoanhThu'),(N'sp_YMC_CapNhatKhachHang'),(N'sp_YMC_CapNhatNhanVien'),(N'sp_YMC_CapQuyenVaiTro'),(N'sp_YMC_DangKyKhachHang'),(N'sp_YMC_DanhSachDonAdmin'),(N'sp_YMC_DoiMatKhau'),(N'sp_YMC_DoiTrangThaiTaiKhoan'),(N'sp_YMC_DonDepGheHetHan'),(N'sp_YMC_GanVaiTro'),(N'sp_YMC_GhiNhanDangNhap'),(N'sp_YMC_GhiNhanHoanTien'),(N'sp_YMC_HuyDonChuaThanhToan'),(N'sp_YMC_KhoaLich'),(N'sp_YMC_KhoaPhong'),(N'sp_YMC_KhoiTaoAdmin'),(N'sp_YMC_KiemTraLienQuan'),(N'sp_YMC_KiemTraSuat'),(N'sp_YMC_KiemTraVe'),(N'sp_YMC_LayQuyenTaiKhoan'),(N'sp_YMC_LayThongTinDangNhap'),(N'sp_YMC_LuuFnb'),(N'sp_YMC_LuuGhe'),(N'sp_YMC_LuuGiaVe'),(N'sp_YMC_LuuLoaiGhe'),(N'sp_YMC_LuuPhim'),(N'sp_YMC_LuuPhong'),(N'sp_YMC_LuuRap'),(N'sp_YMC_PhanCongRap'),(N'sp_YMC_SoDoGheTheoSuat'),(N'sp_YMC_TaoDonGiuGhe'),(N'sp_YMC_TaoNhanVien'),(N'sp_YMC_ThongKeFnb'),(N'sp_YMC_ThongKePhim'),(N'sp_YMC_TraGiaTheoSuatGhe'),(N'sp_YMC_WebChiTietPhim'),(N'sp_YMC_WebDanhSachPhim'),(N'sp_YMC_WebDonHangCuaToi'),(N'sp_YMC_WebLichChieu'),(N'sp_YMC_XacNhanThanhToan'),(N'sp_YMC_XemChiTietDon'),(N'sp_YMC_YeuCauQuyen'),(N'sp_YMC_AdminDatLaiMatKhau'),(N'sp_YMC_BaoCaoTheoSuat'),(N'sp_YMC_BaoCaoThuChiTiet'),(N'sp_YMC_CapNhatLoGhe'),(N'sp_YMC_DoiTrangThaiKhach'),(N'sp_YMC_GanTheLoaiPhim'),(N'sp_YMC_LayPhimBaoCao'),(N'sp_YMC_LayPhimKemTheLoaiAdmin'),(N'sp_YMC_LaySuatSoatVe'),(N'sp_YMC_LayTheLoaiAdmin'),(N'sp_YMC_LayTheLoaiCuaPhim'),(N'sp_YMC_LuuBoQuyenVaiTro'),(N'sp_YMC_LuuTheLoai'),(N'sp_YMC_TaoGheTheoLo'),(N'sp_YMC_TaoKhachTaiQuay'),(N'sp_YMC_TimNhanVienAdmin'),(N'sp_YMC_TimSuatTaiQuay'),(N'sp_YMC_TraCuuPhongAdmin'))v(TenProc) WHERE OBJECT_ID(N'dbo.'+v.TenProc,N'P') IS NULL;
-- Các đối tượng dùng chung và TVP cần cho cài đặt hiện hành đến SQL30.
SELECT v.TenHam HamConThieu FROM(VALUES
 (N'fn_LaySucChuaPhong'),(N'fn_YMC_GioVietNam'),(N'fn_YMC_CoPhamViRap')
)v(TenHam) WHERE OBJECT_ID(N'dbo.'+v.TenHam,N'FN') IS NULL;
SELECT v.TenView ViewConThieu FROM(VALUES
 (N'v_ThongTinPhongChieu'),(N'v_YMC_FnbMenu'),(N'v_YMC_QuyenTaiKhoan')
)v(TenView) WHERE OBJECT_ID(N'dbo.'+v.TenView,N'V') IS NULL;
SELECT v.TenKieu KieuBangConThieu FROM(VALUES
 (N'YMC_FnbThanhPhan'),(N'YMC_DanhSachGhe'),(N'YMC_DanhSachFnb'),(N'YMC_MaQuyen'),(N'YMC_DanhSachTheLoai')
)v(TenKieu) WHERE NOT EXISTS(SELECT 1 FROM sys.table_types t JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE s.name=N'dbo' AND t.name=v.TenKieu);
-- SQL24 cài riêng cho Web, không coi thiếu nó là thiếu bộ cài Admin/nền.
SELECT CONVERT(BIT,CASE WHEN OBJECT_ID(N'dbo.sp_YMC_WebMoPhongThanhToan',N'P') IS NULL THEN 0 ELSE 1 END) DaCaiSQL24WebTuyChon;
SELECT COUNT(*) SoVaiTro FROM dbo.VaiTro;SELECT COUNT(*) SoQuyen FROM dbo.Quyen;SELECT COUNT(*) SoTaiKhoan FROM dbo.TaiKhoan;
SELECT r.TenHienThi,COUNT(q.MaQuyen) SoQuyen FROM dbo.VaiTro r LEFT JOIN dbo.VaiTroQuyen q ON q.MaVaiTro=r.MaVaiTro GROUP BY r.MaVaiTro,r.TenHienThi ORDER BY r.MaVaiTro;
SELECT s.name TenSchema,t.name TenBang FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id ORDER BY t.name;
GO
