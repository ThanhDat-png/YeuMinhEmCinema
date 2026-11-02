# Kết quả phiên 5 — tìm kiếm Admin

Ngày 28/10/2026. Nền commit 47a3f9a. Chỉ T05 (ADM-04,ADM-09,ADM-16); chưa commit/push phiên này.

## Đối chiếu trước triển khai

Đã đọc lại bản đúng C#_Nhóm1.docx trong C_SHARP, SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853. Mục 4.1.1/4.3.2/4.5/5.4.2 yêu cầu tìm kiếm và phân quyền/phạm vi trên các form quản lý. Giữ .NET10, ADO.NET, SQL Server và hợp đồng Web. Chưa chỉnh DOCX.

## Đã làm

- Nhân viên: tìm tên đăng nhập/họ tên, mã nhân viên/mã tài khoản chính xác hoặc một phần SĐT. Label phân biệt hai loại mã; hai miền ID có thể trùng số, tên/SĐT không duy nhất nên kết quả có thể nhiều dòng. Quyền quản trị nhân sự toàn cục giữ như trước, không tự cấp cho quản lý rạp. Các chức năng hồ sơ/tài khoản không đổi.
- Phòng: thêm tìm mã/tên, cây hiển thị mã phòng, đếm kết quả và Xóa lọc. Query có quyền RAP_XEM và lọc rạp phân công; trả cả phòng ngừng để tra cứu lịch sử. Kết quả rỗng xóa lựa chọn/sơ đồ cũ.
- Menu Rạp/Phòng chỉ cần RAP_XEM. Nếu thiếu RAP_QUAN_LY, khóa nút thêm/sửa/ngừng/tạo ghế/đổi ghế và context menu; chọn ghế không bật lại nút ghi. Procedure ghi giữ kiểm quyền/phạm vi SQL. Không mở các menu khác trong phiên này.
- Quầy: tên phim kết hợp rạp/ngày và điều kiện còn được bán. Đổi bộ lọc hoặc suất xóa ghế, menu, tiền khách đưa và tổng tạm cũ; cần tải lại trước chọn. Khi đã có yêu cầu giữ, bộ lọc vẫn nằm trong giỏ khóa như cũ.
- SQL28 thêm ba procedure đọc, không sửa schema/seed/quyền mặc định hoặc hợp đồng procedure cũ. DAL gọi cùng code SQL đã test; hai bộ cài tổng kèm28. Không có file Web được sửa.

## Bằng chứng đã chạy

- Trước SQL28: SQL08 báo thiếu procedure mới, xác nhận cần nâng cấp; không tuyên bố đây là test nghiệp vụ trên bản cũ.
- Nâng cấp:34/34 ca SQL08 đạt, fixture và thay đổi quyền rollback. Có tìm tên/mã/SĐT Unicode, ký tự literal/wildcard, số vượtINT, thiếu quyền/tài khoản khóa; phòng chỉ xem/ngoài phạm vi/thu hồi; điều kiện suất/phim/rạp/phòng ngừng/hủy/đã bắt đầu.
- Cài mới:34/34 đạt trên YMC_SearchInstall_cc16a298_Test; database tạm đã dọn. SQL28 áp dụng lại không lỗi. Có phát hiện test cũ giả định mã/SĐT/tên duy nhất; đã đổi sang kiểm đúng hồ sơ mục tiêu, không ép dữ liệu hệ thống duy nhất.
- Hồi quy SQL01 bán-thu-phát vé-soát-hoàn/retry, SQL02 từ chối, SQL05 phạm vi, SQL06 soát đúng suất/phòng, SQL07 tra cứu/phân trang đều đạt. AdminSmoke 37 kiểm (gồm tiền mặt) đạt. Build 0 lỗi/0 cảnh báo, output bin/AdminSearch. Log.NET nằm trong đầu ra công cụ, không tạo log tệp giả.
- GUI Admin: tìm SĐT0901234567 và mã hồ sơ370 ra đúng hồ sơ Test; phòng vẫn có nút sửa theo quyền Admin.
- GUI BAN_VE Test: tên tài khoản/role đã xác minh trên màn hình; mở được Rạp/Phòng, chỉ thấy một rạp được giao. Mã649/tên Ánh Sáng trả phòng; mã650 ở rạp khác trả0 và xóa sơ đồ. Toàn bộ nút ghi disabled; chọnA1 vẫn disabled; context menu ghế cũng khóa mọi thao tác ghi. SQL test độc lập từ chối người chỉ xem sửa phòng/tạo ghế.
- GUI quầy bằng BAN_VE: có hai phim thử, chọn ghế80000 rồi đổi tên Mặt Trăng xóa suất/ghế/tổng về0; tải lại ra đúng suất Mặt Trăng. Tên không có trả trạng thái rỗng, không giữ sơ đồ/menu cũ. Đã xem thường1172×850 và quầy phóng to1536×816; không khẳng định mọi DPI.
- Fixture GUI ba rạp/phòng, hai phim, tài khoản tạm đã dọn đúng ID/nhãn; chặn cleanup nếu có đơn phát sinh ngoài ca tìm kiếm. Không phát sinh thanh toán GUI. Mật khẩu tạm không lưu repo; tài khoản Test đã xóa. Dữ liệu người dùng và quyền vai trò mặc định được giữ.

Ảnh GUI đã xem qua công cụ, không lưu PNG. Log SQL thật nằm ở evidence/2026-10-28/session-05. Chưa thử mọi menu chuột phải phòng, mất kết nối GUI hoặc thao tác giữ đơn rồi thử thay bộ lọc trong phiên này; khóa giỏ đã rà source và luồng bán được SQL hồi quy kiểm. Không đánh các mục demo tổng đã hoàn thành.

## Áp dụng và còn lại

Máy đã có SQL23/25/26/27: chạy Database/Scripts/28_Admin_TimKiem.sql trên đúng database rồi dùng Admin mới. Đổi USE nếu dùng Test; không seed hoặc cần SQL24 Web. Test local đã nâng cấp, database chính/máy nhóm chưa tự áp dụng.

T05 và ADM-04/09/16 DONE theo phạm vi nêu trên. ADM-02 còn các menu khác; T06 báo cáo theo phim/suất, T07 thể loại, T08 demo và T09 chỉnh báo cáo còn mở. Kế tiếp ưu tiên T06, chưa triển khai trong phiên này. Chưa commit/push, chờ lệnh riêng của người dùng.
