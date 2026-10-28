# Kế hoạch phiên 6 — báo cáo theo phim và suất

Trạng thái: CHỜ NGƯỜI DÙNG DUYỆT, chưa triển khai T06.
Phạm vi: T06, ADM-25 và ADM-26. Chuẩn bị ngày 28/10/2026.

1. Đọc lại báo cáo đúng (4.1.1, 5.4.2), rà UcBaoCaoThongKe.cs và SQL18; chốt ý nghĩa từng số liệu trước sửa.
2. Bổ sung bộ lọc phim và bảng chi tiết từng suất: phim, rạp/phòng, giờ chiếu, số vé và doanh thu vé theo giá đã chốt.
3. Phân biệt ngày giao dịch thu/hoàn với ngày chiếu; tách doanh thu vé khỏi tổng thu gồm F&B; ghi nhãn và cách xử lý hoàn rõ ràng. Giữ nguyên ý nghĩa báo cáo hiện có.
4. Dùng truy vấn chỉ đọc, kiểm quyền BAO_CAO_XEM và phạm vi rạp. Nếu bổ sung SQL: migration riêng, bộ cài đồng bộ và giữ tương thích lời gọi cũ. Không đổi schema giao dịch, Web hoặc .NET10.
5. Kiểm số liệu bằng fixture Test: nhiều vé/F&B tránh nhân dòng join, giá đã thay đổi, hoàn tiền, ngày thu khác ngày chiếu, bộ lọc phim/suất và ngoài phạm vi. Build và kiểm GUI thực tế.
6. Cập nhật nhật ký, đối chiếu báo cáo và kết quả đã làm/còn thiếu. Chỉ commit/push khi có lệnh mới của người dùng.

Chưa làm thể loại T07 hoặc sửa toàn bộ Word trong T06. Các con số chưa thống nhất sẽ được ghi rõ và chốt trước khi triển khai phần phụ thuộc.
