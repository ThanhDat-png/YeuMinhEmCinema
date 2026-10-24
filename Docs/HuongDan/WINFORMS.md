# Sử dụng Admin

## Đăng nhập và quyền

Dùng tài khoản đã tạo trong database chính. Nếu database trống, form cho khởi tạo Admin đầu tiên. Mật khẩu tối thiểu 12 ký tự, không tự bỏ khoảng trắng. PasswordHasher của Identity tạo hash và salt; SQL không lưu mật khẩu gốc.

Các nút Đăng xuất / Đổi mật khẩu / Cập nhật quyền ở cuối cửa sổ chính. Đăng xuất mở lại form đăng nhập. Sai 5 lần khóa tạm 15 phút theo SQL. Khóa tạm không tự bật tài khoản bị vô hiệu hóa.

Menu dựa trên quyền lúc đăng nhập và làm mới khi điều hướng; thao tác ghi vẫn kiểm quyền SQL hiện tại. Các màn hình cũ gộp xem/sửa (rạp, lịch, giá/menu, nhân sự) yêu cầu đủ quyền để mở. Người chỉ có quyền xem phim có thể xem/tìm nhưng không thêm/sửa/ngừng chiếu. Bộ quyền dùng chung của vai trò ảnh hưởng mọi người mang vai trò đó.

Admin có phạm vi toàn rạp. Nhân viên khác chỉ được phân công các rạp của mình cho lịch, bán vé, đơn, báo cáo và soát vé. Thông tin khách mà nhân viên xem được gắn với đơn trong rạp được phân công; Admin xem toàn bộ. Tài khoản SQL kết nối trực tiếp vẫn là môi trường đồ án tin cậy, không phải cơ chế chống người có quyền dbo tự sửa database.

## Rạp/phòng/ghế và phim

Dùng các form hiện có. Tạo sơ đồ tối đa 26 hàng × 50 ghế; chạy lại cùng phạm vi bỏ qua ghế đã tồn tại. Thay loại/trạng thái ghế theo lô là một transaction, có một ghế đang giữ/đã bán chưa kết thúc sẽ từ chối cả lô. Không xóa ghế/lịch sử.

Danh mục có lịch tương lai hoặc đơn/vé đang hiệu lực sẽ chặn thay đổi quan trọng. Không đổi ID để vượt kiểm tra. Định dạng phòng phải khớp chuỗi định dạng trong bảng giá. Các trạng thái rạp/phòng mới dùng Đang hoạt động / Ngừng hoạt động.

## Lịch và giá vé

Lịch mới dùng stored procedure kiểm quyền/rạp. Sao chép chọn một rạp, có thể chọn tất cả phòng của rạp đó. Xem trước bắt buộc; thay nguồn/đích phải xem trước lại.

Giá theo ngày CHIẾU, loại ghế, định dạng; Thứ Hai–Thứ Năm thường, Thứ Sáu–Chủ nhật cuối tuần. Chưa tính ngày lễ/khung giờ. Mỗi MaGhe là một giá, Sweetbox chưa tự nhân đôi. Không có giá duy nhất thì không cho chọn/bán ghế.

## Bán vé tại quầy

1. Chọn rạp, ngày → Tải suất. Chọn suất → Tải ghế / menu.
2. Ghế trắng còn trống và có giá; xanh đang chọn; xám đã giữ/bán/hỏng/thiếu giá. Tooltip giải thích từng ghế. Tối đa 8 ghế.
3. Nhập số lượng bắp nước 0–99 trong cột cuối, tên liên hệ bắt buộc, điện thoại tùy chọn.
4. Bấm **1. Giữ ghế / thử lại**. SQL chốt giá, tạo một đơn cùng suất và giữ tối đa 10 phút (không vượt giờ chiếu). Giỏ bị khóa để tránh đổi nội dung cùng mã yêu cầu.
5. Thu tiền thực tế. Chọn tiền mặt hoặc chuyển khoản đã đối soát, điền mã chứng từ (tiền mặt có thể tự sinh mã biên nhận), bấm **2. Xác nhận đã thu tiền** và xác nhận số tiền.
6. Bấm xuất vé/phiếu QR: lưu HTML tự chứa QR, mở trình duyệt rồi In/lưu PDF. Phiếu chờ thanh toán không có vé có hiệu lực.
7. Hủy giữ / đơn mới sẽ tra mã yêu cầu cũ trước khi hủy đơn chưa trả; không hủy đơn đã thanh toán. Tài khoản bán vé được hủy đơn quầy do chính mình tạo.

