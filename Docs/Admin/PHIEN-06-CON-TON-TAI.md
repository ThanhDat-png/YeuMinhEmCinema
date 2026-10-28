# Tồn tại sau phiên T06

Trạng thái chụp ngày 28/10/2026 từ THEO-DOI.json. OPEN/PARTIAL nghĩa là còn cần xử lý hoặc nghiệm thu, không đồng nghĩa tất cả chưa có code. Không tự triển khai các mục dưới đây trong T06.

Các giới hạn riêng T06: chưa thử GUI bằng mọi vai trò (SQL đã kiểm phân quyền trực tiếp), chưa thử hộp lưu CSV/benchmark dữ liệu lớn hoặc báo cáo đồng thời giao dịch đang chạy. CSV dùng cơ chế cũ; biểu đồ phim/suất/F&B chỉ tối đa 15 mục đầu. Không hỗ trợ phân bổ hoàn từng dòng, chưa snapshot tên/sức chứa lịch sử. Các giới hạn này không được đánh là đã kiểm hoặc tự thêm schema ngoài phạm vi.

## Những công việc còn mở

- T07 — Thể loại và phần mô tả còn thiếu (P2, OPEN). Ước lượng thay đổi schema additive sau P1; chỉ thực hiện nếu không làm Web đổi. Nếu chưa làm ghi thiếu rõ ràng.
- T08 — Bộ demo và nghiệm thu Admin (P1, OPEN). Dữ liệu Test riêng; chạy đủ bán-soát-hoàn; thử vai trò; ghi đạt/không đạt/chưa thử, không suy diễn từ build.
- T09 — Đồng bộ phần Admin trong báo cáo và nhật ký (P1, OPEN). Mô tả đúng .NET10/ADO/SQL, schema/lớp thật, khung giờ và F&B; ghi nguồn bằng chứng, phần đóng góp và các giới hạn còn lại.

## Các yêu cầu còn OPEN/PARTIAL

