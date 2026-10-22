# YeuMinhEm Cinema

Đồ án môn Ngôn ngữ lập trình C#: xây dựng hệ thống quản lý rạp chiếu phim và đặt vé trực tuyến.

Hệ thống gồm ứng dụng quản trị dành cho nhân viên và website dành cho khách hàng.

## Công nghệ

- **Ngôn ngữ:** C#
- **Ứng dụng quản trị:** Windows Forms
- **Website:** ASP.NET Core
- **Truy cập dữ liệu:** ADO.NET — Microsoft.Data.SqlClient
- **Cơ sở dữ liệu:** SQL Server
- **Quản lý mã nguồn:** Git và GitHub

## Chức năng dự kiến

### Website khách hàng

- Xem, tìm kiếm và lọc danh sách phim.
- Xem thông tin phim, trailer và lịch chiếu.
- Chọn suất chiếu, ghế ngồi và đồ ăn, thức uống.
- Đặt vé, theo dõi trạng thái thanh toán và xem vé.
- Xem lịch sử đặt vé.

### Ứng dụng quản trị

- Quản lý phim.
- Quản lý rạp, phòng chiếu và ghế.
- Quản lý suất chiếu.
- Quản lý giá vé, đồ ăn và thức uống.
- Quản lý đơn đặt vé và bán vé tại quầy.
- Kiểm tra, xác nhận vé.
- Quản lý tài khoản và phân quyền.
- Báo cáo doanh thu và thống kê.

> Danh sách trên mô tả phạm vi dự kiến, không đồng nghĩa tất cả chức năng đã hoàn thành.

## Cấu trúc thư mục

| Thư mục | Nội dung |
| --- | --- |
| `src/YeuMinhEmCinema.Admin` | Mã nguồn ứng dụng quản trị Windows Forms |
| `src/YeuMinhEmCinema.Web` | Mã nguồn website khách hàng |
| `src/YeuMinhEmCinema.Core` | Các mô hình dữ liệu và thành phần dùng chung |
| `src/YeuMinhEmCinema.Data` | Kết nối SQL Server và truy cập dữ liệu bằng ADO.NET |
| `Database/Scripts` | Script tạo, cập nhật cấu trúc cơ sở dữ liệu |
| `Database/Seed` | Script dữ liệu mẫu |
| `Docs/BaoCao` | Báo cáo đồ án |
| `Docs/Diagrams` | Các sơ đồ phân tích và thiết kế hệ thống |
| `Docs/HuongDan` | Hướng dẫn cài đặt và sử dụng |
| `Design/Web` | Thiết kế giao diện website |
| `Design/Admin` | Thiết kế giao diện quản trị |
| `Tests` | Mã nguồn kiểm thử |

Các file `.gitkeep` giúp Git lưu lại những thư mục chưa có nội dung.

## Môi trường phát triển

- Windows để phát triển và chạy ứng dụng Windows Forms.
- .NET SDK tương thích với phiên bản của dự án.
- Visual Studio với workload **.NET desktop development** và **ASP.NET and web development**.
- SQL Server hoặc SQL Server Express.
- SQL Server Management Studio để quản lý cơ sở dữ liệu.
- Git.

## Thiết lập dự án

1. Clone repository:

   ```bash
   git clone https://github.com/ThanhDat-png/YeuMinhEmCinema.git
   ```

2. Mở thư mục dự án bằng Visual Studio.
3. Chạy các script cơ sở dữ liệu theo hướng dẫn trong `Database`.
4. Cấu hình kết nối SQL Server phù hợp với máy đang sử dụng.
5. Khôi phục các gói NuGet, biên dịch và chạy dự án cần dùng.

> Cấu trúc thư mục đang được chuẩn hóa. Hướng dẫn chạy chi tiết sẽ được bổ sung khi mã nguồn và script cơ sở dữ liệu được đưa vào đầy đủ.

## Quy ước quản lý mã nguồn

- Đặt mã nguồn trong `src`.
- Lưu script cơ sở dữ liệu trong `Database`.
- Lưu báo cáo, sơ đồ và hướng dẫn trong `Docs`.
- Không đưa mật khẩu, khóa API hoặc thông tin bí mật lên repository.
- Không đưa các thư mục sinh tự động như `bin`, `obj` và `.vs` lên repository.

## Cập nhật lên GitHub

Sau khi chỉnh sửa mã nguồn hoặc tài liệu:

```bash
git add .
git commit -m "Mo ta noi dung cap nhat"
git push
```

## Mục đích sử dụng

Dự án phục vụ học tập và thực hiện đồ án môn Ngôn ngữ lập trình C#.
