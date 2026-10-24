# Web YeuMinhEm Cinema — giai đoạn trang chủ

## Cập nhật đỏ–đen và sửa kết nối

Màu Web hiện tại: nền `#0F0F14`, thẻ `#18181B`, nhấn `#D32F2F`, hover `#B71C1C`. Các màu được tập trung ở `:root` trong `wwwroot/css/site.css`; chữ nhấn dùng đỏ sáng hơn để dễ đọc trên nền tối. Không chỉnh màu tệp poster, ảnh nền hoặc Admin.

Nguyên nhân lỗi tải dữ liệu đã tái hiện: chưa có `appsettings.Local.json`, không có `ConnectionStrings: Cinema` hay biến môi trường kết nối. HTTP trả 503 và log ghi `InvalidOperationException`, mã SQL `(null)`; ứng dụng thất bại trước khi mở kết nối, không phải thiếu phim hay lỗi hợp đồng procedure. Kiểm tra SQL chỉ đọc xác nhận database `YeuMinhEmCinema`, phim “Sau màn đêm” đang chiếu, procedure trả đúng các cột và tổng 2 phim công khai, có 6 rạp hoạt động.

Đã tạo `appsettings.Local.json` cho máy hiện tại dùng SQL Express và Windows Authentication, không có mật khẩu. File này đã được gitignore. File Local được đọc khi khởi động; hãy dừng và chạy lại Web đang mở để nhận cấu hình mới. `Program.cs` bảo đảm biến môi trường và tham số chạy được ưu tiên hơn file Local. Không ghi chuỗi kết nối vào log.

Kiểm tra trong lượt cập nhật này:

- Build Web vào thư mục riêng: `dotnet build src/YeuMinhEmCinema.Web --nologo -p:BaseOutputPath=bin/Review/`: 0 lỗi, 0 cảnh báo. Build mặc định gặp khóa EXE/DLL do bản Web đang chạy, nên dùng output riêng và cổng 5190 để không dừng tiến trình đó.
- Chạy bản vừa build ở cổng 5190, không đặt biến kết nối tạm: HTTP 200, có phim “Sau màn đêm”, 2 phim công khai và 6 rạp từ SQL. Tìm `Sau` trả 1 thẻ phim.
- PASS: kiểm tra Controller, DAL chỉ đọc SQL, phân trang, đầu vào sai và xử lý lỗi kết nối qua `Tests/WebSmoke`; kiểm tra cú pháp JavaScript và ảnh thay thế qua Node.
- PASS: Chrome headless kiểm tra màu nền/thẻ/nút đúng yêu cầu; tìm kiếm có/rỗng, lọc, chuyển trang, ảnh lỗi, slide, Enter, vuốt tổng hợp, hẹn giờ; không tràn ngang ở 1366/390/320px. Đã xem ảnh chụp giao diện mới ở 390px.
- So sánh hash toàn bộ file nguồn Admin trước/sau: không thay đổi. Không sửa SQL, không thêm phim hoặc chạy seed.

File sửa trong lượt này: `Program.cs` (thứ tự cấu hình), `wwwroot/css/site.css` (toàn bộ bảng màu và trạng thái), `Views/Home/Index.cshtml` (thông báo nhóm phim rỗng), `README.md`; bổ sung file cấu hình cục bộ bị bỏ qua bởi Git. `Tests/WebSmoke/browser.mjs` thêm kiểm tra màu, dữ liệu thật và cho phép chọn URL qua biến `YMC_WEB_URL`.

Không có script SQL mới cần chạy. Nhóm Sắp chiếu hiện chưa có phim công khai nên hiển thị rỗng; chưa kiểm thử nhóm này với phim thật. Không thử cảm ứng trên thiết bị thật hay trình duyệt ngoài Chrome trong lượt này.

## Phạm vi

ASP.NET Core MVC .NET 10, Razor và ADO.NET. Giữ nguyên Admin, dùng cùng database YeuMinhEmCinema. Đã làm bố cục đỏ–đen, menu cố định, giới thiệu rạp, slide phim đang chiếu mới khởi chiếu, tìm tên phim, lọc trạng thái, phân trang 12 phim và danh sách rạp hoạt động. Không có trường thể loại hoặc chỉ số độ hot trong schema nên không tự thêm bộ lọc hay xếp hạng đó.