- ADM-01 — Đăng nhập và mật khẩu (P1, OPEN). Điều kiện nghiệm thu: Đúng/sai/khóa tài khoản cho kết quả đúng; không lộ hash; không đổi mật khẩu người dùng để làm test.
- ADM-02 — Quyền menu và quyền thao tác (P1, OPEN). Điều kiện nghiệm thu: Tách xem/sửa hợp lý; người chỉ xem tra cứu được nhưng không ghi được; ghi vẫn kiểm quyền hiện tại ở SQL.
- ADM-05 — Vai trò và phân công nhân viên (P1, OPEN). Điều kiện nghiệm thu: Có ma trận quyền thực tế; thử thu hồi khi đang mở form. Không cấp thêm quyền toàn cục cho quản lý chỉ để khớp báo cáo.
- ADM-06 — Quản lý phim (P1, OPEN). Điều kiện nghiệm thu: CRUD/trạng thái, dữ liệu sai và phim có lịch tương lai được kiểm; dữ liệu liên quan không mất; Web vẫn đọc được hợp đồng hiện tại.
- ADM-07 — Thể loại phim (P2, OPEN). Điều kiện nghiệm thu: Nếu bổ sung: migration cộng thêm, không đổi cột/hợp đồng cũ và không bắt Web sửa theo. Nếu chưa làm trong ngày: ghi rõ chưa có, không đánh dấu đạt và bỏ khẳng định đã triển khai trong báo cáo.
- ADM-08 — Rạp và phòng chiếu (P1, OPEN). Điều kiện nghiệm thu: Tên trùng, dữ liệu sai, phòng chưa có ghế và phòng có lịch được xử lý đúng; không đổi schema chỉ để thêm tên trạng thái trong sơ đồ.
- ADM-10 — Sơ đồ ghế (P1, OPEN). Điều kiện nghiệm thu: Không tạo trùng; ghế hỏng không bán; có ghế bị bảo vệ thì cả lô bị từ chối; không làm sai thông tin vé cũ.
- ADM-11 — Tạo và sửa suất chiếu (P1, OPEN). Điều kiện nghiệm thu: Thời lượng/kết thúc/dọn phòng hợp lệ; chỉ phim/phòng đủ điều kiện; đúng phạm vi rạp.
- ADM-12 — Chống trùng lịch và bảo vệ lịch có đơn (P1, OPEN). Điều kiện nghiệm thu: Thử biên dọn phòng, qua đêm, sửa chính nó; đơn đang giữ/đã trả chặn đổi/hủy; ngừng bán vẫn chiếm phòng.
- ADM-13 — Sao chép lịch và xuất lịch (P2, OPEN). Điều kiện nghiệm thu: Nguồn/đích đổi phải xem trước lại; một suất lỗi không ghi dở nhóm; CSV đúng danh sách đang xem.
- ADM-14 — Giá vé và chốt giá giao dịch (P1, OPEN). Điều kiện nghiệm thu: Giá chồng bị chặn; thay bảng giá không đổi đơn đã chốt; không tự thêm mô hình giá riêng từng rạp hoặc ngày lễ hôm nay.
- ADM-15 — F&B và combo (P2, OPEN). Điều kiện nghiệm thu: Chuyển danh mục/giá/combo vào kết quả đã có sau khi kiểm GUI; giữ giới hạn chưa có tồn kho; không lấy yêu cầu kho từ bản báo cáo gửi nhầm.
- ADM-17 — Giữ ghế và hết hạn (P1, OPEN). Điều kiện nghiệm thu: Giữ hành vi SQL hiện có; mô tả đúng hết hạn theo server, retry cùng mã và tranh ghế; kiểm GUI không thu được đơn hết hạn.
- ADM-19 — Ghi nhận thu và phát hành vé (P1, OPEN). Điều kiện nghiệm thu: Retry không tạo trùng ThanhToan/Ve; lỗi không báo thành công; chỉ ghi nhận thu sau khi người thao tác xác nhận.
- ADM-21 — Hủy và hoàn đơn (P1, OPEN). Điều kiện nghiệm thu: Chặn hoàn đơn đã dùng vé/không đủ điều kiện; không hoàn hai lần; hủy giải phóng ghế; GUI thể hiện đúng trạng thái.
- ADM-22 — Xuất và in vé QR (P1, OPEN). Điều kiện nghiệm thu: QR giải mã đúng GUID; chỉ có vé sau thanh toán; in lại không tạo giao dịch; thử tên có ký tự HTML; mô tả đúng phương thức in.
- ADM-23 — Kiểm tra vé và chống dùng lặp (P1, PARTIAL). Điều kiện nghiệm thu: Giữ khung thời gian SQL hiện tại; chỉnh báo cáo mốc +15 phút; thử vé đã dùng/hủy/chưa trả, đúng phạm vi; không thêm camera hôm nay.
- ADM-27 — Khách hàng trong Admin (P2, OPEN). Điều kiện nghiệm thu: Kiểm phạm vi khách gắn với đơn trong rạp, phiên bản dữ liệu và lịch sử; không sửa đăng ký/đăng nhập Web.
- ADM-28 — Bố cục và nhãn giao diện (P1, PARTIAL). Điều kiện nghiệm thu: Không che nội dung/nút ở cửa sổ thực tế; thử 1366x768 và DPI phổ biến nếu môi trường cho phép; nhãn tiếng Việt và ngày giờ rõ ràng.
- ADM-29 — Tải lại dữ liệu và lỗi kết nối (P2, OPEN). Điều kiện nghiệm thu: Lỗi không làm mất giỏ hoặc báo thành công giả; phục hồi/kết nối lại được; chỉ chuyển async chỗ thật sự gây chờ, không viết lại toàn app.
- ADM-30 — CSV và lịch sử dữ liệu (P2, OPEN). Điều kiện nghiệm thu: Xuất đúng tập dữ liệu, tiếng Việt đọc được; giữ nguyên lịch sử đơn/vé; không lộ hash và cột concurrency trong giao diện.
- ADM-31 — Bộ dữ liệu và demo Admin xuyên suốt (P1, OPEN). Điều kiện nghiệm thu: Script Test riêng, chạy lại được, không reset database khác; có lịch/giá/ghế/F&B, ca bán-soát-hoàn và nhật ký kết quả.
- ADM-32 — Minh chứng, thiết kế dữ liệu và phần đóng góp (P1, OPEN). Điều kiện nghiệm thu: Lập bản đồ bảng/khóa/lớp thật, phân biệt SQL test với GUI test; cập nhật phần Admin và đóng góp thực tế; phần Web giao người phụ trách xác nhận.

T07 đặc biệt chờ yêu cầu riêng; không tự bắt đầu. T08/T09 cũng chưa thực hiện trong T06. Chưa commit/push phiên 6.
