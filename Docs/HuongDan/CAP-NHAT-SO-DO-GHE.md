# Cập nhật sơ đồ ghế

1. Đóng Admin đang chạy.
2. Copy nội dung ZIP vào repo hiện tại, giữ nguyên thư mục .git của repo.
3. Chạy tại thư mục gốc:

```powershell
dotnet build .\YeuMinhEmCinema.slnx
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
```

## Đã sửa

- Mỗi hàng ghế nằm trên một hàng riêng, không tách A11/A12 thành dòng khác.
- Có thanh cuộn ngang nếu phòng rộng hơn khu vực hiển thị.
- Giữ bản sửa màu viền ghế và giải phóng các nút cũ khi đổi phòng.
- Các file SQL được lưu UTF-8 có BOM để nhận diện tiếng Việt trên Windows.

## Dữ liệu tiếng Việt và rạp nghi trùng

Code giao diện hiện có chuỗi tiếng Việt đúng. Ảnh có cả tên đúng và tên lỗi mã hóa,
cho thấy cần kiểm tra dữ liệu SQL đang lưu trên máy; ZIP không chứa database đó.
Đổi encoding file SQL không tự sửa các dòng đã lưu sai trước đây.

Mở Database/Scripts/03_KiemTraDuLieu.sql bằng SSMS rồi Execute.
Gửi ảnh kết quả ba bảng đầu (rạp, phòng, loại ghế) để xác định chính xác mã bản ghi.
Không xóa rạp/phòng/ghế và không chạy lại seed để sửa chữ: cần giữ mã và quan hệ dữ liệu.
Script này chỉ đọc, không xóa, gộp hoặc đổi tên tự động.

## Kiểm tra trên máy

Chọn phòng IMAX 120 ghế: A1–A12 phải cùng hàng, hàng B ở dưới.
Cuộn ngang để xem ghế cuối, cuộn dọc để xem hàng cuối.
Đổi phòng rồi quay lại; thử đổi loại ghế và trạng thái hỏng/hoạt động.
Chưa build hoặc chạy WinForms tại môi trường sửa vì không có .NET SDK/Windows.
