# Cập nhật WinForms YeuMinhEm Cinema

Bản này sửa trực tiếp source bạn gửi YeuMinhEmCinema(4).zip. Không chứa mật khẩu Admin, không chứa database .bak/.mdf.

## Máy bạn đã chạy SQL 00–22 và đã có tài khoản Admin

1. Đóng ứng dụng Admin và Visual Studio để tránh chép trúng file đang chạy.
2. Giải nén vào một thư mục riêng. Có thể mở và thử bản riêng trước khi chép vào repo.
3. Trong SSMS kết nối `.\SQLEXPRESS`, chạy **Database/Scripts/23_WinForms_HoanThien.sql** nếu chưa có SQL 23, sau đó chạy **Database/Scripts/25_Admin_PhamViRap.sql**. SQL 25 vá quyền sửa rạp/phòng/ghế, không seed dữ liệu hoặc đổi mật khẩu.
4. Chạy **Database/KIEM-TRA-WINFORMS.sql**. Các cột ID object phải khác NULL. File không sửa tài khoản.
5. Mở **src/YeuMinhEmCinema.Admin/YeuMinhEmCinema.Admin.csproj** bằng Visual Studio.
6. Build (Ctrl+Shift+B), rồi F5. NuGet tự khôi phục thư viện, gồm QRCoder để xuất vé QR.
7. Đăng nhập bằng tài khoản Admin đã tạo trước đây. Không cần tạo lại tài khoản hoặc chạy lại seed.

Không cần chạy lại CAI-DAT-TAT-CA.sql trên database đang dùng. Nếu sau này chạy lại các script cũ 11/15/22, hãy chạy 23 rồi 25 cuối cùng để giữ bản tích hợp và bản vá quyền mới.

Nếu chép vào repo cũ, chép NỘI DUNG thư mục YeuMinhEmCinema vào đúng thư mục dự án, chọn thay thế file. Giữ thư mục .git của bạn; tránh lồng thành YeuMinhEmCinema/YeuMinhEmCinema. Các Designer chuyển sang giao diện bằng code có file stub đi kèm, phải chép thay thế cả chúng.

## Chạy bằng lệnh

Mở PowerShell tại thư mục có YeuMinhEmCinema.slnx:

```powershell
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

Hoặc nhấp đúp **CHAY-ADMIN.cmd**. Cần Windows, .NET SDK 10 và SQL Server đang chạy; không phải app Web.

## Muốn thử riêng trên database Test

Mở bản sao file 23, đổi dòng `USE YeuMinhEmCinema;` thành `USE YeuMinhEmCinema_Test;`, chạy trên SSMS.
Sau đó chạy từ PowerShell:

```powershell
$env:YMC_CONNECTION = 'Server=.\SQLEXPRESS;Database=YeuMinhEmCinema_Test;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;'
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
Remove-Item Env:\YMC_CONNECTION
```

Database Test có cấu trúc riêng. Dữ liệu fixture của bài thử trước đã rollback, nên có thể cần tạo Admin/danh mục riêng trong Test để thao tác UI.

## Database mới hoàn toàn

Mở Database/CAI-DAT-TAT-CA.sql và chạy toàn bộ (đã kèm 23 và bản vá 25 ở cuối). Seed tùy chọn, không bắt buộc. Đủ bảng giá cho từng loại ghế/định dạng/ngày chiếu trước khi bán. Không có admin/mật khẩu mặc định.

## Điểm cần hiểu khi chạy

- Danh mục và tài khoản hiện có giữ trên SQL Server; ZIP không mang theo hay thay mật khẩu.
- Các màn hình từng minh họa đã thay bằng truy vấn/thao tác SQL. Web trong Design là bản thiết kế cũ, không phải Web backend mới.
- Thu/hoàn chỉ GHI NHẬN tiền đã nhận/đã hoàn. Không tích hợp ngân hàng thật; không bấm xác nhận nếu chưa thu/hoàn tiền.
- Đọc Docs/HuongDan/WINFORMS.md để biết quy trình từng mục và các giới hạn đã chốt.
- Bản này đã build và kiểm tra tự động như KET-QUA-WINFORMS.md; chưa chạy GUI Windows hay SQL 23 trong môi trường đóng gói. Cần kiểm tra chức năng trên máy bạn.

## Bản vá phạm vi Admin SQL 25

Database đang dùng đã có SQL 23 chỉ cần chạy `Database/Scripts/25_Admin_PhamViRap.sql` sau khi chọn đúng database. Không chạy lại seed. Khi dùng database Test, đổi dòng `USE YeuMinhEmCinema;` thành `USE YeuMinhEmCinema_Test;`. Hai file tổng cài mới đã kèm SQL 25. SQL 24 là phần thanh toán mô phỏng Web riêng, không phải điều kiện để áp dụng SQL 25.
