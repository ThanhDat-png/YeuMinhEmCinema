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

## Hồi quy quyền danh mục Admin

Cài SQL 25 trên database Test sau SQL 23, rồi từ thư mục gốc chạy:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -I -b -f 65001 -i Database/Tests/05_Admin_PhamViRap.sql
```

Script chỉ nhận database hậu tố `_Test`; mặc định `YeuMinhEmCinema_Test`. Có 19 ca từ chối và 6 ca cho phép, tự rollback quyền và fixture mỗi ca. Kiểm thu hồi rạp, rạp nguồn/đích khi chuyển phòng/ghế, lô trộn phạm vi, tạo sơ đồ, tài khoản bị khóa/ngừng việc, Admin toàn hệ thống và quản lý có phân công hợp lệ.

## Hồi quy soát vé đúng suất/phòng

Cài SQL 26 sau SQL 23/25 trên Test, rồi chạy từ gốc repo:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -I -b -f 65001 -i Database/Tests/06_Admin_SoatVeTheoSuat.sql
```

31 ca: tra cứu/xác nhận đúng suất/phòng; sai suất cùng phòng, sai phòng cùng rạp, ID không có; caller cũ và tham số tùy chọn; vé không tồn tại/đã dùng/hủy, đơn chưa trả/hoàn, suất hủy; ngoài/ trong khung giờ; thu hồi rạp/quyền, khóa tài khoản/ngừng việc; danh sách quyền SOAT_VE, Admin toàn cục, bỏ suất hủy và gồm suất qua đêm. Các trạng thái từ chối được dựng trong transaction để kiểm guard; không thay thế toàn bộ kiểm thử luồng tạo trạng thái. Fixture từng ca rollback. File chỉ nhận database `_Test`.

Kết quả đã chạy và kiểm GUI: `Docs/Admin/PHIEN-03-KET-QUA.md`.

## Phiên 4: tiền mặt và tra cứu đơn

AdminSmoke liên kết TienMat.cs production, bổ sung 28 kiểm tra tiền vừa đủ/thừa/thiếu, định dạng và giới hạn18 chữ số dưới vi-VN/en-US. Nhập số nguyên đồng hoặc dấu chấm ngăn nghìn Việt Nam (100000 hoặc 100.000); không nhận phần lẻ, số âm, chữ hoặc định dạng100,000 gây nhập nhầm.

Sau SQL 27 trên Test, chạy:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -I -b -f 65001 -i Database/Tests/07_Admin_TraCuuDon.sql
```

24 ca tra cứu mã đơn/mã thu/GUID vé/GUID tham chiếu; bộ lọc ngày/trạng thái; không có/ngoài phạm vi/thu hồi quyền; exact match, GUID có đuôi, số vượt BIGINT; trang đầu/cuối/vượt cuối, output tổng ở trang rỗng và caller cũ. Mỗi fixture rollback. Các đơn phân trang được dựng trực tiếp với trạng thái DA_HUY, không coi là kiểm luồng tạo/hủy đơn.

Đã chạy nâng cấp/cài mới, hồi quy SQL01/02/04/05/06 và GUI tiền mặt/tra cứu. Chi tiết: Docs/Admin/PHIEN-04-KET-QUA.md.

## Phiên 5: tìm nhân viên/phòng/phim và phòng chỉ xem

Sau SQL 28 trên Test, chạy từ gốc repo:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -I -b -f 65001 -i Database/Tests/08_Admin_TimKiem.sql
```

34 ca: mã/tên/SĐT nhân viên và thiếu quyền; mã/tên phòng Unicode, phạm vi/thu hồi, phòng ngừng, chỉ xem không ghi; tên phim literal, rạp/ngày, suất/phim/phòng/rạp ngừng/hủy/đã bắt đầu, thu hồi BAN_VE. Fixture và quyền tạm rollback mỗi ca. Tên/SĐT/mã hồ sơ có thể khớp nhiều tài khoản, nên ca dương kiểm có đúng hồ sơ mục tiêu; không giả định duy nhất. Mã tài khoản và mã hồ sơ là hai miền ID riêng.

SQL01/02/05/06/07, AdminSmoke, cài mới và GUI hai vai trò đã được chạy; kết quả/giới hạn tại Docs/Admin/PHIEN-05-KET-QUA.md.

## T06 — báo cáo phim/suất và phân loại thu

Sau SQL 29 trên Test, chạy:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -I -b -f 65001 -i Database/Tests/09_Admin_BaoCaoPhimSuat.sql
```

32 ca, mỗi ca có fixture rollback qua luồng giữ/thu/hoàn thật. Timestamp thu/hoàn được điều chỉnh trong fixture để kiểm ranh giới ngày VN, không phải dữ liệu thật. Hai vé và hai dòng F&B ở cùng đơn, nhiều đơn cùng suất, đơn chờ, suất hủy/ngoài rạp; bảng giá/menu đổi sau bán. Đối chiếu tiền với báo cáo cũ, bộ lọc phim và hai cơ sở ngày; kiểm trực tiếp sáu procedure với tài khoản ngoài phạm vi/thiếu quyền, thu hồi rạp và khóa actor.

Fixture mẫu rạp A: thu vé320000 + F&B140000 = thu460000, hoàn230000, thuần230000. Phim A thu340000/hoàn230000/thuần110000; phim B thu120000. Báo cáo cũ còn tiền vé160000 và F&B70000 từ đơn chưa hoàn. Không so sánh các cơ sở ngày khác nhau nếu không cùng tập giao dịch/suất.

Đã kiểm nâng cấp/cài mới, SQL01/02/07, AdminSmoke và GUI bản cuối. Kết quả: Docs/Admin/PHIEN-06-KET-QUA.md; checklist Word và các mục còn mở đi kèm. Chưa kiểm GUI với mọi vai trò/CSV dialog hoặc benchmark dữ liệu lớn.
