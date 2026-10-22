# Thiết lập và cập nhật database

SQL Server Express: `.\SQLEXPRESS`, Windows Authentication.
Chuỗi kết nối: `src/YeuMinhEmCinema.Admin/CauHinh.cs`.
Mở file trong SSMS, nhấn Execute/F5, kiểm tra Messages sau từng file.

## Máy đã có database và bảng SuatChieu

Chạy lại lần lượt script 05, 06, 07, 08 trong Scripts. Không chạy lại seed.
Script 05 gồm các thủ tục hỗ trợ và phiên bản mới của sp_ThemSuatChieu;
06–08 phụ thuộc vào các thủ tục hỗ trợ này.
Script không chạy tự động khi mở Admin.

## Máy mới

1. Scripts/00_TaoDatabase_Phim.sql
2. Scripts/01_CauTruc_Rap_Phong_Ghe.sql
3. Seed/01_DuLieuMau_Phim.sql (tùy chọn)
4. Seed/02_DuLieuMau_Rap_Phong_Ghe.sql (tùy chọn)
5. Scripts/04_TaoBang_SuatChieu.sql
6. Scripts/05_ThemSuatChieu.sql
7. Scripts/06_SuaSuatChieu.sql
8. Scripts/07_DoiTrangThaiSuatChieu.sql
9. Scripts/08_SaoChepLich.sql

Scripts/03_KiemTraDuLieu.sql chỉ đọc để kiểm tra dữ liệu.
00_Full_Setup_Rap_Phong_Ghe.sql là bản gộp cũ; không cần chạy nếu dùng thứ tự trên.
Nếu có 02_DuLieuMau_Rap_Phong_Ghe.sql trong Scripts thì đây là bản trùng cũ;
chỉ dùng bản trong Seed để tránh nhầm thứ tự.
Các script CREATE TABLE chỉ tạo bảng chưa tồn tại, không tự nâng cấp bảng sai cấu trúc.
File SQL được lưu UTF-8 có BOM. Chuỗi tiếng Việt dùng N'...'.

## Quy tắc lịch chiếu

- Giờ kết thúc được tính từ thời lượng phim tại lúc lưu.
- Phòng bị chiếm đến hết thời gian dọn phòng; bắt đầu đúng thời điểm sẵn sàng được phép.
- Ngừng bán vẫn chiếm lịch; đã hủy không chiếm lịch, không mở lại bằng đổi trạng thái.
- Chỉ sửa/đổi trạng thái suất chưa bắt đầu. Hủy là đổi trạng thái, không DELETE.
- Thêm/sửa kiểm tra phim, ngày khởi chiếu, rạp/phòng và ghế hoạt động.
- Mọi thủ tục ghi lấy khóa ứng dụng tổng SuatChieu_Lich_Write trước khóa phòng/dòng.
  Khóa tổng tuần tự hóa thao tác ghi lịch, phù hợp quy mô đồ án, đổi lại ít song song hơn.
  Khi đổi phòng, khóa các phòng theo mã tăng dần và không khóa lặp.
- Truy cập ghi trực tiếp bằng SQL ngoài các thủ tục không được bảo vệ bởi khóa ứng dụng.
- Sửa/hủy bị chặn khi bảng người dùng khác có cột MaSuatChieu chứa mã tương ứng.
  Chính sách này bảo thủ: có cả dữ liệu liên quan đã hủy vẫn bị chặn.
  Khi bổ sung vé/đơn theo schema khác hoặc liên kết gián tiếp cần tích hợp quy tắc tương ứng,
  không coi đây là quy trình hoàn vé/thanh toán hoàn chỉnh.
- Sao chép chỉ lấy suất chưa hủy. Suất đích mở bán, giữ giờ trong ngày, tính lại kết thúc.
  Có thể chọn rạp/phòng, không sao chép cùng ngày hoặc vào quá khứ.
  Kiểm tra xung đột với lịch đích và giữa chính các suất trong nhóm; ghi cả nhóm trong transaction.
  Chữ ký nguồn được kiểm tra lại khi xác nhận. Nếu lịch nguồn đổi, phải xem trước lại.

Không xóa/gộp các rạp có hậu tố (cũ). Không thay đổi trạng thái ghế đã sửa trên máy.
