# YeuMinhEm Cinema

Đồ án C#: Admin Windows Forms, ADO.NET và SQL Server; giao diện web khách hàng đang là bản HTML/CSS/JavaScript demo.

Đọc **BAT-DAU-O-DAY.md** để cập nhật trên máy đã có database.

## Đã có trong mã nguồn

- Quản lý phim; rạp/phòng/ghế kết nối SQL Server.
- Module lịch chiếu: danh sách và lọc, thêm/sửa, ngừng/mở bán, hủy,
  lịch phòng trong ngày, sao chép có xem trước và xuất CSV.
- Thủ tục SQL kiểm tra trùng lịch và khoảng dọn phòng, thao tác trong transaction.
- Bộ kiểm tra CSV và SQL integration riêng.

## Chưa hoàn thiện trong đợt này

Các màn hình đơn đặt vé, bán vé, F&B, khách hàng, nhân viên/phân quyền và báo cáo
còn cần phát triển nghiệp vụ/database. Website chưa có backend ASP.NET Core;
Core/Data/Web là các thư mục chuẩn bị, không phải ba project đã hoàn chỉnh.
Chưa có thanh toán thực và quy trình hoàn vé. Đây chưa phải toàn bộ đồ án hoàn thiện.

## Cấu trúc

| Thư mục | Nội dung |
| --- | --- |
| src/YeuMinhEmCinema.Admin | WinForms C#, .NET 10 |
| src/YeuMinhEmCinema.Core, Data, Web | Giữ chỗ cho bước phát triển tiếp |
| Database/Scripts | Tạo bảng và thủ tục SQL |
| Database/Seed | Dữ liệu mẫu, không chạy lại trên máy hiện có để sửa chữ |
| Design/Web | Web demo và tài nguyên |
| Design/Admin | Tài liệu thiết kế Admin |
| Docs | Báo cáo, sơ đồ, hướng dẫn |
| Tests | Kiểm tra CSV và tích hợp SQL |

## Chạy

Cần Windows, .NET 10 SDK, SQL Server/Express. Chạy SQL theo Database/README.md.

```powershell
dotnet build .\YeuMinhEmCinema.slnx
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

Web demo: mở Design/Web/dist/index.html bằng Live Server.

## Kiểm chứng bản sửa

Đã biên dịch Admin bằng .NET SDK 10.0.100 với EnableWindowsTargeting=true trên Linux,
0 lỗi/0 cảnh báo. Đã kiểm tra cú pháp SQL bằng Microsoft ScriptDom (TSql160Parser).
Test CSV đã chạy đạt; test SQL integration đã biên dịch nhưng chưa chạy SQL Server.
Chưa chạy giao diện WinForms trên Windows; cần kiểm thử theo Docs/HuongDan/LICH-CHIEU-HOAN-THIEN.md.

ZIP không chứa lịch sử Git hoặc dữ liệu database. Giữ .git khi cập nhật repo hiện có.
