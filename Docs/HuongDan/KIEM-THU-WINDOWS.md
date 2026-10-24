# Checklist chạy trên Windows với database Test

Đã xác nhận bằng build không thay thế thao tác thật. Chạy SQL 23 trên Test, đặt YMC_CONNECTION theo hướng dẫn, dùng dữ liệu Test để kiểm.

| Ca | Kết quả mong đợi |
|---|---|
| Admin đăng nhập, sai mật khẩu một lần rồi đúng | Sai không mở Form1; đúng mở; không mất tài khoản |
| Đăng xuất rồi đăng nhập tài khoản khác | Không còn cache màn hình/người dùng trước |
| Tạo nhân viên BAN_VE, gán 1 rạp | Chỉ thấy suất/đơn của rạp phân công; không vào nhân sự/báo cáo |
| SOAT_VE gán rạp | Mở kiểm vé, không mở danh mục/thu tiền |
| Thu hồi quyền/rạp khi nhân viên đang đăng nhập | SQL từ chối thao tác tiếp theo; cập nhật quyền chỉnh lại menu |
| Thêm phim/rạp/phòng/ghế | Đọc lại đúng dữ liệu; chạy tạo sơ đồ lặp không thêm ghế trùng |
| Thay ghế có đơn đang giữ/đã bán | Cả lô từ chối, không cập nhật dở dang |
| Lịch trùng/cleanup, sửa có đơn, hủy có đơn | Đúng lỗi nghiệp vụ; không mất lịch/đơn |
| Giá chồng ngày, sửa phiên bản cũ, combo không hợp lệ | Bị từ chối, tải lại trước khi sửa |
| Hai cửa sổ giữ cùng ghế | Chỉ một đơn giữ thành công; còn lại báo ghế đã giữ |
| Tạo đơn rồi xác nhận thu lặp cùng mã | Một ThanhToan, mỗi ghế một Ve |
| Phiếu HTML có tên chứa ký tự HTML | Văn bản được escape, QR quét ra đúng GUID |
| Giữ rồi chờ hết hạn | Không thu được sau hạn, ghế có thể được giữ lại |
| Quầy hủy đơn tự tạo trước thu | Giải phóng ghế; không cần quyền hủy đơn của người khác |
| Hoàn có đối soát / vé đã dùng | Đủ điều kiện mới hoàn; vé đã dùng không được hoàn |
| Quét QR, xác nhận, xác nhận lần hai | Một lần sử dụng, lần sau từ chối |
| Báo cáo rạp/ngày | Thu/hoàn/thuần khớp ThanhToan/HoanTien; không nhân dòng do join chi tiết |
| Máy 1366×768 và scaling 125/150% | Không che nút nhập; xem scrollbar/menu; ghi nhận lỗi bố cục nếu có |

SQL test có sẵn: Database/Tests/01_LuongThanhCong.sql, 02_TuChoiNghiepVu.sql; bản bạn đã chạy PASS thuộc SQL 00–22. Sau cập nhật thử thêm **04_WinForms_QuyenVaGhe.sql** trên Test. Test 04 chưa được chạy trong môi trường đóng gói.

Các ca tiền tệ chỉ mô phỏng trên Test. Không chuyển tiền thật để thử. Không xóa dữ liệu database chính để làm test.
