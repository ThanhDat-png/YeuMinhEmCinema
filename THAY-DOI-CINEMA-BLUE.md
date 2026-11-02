# Đối chiếu thay đổi Cinema Blue

So với `YeuMinhEmCinema_Admin_SoftLavender.zip`.

- Không có file cũ nào bị xóa.
- 98 file thuộc SQL, DAL, controller, model, view model, cấu hình, project và thuật toán lịch phòng được kiểm tra và giữ nguyên từng byte.
- `Form1.cs` chỉ đổi màu chữ và màu hover của menu.
- `FormDangNhap.cs` chỉ thêm lời gọi sắp xếp giao diện; nội dung xác thực giữ nguyên.
- Không thay hợp đồng stored procedure, tham số SQL, quyền truy cập hay cấu hình kết nối.

## File cũ đã sửa

- `src/YeuMinhEmCinema.Admin/Forms/Form1.Presentation.cs`
- `src/YeuMinhEmCinema.Admin/Forms/Form1.cs`
- `src/YeuMinhEmCinema.Admin/Forms/FormDangNhap.cs`
- `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`
- `src/YeuMinhEmCinema.Admin/UI/AdminWelcomeCard.cs`
- `src/YeuMinhEmCinema.Web/Views/Home/Index.cshtml`
- `src/YeuMinhEmCinema.Web/Views/Shared/_Layout.cshtml`

## File mới

- `HUONG-DAN-CINEMA-BLUE.md`
- `src/YeuMinhEmCinema.Admin/Forms/FormDangNhap.Presentation.cs`
- `src/YeuMinhEmCinema.Web/wwwroot/css/cinema-blue.css`
- `src/YeuMinhEmCinema.Web/wwwroot/js/cinema-home.js`
- `src/YeuMinhEmCinema.Web/wwwroot/images/cosmic/cinema-horizon.png`
- `Design/CinemaBlue/KIEM-TRA-MOBILE.html`
- `Design/CinemaBlue/XEM-THU-WEB.html`
- `THAY-DOI-CINEMA-BLUE.md`

## Vị trí bắt đầu để tự chỉnh

- Bố cục banner: `src/YeuMinhEmCinema.Web/Views/Home/Index.cshtml`, dòng 5.
- Thanh đặt vé nhanh: `src/YeuMinhEmCinema.Web/Views/Home/Index.cshtml`, dòng 74.
- Màu sắc Web: `src/YeuMinhEmCinema.Web/wwwroot/css/cinema-blue.css`, dòng 2.
- Cỡ chữ Web: `src/YeuMinhEmCinema.Web/wwwroot/css/cinema-blue.css`, dòng 9.
- Khung banner: `src/YeuMinhEmCinema.Web/wwwroot/css/cinema-blue.css`, dòng 68.
- Chuyển banner: `src/YeuMinhEmCinema.Web/wwwroot/js/cinema-home.js`, dòng 17.
- Bảng màu Admin: `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`, dòng 11.
- Kiểu bảng dữ liệu: `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`, dòng 202.
- Menu mặc định mở rộng: `src/YeuMinhEmCinema.Admin/Forms/Form1.Presentation.cs`, dòng 71.
- Bố cục đăng nhập: `src/YeuMinhEmCinema.Admin/Forms/FormDangNhap.Presentation.cs`, dòng 6.