Chi tiết phim, lịch chiếu, tài khoản, giữ ghế, bắp nước, thanh toán và vé QR chưa nằm trong giai đoạn này. Vì vậy chưa hiển thị nút đặt vé/đăng nhập dẫn tới chức năng chưa làm. Nút trên slide đưa tới thẻ phim tương ứng. Chưa có email/điện thoại chính thức nên liên hệ dùng địa chỉ rạp thật.

## Chạy bằng Visual Studio

1. Mở `YeuMinhEmCinema.slnx` bằng Visual Studio hỗ trợ .NET 10.
2. Chọn `YeuMinhEmCinema.Web` làm Startup Project.
3. Tạo `appsettings.Local.json` trong thư mục Web (đã được gitignore):

```json
{
  "ConnectionStrings": {
    "Cinema": "Server=.\\SQLEXPRESS;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;Connect Timeout=5"
  }
}
```

Đây là ví dụ SQL Express cục bộ dùng Windows Authentication. Đổi tên máy chủ theo máy của bạn. Không đưa mật khẩu SQL vào source. `TrustServerCertificate=True` chỉ phù hợp máy phát triển với chứng chỉ tự ký; môi trường thật cần chứng chỉ tin cậy.

4. Bấm F5 và mở http://localhost:5186.

## Chạy bằng PowerShell

Từ thư mục gốc dự án:

```powershell
$env:YMC_CONNECTION = 'Server=.\SQLEXPRESS;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;Connect Timeout=5'
dotnet build src/YeuMinhEmCinema.Web
dotnet run --project src/YeuMinhEmCinema.Web
```

Mở http://localhost:5186. Dừng bằng Ctrl+C. `ConnectionStrings: Cinema` trong cấu hình được ưu tiên hơn `YMC_CONNECTION`; cũng có thể dùng biến môi trường `ConnectionStrings__Cinema`.

Không có SQL mới cần chạy. Database cần có `dbo.sp_YMC_WebDanhSachPhim` từ script 19 đã cài và bảng `Rap`. Không chạy lại seed hoặc file tổng chỉ để mở Web. Ứng dụng chỉ đọc dữ liệu ở giai đoạn này.

## Ảnh và cấu trúc mã

- `Program.cs`, `appsettings.json`, `Properties/launchSettings.json`: đăng ký MVC, cấu hình và địa chỉ chạy.
- `Controllers/HomeController.cs`: kiểm tra bộ lọc, gọi DAL, trả lỗi an toàn.
- `Data/TrangChuData.cs`: gọi procedure danh sách phim bằng tham số; đọc rạp hoạt động; giải phóng kết nối mỗi lần đọc.
- `Models/Phim.cs`, `Models/Rap.cs`: dữ liệu công khai và kiểm tra địa chỉ ảnh.
- `ViewModels/TrangChuViewModel.cs`: dữ liệu và phân trang của trang chủ.
- `Views/Shared/_Layout.cshtml`, `Views/_ViewImports.cshtml`, `Views/_ViewStart.cshtml`: bố cục Razor chung.
- `Views/Home/Index.cshtml`, `Views/Home/Loi.cshtml`: trang chủ và thông báo lỗi.
- `wwwroot/css/site.css`, `wwwroot/js/site.js`: responsive, tìm kiếm có trạng thái chờ, slide hỗ trợ cảm ứng/dừng tự chuyển, giảm chuyển động.
- `wwwroot/images`: logo/ảnh giới thiệu sao chép từ `Design/Web/dist/assets`; SVG thay thế poster bị thiếu.
- Solution gốc chỉ bổ sung project Web. Các file Admin và SQL không bị sửa bởi giai đoạn này.

Poster trong SQL phải là URL HTTP(S) hoặc đường dẫn bắt đầu bằng `/` trỏ vào wwwroot. Nếu Admin đang lưu đường dẫn ổ đĩa Windows, Web hiển thị ảnh thay thế; không tự sửa dữ liệu hay gán poster mẫu cho phim thật. Để dùng ảnh cục bộ, chép ảnh được phép sử dụng vào wwwroot/images và quản lý đường dẫn tương ứng theo quy trình dữ liệu của bạn.

