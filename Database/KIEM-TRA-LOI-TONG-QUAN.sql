USE YeuMinhEmCinema;
GO
SET NOCOUNT ON;
DECLARE @A INT=(SELECT TOP(1) t.MaTaiKhoan FROM dbo.TaiKhoan t JOIN dbo.TaiKhoanVaiTro tv ON tv.MaTaiKhoan=t.MaTaiKhoan JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE v.TenVaiTro='ADMIN' ORDER BY t.MaTaiKhoan);
DECLARE @R INT;
BEGIN TRY
 SELECT MaRap,TenRap FROM dbo.Rap WHERE dbo.fn_YMC_CoPhamViRap(@A,MaRap)=1;
 SELECT TOP(1) @R=MaRap FROM dbo.Rap WHERE dbo.fn_YMC_CoPhamViRap(@A,MaRap)=1 ORDER BY MaRap;
 IF @R IS NOT NULL BEGIN
 DECLARE @Tu DATE=DATEADD(DAY,-6,CONVERT(DATE,GETDATE())),@Den DATE=CONVERT(DATE,GETDATE());
 EXEC dbo.sp_YMC_BaoCaoDoanhThu @A,@R,@Tu,@Den;
 END;
 SELECT N'PASS: truy vấn tổng quan' KetQua;
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() MaLoi,ERROR_PROCEDURE() ThuTuc,ERROR_LINE() Dong,ERROR_MESSAGE() NoiDung;
END CATCH;
GO
