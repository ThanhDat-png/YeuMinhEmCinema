# Kế hoạch phiên 4 — tiền khách đưa và tra cứu giao dịch

Trạng thái: CHỜ LỆNH TRIỂN KHAI. Ngày chuẩn bị: 28/10/2026.
Phạm vi T04 (ADM-18, ADM-20), chưa sửa code tính năng trong bước chuẩn bị này.

## Đối chiếu trước khi triển khai

Đọc lại bản đúng C#_Nhóm1.docx trong C_SHARP, đối chiếu 5.4.2 và 6.2.3 ca 5 cho tiền khách đưa; 4.1.1, 4.3.2, 5.4.2 cho tra cứu đơn. Kiểm tra hash nguồn theo THEO-DOI.json. Giữ .NET10, WinForms, ADO.NET và SQL hiện tại.

## 1. Tiền khách đưa và tiền thừa

- Rà UcBanVeTaiQuay.cs và GiaoDichDAL.cs trước khi sửa.
- Thêm ô tiền khách đưa cho thanh toán tiền mặt; hiển thị tổng đơn và tiền thừa, chặn số tiền không hợp lệ hoặc thiếu.
- Khi đổi đơn/giỏ hoặc phương thức thanh toán, cập nhật hoặc xóa giá trị để tránh dùng tiền của đơn trước.
- ThanhToan.SoTien vẫn là tổng đơn, không phải tiền khách đưa. Không đổi schema tài chính hoặc luồng Web.
- Kiểm tiền thiếu, vừa đủ, có tiền thừa, nhập sai; đơn hết hạn, bấm lại và phương thức chuyển khoản giữ hành vi phù hợp.

## 2. Tra cứu đơn và giao dịch

- Rà UcDonDatVe.cs, GiaoDichDAL.cs và truy vấn SQL19.
- Bổ sung tìm trực tiếp theo mã đơn, mã giao dịch thu hoặc GUID vé; nhãn hướng dẫn rõ loại mã hỗ trợ.
- Truy vấn luôn kiểm quyền/phạm vi rạp; mã ngoài phạm vi không trả dữ liệu. Giữ tương thích caller cũ nếu mở rộng procedure.
- Xác định tổng số dòng/trang; khóa Trước/Sau ở biên và đưa về trang đầu khi đổi bộ lọc/từ khóa. Phân trang có thứ tự ổn định.
- Kiểm tìm đúng/không có/ngoài phạm vi, bộ lọc kết hợp, trang rỗng/đầu/cuối và chi tiết đơn.

## Nghiệm thu và bàn giao

- Chỉ nâng cấp/ghi dữ liệu thử trên database Test; fixture rollback hoặc dọn đúng nhãn/ID.
- Build, chạy hồi quy liên quan bán/thanh toán/soát/hoàn và quyền theo rạp; kiểm GUI thực tế.
- Nếu sửa SQL: có migration riêng và đồng bộ bộ cài mới, kèm ca hồi quy.
- Cập nhật THEO-DOI.json, nhật ký và kết quả phiên: đã làm/còn thiếu/khác báo cáo; không đánh đạt phần chưa thử.
- Chưa làm T05 tìm kiếm khác, T06 báo cáo hoặc T07 thể loại trong phạm vi T04 này.
- Sau kiểm thử chờ lệnh riêng mới commit/push. Hiện tại chỉ chuẩn bị kế hoạch và chờ lệnh triển khai.
