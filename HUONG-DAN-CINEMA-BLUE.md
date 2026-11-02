# Cinema Blue — Web khách hàng và Admin WinForms

Bản thiết kế ngày 31/10/2026, phát triển từ source Admin Soft Lavender đã có phần xem lịch phòng.

## 1. Nội dung đã làm

### Web khách hàng

- Trang chủ có banner điện ảnh lớn, ảnh nền vũ trụ riêng và poster phim xếp lớp bên phải.
- Tên phim, nhãn tuổi, thời lượng, ngày khởi chiếu và poster dùng dữ liệu thật từ model hiện có.
- Bấm poster hoặc nút mũi tên để đổi phần giới thiệu. Banner không tự chuyển, giúp người dùng đọc đủ nội dung.
- Nút **Đặt vé ngay** đi đến lịch chiếu trên trang chi tiết của đúng phim. Nút **Xem chi tiết** mở thông tin phim; trailer thật vẫn ở trang chi tiết khi có dữ liệu.
- Thanh **Đặt vé nhanh** gửi phim/ngày đến màn hình lịch chiếu đang có. Chọn rạp, suất và ghế ở các màn hình thật. Có liên kết chọn theo rạp ngay trên thanh.
- Ô chọn phim nhanh lấy các phim nổi bật và các phim trên trang hiện tại; chọn “Tất cả phim” để sang lịch chiếu đầy đủ.
- Giữ tìm tên phim, lọc đang/sắp chiếu, phân trang, danh sách rạp, đăng nhập/đăng ký, hồ sơ, đơn vé và quy trình đặt vé hiện có.
- Cỡ chữ nội dung 18 px trên máy tính, 17 px trên màn hình nhỏ; cỡ chữ tiêu đề co giãn theo chiều rộng.
- Giữ sao băng, nút tạm dừng và hỗ trợ thiết lập giảm chuyển động của hệ điều hành.
- Ảnh vũ trụ là hình trang trí chung của website, không phải ảnh trích từ một bộ phim trong database. Poster dùng nguyên dữ liệu đang có; ảnh thiếu tiếp tục có ảnh thay thế.

### Admin WinForms

- Menu navy, nút chính xanh dương, nền xanh xám rất nhạt và bảng trắng.
- Dòng được chọn xanh nhạt, bảng có hàng xen kẽ và khoảng đệm dễ đọc.
- Menu mặc định có chữ; nút ☰ thu gọn/mở rộng và tooltip tiếp tục hoạt động.
- Giữ các góc bo đang có ở nút và khối nội dung.
- Banner Tổng quan chuyển sang gradient xanh, hình cuộn phim vẽ bằng GDI+.
- Sắp xếp lại hộp đăng nhập: tiêu đề, ô nhập và các nút rõ ràng hơn; dùng nguyên các control và trình xử lý xác thực cũ.
- Giữ nguyên các chức năng đang có trong bản source đầu vào, bao gồm xem lịch phòng khi thêm/sửa suất chiếu.

## 2. Mở xem giao diện mà không cần database

Mở file:

```text
Design/CinemaBlue/XEM-THU-WEB.html
```

Đây là bản HTML minh họa sử dụng cùng CSS/JS với Web để xem màu, bố cục và thử chuyển banner. Không đăng nhập hay đặt vé thật. Poster demo có sẵn trong source; ứng dụng MVC dùng dữ liệu của database.

Bản khung hẹp để xem cách xếp trên điện thoại:

```text
Design/CinemaBlue/KIEM-TRA-MOBILE.html
```

## 3. Chạy ứng dụng thật trên Windows

Giải nén toàn bộ vào một thư mục mới. Dùng cấu hình kết nối CSDL đang hoạt động trên máy bạn. Bản này không thay chuỗi kết nối, không chạy migration hay dữ liệu mẫu tự động.

Tại thư mục có `YeuMinhEmCinema.slnx`, dùng PowerShell:

```powershell
dotnet build .\YeuMinhEmCinema.slnx
```

Chạy Web:

```powershell
dotnet run --project .\src\YeuMinhEmCinema.Web\YeuMinhEmCinema.Web.csproj -- --urls http://localhost:5190
```

Mở `http://localhost:5190`. Có thể dùng `CHAY-WEB.cmd` thay cho lệnh trên.

Chạy Admin trong cửa sổ PowerShell khác:

```powershell
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

Hoặc dùng `CHAY-ADMIN.cmd`. Source hiện nhắm .NET 10 và .NET 10 Windows; cần SDK tương ứng trên máy Windows.

Nếu trình duyệt vẫn thấy giao diện cũ, nhấn Ctrl+F5. Nếu thiếu stored procedure, kiểm tra database và `Database/KIEM-TRA-CAI-DAT.sql` như hướng dẫn trước; thay đổi giao diện lần này không cần script SQL mới. Không xóa database hoặc chạy lại dữ liệu mẫu chỉ để đổi giao diện.

## 4. Kiểm tra đã thực hiện và giới hạn

- Đã kiểm tra cú pháp JavaScript bằng `node --check`.
- Đã xem bản HTML minh họa trên trình duyệt ở màn hình rộng và khung 390 px (vùng nội dung 375 px khi có thanh cuộn): không tràn ngang.
- Đã kiểm tra nút chuyển phim cập nhật tên phim, trạng thái poster được chọn và số thứ tự; chỉ hiện một phần giới thiệu tại một thời điểm.
- Đã kiểm tra tài nguyên ảnh trong bản xem thử tải được.
- Đã đối chiếu từng file với ZIP đầu vào, ghi kết quả trong `THAY-DOI-CINEMA-BLUE.md`.
- Môi trường tạo bản sửa không có .NET SDK, Windows và SQL Server của bạn. Chưa build C#, chưa chạy Razor thực tế với CSDL, chưa chạy WinForms, chưa xác nhận giao dịch đặt vé và lưu lịch trên Windows. Kiểm tra HTML/CSS/JS không thay thế các bước này.

## 5. Kiểm tra tiếp trên máy bạn

1. Build solution, đăng nhập Admin bằng tài khoản đang sử dụng.
2. Mở từng mục menu; thu gọn/mở rộng và kiểm tra phân quyền của các vai trò.
3. Mở Thêm/Sửa suất chiếu, kiểm tra lịch phòng và các thao tác đã dùng trước đó.
4. Kiểm tra bảng, bộ lọc và hộp thoại tại mức hiển thị Windows 100%, 125% và 150%; chú ý nhãn/nút có bị cắt hay không.
5. Trên Web, thử chuyển phim bằng poster, mũi tên và bàn phím; kiểm tra nút đặt vé tới đúng phim.
6. Thử tìm/lọc/phân trang, chọn phim/ngày trên thanh nhanh, chọn rạp và suất ở trang lịch.
7. Thử đăng nhập, chọn ghế, bắp nước, xem đơn và in vé theo luồng hiện có.
8. Tắt/bật sao băng; thử cửa sổ trình duyệt hẹp và thiết lập giảm chuyển động.

Các bước 1–8 là danh sách cần thực hiện tại môi trường Windows/CSDL thật, chưa được ghi là đã đạt.
