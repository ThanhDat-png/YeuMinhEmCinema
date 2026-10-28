# Sử dụng Admin

## Đăng nhập và quyền

Dùng tài khoản đã tạo trong database chính. Nếu database trống, form cho khởi tạo Admin đầu tiên. Mật khẩu tối thiểu 12 ký tự, không tự bỏ khoảng trắng. PasswordHasher của Identity tạo hash và salt; SQL không lưu mật khẩu gốc.

Các nút Đăng xuất / Đổi mật khẩu / Cập nhật quyền ở cuối cửa sổ chính. Đăng xuất mở lại form đăng nhập. Sai 5 lần khóa tạm 15 phút theo SQL. Khóa tạm không tự bật tài khoản bị vô hiệu hóa.

Menu dựa trên quyền lúc đăng nhập và làm mới khi điều hướng; thao tác ghi vẫn kiểm quyền SQL hiện tại. Các màn hình cũ gộp xem/sửa (rạp, lịch, giá/menu, nhân sự) yêu cầu đủ quyền để mở. Người chỉ có quyền xem phim có thể xem/tìm nhưng không thêm/sửa/ngừng chiếu. Bộ quyền dùng chung của vai trò ảnh hưởng mọi người mang vai trò đó.

Admin có phạm vi toàn rạp. Nhân viên khác chỉ được phân công các rạp của mình cho lịch, bán vé, đơn, báo cáo và soát vé. Thông tin khách mà nhân viên xem được gắn với đơn trong rạp được phân công; Admin xem toàn bộ. Tài khoản SQL kết nối trực tiếp vẫn là môi trường đồ án tin cậy, không phải cơ chế chống người có quyền dbo tự sửa database.

## Rạp/phòng/ghế và phim

SQL 28: người có RAP_XEM được mở Rạp/Phòng, nhập mã hoặc một phần tên phòng có dấu rồi bấm Tìm phòng/Enter; Xóa lọc để xem lại các rạp được phân công. Cây hiển thị mã phòng để phân biệt tên trùng. Không có RAP_QUAN_LY thì các nút thêm/sửa/ngừng/tạo ghế/đổi ghế và menu chuột phải bị khóa, kể cả sau khi chọn ghế. SQL vẫn chặn lời gọi ghi trái quyền.

Dùng các form hiện có. Tạo sơ đồ tối đa 26 hàng × 50 ghế; chạy lại cùng phạm vi bỏ qua ghế đã tồn tại. Thay loại/trạng thái ghế theo lô là một transaction, có một ghế đang giữ/đã bán chưa kết thúc sẽ từ chối cả lô. Không xóa ghế/lịch sử.

Danh mục có lịch tương lai hoặc đơn/vé đang hiệu lực sẽ chặn thay đổi quan trọng. Không đổi ID để vượt kiểm tra. Định dạng phòng phải khớp chuỗi định dạng trong bảng giá. Các trạng thái rạp/phòng mới dùng Đang hoạt động / Ngừng hoạt động.

## Lịch và giá vé

Lịch mới dùng stored procedure kiểm quyền/rạp. Sao chép chọn một rạp, có thể chọn tất cả phòng của rạp đó. Xem trước bắt buộc; thay nguồn/đích phải xem trước lại.

Giá theo ngày CHIẾU, loại ghế, định dạng; Thứ Hai–Thứ Năm thường, Thứ Sáu–Chủ nhật cuối tuần. Chưa tính ngày lễ/khung giờ. Mỗi MaGhe là một giá, Sweetbox chưa tự nhân đôi. Không có giá duy nhất thì không cho chọn/bán ghế.

## Bán vé tại quầy

