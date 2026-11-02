# Giá vé & F&B

## Giá vé

Mỗi quy tắc gồm loại ghế, định dạng phòng, loại ngày, khoảng áp dụng và đơn giá.
Ngày thường là thứ Hai–thứ Năm, cuối tuần là thứ Sáu–Chủ nhật.
Tính theo ngày bắt đầu suất chiếu, không phải ngày khách mua.
Ngày đầu/cuối đều nằm trong khoảng; bỏ ngày kết thúc để áp dụng không thời hạn.
Chưa có lịch ngày lễ hoặc phụ thu khung giờ trong module này.
Giá tính trên mỗi mã ghế trong dbo.Ghe; không tự nhân đôi theo tên Sweetbox.

Thêm giá: chọn loại ghế, định dạng đúng tên phòng, loại ngày, ngày bắt đầu/kết thúc và giá.
Sửa giá / bật tắt: chọn dòng rồi sửa; bỏ Đang áp dụng để ngừng.
Không xóa vật lý bản giá. Server chặn giá đang bật có khoảng giao nhau cùng loại ghế/định dạng/loại ngày.
Hai khoảng kết thúc 31/10 và bắt đầu 01/11 không chồng nhau.
Giá đã hết ngày áp dụng có thể vẫn mang cờ Đang bật, nhưng tra giá sẽ không chọn ngoài khoảng.
Nếu không có giá, tra giá trả thông báo thiếu cấu hình; không dùng giá mặc định giả.

Khi cần đổi giá cho tương lai, kết thúc dòng cũ ở ngày trước ngày mới, sau đó thêm dòng mới.
Không sửa lịch sử giá để mô phỏng hóa đơn: bước bán vé sau này phải lưu snapshot đơn giá trong chi tiết đơn.
Module hiện chưa có bảng bán vé/chi tiết đơn, nên chưa có cơ chế snapshot đơn giá bán.

## Sản phẩm và combo

Mã hàng duy nhất: A–Z, số, _ hoặc -. Tên, nhóm, quy cách, đơn giá và Bật bán.
Mỗi kích cỡ là một mã hàng riêng nếu cần bán/tính giá riêng.
Ngừng bán bằng cách bỏ Bật bán, không xóa sản phẩm.
Giá phải lớn hơn 0 và không quá 1 tỷ đồng, đơn vị đồng, không có phần thập phân.

Combo có giá bán riêng và danh sách món lẻ/số lượng. Không lồng combo, không tự tham chiếu.
Thêm cùng món lần nữa sẽ tăng số lượng, tối đa 99 cho mỗi thành phần.
Muốn đổi số lượng, bỏ dòng và thêm lại với số lượng mới.
Không biến món đang là thành phần combo thành một combo lồng.
Nếu món thành phần ngừng bán, combo liên quan hiển thị Chặn do thành phần, Có thể bán=false.
Cờ Bật bán của combo vẫn giữ nguyên để sau khi bật lại món, khả năng bán phục hồi.
Không bật/lưu combo đang bán nếu có thành phần ngừng bán; có thể tắt combo và sửa thành phần.
Không có quản lý tồn kho, nhập/xuất kho hoặc định lượng nguyên liệu trong module này.

## Tìm kiếm và CSV

Lọc giá theo loại ghế, cờ bật và từ khóa; lọc sản phẩm theo nhóm, cờ bán, mã/tên.
Bộ lọc F&B theo Trạng thái cấu hình đọc cờ Bật bán, không phải cờ Có thể bán của combo.
CSV lấy đúng danh sách đang hiển thị, UTF-8 BOM, dùng bộ xuất đã kiểm tra ở module lịch chiếu.
Các cột PhienBan và khóa nội bộ được ẩn.

## Đồng thời và tính toàn vẹn

Thao tác lưu dùng ADO.NET, truy vấn có tham số, transaction và khóa ứng dụng.
Giá dùng YMC_GiaVe_Write, sản phẩm dùng YMC_Fnb_Write.
Phiên bản rowversion chặn ghi đè nếu bản ghi đã đổi từ lúc mở form.
Thông báo xung đột yêu cầu đóng form, Làm mới rồi mở lại.
Các quy tắc chống chồng/lồng combo nằm trong thủ tục lưu. Ghi trực tiếp ngoài thủ tục có thể bỏ qua chúng.

sp_YMC_TraGiaTheoSuatGhe là điểm chuẩn bị cho POS: kiểm tra suất mở bán, ghế thuộc đúng phòng,
ghế/rạp/phòng hoạt động và trả MaGiaVe/DonGia cho ngày chiếu.
Thủ tục này chỉ tra giá, không giữ ghế, không tạo đơn hoặc bảo đảm giá trong giao dịch mua.
Khi viết POS cần tra giá lại và lưu snapshot trong cùng transaction đặt vé.

## Các ca cần thử trên Windows

1. Chạy script 09, tab trống nếu chưa thêm mẫu là bình thường.
2. Thêm/sửa giá, đóng mở lại Admin: giá vẫn có.
3. Tạo giá chồng đang bật: bị từ chối; giá tắt có thể chồng, bật lại phải bị kiểm tra.
4. Tra thứ Sáu và thứ Hai, kiểm tra biên ngày cuối và trường hợp chưa có giá.
5. Thêm món, thử trùng mã hàng, thử ngừng/bật lại bán.
6. Thêm combo 1 bắp + 2 nước, giá combo riêng; kiểm tra số lượng/thành phần lưu lại.
7. Tắt một thành phần: combo bị chặn; bật lại: có thể bán trở lại.
8. Đổi món đang là thành phần thành combo: bị chặn.
9. Lọc rồi xuất CSV, kiểm tra tiếng Việt/cột/số dòng.
10. Kiểm tra giao diện 1366×768, Scale 125%/150%.

Log mới: %LOCALAPPDATA%/YeuMinhEmCinema/Logs/gia-ve-fnb.log.
