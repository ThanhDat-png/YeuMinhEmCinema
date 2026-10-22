# Cập nhật quản lý suất chiếu

## Bạn đã có database và các suất kiểm thử

1. Đóng Admin. Sao lưu folder code hiện tại trước khi ghi đè.
2. Giải nén ZIP này, vào folder YeuMinhEmCinema, copy các file/thư mục bên trong
   vào folder repo hiện tại (có YeuMinhEmCinema.slnx). Chọn ghi đè file trùng tên.
   Giữ nguyên thư mục .git của repo cũ. Không lồng thêm một folder YeuMinhEmCinema.
3. Trong SSMS, kết nối .\SQLEXPRESS, chạy từng file theo thứ tự:
   - Database/Scripts/05_ThemSuatChieu.sql
   - Database/Scripts/06_SuaSuatChieu.sql
   - Database/Scripts/07_DoiTrangThaiSuatChieu.sql
   - Database/Scripts/08_SaoChepLich.sql
   Dừng và kiểm tra nếu Messages có lỗi. File 05 đã cập nhật, cần chạy lại dù trước đây đã có thủ tục thêm.
   Không chạy lại seed hoặc các script tạo rạp cũ trên máy đã có dữ liệu.
4. Mở PowerShell tại folder có solution rồi chạy:

```powershell
dotnet build .\YeuMinhEmCinema.slnx
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

5. Vào Lịch chiếu. Mặc định hiển thị mọi ngày để thấy cả các suất kiểm thử.

## Nếu cài trên máy mới

Đọc Database/README.md. Chạy tạo database, bảng và dữ liệu mẫu theo đúng thứ tự;
không chỉ chạy script 05–08 trên một database rỗng.

## Phạm vi bản cập nhật

Hoàn thiện code module lịch chiếu: danh sách/lọc, thêm/sửa, đổi trạng thái/hủy,
lịch phòng trong ngày, sao chép có xem trước, xuất CSV. Không xóa hoặc đặt lại dữ liệu cũ.
Bản ZIP là mã nguồn; dữ liệu bạn đã sửa trong SQL Server không tự đi theo ZIP.

Admin đã được build với .NET 10: 0 lỗi, 0 cảnh báo. Kiểm tra cú pháp SQL và test CSV đã đạt.
Chưa chạy ứng dụng WinForms trên Windows và chưa thực thi các thủ tục mới trên SQL Server tại môi trường sửa.
Các module bán vé, F&B, tài khoản, báo cáo và backend web chưa được hoàn thiện trong đợt này.