Nếu tạo đơn hoặc thu tiền bị timeout, không đổi mã/giao dịch rồi bấm tạo mới. Giữ nguyên màn hình, dùng lại nút thử lại để SQL trả kết quả cũ. Khi mất kết nối chưa xác định được đơn, kiểm tra mục Đơn hàng. Các đơn chưa trả sẽ hết hạn; đóng app/chuyển màn hình không xóa giao dịch. Đồng hồ đếm ngược chỉ hiển thị theo đồng hồ máy; SQL quyết định hạn thực tế.

Giá được snapshot lúc giữ và giữ nguyên trong hạn. Bảng giá/menu thay đổi sau đó không sửa đơn cũ. Không có tồn kho trong phiên bản này. Không hỗ trợ đơn chỉ mua bắp nước hoặc đơn nhiều suất.

## Đơn và hoàn

Lọc rạp/ngày tạo đơn/trạng thái, 50 đơn/trang. Chi tiết có đơn, vé, bắp nước, thu, hoàn, thành phần combo đã chụp. Xuất QR từ dữ liệu SQL.

Hủy trực tiếp đơn chưa trả. Hoàn toàn bộ đơn đã trả trước giờ chiếu và chưa dùng vé nào; người có HOAN_TIEN phải nhập mã giao dịch hoàn, lý do, tích đã hoàn tiền thực tế. SQL không tự hoàn ngân hàng. Hoàn gồm bắp nước và vé; chưa có hoàn một phần/chính sách phí.

Một giao dịch thu thành công/đơn và một giao dịch hoàn toàn bộ/đơn. Retry cùng mã không nhân đôi vé/tiền. Không có tích hợp callback cổng thanh toán thật; tiền đến sau hạn cần đối soát ngoài luồng.

## Kiểm vé

QR chứa GUID MaVe. Máy quét USB kiểu bàn phím có thể điền vào ô rồi Enter để tra; cũng có thể dán GUID. Không tích hợp camera đọc QR trực tiếp trong WinForms. Sau khi tra, bấm Xác nhận vào rạp. Chỉ từ 30 phút trước giờ chiếu đến trước giờ kết thúc; kiểm lần hai bị chặn. Tra thông tin không tự đánh dấu đã sử dụng.

## Khách hàng / nhân viên

Khách tại quầy có hồ sơ không tài khoản. Ngừng hồ sơ khách và khóa tài khoản là hai trạng thái riêng. Chưa có CRM điểm thưởng, khuyến mãi hay gửi SMS/email.

Nhân viên mới có một vai trò khởi đầu và một rạp. Có thể gán thêm/thu hồi rạp và vai trò sau đó. Admin không bắt buộc có hồ sơ nhân viên nên một số nút sửa hồ sơ không áp dụng cho tài khoản Admin. Không chỉnh/khóa ADMIN bằng màn hình quản trị tài khoản này; ADMIN tự đổi mật khẩu hiện tại. Không tạo Admin thứ hai qua đăng ký.

Quyền theo vai trò được thay cả bộ trong transaction, không sửa bộ ADMIN. Người dùng đang mở app cần Cập nhật quyền/đăng nhập lại để thấy menu mới; SQL vẫn kiểm quyền khi ghi. Gán vai trò nhân viên đòi hồ sơ nhân sự đang làm việc; gán khách đòi hồ sơ khách. Có thể đặt lại mật khẩu nhân viên/khách từ tài khoản có quyền quản lý tài khoản.

## Báo cáo

Thu/hoàn/thuần theo ngày giao dịch Việt Nam, có thể âm khi ngày đó hoàn nhiều hơn thu. Hiệu quả phim theo ngày chiếu, doanh số bắp nước theo ngày thu của đơn chưa hoàn. Tỷ lệ lấp đầy dùng số ghế hoạt động hiện tại, chưa snapshot sức chứa cả phòng cho lịch sử. Tổng quan dùng chung dữ liệu báo cáo, không bịa KPI khi không có đơn.

Giao dịch lưu UTC; nhãn ngày giờ *_Utc trong bảng và file chi tiết thể hiện UTC. Suất chiếu lưu giờ Việt Nam. CSV UTF-8 BOM hỗ trợ Excel, chặn ô bắt đầu bằng dấu công thức.

Các truy vấn Admin dùng SQL cục bộ đồng bộ và có timeout; database chậm có thể làm chờ giao diện. Bản này dành cho đồ án/quy mô cục bộ; chưa kiểm thử tải hay cân bằng nhiều máy quầy. Web backend/cổng thanh toán production không thuộc bản cập nhật WinForms này.
