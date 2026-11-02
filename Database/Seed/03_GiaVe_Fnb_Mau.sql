-- TÙY CHỌN: dữ liệu minh họa cho module. Không phải giá thị trường.
-- Chạy sau script 09. Không ghi đè giá hoặc sản phẩm đã có.
USE YeuMinhEmCinema;
GO
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRAN;
    DECLARE @loai INT=(SELECT MIN(MaLoai) FROM dbo.LoaiGhe WHERE TenLoai=N'Ghế thường');
    IF @loai IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.PhongChieu WHERE DinhDang=N'2D Digital')
    BEGIN
        IF NOT EXISTS(SELECT 1 FROM dbo.GiaVe WHERE MaLoaiGhe=@loai AND DinhDang=N'2D Digital' AND LoaiNgay=N'Ngày thường')
            EXEC dbo.sp_YMC_LuuGiaVe @MaLoaiGhe=@loai,@DinhDang=N'2D Digital',@LoaiNgay=N'Ngày thường',
                @TuNgay='20260101',@DonGia=80000,@DangApDung=1;
        IF NOT EXISTS(SELECT 1 FROM dbo.GiaVe WHERE MaLoaiGhe=@loai AND DinhDang=N'2D Digital' AND LoaiNgay=N'Cuối tuần')
            EXEC dbo.sp_YMC_LuuGiaVe @MaLoaiGhe=@loai,@DinhDang=N'2D Digital',@LoaiNgay=N'Cuối tuần',
                @TuNgay='20260101',@DonGia=95000,@DangApDung=1;
    END;
    DECLARE @empty dbo.YMC_FnbThanhPhan;
    IF NOT EXISTS(SELECT 1 FROM dbo.FnbSanPham WHERE MaHang='BAP_L')
        EXEC dbo.sp_YMC_LuuFnb @MaHang='BAP_L',@TenSanPham=N'Bắp rang bơ',@Nhom=N'Bắp',@KichCo=N'Lớn',
            @DonGia=55000,@DangBan=1,@ThanhPhan=@empty;
    IF NOT EXISTS(SELECT 1 FROM dbo.FnbSanPham WHERE MaHang='NUOC_L')
        EXEC dbo.sp_YMC_LuuFnb @MaHang='NUOC_L',@TenSanPham=N'Nước ngọt',@Nhom=N'Nước',@KichCo=N'Lớn',
            @DonGia=35000,@DangBan=1,@ThanhPhan=@empty;
    DECLARE @bap INT=(SELECT MaSanPham FROM dbo.FnbSanPham WHERE MaHang='BAP_L' AND Nhom<>N'Combo' AND DangBan=1);
    DECLARE @nuoc INT=(SELECT MaSanPham FROM dbo.FnbSanPham WHERE MaHang='NUOC_L' AND Nhom<>N'Combo' AND DangBan=1);
    IF @bap IS NOT NULL AND @nuoc IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.FnbSanPham WHERE MaHang='COMBO_SOLO')
    BEGIN
        DECLARE @tp dbo.YMC_FnbThanhPhan;
        INSERT @tp VALUES(@bap,1),(@nuoc,1);
        EXEC dbo.sp_YMC_LuuFnb @MaHang='COMBO_SOLO',@TenSanPham=N'Combo Solo',@Nhom=N'Combo',@KichCo=N'1 bắp + 1 nước',
            @DonGia=79000,@DangBan=1,@ThanhPhan=@tp;
    END;
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK;THROW;
END CATCH;
GO
