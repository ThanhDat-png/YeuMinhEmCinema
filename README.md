# YeuMinhEm Cinema

Đồ án môn Ngôn ngữ lập trình C#: hệ thống quản lý rạp chiếu phim và đặt vé.

## Nội dung hiện có

- Admin Windows Forms C#, .NET 10, ADO.NET (`Microsoft.Data.SqlClient`).
- Code truy cập SQL Server cho phim, rạp, phòng chiếu và ghế.
- Bản giao diện web HTML/CSS/JavaScript, dùng dữ liệu mô phỏng và localStorage.
- Script SQL tạo database, bảng Phim, rạp, phòng, loại ghế, ghế và dữ liệu mẫu.

## Cấu trúc

| Thư mục | Mục đích |
| --- | --- |
| `src/YeuMinhEmCinema.Admin` | Project WinForms hiện có |
| `src/YeuMinhEmCinema.Web` | Dành cho ASP.NET Core, chưa có project |
| `src/YeuMinhEmCinema.Core` | Dành cho mô hình dùng chung, chưa có project |
| `src/YeuMinhEmCinema.Data` | Dành cho DAL dùng chung, chưa có project |
| `Database/Scripts` | Cấu trúc database |
| `Database/Seed` | Dữ liệu mẫu |
| `Design/Web` | Giao diện web chạy thử và hướng dẫn gốc |
| `Design/Admin` | Dành cho tài liệu thiết kế Admin |
| `Docs/BaoCao`, `Docs/Diagrams` | Dành cho báo cáo và sơ đồ |
| `Docs/HuongDan` | Hướng dẫn chạy và kết quả kiểm tra đóng gói |
| `Tests` | Dành cho kiểm thử, chưa có test project |

## Chạy Admin trên Windows

Cần .NET 10 SDK, SQL Server Express và Visual Studio hỗ trợ .NET 10/Windows Forms.
Thiết lập database theo `Database/README.md`, kiểm tra chuỗi kết nối trong `CauHinh.cs`.
Mở `YeuMinhEmCinema.slnx` bằng Visual Studio, hoặc chạy tại thư mục gốc:

```powershell
dotnet restore .\YeuMinhEmCinema.slnx
dotnet build .\YeuMinhEmCinema.slnx
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

## Chạy giao diện Web

Mở `Design/Web/dist/index.html` bằng Live Server trong VS Code.
Trang admin web minh họa ở `Design/Web/dist/admin.html`.
Nếu đã cài Python, có thể chạy:

```powershell
py -m http.server 8080 --directory .\Design\Web\dist
```

Truy cập http://localhost:8080. Web demo chưa kết nối database của WinForms.

## Phạm vi chưa hoàn thành

Chưa có backend ASP.NET Core và kết nối đặt vé web với SQL Server.
Các màn hình lịch chiếu, đơn đặt vé, khách hàng, bán vé, F&B, kiểm tra vé,
nhân viên và báo cáo còn cần triển khai/kiểm thử nghiệp vụ với database.
Chưa có hệ thống thanh toán thực, bộ kiểm thử, báo cáo đồ án và sơ đồ hoàn chỉnh.
Các thư mục giữ chỗ không đồng nghĩa chức năng đã triển khai.

## GitHub

```powershell
git add .
git commit -m "Sap xep ma nguon va bo sung huong dan"
git push
```

Bản ZIP không chứa lịch sử Git. Khi cập nhật repo đã liên kết, copy nội dung
vào thư mục repo cũ và giữ nguyên thư mục `.git` của repo đó.
