# Checklist chỉnh Word sau T07 — chưa sửa DOCX

- 4.1.1: có quản lý thể loại WinForms (thêm/sửa/ngừng/sử dụng lại), nhiều thể loại/phim; cho phép phim chưa gán. Giữ phạm vi phim chung và quyền PHIM_XEM/PHIM_QUAN_LY, không khẳng định quản lý rạp mặc định sửa được danh mục chung.
- 5.2: thay tên thiết kế Genres/MovieGenres bằng bảng thực tế TheLoai(MaTheLoai PK,TenTheLoai UNIQUE,MoTa,DangSuDung) và PhimTheLoai(MaPhim FK,MaTheLoai FK,PK ghép); không cascade xóa. Phim giữ schema cũ. Không dùng bảng thể loại để tính lại vé/giao dịch.
- 5.4: mô tả thao tác tạo phim trước, chọn phim rồi gán nhiều thể loại qua hộp riêng; cột thể loại được gộp thành một dòng/phim. Ngừng thể loại giữ liên kết đã gán, chặn gán mới.
- 6.3–6.5: ghi 37 caSQL nâng cấp/cài mới và GUI đã thử theo PHIEN-07-KET-QUA.md; không lấy smoke dữ liệu giả làm bằng chứng SQL hoặc khẳng định kiểm đủ mọi vai trò/DPI.
- Bỏ khẳng định Web đã lọc/hiển thị thể loại tự động khi Admin đổi. T07 chỉ giữ tương thích Web hiện có; Web không nhận trường mới và chưa triển khai filter/hiển thị thể loại. Phần Web giao người phụ trách xác nhận.
- Kiến trúc vẫn .NET10, WinForms, ADO.NET và stored procedure; không ghi đã chuyển API/EF/JWT để khớp sơ đồ cũ. ADM-32 và các sơ đồ/đóng góp tổng còn T09.

File này là hướng dẫn cần chỉnh, không phải bản Word đã sửa. DOCX nguồn giữ nguyên SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853.
