# Bản sửa đỏ–đen

Đã build lại Release: 0 lỗi, 0 cảnh báo. Chưa chạy GUI Windows hoặc SQL Server trong môi trường này. Xem BAN-SUA-DO-DEN.md cho thay đổi và cách chạy. Lỗi SQL Tổng quan trước đó chưa có mã lỗi để xác định nguyên nhân.

# Kết quả kiểm tra WinForms

Bản cập nhật dựa trên YeuMinhEmCinema(4).zip, giữ kết nối và tài khoản trên SQL Server của người dùng.

## Đã thực hiện trong môi trường đóng gói

- Build Release net10.0-windows bằng .NET SDK 10.0.100 với EnableWindowsTargeting=true: **0 lỗi, 0 cảnh báo**. Đây là biên dịch chéo trên Linux.
- AdminSmoke chạy trực tiếp helper production: **9 kiểm tra PASS** cho hash/salt, xác thực mật khẩu tiếng Việt, không Trim mật khẩu, sai mật khẩu, hash hỏng, mật khẩu ngắn, CSV BOM/tiếng Việt/escape/chặn công thức, PNG QR.
- QR PNG từ helper production được giải mã bằng thư viện độc lập ZXing-C++: đúng GUID gốc `abc12345-1234-4321-9123-0123456789ab`.
- CsvSmoke: PASS cho BOM, Unicode, dấu phẩy, dấu nháy, nhiều dòng, NULL, ngày và chặn công thức.
- SQL ScriptDom TSql160Parser: **35 file SQL, 20 truy vấn inline C#, 0 lỗi cú pháp**.
- Đối chiếu **29 lời gọi Db.Call/Db.Table có tên procedure literal** với khai báo SQL: không thiếu tên procedure hay tên tham số được truyền. Không coi đây là kiểm tra đầy đủ mọi dynamic call hay binding cột SQL Server.
- Build project SqlIntegration và PricingIntegration: **0 lỗi, 0 cảnh báo**. Chưa chạy hai project với SQL Server.
- Rà source: các màn hình từng minh họa đã thay bằng dữ liệu SQL; không còn mã NapDuLieuMinhHoa/NapNhanVienMinhHoa hoặc nút chỉ báo đang phát triển trong source Admin.
- ZIP kiểm CRC, loại bin/obj/.vs/.git và csproj.user; chứa source, SQL và hướng dẫn.

## Chưa xác nhận trong môi trường này

- Chưa chạy GUI Windows, kiểm bố cục/DPI, máy in hoặc máy quét USB.
- Không có SQL Server ở môi trường đóng gói: **SQL 23 chưa được triển khai/chạy nghiệp vụ tại đây**. Kiểm cú pháp không thay kiểm tra biên dịch module/binding/transaction SQL Server.
- Các PASS SQL 00–22 do người dùng đã chạy trước đó không chứng minh SQL 23 mới đã PASS. Có thêm Database/Tests/04_WinForms_QuyenVaGhe.sql để chạy trên Test.
- Chưa chạy hai phiên tranh ghế/callback, kiểm tải hoặc mô phỏng rớt kết nối thật. Code giữ mã yêu cầu/mã giao dịch khi retry và sử dụng khóa SQL/khóa chính hiện có.
- Không tích hợp ngân hàng/cổng thanh toán thật. Chức năng thu/hoàn là ghi nhận có xác nhận; không tự chuyển tiền.

## Chạy xác nhận trên máy bạn

1. Chạy SQL 23 cuối cùng trên database muốn dùng.
2. Chạy KIEM-TRA-WINFORMS.sql, mở project và F5.
3. Làm checklist Docs/HuongDan/KIEM-THU-WINDOWS.md trên Test trước khi dùng dữ liệu chính.
4. Nếu lỗi, gửi Messages SQL hoặc mã lỗi từ nhật ký LocalAppData/YeuMinhEmCinema/Logs/admin.log. Không gửi mật khẩu.

Các hạn chế nghiệp vụ (đơn một suất, tối đa 8 ghế, hoàn toàn bộ, không kho/khuyến mãi/Web backend) được ghi trong Docs/HuongDan/WINFORMS.md.
