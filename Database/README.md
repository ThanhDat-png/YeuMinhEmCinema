# Thiết lập SQL Server

Kết nối `.\SQLEXPRESS` trong SSMS bằng Windows Authentication.
Chạy từng file theo thứ tự dưới đây, kiểm tra Messages sau mỗi file:

1. `Scripts/00_TaoDatabase_Phim.sql`: tạo database và bảng Phim nếu chưa có.
2. `Scripts/01_CauTruc_Rap_Phong_Ghe.sql`: tạo bảng, view và hàm cho rạp/phòng/ghế.
3. `Seed/01_DuLieuMau_Phim.sql`: tùy chọn, thêm phim minh họa.
4. `Seed/02_DuLieuMau_Rap_Phong_Ghe.sql`: thêm dữ liệu rạp/phòng/ghế mẫu.

`Scripts/00_Full_Setup_Rap_Phong_Ghe.sql` là bản gộp cũ của phần rạp/phòng/ghế.
Không cần chạy file gộp nếu đã làm các bước trên. File gộp không tự tạo database hoặc bảng Phim.

Các script tạo mới không nâng cấp cấu trúc của bảng đã tồn tại. Nếu database cũ có cấu trúc khác, cần đối chiếu và viết migration riêng.
Chuỗi kết nối của Admin nằm trong `src/YeuMinhEmCinema.Admin/CauHinh.cs`.
