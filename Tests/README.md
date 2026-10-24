# Kiểm thử

## Không cần SQL Server

```powershell
dotnet run --project .\Tests\AdminSmoke\AdminSmoke.csproj
dotnet run --project .\Tests\CsvSmoke\CsvSmoke.csproj
```

AdminSmoke dùng trực tiếp BaoMatMatKhau, CsvUtility và TicketQr từ production; kiểm hash/salt/sai mật khẩu/không Trim/hash hỏng, CSV tiếng Việt/BOM/escape/chặn công thức, PNG QR.

## Cần SQL Server — chỉ trên database Test

Chạy SQL 00–23 trên Test trước. Không dùng database chính. Các project kiểm tra đều đòi YMC_TEST_CONNECTION có tên database hậu tố _Test:

```powershell
$env:YMC_TEST_CONNECTION='Server=.\SQLEXPRESS;Database=YeuMinhEmCinema_Test;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;'
dotnet run --project .\Tests\SqlIntegration\SqlIntegration.csproj
dotnet run --project .\Tests\PricingIntegration\PricingIntegration.csproj
Remove-Item Env:\YMC_TEST_CONNECTION
```

SqlIntegration kiểm các procedure lịch legacy dùng chung core nghiệp vụ. PricingIntegration nối DAL mới và tạo actor fixture riêng có vai trò ADMIN rồi dọn đúng fixture. Hash X chỉ là dữ liệu test tạm, không phải tài khoản dùng thực tế. Nếu tiến trình bị dừng cưỡng bức có thể còn fixture, chỉ xử lý trên Test.

SQL script end-to-end trong Database/Tests; checklist UI trong Docs/HuongDan/KIEM-THU-WINDOWS.md. Build các project test không có nghĩa đã thực thi kiểm thử SQL. Xem KET-QUA-WINFORMS.md.
