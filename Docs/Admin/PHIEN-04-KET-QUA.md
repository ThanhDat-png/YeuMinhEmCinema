# Kết quả phiên 4 — tiền mặt và tra cứu đơn

Ngày 28/10/2026, nền commit 834ab95. Phạm vi T04 (ADM-18, ADM-20). Chưa commit/push phiên này.

## Đối chiếu báo cáo

Đã đọc trực tiếp bản đúng C#_Nhóm1.docx trong C_SHARP; hash SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853 không đổi. Mục5.4.2 và6.2.3 ca5 yêu cầu nhập tiền khách đưa;4.1.1/4.3.2/5.4.2 yêu cầu tra cứu đơn/giao dịch. Giữ .NET10, ADO.NET, SQL Server; không sửa Web, schema tài chính hoặc quy tắc thu/hoàn dùng chung. Chưa chỉnh nội dung DOCX.

## Đã triển khai

- Tiền mặt: sau giữ ghế chốt tổng, nhập số nguyên đồng hoặc dấu chấm ngăn nghìn Việt Nam (100000/100.000); hiển thị thiếu/thừa, chặn thiếu/sai/âm/phần lẻ/vượt18 chữ số. Quy tắc parse cố định vi-VN, không đổi theo culture máy. Đổi phương thức hoặc giỏ xóa số cũ; đã trả thì khóa tiền/phương thức/mã và chặn bấm thu lại. Chuyển khoản vẫn cần mã đối soát.
- Hộp xác nhận nêu tổng đơn, tiền khách đưa và tiền trả. GiaoDichDAL.Thu chỉ truyền tổng đơn, không truyền tiền khách đưa; ThanhToan.SoTien và toàn bộ proc thanh toán giữ hợp đồng cũ. Tiền khách đưa/thừa không lưu vào database hay phiếu QR.
- Tra cứu: tìm chính xác theo MaDonHang, mã giao dịch thu hoặc GUID vé; SQL cũng nhận GUID tham chiếu đơn. Mã kết hợp rạp/ngày tạo/trạng thái, giữ quyền DON_HANG_XEM/phạm vi. Không tìm gần đúng hoặc theo mã hoàn trong phiên này.
- SQL 27 thêm cuối hai tham số tùy chọn @TuKhoa và @TongKetQua OUTPUT. Giữ một result set các cột đơn/TongKetQua và caller cũ không truyền vẫn chạy. GUID có đuôi không bị SQL cắt thành GUID hợp lệ.
- Snapshot tập kết quả trong một lần tải, trả tổng qua output cả trang rỗng. UI tổng số dòng/trang, thứ tự mã giảm dần, khóa Trước/Sau ở biên; đổi bộ lọc/từ khóa xóa kết quả và đưa trang1. Tải lại trang vượt cuối điều chỉnh theo tổng. Không cam kết snapshot xuyên nhiều lần tải khi người khác sửa dữ liệu.
- SourceSQL19 chỉ sửa proc danh sách đơn Admin; các proc Web giữ nguyên. Bộ cài tổng kèm27; không seed mới.

## Kiểm thử đã chạy

- Trước nâng cấp: SQL07 báo too many arguments vì proc cũ chưa hỗ trợ từ khóa/output; không coi là bằng chứng guard tìm mã cũ đã chạy.
- Sau nâng cấp:24/24 ca SQL07 đạt, bao gồm mã đơn/thu/vé/tham chiếu, lọc ngày/trạng thái, không có/ngoài phạm vi/thu hồi quyền/tài khoản ngừng, exact match/GUID đuôi/số vượtBIGINT, trang đầu/cuối/vượt cuối và caller cũ. Fixture rollback mỗi ca. Đơn phân trang dựng trực tiếp DA_HUY, không thay thế test luồng hủy.
- Cài mới đầy đủ ở YMC_CashInstall_7ac4f708_Test:24/24 đạt; database tạm đã dọn. SQL 27 áp dụng lại không lỗi.
- AdminSmoke:9 kiểm cũ và28 kiểm tiền mặt dưới vi-VN/en-US đều đạt. Build cuối0 lỗi/0 cảnh báo tại bin/AdminCash. Output .NET trong công cụ, không có tệp log giả.
- Hồi quy SQL01 bán/thu/phát vé/soát/hoàn và retry, SQL02 nghiệp vụ từ chối (gồm quá hạn), SQL04 quyền/ghế, SQL05 phạm vi, SQL06 soát đúng suất/phòng đều đạt. Không chạy lại các test lịch/giá không liên quan vì không sửa core đó.
- GUI sau người dùng đăng nhập: chọnA2 giá80000, giữ đơn298, nhập79000 hiện thiếu1000 và bị chặn;100.000 hiện thừa20000; chọn chuyển khoản rồi về tiền mặt xóa tiền đã nhập. Xác nhận ghi thu thành công; bấm lại bị chặn. DB xác nhận tổng 80000, thu80000, một thu/một vé dù khách đưa100000.
- GUI tra cứu57 đơn: trang1 có50 dòng/khóa Trước, trang2 có7 dòng/khóa Sau; đổi từ khóa về trang1. Tìm mã298/mã thu/GUID vé ra đúng đơn, mở chi tiết được; mã không có trả rỗng và khóa hai nút. Xem bố cục thường1172×850 và tra cứu phóng to1536×816, không khẳng định mọi DPI.
- Dọn đúng fixture GUI bằng ID và nhãn ngẫu nhiên TEST_CASH_A3AAAA1FF262424B, giữ tài khoản/dữ liệu người dùng. Các fixture SQL rollback. Không lưu ảnhPNG; đã xem ảnh trực tiếp qua công cụ.

Log SQL thật: evidence/2026-10-28/session-04. Chưa thử mất mạng/thử lại bằng GUI, xác nhận chuyển khoản thành công hoặc nút giỏ mới sau thanh toán trong phiên này; đường reset đã rà source, SQL kiểm retry/hết hạn đã đạt. Không tuyên bố đã chạy mọi tổ hợp GUI.

## Áp dụng và còn lại

Database đã có23/25/26: chạy Database/Scripts/27_Admin_ThuTien_TraCuuDon.sql trên đúng database rồi chạy Admin mới. Đổi USE cho Test; không cần seed/SQL 24/schema mới. Test local đã cập nhật, database chính/máy nhóm chưa tự nâng cấp.

T04, ADM-18 và ADM-20 DONE theo phạm vi trên. T05 tìm kiếm khác, T06 báo cáo, T07 thể loại còn mở; demo/tài liệu Word ở T08/T09. Bước tiếp theo ưu tiên T05, chưa tự triển khai trong phiên này. Chưa commit/push, cần lệnh riêng của người dùng.
