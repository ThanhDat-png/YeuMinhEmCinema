# Yêu Mình Em Cinema

Hệ thống quản lý rạp chiếu phim và đặt vé dành cho đồ án môn Lập trình C#.

Dự án gồm hai phân hệ sử dụng chung cơ sở dữ liệu SQL Server:

- **Admin Windows Forms:** quản lý danh mục, vận hành rạp, bán vé tại quầy và xem báo cáo.
- **Web ASP.NET Core MVC:** tra cứu phim, đặt vé và quản lý tài khoản khách hàng.

## Công nghệ

- C# và .NET 10.
- Windows Forms.
- ASP.NET Core MVC và Razor Views.
- ADO.NET với Microsoft.Data.SqlClient.
- SQL Server.
- QRCoder để tạo mã QR vé.

Các thao tác dữ liệu sử dụng truy vấn có tham số và stored procedure. SQL Server thực hiện các kiểm tra nghiệp vụ, phân quyền và xử lý giao dịch dùng chung cho Admin và Web.

## Chức năng

### Admin Windows Forms

- Đăng nhập, đổi mật khẩu và quản lý phiên làm việc.
- Quản lý nhân viên, tài khoản, vai trò, quyền và phân công rạp.
- Quản lý phim, thể loại và gán nhiều thể loại cho phim.
- Quản lý rạp, phòng chiếu, loại ghế và sơ đồ ghế.
- Quản lý lịch chiếu, kiểm tra trùng lịch và thời gian dọn phòng.
- Quản lý giá vé theo loại ghế, định dạng, loại ngày và khoảng hiệu lực.
- Quản lý sản phẩm F&B và combo.
- Bán vé tại quầy, giữ ghế, ghi nhận thu tiền và xuất phiếu/vé QR.
- Tra cứu đơn hàng, xem chi tiết, hủy đơn chờ thanh toán và ghi nhận hoàn tiền.
- Tra cứu vé và xác nhận vào rạp theo suất chiếu.
- Quản lý hồ sơ khách hàng và xem lịch sử đơn.
- Xem báo cáo thu tiền, hoàn tiền, doanh thu thuần, phim, suất chiếu và F&B.
- Xuất dữ liệu CSV tại các màn hình hỗ trợ.

Quyền thao tác và phạm vi rạp được kiểm tra tại SQL Server bên cạnh việc điều khiển chức năng trên giao diện.

### Web khách hàng

- Xem danh sách phim, tìm kiếm và xem thông tin phim.
- Tra cứu suất chiếu theo phim, rạp và ngày.
- Đăng ký, đăng nhập, đăng xuất và đổi mật khẩu.
- Cập nhật hồ sơ và ảnh đại diện.
- Chọn ghế, sản phẩm F&B và xác nhận giữ ghế.
- Thanh toán mô phỏng khi được bật trong môi trường phát triển.
- Xem lịch sử đặt vé, chi tiết đơn và vé QR.
- Hủy đơn đang chờ thanh toán theo điều kiện nghiệp vụ.

## Cấu trúc repository

```text
YeuMinhEmCinema/
├── Database/                    # Bộ cài, script SQL, dữ liệu mẫu và kiểm thử SQL
│   ├── CAI-DAT-TAT-CA.sql
│   ├── CAI-DAT-TEST.sql
│   ├── KIEM-TRA-CAI-DAT.sql
│   ├── Scripts/
│   ├── Seed/
│   ├── Tests/
│   └── README.md
├── Design/                      # Tài nguyên thiết kế và giao diện tham khảo
├── Docs/                        # Hướng dẫn, sơ đồ và tài liệu kỹ thuật
├── src/
│   ├── YeuMinhEmCinema.Admin/    # Ứng dụng Windows Forms
│   ├── YeuMinhEmCinema.Web/      # Website ASP.NET Core MVC
│   ├── YeuMinhEmCinema.Core/     # Thư mục thành phần Core
│   └── YeuMinhEmCinema.Data/     # Thư mục thành phần Data
├── Tests/                       # Các project kiểm tra C#
├── CHAY-ADMIN.cmd
├── CHAY-WEB.cmd
├── YeuMinhEmCinema.slnx
└── README.md
```