Package: `Microsoft.Data.SqlClient` 7.1.1 cùng bản Admin để kết nối SQL; `System.Security.Cryptography.Pkcs` 10.0.13 nâng phụ thuộc đang bị NuGet cảnh báo khi dùng bản mặc định của SqlClient. Không dùng Entity Framework.

## Kiểm tra

- PASS: `dotnet build src/YeuMinhEmCinema.Web/YeuMinhEmCinema.Web.csproj --nologo`: 0 lỗi, 0 cảnh báo.
- PASS: `node --check src/YeuMinhEmCinema.Web/wwwroot/js/site.js`.
- PASS: kết nối SQL chỉ đọc qua sqlcmd: database hiện có 4 phim và có procedure danh sách phim Web. Không thay đổi dữ liệu.
- PASS: HTTP với Web kết nối SQL thật: trang chủ 200, hiển thị 2 phim công khai; lọc Đang chiếu 200 với 2 thẻ; tìm từ khóa không có 200 với thông báo rỗng; `?trang=0` trả 400; CSS và ảnh giới thiệu trả 200. Số phim toàn bảng khác số phim công khai vì Web chỉ lấy trạng thái được procedure cho phép.
- PASS: kiểm tra tự động `Tests/WebSmoke`: đầu vào sai không gọi DAL, trang vượt chuyển về cuối và giữ bộ lọc, trạng thái rỗng là Tất cả, chặn đường dẫn poster không phù hợp, thiếu cấu hình trả 503.
- PASS: DAL với SQL thật, dùng kích thước trang 1 để thử trang đầu/cuối/vượt trang trên dữ liệu đang có; trang vượt giữ đúng tổng, bộ lọc không có kết quả giữ tổng 0. Không seed hoặc thay đổi dữ liệu.
- PASS: SQL không truy cập được (địa chỉ loopback cổng 1, timeout 1 giây) được xử lý 503 với thông báo an toàn.
- PASS: Chrome headless 1366, 390 và 320px: không cuộn ngang, giới thiệu trước slide, điểm neo không bị menu che; thử tên phim/rạp dài trong DOM trình duyệt không ghi SQL. Đã xem ảnh chụp toàn trang ba kích thước.
- PASS: nút trước/sau, chỉ báo, vuốt mô phỏng, phím Enter, bật/tắt, tự chuyển sau 6 giây, dừng khi tương tác và trạng thái khởi đầu khi prefers-reduced-motion được bật.
- PASS: ảnh lỗi trước/sau khi gắn listener được thay thế; mô phỏng ảnh thay thế cũng lỗi để xác nhận không lặp.
- PASS: Web chạy không cấu hình SQL trả HTTP 503; Chrome kiểm tra thông báo lỗi không tràn ngang ở 1366/390/320px, đã xem ảnh ở 320px.
- Chưa kiểm tra các luồng tài khoản, đặt vé đồng thời, thanh toán, hết hạn, QR/WinForms và quyền sở hữu: các luồng đó chưa được triển khai trong giai đoạn trang chủ.

## Sửa lỗi trang chủ (lượt hoàn thiện)

Giữ nguyên ASP.NET Core MVC, ADO.NET và màu đỏ–đen. Không thay đổi các file Admin, dữ liệu hay SQL trong lượt này; các thay đổi Admin đã tồn tại từ trước được giữ nguyên. Không có script SQL mới cần chạy.

Đã kiểm tra nơi gọi procedure trong `src`, `Tests` và SQL: mã ứng dụng hiện chỉ có `TrangChuData` gọi danh sách phim Web. Giữ nguyên hợp đồng procedure. Khi trang > 1 trả rỗng, DAL gọi lại trang 1 với kích thước 1 để lấy `TongKetQua` thay vì tải cả danh sách. Controller chuyển về trang cuối (hoặc trang 1 nếu không có kết quả), giữ từ khóa và trạng thái. Nếu dữ liệu thay đổi đồng thời giữa các lần đọc, lần request sau sẽ kiểm tra lại phạm vi trang; đây không phải ảnh chụp transaction chung cho cả lượt duyệt.

