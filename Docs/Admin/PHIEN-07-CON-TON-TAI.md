# Tồn tại sau T07

T07/ADM-07 hoàn tất theo phạm vi. T08 và T09 chưa bắt đầu; cần lệnh riêng. Không sửa Word trong T07.

## Giới hạn thể loại

- Web chưa hiển thị/lọc thể loại. Không đổi hợp đồng Web để khớp phần này của báo cáo; chỉ ghi rõ cho người phụ trách Web và checklist Word.
- Chưa GUI mọi vai trò, sửa/bỏ hết tập gán/sử dụng lại, DPI khác hoặc dữ liệu lớn. SQL test đã kiểm quyền và các nghiệp vụ nêu trong kết quả; không thay cho GUI.
- Không có rowversion hoặc nhật ký lịch sử đổi thể loại; hai người sửa cùng bản ghi dùng lần lưu cuối. Khóa ứng dụng/transaction bảo vệ tính hợp lệ tập gán và race với ngừng sử dụng.
- Không tự phân loại phim cũ hoặc seed thể loại mặc định; cần người quản lý nhập/gán theo dữ liệu phim thật khi triển khai.
- SQL30 mới áp dụng trên Test local; chưa áp dụng database thật/máy nhóm. Không tự chạy triển khai production.
- ADM-32 còn mở: tài liệu thiết kế/Word/ảnh minh chứng tổng và đóng góp thực tế xử lý T09.

## Công việc còn mở

- T08 — Bộ demo và nghiệm thu Admin: OPEN. Dữ liệu Test riêng; chạy đủ bán-soát-hoàn; thử vai trò; ghi đạt/không đạt/chưa thử, không suy diễn từ build.
- T09 — Đồng bộ phần Admin trong báo cáo và nhật ký: OPEN. Mô tả đúng .NET10/ADO/SQL, schema/lớp thật, khung giờ và F&B; ghi nguồn bằng chứng, phần đóng góp và các giới hạn còn lại.

## Yêu cầu còn OPEN/PARTIAL

- ADM-01 — Đăng nhập và mật khẩu: OPEN. Đúng/sai/khóa tài khoản cho kết quả đúng; không lộ hash; không đổi mật khẩu người dùng để làm test.
- ADM-02 — Quyền menu và quyền thao tác: OPEN. Tách xem/sửa hợp lý; người chỉ xem tra cứu được nhưng không ghi được; ghi vẫn kiểm quyền hiện tại ở SQL.
- ADM-05 — Vai trò và phân công nhân viên: OPEN. Có ma trận quyền thực tế; thử thu hồi khi đang mở form. Không cấp thêm quyền toàn cục cho quản lý chỉ để khớp báo cáo.
- ADM-06 — Quản lý phim: OPEN. CRUD/trạng thái, dữ liệu sai và phim có lịch tương lai được kiểm; dữ liệu liên quan không mất; Web vẫn đọc được hợp đồng hiện tại.
- ADM-08 — Rạp và phòng chiếu: OPEN. Tên trùng, dữ liệu sai, phòng chưa có ghế và phòng có lịch được xử lý đúng; không đổi schema chỉ để thêm tên trạng thái trong sơ đồ.
- ADM-10 — Sơ đồ ghế: OPEN. Không tạo trùng; ghế hỏng không bán; có ghế bị bảo vệ thì cả lô bị từ chối; không làm sai thông tin vé cũ.
- ADM-11 — Tạo và sửa suất chiếu: OPEN. Thời lượng/kết thúc/dọn phòng hợp lệ; chỉ phim/phòng đủ điều kiện; đúng phạm vi rạp.
- ADM-12 — Chống trùng lịch và bảo vệ lịch có đơn: OPEN. Thử biên dọn phòng, qua đêm, sửa chính nó; đơn đang giữ/đã trả chặn đổi/hủy; ngừng bán vẫn chiếm phòng.
- ADM-13 — Sao chép lịch và xuất lịch: OPEN. Nguồn/đích đổi phải xem trước lại; một suất lỗi không ghi dở nhóm; CSV đúng danh sách đang xem.
- ADM-14 — Giá vé và chốt giá giao dịch: OPEN. Giá chồng bị chặn; thay bảng giá không đổi đơn đã chốt; không tự thêm mô hình giá riêng từng rạp hoặc ngày lễ hôm nay.
- ADM-15 — F&B và combo: OPEN. Chuyển danh mục/giá/combo vào kết quả đã có sau khi kiểm GUI; giữ giới hạn chưa có tồn kho; không lấy yêu cầu kho từ bản báo cáo gửi nhầm.
- ADM-17 — Giữ ghế và hết hạn: OPEN. Giữ hành vi SQL hiện có; mô tả đúng hết hạn theo server, retry cùng mã và tranh ghế; kiểm GUI không thu được đơn hết hạn.
- ADM-19 — Ghi nhận thu và phát hành vé: OPEN. Retry không tạo trùng ThanhToan/Ve; lỗi không báo thành công; chỉ ghi nhận thu sau khi người thao tác xác nhận.
- ADM-21 — Hủy và hoàn đơn: OPEN. Chặn hoàn đơn đã dùng vé/không đủ điều kiện; không hoàn hai lần; hủy giải phóng ghế; GUI thể hiện đúng trạng thái.
- ADM-22 — Xuất và in vé QR: OPEN. QR giải mã đúng GUID; chỉ có vé sau thanh toán; in lại không tạo giao dịch; thử tên có ký tự HTML; mô tả đúng phương thức in.
- ADM-23 — Kiểm tra vé và chống dùng lặp: PARTIAL. Giữ khung thời gian SQL hiện tại; chỉnh báo cáo mốc +15 phút; thử vé đã dùng/hủy/chưa trả, đúng phạm vi; không thêm camera hôm nay.
- ADM-27 — Khách hàng trong Admin: OPEN. Kiểm phạm vi khách gắn với đơn trong rạp, phiên bản dữ liệu và lịch sử; không sửa đăng ký/đăng nhập Web.
- ADM-28 — Bố cục và nhãn giao diện: PARTIAL. Không che nội dung/nút ở cửa sổ thực tế; thử 1366x768 và DPI phổ biến nếu môi trường cho phép; nhãn tiếng Việt và ngày giờ rõ ràng.
- ADM-29 — Tải lại dữ liệu và lỗi kết nối: OPEN. Lỗi không làm mất giỏ hoặc báo thành công giả; phục hồi/kết nối lại được; chỉ chuyển async chỗ thật sự gây chờ, không viết lại toàn app.
- ADM-30 — CSV và lịch sử dữ liệu: OPEN. Xuất đúng tập dữ liệu, tiếng Việt đọc được; giữ nguyên lịch sử đơn/vé; không lộ hash và cột concurrency trong giao diện.
- ADM-31 — Bộ dữ liệu và demo Admin xuyên suốt: OPEN. Script Test riêng, chạy lại được, không reset database khác; có lịch/giá/ghế/F&B, ca bán-soát-hoàn và nhật ký kết quả.
- ADM-32 — Minh chứng, thiết kế dữ liệu và phần đóng góp: OPEN. Lập bản đồ bảng/khóa/lớp thật, phân biệt SQL test với GUI test; cập nhật phần Admin và đóng góp thực tế; phần Web giao người phụ trách xác nhận.
