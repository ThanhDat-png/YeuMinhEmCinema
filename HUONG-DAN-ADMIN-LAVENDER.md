# Admin WinForms — Soft Lavender

Bản giao diện này phát triển từ `YeuMinhEmCinema_CosmicBlue_LichPhong.zip`. Tất cả thay đổi của lần này nằm trong phần hiển thị Admin. Web xanh vũ trụ và phần xem lịch phòng Thêm/Sửa suất được giữ nguyên từ bản trước.

## Thiết kế

- Nền xám tím rất nhạt, các bề mặt trắng pha lavender.
- Thanh điều hướng bên trái sáng, mặc định thu gọn thành các biểu tượng như ảnh tham chiếu. Rê chuột có tên chức năng; bấm nút ☰ phía dưới để mở rộng thành menu có chữ. Toàn bộ mục và sự kiện Click/Enabled/Visible theo phân quyền được giữ nguyên. Mục đang chọn có nền tím xám đậm và chữ trắng.
- Thanh tiêu đề trên cùng tím đậm, chữ sáng.
- Nút thao tác bo góc, phân biệt nút chính/nút phụ; nút nguy hiểm và màu trạng thái nghiệp vụ được giữ rõ ràng.
- Bảng dữ liệu dùng tiêu đề lavender, chữ đậm màu và dòng chọn tím nhạt.
- Các khối quản lý phim, tổng hợp báo cáo và biểu đồ được bo góc.
- Trang Tổng quan có banner cuộn phim tự vẽ bằng GDI+, không cần ảnh/font hay thư viện UI ngoài.

Bố cục lấy cảm hứng từ ảnh tham chiếu; được thực hiện bằng control WinForms thật. Không dùng WebView. Không thêm số liệu mẫu, thông báo giả, nút không hoạt động hoặc nhân vật từ ảnh tham chiếu. Bảng, bộ lọc và biểu đồ sẵn có tiếp tục lấy dữ liệu bằng luồng cũ.

## Giữ nguyên chức năng

Không thay controller, DAL, SQL, kết nối, tài khoản, phân quyền, tính doanh thu, luồng thêm/sửa/xóa hay các sự kiện xử lý nghiệp vụ trong lần đổi giao diện này. Toàn bộ mục chức năng hiện có vẫn giữ. Các thay đổi DAL và kiểm tra trùng lịch của bản Lịch phòng trước đó vẫn nằm trong source, không bị thay đổi trong lần này.

Trong `Form1.cs`, chỉ bổ sung khởi tạo trình bày menu và đổi màu chữ/hover/nhấn của menu. `Form1.Presentation.cs` quản lý việc thu gọn/mở rộng hình thức menu, không thay hành vi điều hướng nghiệp vụ. Trong `UcBaoCaoThongKe.cs`, chỉ đặt tên cho label tổng hợp để áp dụng kiểu card, không thay phần tải hoặc tính số liệu. `UcTongQuan.cs` chỉ bọc bố cục báo cáo cũ và thêm banner trang trí; không thay luồng tải dữ liệu.

## Chạy trên Windows

Giải nén sang thư mục mới, mở PowerShell tại thư mục chứa `YeuMinhEmCinema.slnx`:

```powershell
dotnet build src/YeuMinhEmCinema.Admin

dotnet run --project src/YeuMinhEmCinema.Admin
```

Dùng cùng cấu hình SQL Server và tài khoản đang chạy được ở bản trước. Bản giao diện này không yêu cầu script SQL mới. Nếu CSDL còn thiếu các procedure SQL 26–30 như trước, cần xử lý việc cập nhật CSDL riêng; đổi theme không thay thế việc đó.

## Kiểm tra trên máy em

- Đăng nhập và mở từng mục menu để xác nhận đủ chức năng, trạng thái chọn và phân quyền.
- Kiểm tra dropdown, ô nhập, bàn phím Tab/Enter/Escape và nút bị vô hiệu hóa.
- Kiểm tra trang Tổng quan với bộ lọc, tất cả loại báo cáo, xuất CSV và biểu đồ.
- Kiểm tra cảnh báo, màu trạng thái ghế, nút nguy hiểm, form Thêm/Sửa suất và màu báo trùng lịch.
- Thử thu/phóng cửa sổ và Windows Display Scale 100%, 125%, 150%; xem có cắt chữ hoặc bảng không.

## File của lần đổi giao diện

- `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`: bảng màu và áp dụng kiểu hiển thị.
- `src/YeuMinhEmCinema.Admin/UI/SoftCorners.cs`: bo góc, cập nhật khi đổi kích thước.
- `src/YeuMinhEmCinema.Admin/UI/AdminWelcomeCard.cs`: banner điện ảnh tự vẽ.
- `src/YeuMinhEmCinema.Admin/Forms/Form1.cs`: khởi tạo trình bày, màu chữ/hover/nhấn của menu.
- `src/YeuMinhEmCinema.Admin/Forms/Form1.Presentation.cs`: thu gọn/mở rộng menu và tooltip; giữ nguyên các nút gốc.
- `src/YeuMinhEmCinema.Admin/UserControls/UcTongQuan.cs`: bố cục Tổng quan có banner.
- `src/YeuMinhEmCinema.Admin/UserControls/UcBaoCaoThongKe.cs`: tên control tổng hợp báo cáo.

Muốn đổi sắc tím, chỉnh các hằng màu đầu `AdminTheme.cs`. Các card và banner dùng chung bảng màu này.

## Mức kiểm chứng

Đã đối chiếu từng file với bản Lịch phòng trước: chỉ các file UI được sửa/thêm; DAL, SQL, cấu hình và Web không đổi. Đã kiểm tra cấu trúc project và tính toàn vẹn ZIP. Môi trường thực hiện chưa có .NET SDK/Windows/SQL Server nên CHƯA build hoặc chạy WinForms; cần kiểm tra giao diện thực tế và thao tác trên Windows trước khi dùng chính thức.

Đọc thêm `HUONG-DAN-LICH-PHONG.md` cho tính năng lịch phòng đã có và `HUONG-DAN-COSMIC-BLUE.md` cho Web xanh vũ trụ. Tài liệu màu Admin ở bản cũ chỉ mô tả lịch sử; bảng màu Admin hiện hành là Soft Lavender trong tài liệu này.
