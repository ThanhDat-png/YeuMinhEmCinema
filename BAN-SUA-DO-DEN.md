# Bản sửa giao diện đỏ–đen

- Khôi phục màu chính RGB(211,47,47) theo ZIP gốc; giữ nền/sidebar, các màu trạng thái.
- Các nút mới dùng cùng màu đỏ. Không thay dữ liệu SQL hoặc tài khoản.
- Không tạo cột ảnh cho byte[]/rowversion. Dữ liệu phiên bản vẫn giữ trong DataRow để cập nhật an toàn.
- Ẩn trang cũ khi chuyển màn hình; chỉ đổi tiêu đề/menu sau khi tạo được trang đích.
- Cột bố cục Tổng quan/Báo cáo chiếm 100% vùng nội dung.
- Lỗi SQL hiển thị mã, tên thủ tục và dòng. Chưa có log lỗi SQL của máy người dùng nên chưa thể xác nhận nguyên nhân lỗi truy vấn trước đó.

## Cách dùng

1. Dừng chương trình (Shift+F5), sao lưu thư mục đang dùng.
2. Giải nén ZIP này sang thư mục riêng. Mở src/YeuMinhEmCinema.Admin/YeuMinhEmCinema.Admin.csproj.
3. F5 và đăng nhập tài khoản hiện có. Nếu đã chạy SQL23 không cần chạy lại.
4. Nếu Tổng quan còn lỗi SQL, gửi mã lỗi mới; có thể chạy Database/KIEM-TRA-LOI-TONG-QUAN.sql trong SSMS và gửi kết quả. Script chỉ đọc, không sửa dữ liệu.

Chỉ kiểm tra biên dịch trên Linux; cần xác nhận giao diện thực tế trên Windows và truy vấn trên SQL Server của bạn.
