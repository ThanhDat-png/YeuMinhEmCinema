# Kiểm tra bộ SQL

- 29 file SQL đã phân tích bằng Microsoft.SqlServer.TransactSql.ScriptDom (TSql160Parser): 0 lỗi cú pháp. Cả file cài tổng và script kiểm thử đều đã được phân tích.
- 52 stored procedure có định nghĩa; lời gọi EXEC dbo.sp_* trong các script đều tìm thấy định nghĩa trong bộ cài.
- 25 bảng nghiệp vụ được định nghĩa; SQL UTF-8 BOM.
- File tổng không chạy seed, không có lệnh DROP DATABASE hay TRUNCATE, không tạo tài khoản đăng nhập mặc định.
- Có 1 kịch bản luồng thành công rollback fixture và 6 ca từ chối có kiểm mã lỗi; có hướng dẫn kiểm đồng thời ở hai phiên.

**Chưa thực hiện:** triển khai trên SQL Server thực tế, biên dịch/ràng buộc tên object bởi SQL Server, chạy các fixture nghiệp vụ, kiểm deadlock/đặt ghế hai phiên, chạy WinForms/Web với database mới. Môi trường đóng gói không có SQL Server. Kiểm cú pháp và kiểm tham chiếu tĩnh không thay thế các bước này.

Không khẳng định bộ SQL đã vượt qua kiểm thử tích hợp. Khi chạy trên máy bạn, bắt đầu bằng CAI-DAT-TAT-CA.sql và gửi lỗi nếu có; bộ cài không tự nối các chức năng mới vào mã C# cũ.
