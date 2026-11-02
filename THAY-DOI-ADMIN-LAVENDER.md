# Thay đổi Admin Soft Lavender so với bản Lịch phòng trước

## Sửa giao diện

- `src/YeuMinhEmCinema.Admin/Forms/Form1.cs`
- `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`
- `src/YeuMinhEmCinema.Admin/UserControls/UcBaoCaoThongKe.cs`
- `src/YeuMinhEmCinema.Admin/UserControls/UcTongQuan.cs`

## Thêm

- `HUONG-DAN-ADMIN-LAVENDER.md`
- `THAY-DOI-ADMIN-LAVENDER.md`
- `src/YeuMinhEmCinema.Admin/Forms/Form1.Presentation.cs`
- `src/YeuMinhEmCinema.Admin/UI/AdminWelcomeCard.cs`
- `src/YeuMinhEmCinema.Admin/UI/SoftCorners.cs`

Không có file bị xóa. DAL, SQL, cấu hình, Web và thuật toán xem lịch phòng giống từng byte với bản Lịch phòng trước. Form1 chỉ thêm khởi tạo trình bày menu, màu menu và giữ tiêu đề đầy đủ khi thu gọn. UcBaoCaoThongKe chỉ được đặt Name cho label tổng hợp. Toàn bộ control menu, handler, thứ tự và phân quyền cũ giữ nguyên. Chưa build/chạy WinForms.
