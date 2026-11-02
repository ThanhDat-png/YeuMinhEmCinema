# Thêm/sửa suất chiếu có xem lịch phòng ngay trong cửa sổ

## Giao diện mới

Cửa sổ có hai phần:

- Trái: chọn phim, rạp, phòng, ngày giờ bắt đầu và số phút dọn phòng.
- Phải: lịch phòng của ngày đã chọn, gồm mã suất, phim, bắt đầu, kết thúc, dọn phòng, phòng sẵn sàng và trạng thái.

Khi chọn phòng, lịch tải tự động. Đổi ngày sẽ tải ngày mới; đổi giờ/phim/phút dọn phòng sẽ tính lại xung đột từ lịch đã tải. Không cần mở hộp thoại lịch riêng, nhưng vẫn có nút mở nếu muốn xem rộng hơn.

Nếu suất mới qua nửa đêm, bảng mở rộng đến hết khoảng chiếm phòng của suất mới để thể hiện suất xung đột ngày kế tiếp. Suất từ ngày trước còn chiếm phòng cũng được tính. Tiêu đề hiển thị ngày bắt đầu của khung đang xem.

## Cách đọc trạng thái

- Xanh: khung giờ mới không trùng các suất khác trong dữ liệu lịch đã tải.
- Hồng: trùng thời gian chiếu hoặc dọn phòng; các dòng liên quan được tô hồng và nút Lưu bị khóa.
- Chưa chọn phim: vẫn xem được phòng đã có lịch chưa, nhưng chưa đánh giá khung giờ mới.
- Không tải được lịch: hiển thị lỗi và khóa Lưu; không coi lịch lỗi là phòng trống.

Ví dụ suất cũ 18:00–20:00, dọn 15 phút: 20:10 bị trùng, 20:15 được phép bắt đầu nếu thời lượng phim mới không đụng suất sau.

Nút “Dùng giờ trống ...” tìm khoảng đủ cho toàn bộ phim mới + thời gian dọn phòng, bắt đầu từ giờ đang chọn trở đi. Dữ liệu gợi ý được đọc trước 7 ngày; không gợi ý nếu phần cuối vượt khỏi dữ liệu đã tải. Giờ gợi ý được làm tròn lên phút để tránh chồng vài giây. Chọn ngày khác nếu không có khoảng phù hợp.

Khi sửa suất, suất đó được bỏ qua khi kiểm tra trùng và khi hiển thị lịch các suất khác.

## Cập nhật dữ liệu và lưu

“Tải lại lịch” lấy thay đổi từ máy khác. Lịch không tự cập nhật liên tục. Trước khi lưu, form tải lại lịch và kiểm tra thêm một lần; các procedure thêm/sửa hiện có trong SQL Server vẫn kiểm tra nghiệp vụ/xung đột cuối cùng, kể cả trường hợp người khác vừa thêm suất.

Bản này không tạo thủ tục SQL mới, không sửa script CSDL và không cần chạy thêm migration cho tính năng xem lịch này. Các lỗi thiếu procedure 26–30 của phiên bản source trước vẫn cần được xử lý riêng theo hướng dẫn trước đó.

## File chính

1. `src/YeuMinhEmCinema.Admin/Forms/FormSuatChieuBase.cs`: bố cục chung cho cả Thêm/Sửa, bảng lịch, trạng thái, gợi ý và kiểm tra trước khi lưu.
2. `src/YeuMinhEmCinema.Admin/UI/RoomSchedule.cs`: kiểm tra giao nhau và tìm khoảng trống, không phụ thuộc WinForms hoặc SQL.
3. `src/YeuMinhEmCinema.Admin/DataAccess/SuatChieuDAL.cs`: thêm truy vấn đọc lịch theo khoảng thời gian có tham số; giữ kiểm quyền xem lịch và phạm vi rạp. Hàm xem lịch trong ngày cũ gọi lại truy vấn này.
4. `Tests/RoomScheduleSmoke`: 14 ca kiểm tra thuật toán biên thời gian, dọn phòng, qua đêm, chuỗi suất, khoảng vừa đủ, làm tròn giây và bỏ qua suất đang sửa.

## Chạy trên Windows

Mở PowerShell tại thư mục chứa `YeuMinhEmCinema.slnx`:

```powershell
dotnet run --project Tests/RoomScheduleSmoke

dotnet build src/YeuMinhEmCinema.Admin

dotnet run --project src/YeuMinhEmCinema.Admin
```

Đăng nhập, vào Quản lý lịch chiếu, bấm Thêm suất; chọn phòng có lịch và thử các giờ cạnh nhau. Kiểm tra thêm trường hợp sửa suất cũ, suất qua nửa đêm, thay đổi phút dọn và mất kết nối CSDL.

## Mức kiểm chứng

Đã đối chiếu truy vấn, quy tắc khoảng thời gian và liên kết project test; đã kiểm tra tính toàn vẹn ZIP và phạm vi thay đổi so với nguồn gốc. Môi trường thực hiện không có .NET SDK, Windows/WinForms hay SQL Server nên CHƯA biên dịch/chạy giao diện và CHƯA chạy 14 ca C#. Không coi kết quả đọc source là kết quả chạy kiểm thử. Cần chạy các lệnh trên máy Windows trước khi dùng chính thức.

Giải nén sang thư mục mới để giữ nguyên bản trước. Các phần màu Cosmic Blue và Web sao băng từ bản trước vẫn có trong gói này.