Source Admin được tổ chức thành các thư mục `Forms`, `UserControls`, `DataAccess`, `UI`, `Helpers` và `Infrastructure`.

## Yêu cầu môi trường

- Windows để chạy Admin Windows Forms.
- .NET SDK 10.
- SQL Server 2017 trở lên, compatibility level tối thiểu 140.
- SQL Server Management Studio để cài đặt và kiểm tra database.
- Visual Studio hỗ trợ .NET 10 nếu phát triển bằng IDE.
- Kết nối Internet khi khôi phục các package NuGet lần đầu.

## Cài đặt cơ sở dữ liệu

### Database mới

Chọn một bộ cài trong `Database/`:

- `CAI-DAT-TAT-CA.sql`: cài database `YeuMinhEmCinema`.
- `CAI-DAT-TEST.sql`: cài database `YeuMinhEmCinema_Test`.

Thực hiện:

1. Mở bộ cài bằng SQL Server Management Studio.
2. Kiểm tra SQL Server và tên database đích.
3. Chạy toàn bộ file và kiểm tra lỗi trong cửa sổ Messages.
4. Chạy `KIEM-TRA-CAI-DAT.sql` với đúng database.
5. Bổ sung dữ liệu mẫu nếu cần.

Dữ liệu mẫu chính thức nằm trong `Database/Seed/` và được chạy riêng. Trước khi bán vé, cần có phim, rạp, phòng, ghế, suất chiếu và bảng giá phù hợp.

Không có tài khoản hoặc mật khẩu Admin mặc định. Sử dụng chức năng khởi tạo quản trị viên đầu tiên khi database chưa có Admin.

### Database hiện có

Xác định các script đã được áp dụng trước khi nâng cấp. Với database đã có phần nền SQL00–22, thứ tự nâng cấp Admin là:

```text
23 → 25 → 26 → 27 → 28 → 29 → 30
```

Chỉ áp dụng những phần còn thiếu. Không chạy lại seed như một bước nâng cấp.

`Scripts/24_Web_MoPhongThanhToan.sql` phục vụ thanh toán mô phỏng Web và được cài riêng; không mặc định nằm trong hai bộ cài tổng.

Xem `Database/README.md` để biết thứ tự, điều kiện và hướng dẫn chi tiết. Không chạy hàng loạt mọi file trong `Scripts/` chỉ theo tên file.

## Cấu hình kết nối

Ví dụ kết nối database Test bằng Windows Authentication:

### Admin

Mở PowerShell tại thư mục gốc repository:

```powershell
$env:YMC_CONNECTION = 'Server=.\SQLEXPRESS;Database=YeuMinhEmCinema_Test;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;'
```

### Web

Cấu hình bằng biến môi trường:

```powershell
$env:ConnectionStrings__Cinema = 'Server=.\SQLEXPRESS;Database=YeuMinhEmCinema_Test;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;'
```

Thay `.\SQLEXPRESS` bằng SQL Server thực tế. Các biến trên có hiệu lực trong phiên PowerShell hiện tại và cần được đặt tại cửa sổ dùng để chạy ứng dụng.

Admin và Web cần trỏ đến cùng database nếu muốn sử dụng chung dữ liệu.

Không đưa mật khẩu SQL hoặc thông tin kết nối riêng lên repository.

## Chạy ứng dụng

Thực hiện tại thư mục chứa `YeuMinhEmCinema.slnx`.

### Khôi phục và build

```powershell
dotnet restore YeuMinhEmCinema.slnx
dotnet build YeuMinhEmCinema.slnx
```

### Chạy Admin

