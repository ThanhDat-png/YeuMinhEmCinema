# YeuMinhEm Cinema

Bản giao diện Web tương tác chạy thử theo thiết kế nền đen, hồng khói và điểm nhấn đỏ theo mẫu mới.

## Chạy tại máy

Mở `dist/index.html` bằng Live Server trong VS Code hoặc chạy `python -m http.server 8080 --directory dist` và mở http://localhost:8080.

## Chức năng

- Logo YeuMinhEm Cinema; slide phim hot tự chuyển, chuyển bằng nút và dừng khi rê chuột.
- Danh sách phim đang/sắp chiếu; tìm kiếm không dấu, lọc thể loại, sắp xếp.
- Chi tiết phim, trình phát video minh họa, theo dõi phim sắp chiếu.
- Chọn rạp, ngày và suất chiếu; khóa suất đã qua giờ.
- Đăng ký và đăng nhập tài khoản demo, tài khoản trải nghiệm, hồ sơ, đổi mã truy cập và đăng xuất.
- Sơ đồ 80 ghế, trạng thái ghế, giới hạn 8 ghế, giá ghế thường/VIP.
- Giới hạn thời gian 5 phút, tạo đơn chờ, xác nhận thanh toán mô phỏng, hủy đơn và giải phóng ghế.
- Lịch sử theo tài khoản, bộ lọc trạng thái, xem và tải thông tin vé, in/lưu PDF bằng trình duyệt.
- Danh sách rạp và lọc thành phố.
- Layout responsive và điều hướng cho thiết bị nhỏ.

## Phạm vi bản thử

HTML/CSS/JavaScript buildless, lưu localStorage trên trình duyệt. Không phải sản phẩm C# hoàn chỉnh; chưa có ASP.NET Core, SQL Server hoặc WinForms. Các tài khoản chỉ minh họa giao diện, không dùng mật khẩu thật. Giá tiền, phim và rạp là dữ liệu minh họa; không có giao dịch tiền thật. Video mẫu công khai CC0 minh họa trình phát, không phải trailer chính thức. Trạng thái ghế không đồng bộ giữa thiết bị và không có bảo đảm transaction máy chủ. Không sử dụng làm hệ thống bán vé thực tế.

## Kiểm tra

Đã kiểm tra cú pháp JavaScript. Đã thao tác bằng trình duyệt: đăng nhập trải nghiệm → chọn lịch → chọn ghế E5 (95.000 đồng) → xác nhận mô phỏng → phát hành vé. Đã kiểm tra trực quan trang chủ. Các chức năng còn lại cần kiểm thử nghiệm thu và kiểm tra thiết bị khi tích hợp backend C#.

## Cập nhật trang chi tiết phim
Khung kính bo tròn, nền ảnh làm mờ, tên phim lớn, thẻ ảnh phim và nút trailer, lưu/bỏ lưu, chuyển phim tiếp theo. Nội dung, thông tin đoàn phim và lịch chiếu ở bên dưới. Đã kiểm tra bằng trình duyệt nút lưu phim và điều hướng từ Đặt vé đến vùng chọn suất chiếu.

## Cập nhật danh sách phim dạng thẻ nhỏ
Phần dưới banner gồm khu khám phá dạng lưới ba cột trên desktop, từng thẻ có ảnh ngang, tên, phân loại tuổi, thể loại, thời lượng hoặc ngày khởi chiếu, nút Đặt vé/Theo dõi và Chi tiết. Có lọc trạng thái và thể loại, cột đề cử phim và liên kết khám phá thể loại. Responsive xuống hai cột ở màn hình nhỏ. Đã kiểm tra bố cục bằng trình duyệt và bộ lọc Hành động trả đúng phim đang chiếu.

## Slide mở đầu và tên thương hiệu
Đổi thương hiệu hiển thị thành YeuMinhEm Cinema. Banner trang chủ dùng bố cục ảnh nền 3D lớn, menu nằm trên banner, chữ lớn bên trái, điểm nhấn đỏ, chỉ số slide ở cạnh phải và mũi tên chuyển ở góc phải dưới. Ảnh nền đầu tiên được tạo riêng cho dự án, lưu trong dist/assets/entrance-hero.webp. Nút khám phá dẫn đến danh sách phim; các slide phim tiếp theo giữ chức năng đặt vé. Đã kiểm tra trực quan trên trình duyệt và chuyển về slide 1 bằng bộ chọn.

## Tách giới thiệu rạp và slide phim
Phần đầu trang là nội dung giới thiệu cố định về YeuMinhEm Cinema, có nút khám phá rạp và cuộn tới phim đang chiếu. Khu Phim hot hôm nay nằm ngay bên dưới, gồm ba slide phim với tự chuyển, chọn slide, trailer và đặt vé. Kế tiếp là thanh đặt vé nhanh và danh sách phim. Đã kiểm tra thứ tự nội dung và nút cuộn bằng trình duyệt.

## Menu cố định và slide thu gọn
Thanh điều hướng trang chủ cố định ở đầu màn hình, có nền mờ để đọc rõ khi cuộn. Nội dung đầu trang có khoảng đệm để tránh bị che. Slide Phim hot giảm còn khoảng 360px trên desktop, căn cùng mép với khu phim bên dưới; điều chỉnh chữ, nút và điều hướng cho kích thước mới. Đã kiểm tra trực tiếp sau khi cuộn tới slide: menu vẫn hiển thị và slide không tràn nội dung.

## Rà soát giao diện và luồng đặt vé
Thay logo mascot ở header, footer và favicon. Thống nhất thanh điều hướng cố định trên mọi trang; chỉnh trạng thái chọn và focus bàn phím. Tách nhóm 01–02–03 khỏi nút cuộn, sửa khoảng cách và chữ dài trên điện thoại. Giữ lựa chọn ghế khi tải lại bằng sessionStorage, kiểm tra tham số suất chiếu và xử lý đơn đã giữ/đã thanh toán.
Đã kiểm tra cú pháp JS và thao tác trình duyệt: tìm kiếm không dấu, chi tiết tên phim dài, chọn ghế thường + VIP tổng 170.000 đồng, tải lại giữ hai ghế, tiếp tục thanh toán và hủy đơn. Đã xem trang chủ và mở menu trong viewport 375px, kiểm tra desktop trang phim và chi tiết. Đây là kiểm tra bản demo, không thay thế nghiệm thu backend hay mọi thiết bị.

## Bản thiết kế Admin
Mở /admin.html. Giao diện Tổng quan, 11 mục điều hướng, bảng quản lý mẫu, tìm kiếm không dấu, lọc trạng thái, form thêm/sửa lưu riêng localStorage, xuất CSV, chọn ghế tại quầy và tra mã vé minh họa. Đây là prototype web để duyệt thiết kế WinForms, chưa có xác thực/phân quyền thật hay ADO.NET; dữ liệu Admin tách riêng khỏi web khách. Đã kiểm tra cú pháp và xem desktop, tìm Dế Mèn bằng “de men”, mở chi tiết.
