# YeuMinhEm Cinema — Web khách hàng và Admin

## Chạy trên VS Code (Windows)
1. Giải nén toàn bộ file ZIP.
2. Mở thư mục YeuMinhEm-Cinema trong VS Code.
3. Cài extension Live Server nếu chưa có.
4. Chuột phải dist/index.html → Open with Live Server để mở web khách hàng.
5. Đổi đường dẫn trên trình duyệt sang /admin.html để mở Admin; hoặc mở dist/admin.html bằng Live Server.

Nếu đã cài Python: mở terminal tại thư mục YeuMinhEm-Cinema rồi chạy:
    py -m http.server 5500 --directory dist
Mở http://localhost:5500/ cho khách hàng.
Mở http://localhost:5500/admin.html cho Admin.
Dừng bằng Ctrl+C. Không cần npm hay Docker.

## Cấu trúc
- dist/index.html, style.css, app.js: web khách hàng.
- dist/admin.html, admin.css, admin.js: bản thiết kế Admin.
- dist/assets/: toàn bộ ảnh, logo, poster.
- README.md: lịch sử cập nhật, kiểm tra và giới hạn của bản demo.

## Lưu ý
Đây là mã nguồn HTML/CSS/JavaScript đúng bản xem trước hiện tại, chưa phải C# WinForms, ASP.NET Core hay ADO.NET/SQL Server.
Dữ liệu mẫu lưu trong trình duyệt bằng localStorage/sessionStorage. Admin và web khách dùng dữ liệu riêng, chưa đồng bộ cơ sở dữ liệu.
Các số liệu thống kê là minh họa. Phân quyền, xác thực Admin, thanh toán và quét QR thật chưa được triển khai.
Không nhập mật khẩu thật vào bản demo. Không có giao dịch tiền thật.
Dùng cùng địa chỉ và cổng để giữ dữ liệu; xóa dữ liệu trang trong trình duyệt sẽ khôi phục dữ liệu mẫu.
