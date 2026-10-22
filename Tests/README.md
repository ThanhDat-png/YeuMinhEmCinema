# Kiểm tra

## CSV (không cần database)

```powershell
dotnet run --project .\Tests\CsvSmoke
```

Kiểm tra round-trip CSV: BOM, tiếng Việt, dấu phẩy, ngoặc kép, xuống dòng,
NULL, ngày giờ và ô có tiền tố công thức. Đã chạy thành công trong môi trường sửa.

## SQL integration (chạy thủ công trên Windows)

Cần đã chạy script 04–08 và tài khoản có quyền tạo dữ liệu trong database.
Mặc định dùng .\SQLEXPRESS, database YeuMinhEmCinema, Windows Authentication.
Có thể đặt biến YMC_TEST_CONNECTION để thay chuỗi kết nối; không đưa bí mật lên Git.

```powershell
dotnet run --project .\Tests\SqlIntegration
```

Test tạo rạp/phòng/phim/loại ghế riêng có tiền tố YMC_TEST_ và các suất của riêng chúng.
Cuối test dọn đúng fixture đã tạo, không xóa rạp/phòng/phim của người dùng.
Chạy khi không thao tác với fixture; nên chạy trên bản sao database để dễ kiểm tra.
Nếu process bị tắt đột ngột, finally không chạy và fixture có thể còn lại.
Test không chạy tự động khi mở app hoặc build solution.

Có các ca thêm trùng, ranh giới dọn phòng, hai phòng cùng giờ, sửa chính nó,
đổi phòng trùng, ngừng bán/hủy, giờ quá khứ, qua đêm, sao chép theo nhóm,
không tạo dở dang, nguồn đổi sau xem trước và hai kết nối đồng thời.
Project đã build; chưa thực thi do môi trường sửa không có SQL Server.

Các test này không thay thế kiểm tra thao tác giao diện hoặc quy trình bán vé/thanh toán.
