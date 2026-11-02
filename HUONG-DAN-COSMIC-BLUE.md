# YeuMinhEm Cinema — Cosmic Blue

Bản này được chỉnh trực tiếp từ `YeuMinhEmCinema(2).zip` em gửi. Mục tiêu là đồng bộ màu giao diện, bổ sung nền chòm sao và sao băng cho Web khách hàng. Bản màu ban đầu giữ nguyên controller, DAL và SQL. Bản lịch phòng hiện tại có bổ sung truy vấn đọc trong SuatChieuDAL và kiểm tra trước khi lưu ở UI; xem HUONG-DAN-LICH-PHONG.md. Các script SQL, controller, xác thực và phân quyền không đổi.

## 1. Chạy source C# thật trên Windows

Cần .NET 10 SDK, SQL Server và cấu hình kết nối của dự án. Làm theo `BAT-DAU-O-DAY.md` và hướng dẫn database có sẵn nếu máy chưa thiết lập.

Mở PowerShell tại thư mục chứa `YeuMinhEmCinema.slnx`:

```powershell
dotnet restore YeuMinhEmCinema.slnx

# Web khách hàng
dotnet run --project src/YeuMinhEmCinema.Web
```

Mở `http://localhost:5186` theo profile có sẵn. Nếu dùng URL được ghi trong terminal, ưu tiên URL terminal thông báo.

Chạy Admin trong terminal thứ hai:

```powershell
dotnet run --project src/YeuMinhEmCinema.Admin
```

WinForms cần Windows. Nếu thiếu kết nối SQL thì giao diện có thể báo lỗi tải dữ liệu; bản đổi màu không tạo hoặc khôi phục database.

## 2. Web khách hàng đã đổi gì?

- Nền xanh navy, xanh điện và các điểm sáng cyan theo ảnh tham chiếu.
- Sao băng chuyển động chậm từ trên trái xuống dưới phải, khoảng 21–30 pixel/giây tùy sao.
- Nền chòm sao nằm sau nội dung và không chặn thao tác chuột, bàn phím hay biểu mẫu.
- Nút “Tạm dừng sao băng” ở góc dưới phải; bấm lần nữa để bật lại.
- Tôn trọng thiết lập giảm chuyển động của hệ điều hành; tự ngừng vòng vẽ khi tab bị ẩn và khi rời trang.
- Giữ nội dung, ảnh phim và các luồng MVC hiện có; không thay dữ liệu thật bằng phim minh họa của preview.

Muốn sao băng chậm hơn: mở `src/YeuMinhEmCinema.Web/wwwroot/js/cosmic-sky.js`, tìm `meteorSpeed: 30`, đổi thành `20`.

Muốn ít sao băng hơn: thay `desktopMeteorCount: 5` và `mobileMeteorCount: 3` trong cùng tệp.

Muốn chỉnh màu: mở `src/YeuMinhEmCinema.Web/wwwroot/css/cosmic-theme.css`; các biến màu nằm đầu tệp. Độ hiện ảnh nền được chỉnh bằng `opacity` của `.cosmic-sky::before`.

## 3. Admin đã đổi gì?

Admin chạy thật là **WinForms**, trong `src/YeuMinhEmCinema.Admin`:

- Menu bên trái: xanh navy; nút đang chọn: xanh dương.
- Nội dung: nền xanh rất nhạt; các khối và bảng: trắng.
- Tiêu đề bảng: navy, chữ sáng; dòng đang chọn: xanh nhạt, chữ đậm màu.
- Các form đăng nhập, form chính, hộp thoại và UserControl thêm sau được áp dụng theme chung.
- Biểu đồ doanh thu dương dùng màu xanh chính.
- Các màu nghiệp vụ riêng như ghế VIP, ghế hỏng, ngừng hoạt động, cảnh báo, thao tác nguy hiểm được giữ theo nguồn.

Chỉnh bảng màu tập trung ở `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`. Theme không có sao băng trong vùng làm việc Admin.

Ngoài ra, `Design/Web/dist/admin.css` đã được đồng bộ xanh navy/xanh dương cho **bản thiết kế Admin HTML có sẵn**. Bản HTML là mô phỏng, không phải WinForms đang chạy.

## 4. Code của bản xem thử đã gửi trước đó

Toàn bộ source bản vũ trụ ở `Design/CosmicPreview/`, gồm `index.html` và thư mục `assets`. Đây là HTML/CSS/JavaScript độc lập, có thanh chỉnh tốc độ, độ sáng, mật độ sao; phim là nội dung minh họa.

Để mở bản xem thử này mà không cần SQL Server, chạy:

```powershell
py -m http.server 5500 --directory Design/CosmicPreview
```

Mở `http://localhost:5500`.

Muốn xem thiết kế Admin HTML sẵn có với màu mới:

```powershell
py -m http.server 5501 --directory Design/Web/dist
```

Mở `http://localhost:5501/admin.html`.

## 5. Kiểm tra đã thực hiện và giới hạn

Đã kiểm tra cú pháp JavaScript, các đường dẫn tài nguyên mới, tính toàn vẹn ZIP, màu của bản thiết kế Admin HTML trên trình duyệt và đối chiếu thay đổi với ZIP gốc. Kiểm tra mô phỏng vòng vẽ xác nhận: hướng sao băng xuống phải, giới hạn DPR, tạm dừng/bật lại, dừng khi tab ẩn, khôi phục sau back/forward cache, thiết lập giảm chuyển động và trường hợp trình duyệt không hỗ trợ canvas.

Môi trường thực hiện không có .NET SDK, Windows/WinForms hoặc SQL Server nên **chưa biên dịch và chưa chạy kiểm thử C# / WinForms / nghiệp vụ với database thật**. Cần kiểm tra trên máy Windows trước khi dùng chính thức. Xem `DANH-SACH-THAY-DOI-COSMIC.md` để biết toàn bộ file sửa/thêm.

ZIP không đóng gói `.git`, `.vs`, `bin`, `obj`, `node_modules`; các tệp này không cần để đọc/build source. File ZIP gốc không bị sửa. Bản giao diện này không tự xóa các chức năng cũ trong source.
