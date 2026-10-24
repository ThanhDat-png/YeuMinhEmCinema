﻿# Web: suất gần nhất và nền phim

1. Giải nén vào thư mục mới, dùng cấu hình kết nối SQL của bạn. Admin không thay đổi.
2. Chạy SQL24 nếu máy chưa có thanh toán mô phỏng (Database/Scripts/24_Web_MoPhongThanhToan.sql).
3. Muốn thêm dữ liệu mẫu: chạy Database/Seed/25_PhimDemo_Web.sql trong SSMS. Script thêm 16 phim hư cấu có poster riêng, không ghi đè phim cũ và không thêm trùng khi chạy lại.
4. Phim mẫu CHƯA tự có lịch chiếu. Để thử đặt vé: vào Admin, tạo suất tương lai cho phim [DEMO] trong phòng có ghế và giá phù hợp. Dùng chức năng Thêm suất để hệ thống kiểm tra trùng lịch. Web sẽ tự hiển thị suất này.
5. Mở chi tiết phim: mặc định hiện tối đa 18 suất tương lai gần nhất trên mọi rạp. Chọn rạp để giới hạn nơi xem; chọn ngày để xem đúng ngày, bỏ trống ngày hoặc bấm Suất gần nhất để trở lại chế độ gần nhất.
6. Nền chi tiết dùng poster đúng phim, làm mờ và phủ tối theo bố cục tham khảo. Phim cũ có đường dẫn poster Windows vẫn hiện ảnh thay thế, cần sửa Poster sang URL Web hợp lệ trong dữ liệu nếu muốn có ảnh riêng.

Kiểm tra: build Web và WebSmoke; chưa có SQL Server hoặc GUI trình duyệt để chạy xác nhận thay đổi trên dữ liệu thật tại môi trường này. Chạy các thao tác trên máy Windows trước khi chốt.

## Cập nhật nền theo ảnh tham khảo
Nền ngoài dùng ảnh phim làm mờ tối; khung bo góc bên trong dùng ảnh lớn rõ nét, chuyển tối về phía dưới, thông tin đặt bên trái. Không đổi phim thành Peaky Blinders. Hiện schema dùng Poster nên poster dọc sẽ bị cắt khi phủ khung ngang; muốn ảnh điện ảnh ngang đẹp hơn cần cung cấp ảnh ngang riêng cho từng phim. Không chép ảnh chụp có chữ/giao diện mẫu vào nền.

## Trang tài khoản
Ảnh bên trái, thông tin bên phải, màu đỏ–đen. Đổi ảnh PNG/JPEG tối đa 2 MB bằng form riêng; hồ sơ và đổi mật khẩu giữ luồng hiện tại. Ảnh lưu ở src/YeuMinhEmCinema.Web/App_Data/Avatars ngoài thư mục công khai, endpoint chỉ trả ảnh của người đăng nhập. Sao lưu thư mục này khi chuyển máy/triển khai; không cần SQL mới. Kiểm tra chữ ký file, không giải mã/re-encode ảnh; file hỏng vẫn có thể không hiển thị dù qua kiểm tra chữ ký. Chưa kiểm tra UI trên trình duyệt hoặc tải ảnh với SQL thật tại môi trường này.

## Cập nhật giao diện ngày 24/10/2026

- Menu trải rộng, logo/menu bên trái và tài khoản có avatar bên phải.
- Chọn thẻ bắp/nước rồi nhập số lượng hoặc bấm −/+. Bỏ chọn đưa số lượng về 0.
- Chi tiết đơn chia hai cột: vé bên trái, bắp nước/tổng tiền/thao tác bên phải.
- Đơn đã hủy/hết hạn có nút Đặt vé lại. Chỉ đơn đã thanh toán có nút in vé.
- Slide tự chạy mỗi 5 giây, mũi tên ở hai cạnh, chấm chỉ vị trí ở dưới.
  Dừng khi rê chuột, bàn phím đang thao tác trong slide hoặc tab bị ẩn.
  Có nút dừng/tự chạy, hỗ trợ vuốt. Tôn trọng cài đặt giảm chuyển động.
- Không cần thêm SQL cho đợt sửa giao diện.

### Cập nhật trên Windows

1. Dừng web bằng Ctrl+C và sao lưu dự án.
2. Chép đè thư mục src/YeuMinhEmCinema.Web từ ZIP này vào đúng dự án.
3. Giữ cấu hình kết nối riêng và thư mục App_Data/Avatars hiện có.
4. Chạy lại web, nhấn Ctrl+F5 trên trình duyệt để tải CSS/JS mới.

### Bố cục đơn hàng cân đối
Hai cột rộng bằng nhau và bắt đầu ngang hàng. Cột trái chứa thông tin đơn/vé; cột phải chứa bắp nước, dòng chi phí, tổng tiền, hạn giữ ghế và các thao tác. Điện thoại vẫn xếp một cột.

### Tinh gọn điều khiển slide
Đã bỏ nút Tạm dừng và hàng chấm tròn theo yêu cầu. Slide chỉ giữ hai mũi tên ở giữa cạnh trái/phải, tiếp tục tự chạy và tạm nghỉ khi hover/focus; cài đặt giảm chuyển động vẫn được tôn trọng.

## Phim theo cụm rạp và gợi ý lịch chiếu

- Cụm rạp → Xem phim tại rạp: danh sách phim có suất tương lai đang mở bán tại đúng rạp đã chọn.
- Mỗi phim xuất hiện một lần, kèm poster và suất gần nhất.
- Xem suất tại rạp mở chi tiết phim, giữ rạp đã chọn và chuyển tới vùng lịch.
- Trang Lịch chiếu tự tải các suất sắp tới ngay khi chưa chọn phim.
- Bộ lọc phim/rạp/ngày hoạt động độc lập; không tự chọn suất giúp khách.
- Không cần chạy thêm SQL. Chỉ đọc dữ liệu có sẵn, không tạo lịch mẫu.
- Kiểm tra thực tế: rạp có lịch/không có lịch; phim chỉ có lịch đã hủy hoặc quá khứ không xuất hiện.

## Kiểm tra lại luồng lịch và rạp

- Đã kiểm tra HTTP bằng controller và Razor thật với dữ liệu giả:
  lịch mặc định, bộ lọc rạp/ngày, trang rạp, trang phim riêng theo rạp,
  chi tiết phim giữ rạp, trạng thái rỗng, mã rạp sai/không tồn tại.
- Sửa nút xem chi tiết trong trang rạp để mở đầu trang phim,
  không nhảy thẳng xuống lịch. Có liên kết quay lại danh sách phim tại rạp.
- File CHAY-WEB.cmd chạy đúng dự án trong thư mục vừa giải nén,
  cổng 5190, in đường dẫn đang chạy để tránh nhầm bản code.
- Kiểm tra SQL thực tế vẫn cần kết nối SQL Server trên Windows;
  kiểm tra HTTP ở đây sử dụng dữ liệu giả và không xác nhận dữ liệu trên máy người dùng.

Đường dẫn thử: http://localhost:5190/Phim/Lich
và http://localhost:5190/Phim/PhimTaiRap/2