```powershell
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

Hoặc mở `CHAY-ADMIN.cmd`.

### Chạy Web

```powershell
dotnet run --project .\src\YeuMinhEmCinema.Web\YeuMinhEmCinema.Web.csproj
```

Với launch profile đi kèm, truy cập:

```text
http://localhost:5186
```

Hoặc mở `CHAY-WEB.cmd`, sử dụng địa chỉ:

```text
http://localhost:5190
```

Địa chỉ và cổng thực tế được hiển thị trong cửa sổ chạy ứng dụng.

## Quy tắc nghiệp vụ chính

- Một đơn hàng thuộc một suất chiếu, gồm từ 1 đến 8 ghế.
- Đơn có thể kèm tối đa 20 dòng F&B, số lượng mỗi dòng từ 1 đến 99.
- Ghế chỉ được giữ khi xác nhận tạo đơn, không phải khi vừa chọn trên sơ đồ.
- Thời gian giữ ghế tối đa 10 phút và không vượt quá giờ bắt đầu chiếu.
- Giá vé được xác định theo loại ghế, định dạng, loại ngày và ngày chiếu.
- Ghế chưa có giá phù hợp không được đặt.
- Đơn lưu giá và thông tin tại thời điểm đặt; thay đổi danh mục không tính lại giá của đơn đã tạo.
- Vé được phát hành sau khi ghi nhận thanh toán thành công.
- Hoàn tiền áp dụng cho toàn bộ đơn trước giờ chiếu khi chưa có vé nào được sử dụng.
- Xác nhận vào rạp được thực hiện từ 30 phút trước giờ bắt đầu đến trước giờ kết thúc suất.
- Vé đã sử dụng không được xác nhận lần thứ hai.
- Giờ suất chiếu sử dụng giờ Việt Nam; các thời điểm giao dịch được lưu UTC.
- Báo cáo thu/hoàn sử dụng ngày giao dịch; báo cáo theo suất sử dụng ngày bắt đầu chiếu.
- Doanh thu thuần được xác định bằng tổng thu trừ hoàn tiền.

## Kiểm thử

Repository có các project kiểm tra trong `Tests/` và các bài kiểm thử SQL trong `Database/Tests/`.

Một số project kiểm tra:

- `AdminSmoke`
- `CsvSmoke`
- `CatalogSmoke`
- `PricingIntegration`
- `SqlIntegration`
- `WebSmoke`
- `WebCustomerIntegration`

Ví dụ chạy kiểm tra CSV:

```powershell
dotnet run --project .\Tests\CsvSmoke\CsvSmoke.csproj
```

Các kiểm thử tích hợp cần database và cấu hình phù hợp. Chỉ chạy bài kiểm thử có ghi dữ liệu trên database Test theo hướng dẫn của từng bộ kiểm thử.

Build thành công không thay thế việc kiểm tra giao diện và nghiệp vụ thực tế.

## Phạm vi và giới hạn

- Thanh toán Web hiện là mô phỏng trong môi trường Development, chưa tích hợp cổng thanh toán thật.
- Ghi nhận thu/hoàn trong hệ thống không tự thực hiện chuyển tiền ngân hàng.
- Chưa hỗ trợ hoàn một phần hoặc nhiều lần thanh toán cho một đơn.
- Chưa hỗ trợ đơn chỉ mua F&B và quản lý tồn kho.
- Chưa có chức năng khuyến mãi, điểm thưởng hoặc bảng giá ngày lễ riêng.
- Thể loại phim được quản lý tại Admin; Web chưa hỗ trợ hiển thị và lọc theo thể loại.

## Tài liệu

- `Database/README.md`: cài đặt, nâng cấp, seed và kiểm thử SQL.
- `Docs/HuongDan/`: hướng dẫn sử dụng và vận hành.
- `Docs/Diagrams/`: sơ đồ kiến trúc, lớp và cơ sở dữ liệu.
- `Docs/Admin/`: tài liệu chức năng và kết quả kiểm thử Admin.

## Mục đích sử dụng

Dự án phục vụ học tập và minh họa việc xây dựng hệ thống quản lý rạp chiếu phim bằng C#, Windows Forms, ASP.NET Core MVC, ADO.NET và SQL Server.
