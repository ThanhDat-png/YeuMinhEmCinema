# T06 — các nội dung cần chỉnh trong báo cáo Word

Đây là checklist nội dung, chưa sửa C#_Nhóm1.docx. Áp dụng cho phần Admin, không tự đánh đạt phần Web.

- Mục4.1.1/5.4.2: mô tả mở rộng module thống kê hiện có, bộ lọc rạp/phim/ngày và bảng từng suất; không mô tả một module viết lại.
- Ghi rõ hai cơ sở ngày: Thu/hoàn và F&B theo ngày giao dịch Việt Nam (UTC+7); Hiệu quả phim/Từng suất theo ngày bắt đầu suất. Không dùng ngày tạo đơn thay ngày thu, không so sánh hai khoảng khác cơ sở như cùng một phép tính.
- Thu vé trước hoàn từ ChiTietVe.DonGia đã chốt; thu F&B trước hoàn từ ChiTietDonFnb.SoLuong×DonGia đã chốt, không tính lại bảng giá/menu. Tổng thu từ ThanhToan.SoTien, hoàn từ HoanTien.SoTien, thuần=thu−hoàn. Khoản hoàn toàn đơn gồm vé/F&B, không chia hoàn vé/F&B nếu schema không lưu phân bổ. Thuần không phải lợi nhuận sau chi phí.
- Mô tả cộng riêng vé/F&B theo đơn trước join giao dịch để tránh nhân dòng; đơn chưa trả không có doanh thu. Giá danh mục đổi sau bán không đổi số đã chốt.
- Giữ nghĩa Hiệu quả phim cũ: chỉ đơn hiện DA_THANH_TOAN, loại đơn đã hoàn và suất hủy; tỷ lệ dùng sức chứa hiện tại. F&B cũ cũng loại đơn đã hoàn dù hoàn sau kỳ xem. Sổ Thu/hoàn mới giữ khoản thu cũ và ghi hoàn đúng ngày hoàn; ngày chỉ hoàn có thể âm.
- Từng suất là lũy kế giao dịch hiện tại của tập suất theo ngày chiếu, gồm suất hủy để không mất lịch sử. Không tuyên bố là snapshot đóng sổ theo thời điểm. Phim/phòng hiển thị theo danh mục hiện tại; tiền dùng snapshot.
- Mục4.5/6.2: BAO_CAO_XEM và phạm vi rạp được kiểm trong cả sáu procedure, không chỉ UI. Bổ sung ca gọi trực tiếp ngoài rạp/thiếu quyền, thu hồi rạp và khóa tài khoản.
- Mục6.1/6.2: ghi môi trường Windows/.NET10/ADO.NET/SQL Server;32 ca SQL09, hồi quy01/02/07 và AdminSmoke, kết quả GUI đã chạy, phạm vi Test. Ảnh GUI đã xem trong công cụ nhưng chưa lưu PNG vào tài liệu; cần chụp ảnh dùng cho Word khi làm T09, không gắn ảnh giả.
- Số mẫu minh họa: thu vé320000, F&B140000, tổng460000, hoàn230000, thuần230000. Ngày thu25–26/10/2026, ngày hoàn27/10, ngày chiếu07/11. Từng suất: phim A thu340000/hoàn230000/thuần110000; phim B thu120000. Legacy phim160000 tiền vé chưa hoàn, legacy F&B70000. Đây là fixture Test đã dọn, không phải doanh thu thật.
- Các điểm tài liệu cũ còn cần đồng bộ ở T09: .NET10/ADO/SQL thay mô tả EF/API không khớp sản phẩm; giữ khung giữ ghế/soát vé đã chốt; mô tả F&B/ghi nhận hoàn theo chức năng thực tế. Không ép thay kiến trúc hệ thống để khớp bản báo cáo cũ.
