# Kết quả bản Giá vé & F&B

- Build Admin bằng .NET SDK 10.0.100, EnableWindowsTargeting=true: 0 lỗi, 0 cảnh báo.
- Parser SQL ScriptDom TSql160Parser: 0 lỗi cú pháp trong Database.
- Tests/PricingIntegration: build 0 lỗi, 0 cảnh báo; chưa thực thi vì không có SQL Server.
- Chưa chạy WinForms hoặc kiểm tra DPI/bố cục trên Windows ở môi trường sửa.

## Phần bổ sung

- Script 09 tạo GiaVe, FnbSanPham, FnbComboChiTiet, TVP, view khả năng bán, thủ tục lưu và tra giá theo suất/ghế.
- Giá theo loại ghế, định dạng, loại ngày và khoảng ngày; khóa ứng dụng, chặn chồng, rowversion.
- Món lẻ và combo có thành phần; không lồng combo; thành phần ngừng bán làm combo không bán được.
- Tab giá/menu, tìm kiếm, bộ lọc, tra giá, CSV và form thêm/sửa/bật tắt.
- Script mẫu tùy chọn, hướng dẫn cập nhật và test riêng.
- Sửa nhãn DỮ LIỆU MINH HỌA còn sót trên menu Lịch chiếu/Giá vé & F&B.

Chưa tích hợp bán vé, thanh toán, snapshot hóa đơn, tồn kho, lịch ngày lễ hoặc phụ thu theo giờ.
Code phần lịch chiếu và các dữ liệu SQL trên máy người dùng không bị reset.
