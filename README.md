# YeuMinhEm Cinema

Đồ án C# — Admin Windows Forms, ADO.NET và SQL Server Express.

Bắt đầu bằng **BAT-DAU-O-DAY.md**. Máy đã có SQL 00–22 chỉ cần chạy thêm **23_WinForms_HoanThien.sql** trước khi chạy bản Admin mới.

| Mục Admin | Chức năng đã có code nối SQL |
|---|---|
| Đăng nhập | Băm mật khẩu, Admin đầu tiên, khóa tạm sau sai liên tiếp, đổi mật khẩu, đăng xuất |
| Phim | Xem/tìm/lọc/thêm/sửa/ngừng chiếu; bảo vệ phim có lịch tương lai |
| Rạp/phòng/ghế | Danh sách, sơ đồ thật, thêm/sửa/trạng thái, tạo ghế theo lô giữ nguyên ghế cũ |
| Lịch chiếu | Thêm/sửa, kiểm xung đột và dọn phòng, đổi trạng thái, xem lịch phòng, xem trước/sao chép, CSV |
| Giá/bắp nước | Khoảng hiệu lực, loại ngày/ghế/định dạng, combo thành phần, rowversion, tra giá |
| Bán vé | Suất theo rạp/ngày, sơ đồ thật, số lượng bắp nước, giữ ghế có hạn, xác nhận thu, xuất phiếu/vé QR |
| Đơn hàng | Lọc/phân trang, 6 bảng chi tiết, hủy chưa trả, ghi nhận hoàn toàn bộ, xuất phiếu/QR |
| Kiểm vé | Đọc GUID từ QR/máy quét, xem thông tin, xác nhận vào rạp một lần |
| Khách hàng | Tìm, thêm tại quầy, sửa, trạng thái hồ sơ, lịch sử đơn theo phạm vi rạp |
| Nhân viên | Tạo tài khoản/hồ sơ, sửa nhân sự, gán/thu hồi rạp và vai trò, bộ quyền theo vai trò, khóa/tái kích hoạt, đặt lại mật khẩu |
| Tổng quan/báo cáo | Thu/hoàn/thuần, hiệu quả phim, bắp nước, biểu đồ, lọc rạp/ngày và CSV |

Khả năng biên dịch không đồng nghĩa mọi màn hình đã được chạy kiểm thử. Xem **KET-QUA-WINFORMS.md** để biết mức xác nhận thực tế.

Các project Core/Data/Web vẫn giữ cấu trúc gốc; không tuyên bố Web ASP.NET đã hoàn thiện. Source có chú thích theo lớp DAL/UI. Không chứa mật khẩu/database người dùng.
