# Kiểm tranh chấp trên bản sao database

Chuẩn bị một suất đang mở bán trong tương lai, một ghế hoạt động chưa bán, bảng giá tương ứng và tài khoản có BAN_VE, được phân công đúng rạp (hoặc ADMIN).

Mở hai cửa sổ SSMS cùng database. Trong mỗi cửa sổ:

```sql
DECLARE @g dbo.YMC_DanhSachGhe,@f dbo.YMC_DanhSachFnb;
-- Thay ID_GHE, ID_TAI_KHOAN, ID_SUAT bằng số thực tế trước khi chạy.
INSERT @g VALUES(ID_GHE);
DECLARE @r UNIQUEIDENTIFIER=NEWID();
EXEC dbo.sp_YMC_TaoDonGiuGhe
 @NguoiThucHien=ID_TAI_KHOAN,@MaYeuCau=@r,@MaSuatChieu=ID_SUAT,
 @Kenh='QUAY',@DanhSachGhe=@g,@DanhSachFnb=@f,@HoTenLienHe=N'Thử đồng thời';
```

Chạy gần như đồng thời bằng F5 ở hai cửa sổ. Đúng: một đơn giữ thành công, một lệnh báo 50310 (ghế đã giữ), không có hai đơn cùng sở hữu ghế. Kiểm bảng GiuGhe chỉ một dòng cho cặp suất/ghế.

Thanh toán: hai cửa sổ cùng gọi sp_YMC_XacNhanThanhToan cho một đơn, cùng MaGiaoDich, PhuongThuc, SoTien. Cả hai trả về cùng vé; ThanhToan chỉ một dòng, mỗi ghế chỉ một Ve. Dùng mã giao dịch khác cho đơn đã trả phải bị từ chối.

Kiểm vé: trong khoảng cho phép, hai cửa sổ cùng xác nhận MaVe. Chỉ một xác nhận thành công; lệnh còn lại báo 50341. Vé chỉ có một NguoiSoat/NgaySoatUtc.

Các bước này chưa được tự chạy trong môi trường tạo ZIP. Dọn dữ liệu thử bằng hủy đơn/hoàn tiền theo nghiệp vụ trên bản sao, không xóa lịch sử trong database thật.