`ModelState` được kiểm tra trước DAL để `trang=abc` hoặc vượt int không bị âm thầm thành trang 1. Khoảng cho phép 1–1.000.000, từ khóa tối đa 200 ký tự; trạng thái rỗng là Tất cả. Tham số sai trả HTTP 400, lỗi dữ liệu/kết nối trả 503.

Các file sửa trong lượt này:

- `Controllers/HomeController.cs`: constructor thông thường, ModelState, thông báo 400 theo lỗi, chuẩn hóa bộ lọc, chuyển trang hợp lệ.
- `Data/TrangChuData.cs`: constructor thông thường, lấy tổng khi trang rỗng; phương thức virtual để kiểm tra Controller không cần SQL.
- `Views/Home/Index.cshtml`, `Views/Home/Loi.cshtml`, `Views/Shared/_Layout.cshtml`, `Views/_ViewStart.cshtml`: xuống dòng, thụt lề Razor/HTML.
- `wwwroot/css/site.css`: định dạng đầy đủ, cho phép tên dài co trong flex và xuống dòng địa chỉ rạp.
- `wwwroot/js/site.js`: mở rộng khối một dòng, bổ sung chú thích, bắt ảnh lỗi sớm, ngăn vòng lặp ảnh thay thế; nhãn tự chuyển đúng khi reduced-motion bật.
- `wwwroot/images/poster-placeholder.svg`: định dạng SVG dễ đọc.
- `README.md`: hướng dẫn và kết quả thực tế.
- Thêm `Tests/WebSmoke/WebSmoke.csproj`, `Program.cs`, `browser.mjs`, `poster.mjs`, `error-page.mjs`: kiểm tra nhẹ dùng .NET và Node có sẵn, không thêm framework kiểm thử hoặc package mới trong lượt này.

Chạy kiểm tra từ thư mục gốc:

```powershell
dotnet run --project Tests/WebSmoke
node --check src/YeuMinhEmCinema.Web/wwwroot/js/site.js
node Tests/WebSmoke/poster.mjs
```

Kiểm tra SQL chỉ đọc (cần `YMC_CONNECTION` đã cấu hình như hướng dẫn trên):

```powershell
$env:YMC_WEB_SQL_TEST = '1'
dotnet run --project Tests/WebSmoke
Remove-Item Env:YMC_WEB_SQL_TEST
```

Kiểm tra HTTP/Chrome: chạy Web có SQL tại 5186, mở Chrome headless với `--remote-debugging-port=9226` và profile thử nghiệm riêng, rồi chạy `node Tests/WebSmoke/browser.mjs`. Script yêu cầu dữ liệu hiện có ít nhất 2 phim đang chiếu để kiểm tra slide; không tự thêm dữ liệu. Ảnh chụp nằm trong `Tests/WebSmoke/bin/screenshots` (không đưa vào Git). Script kết thúc bằng đóng phiên Chrome thử nghiệm, vì vậy không dùng cổng của trình duyệt làm việc cá nhân.

`error-page.mjs` dùng Web không cấu hình kết nối ở cổng 5187 và Chrome thử nghiệm cổng 9226 để kiểm tra HTTP 503, bố cục thông báo lỗi. Có thể chạy Web đó bằng `dotnet run --project src/YeuMinhEmCinema.Web --no-launch-profile --urls http://localhost:5187` sau khi bỏ các cấu hình kết nối cục bộ trong phiên thử nghiệm.

Giới hạn: kiểm tra bằng Chrome headless và vuốt tổng hợp, chưa thử thiết bị cảm ứng thật, Safari, Firefox hoặc trình đọc màn hình. Bộ lọc Sắp chiếu trên database hiện tại không có phim công khai, đã kiểm tra trạng thái rỗng, chưa kiểm tra bộ thẻ Sắp chiếu với dữ liệu thật. Trang cuối nhiều hơn 1 trang đã thử ở DAL bằng kích thước 1 và Controller bằng dữ liệu kiểm thử 25 phim; chưa thử UI có hơn 12 phim thật, không seed để tạo điều kiện đó. Các luồng tài khoản, đặt vé và thanh toán nằm ngoài lượt này.
