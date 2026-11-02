USE YeuMinhEmCinema;
GO
SELECT OBJECT_ID(N'dbo.fn_YMC_CoPhamViRap') HamPhamViRap,
 OBJECT_ID(N'dbo.sp_YMC_TaoGheTheoLo') TaoGheTheoLo,
 OBJECT_ID(N'dbo.sp_YMC_CapNhatLoGhe') CapNhatLoGhe,
 OBJECT_ID(N'dbo.sp_YMC_TaoKhachTaiQuay') TaoKhachTaiQuay,
 OBJECT_ID(N'dbo.sp_YMC_LuuBoQuyenVaiTro') LuuBoQuyen;
-- Các cột trên phải khác NULL. Không chứa mật khẩu/hash.
SELECT COUNT(*) SoTaiKhoan FROM dbo.TaiKhoan;
GO
