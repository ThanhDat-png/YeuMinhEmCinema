# Hướng dẫn quản lý suất chiếu

## Danh sách và lọc

Vào Lịch chiếu: dữ liệu thật từ SQL Server. Chọn rạp/phòng/phim/trạng thái,
nhập tên phim và nhấn Lọc. Tích Lọc khoảng ngày để áp dụng Từ ngày/Đến ngày.
Làm mới nạp lại danh mục và bỏ bộ lọc. Có số kết quả/thông báo trống.
Khi chọn một rạp, danh sách phòng thay đổi theo rạp đó.

## Thêm / sửa

Thêm suất mở hộp thoại riêng. Chọn phim, rạp, phòng, ngày giờ, phút dọn phòng.
Chỉ chọn phim hợp lệ và phòng/rạp hoạt động có ghế hoạt động.
Giờ kết thúc và phòng sẵn sàng được tính để xem trước; SQL kiểm tra lại khi lưu.
Xem lịch phòng giúp kiểm tra khoảng đã chiếm, gồm suất từ hôm trước chiếm qua ngày chọn.
Lưu thành công đóng form, bỏ bộ lọc, tải lại và chọn suất vừa lưu.
Lỗi trùng lịch giữ form để chỉnh giờ. Giây được chuẩn hóa về 00 theo giao diện hiển thị phút.
Sửa yêu cầu suất chưa bắt đầu/chưa hủy và không có dữ liệu nghiệp vụ liên quan.

## Trạng thái

Chọn một suất rồi Ngừng bán, Mở bán lại hoặc Hủy suất.
Hộp xác nhận hiện phim/rạp/phòng/giờ. Ngừng bán giữ lịch, hủy giải phóng lịch.
Không hủy/sửa dữ liệu có liên quan và không tự hoàn tiền.

## Sao chép

Chọn ngày nguồn/ngày đích, rạp/phòng hoặc tất cả. Bấm Xem trước và kiểm tra.
Bảng là các suất dự kiến ở ngày đích; nếu không hợp lệ sẽ hiện thông báo để sửa lựa chọn.
Xác nhận số suất/ngày đích rồi ghi. Đổi bộ lọc/ngày làm mất hiệu lực xem trước.
Nếu dữ liệu nguồn đổi hoặc đích phát sinh xung đột trong lúc xem, server từ chối toàn bộ.
Không tạo một phần lịch.

## CSV

Xuất danh sách đang hiển thị sau khi lọc/sắp xếp, chỉ các cột đang hiện.
Chọn file .csv. UTF-8 BOM, hỗ trợ dấu phẩy/ngoặc kép/xuống dòng và bảo vệ ô công thức.

## Kiểm tra trên Windows

- Hai suất thử 23/10/2026 vẫn hiện, nếu chưa hủy/xóa bằng thao tác khác.
- Thêm mới và mở lại app: dữ liệu vẫn còn.
- Thêm trùng/chạm khoảng dọn phòng bị chặn, đúng ranh giới được phép.
- Sửa không tự xung đột nhưng vẫn chặn chồng suất khác.
- Đổi từ phòng mã lớn sang mã nhỏ và ngược lại.
- Ngừng bán vẫn chặn suất mới; hủy cho phép xếp lại nhưng không mở bán lại suất hủy.
- Xem lịch phòng có suất từ hôm trước kéo qua nửa đêm.
- Sao chép thành công; sao chép trùng bị chặn; đổi nguồn sau xem trước phải xem lại.
- Kiểm tra toolbar/form ở 1366×768 và Windows Scale 125%/150%.

Log kỹ thuật: %LOCALAPPDATA%/YeuMinhEmCinema/Logs/lich-chieu.log.
Không ghi chuỗi kết nối, câu SQL hay dữ liệu khách hàng vào log mới của module này.