1. Chọn rạp, ngày và tùy chọn tên phim → Tải suất / tìm phim (hoặc Enter). Chọn suất → Tải ghế / menu. Đổi tên phim/rạp/ngày hoặc suất sẽ xóa ghế/tổng tạm cũ, cần tải lại trước khi chọn; khi đã giữ đơn thì bộ lọc bị khóa. Xóa tên phim và tải lại để xem mọi suất được phép bán.
2. Ghế trắng còn trống và có giá; xanh đang chọn; xám đã giữ/bán/hỏng/thiếu giá. Tooltip giải thích từng ghế. Tối đa 8 ghế.
3. Nhập số lượng bắp nước 0–99 trong cột cuối, tên liên hệ bắt buộc, điện thoại tùy chọn.
4. Bấm **1. Giữ ghế / thử lại**. SQL chốt giá, tạo một đơn cùng suất và giữ tối đa 10 phút (không vượt giờ chiếu). Giỏ bị khóa để tránh đổi nội dung cùng mã yêu cầu.
5. Thu tiền thực tế. Với tiền mặt: sau giữ ghế nhập tiền khách đưa (100000 hoặc 100.000), kiểm tiền thừa; thiếu hoặc nhập sai thì không xác nhận được. Chuyển khoản cần mã đã đối soát; đổi phương thức sẽ xóa tiền mặt. Bấm **2. Xác nhận đã thu tiền** và đối chiếu tổng đơn/tiền khách đưa/tiền trả lại. Tiền mặt có thể tự sinh mã biên nhận. Chỉ tổng đơn được lưu vào ThanhToan, tiền khách đưa/thừa là hỗ trợ UI; đã trả thì khóa sửa phương thức/mã/tiền mặt. Giỏ mới xóa giá trị cũ.
6. Bấm xuất vé/phiếu QR: lưu HTML tự chứa QR, mở trình duyệt rồi In/lưu PDF. Phiếu chờ thanh toán không có vé có hiệu lực.
7. Hủy giữ / đơn mới sẽ tra mã yêu cầu cũ trước khi hủy đơn chưa trả; không hủy đơn đã thanh toán. Tài khoản bán vé được hủy đơn quầy do chính mình tạo.

Nếu tạo đơn hoặc thu tiền bị timeout, không đổi mã/giao dịch rồi bấm tạo mới. Giữ nguyên màn hình, dùng lại nút thử lại để SQL trả kết quả cũ. Khi mất kết nối chưa xác định được đơn, kiểm tra mục Đơn hàng. Các đơn chưa trả sẽ hết hạn; đóng app/chuyển màn hình không xóa giao dịch. Đồng hồ đếm ngược chỉ hiển thị theo đồng hồ máy; SQL quyết định hạn thực tế.

Giá được snapshot lúc giữ và giữ nguyên trong hạn. Bảng giá/menu thay đổi sau đó không sửa đơn cũ. Không có tồn kho trong phiên bản này. Không hỗ trợ đơn chỉ mua bắp nước hoặc đơn nhiều suất.

## Đơn và hoàn

Cần SQL 27 cho Admin mới. Lọc rạp/ngày tạo đơn/trạng thái,50 đơn/trang. Có tìm chính xác theo mã đơn, mã giao dịch thu hoặc GUID vé (SQL cũng nhận GUID tham chiếu đơn); nhấn Lọc / tìm hoặc Enter. Tìm mã vẫn kết hợp bộ lọc, nên kiểm lại ngày/rạp/trạng thái nếu không có kết quả. Hiển thị tổng số đơn/trang, khóa Trước/Sau ở biên; đổi bộ lọc/từ khóa xóa kết quả cũ và đặt về trang đầu. Chi tiết có đơn, vé, bắp nước, thu, hoàn, thành phần combo đã chụp. Xuất QR từ dữ liệu SQL.

Hủy trực tiếp đơn chưa trả. Hoàn toàn bộ đơn đã trả trước giờ chiếu và chưa dùng vé nào; người có HOAN_TIEN phải nhập mã giao dịch hoàn, lý do, tích đã hoàn tiền thực tế. SQL không tự hoàn ngân hàng. Hoàn gồm bắp nước và vé; chưa có hoàn một phần/chính sách phí.

Một giao dịch thu thành công/đơn và một giao dịch hoàn toàn bộ/đơn. Retry cùng mã không nhân đôi vé/tiền. Không có tích hợp callback cổng thanh toán thật; tiền đến sau hạn cần đối soát ngoài luồng.

## Kiểm vé

Cần SQL 26 trước khi chạy Admin mới. Chọn ngày, bấm Tải suất và chọn suất đang soát (hiển thị rạp, phòng, giờ, phim). Không tự chọn sẵn suất đầu tiên. Danh sách chỉ chứa suất thuộc phạm vi có quyền soát, bỏ suất hủy; gồm suất hôm trước còn chiếu sang ngày chọn. Chưa chọn suất thì không thể tra hoặc xác nhận.

QR chứa GUID MaVe. Máy quét USB kiểu bàn phím có thể điền vào ô rồi Enter để tra; cũng có thể dán GUID. Không tích hợp camera đọc QR trực tiếp. Tra cứu không tự đánh dấu sử dụng. Xác nhận hiển thị lại suất/phòng; SQL kiểm cả suất và phòng trước cập nhật. Chỉ cho vào từ 30 phút trước giờ chiếu đến trước giờ kết thúc; vé đã dùng, hủy, chưa thanh toán, sai ngữ cảnh hoặc ngoài phạm vi đều bị chặn theo nghiệp vụ.

Đổi suất/ngày, tải lại hoặc nhập mã mới sẽ xóa kết quả cũ để tránh nhầm vé. Khi thu hồi phân công/quyền trong lúc form mở, SQL kiểm lại lúc thao tác; bấm Tải suất để lấy danh sách mới. Caller cũ không truyền ngữ cảnh vẫn giữ tương thích; quy tắc bắt chọn suất áp dụng cho Admin mới.

## Khách hàng / nhân viên

SQL 28: tìm nhân viên theo tên đăng nhập/họ tên, mã nhân viên/mã tài khoản hoặc SĐT (cả một phần). Bấm Tìm/Enter. Mã nhân viên và mã tài khoản là hai cột khác nhau; một con số có thể khớp cả hai hồ sơ. Quyền quản trị nhân sự và menu nhân sự giữ như trước; phiên này chỉ nới menu Rạp/Phòng cho RAP_XEM.

Khách tại quầy có hồ sơ không tài khoản. Ngừng hồ sơ khách và khóa tài khoản là hai trạng thái riêng. Chưa có CRM điểm thưởng, khuyến mãi hay gửi SMS/email.

Nhân viên mới có một vai trò khởi đầu và một rạp. Có thể gán thêm/thu hồi rạp và vai trò sau đó. Admin không bắt buộc có hồ sơ nhân viên nên một số nút sửa hồ sơ không áp dụng cho tài khoản Admin. Không chỉnh/khóa ADMIN bằng màn hình quản trị tài khoản này; ADMIN tự đổi mật khẩu hiện tại. Không tạo Admin thứ hai qua đăng ký.

Quyền theo vai trò được thay cả bộ trong transaction, không sửa bộ ADMIN. Người dùng đang mở app cần Cập nhật quyền/đăng nhập lại để thấy menu mới; SQL vẫn kiểm quyền khi ghi. Gán vai trò nhân viên đòi hồ sơ nhân sự đang làm việc; gán khách đòi hồ sơ khách. Có thể đặt lại mật khẩu nhân viên/khách từ tài khoản có quyền quản lý tài khoản.

## Báo cáo

Thu/hoàn/thuần theo ngày giao dịch Việt Nam, có thể âm khi ngày đó hoàn nhiều hơn thu. Hiệu quả phim theo ngày chiếu, doanh số bắp nước theo ngày thu của đơn chưa hoàn. Tỷ lệ lấp đầy dùng số ghế hoạt động hiện tại, chưa snapshot sức chứa cả phòng cho lịch sử. Tổng quan dùng chung dữ liệu báo cáo, không bịa KPI khi không có đơn.

Giao dịch lưu UTC; nhãn ngày giờ *_Utc trong bảng và file chi tiết thể hiện UTC. Suất chiếu lưu giờ Việt Nam. CSV UTF-8 BOM hỗ trợ Excel, chặn ô bắt đầu bằng dấu công thức.

Các truy vấn Admin dùng SQL cục bộ đồng bộ và có timeout; database chậm có thể làm chờ giao diện. Bản này dành cho đồ án/quy mô cục bộ; chưa kiểm thử tải hay cân bằng nhiều máy quầy. Web backend/cổng thanh toán production không thuộc bản cập nhật WinForms này.
