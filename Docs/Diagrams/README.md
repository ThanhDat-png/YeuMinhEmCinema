# Sơ đồ tổng thể YeuMinhEm Cinema

Phiên 01 ngày 29/10/2026. Gồm 19 sơ đồ chỉnh sửa trực tiếp bằng draw.io và 19 ảnh PNG xuất bằng draw.io ở tỷ lệ 2x. Không có khung ghi chú hoặc dòng commit trong hình.

## Danh mục

1. [Biểu đồ phân rã chức năng hệ thống](01-BFD.drawio) — [PNG](01-BFD.png)
2. [Use Case tổng quát hệ thống](02-UC-Tong-quat.drawio) — [PNG](02-UC-Tong-quat.png)
3. [Use Case 01 — Đăng nhập và phiên làm việc](03-UC01.drawio) — [PNG](03-UC01.png)
4. [Use Case 02 — Quản lý nhân viên tài khoản và quyền](04-UC02.drawio) — [PNG](04-UC02.png)
5. [Use Case 03 — Quản lý phim và thể loại](05-UC03.drawio) — [PNG](05-UC03.png)
6. [Use Case 04 — Quản lý rạp phòng và ghế](06-UC04.drawio) — [PNG](06-UC04.png)
7. [Use Case 05 — Quản lý lịch chiếu](07-UC05.drawio) — [PNG](07-UC05.png)
8. [Use Case 06 — Quản lý giá vé](08-UC06.drawio) — [PNG](08-UC06.png)
9. [Use Case 07 — Quản lý sản phẩm và combo F&B](09-UC07.drawio) — [PNG](09-UC07.png)
10. [Use Case 08 — Bán vé tại quầy](10-UC08.drawio) — [PNG](10-UC08.png)
11. [Use Case 09 — Quản lý đơn hàng và hoàn tiền](11-UC09.drawio) — [PNG](11-UC09.png)
12. [Use Case 10 — Kiểm tra và xác nhận vé](12-UC10.drawio) — [PNG](12-UC10.png)
13. [Use Case 11 — Quản lý khách hàng](13-UC11.drawio) — [PNG](13-UC11.png)
14. [Use Case 12 — Tổng quan và báo cáo](14-UC12.drawio) — [PNG](14-UC12.png)
15. [Use Case 13 — Tra cứu công khai trên Web](15-UC13.drawio) — [PNG](15-UC13.png)
16. [Use Case 14 — Tài khoản khách hàng trên Web](16-UC14.drawio) — [PNG](16-UC14.png)
17. [Use Case 15 — Đặt vé và thanh toán mô phỏng trên Web](17-UC15.drawio) — [PNG](17-UC15.png)
18. [Use Case 16 — Đơn hàng và vé cá nhân trên Web](18-UC16.drawio) — [PNG](18-UC16.png)
19. [Sơ đồ kiến trúc triển khai](19-Kien-truc-trien-khai.drawio) — [PNG](19-Kien-truc-trien-khai.png)

## Căn cứ đối chiếu

Source được đối chiếu tại commit `a217f8216aa606aaf0029b84f0c6997f0447652b`. Các nguồn cụ thể và vị trí trong báo cáo nằm trong `manifest.json`. 16 sơ đồ nhóm bao phủ đủ 66 mã Use Case hiện hành, không thêm chức năng ngoài source.

Tác nhân “Nhân sự có quyền tương ứng” biểu diễn tài khoản Desktop đã được cấp quyền cho thao tác và phạm vi rạp. Bộ quyền có thể cấu hình nên sơ đồ không mặc định mọi vai trò đều có mọi quyền. Đăng nhập là tiền điều kiện ở các chức năng cần phiên; không gán quan hệ include đăng nhập cho mọi Use Case.

Khởi tạo Admin chỉ dành cho lần đầu. Khách Web chỉ quản lý hồ sơ/đơn của mình. Thanh toán Web là mô phỏng; không có ngân hàng ngoài hệ thống. WinForms và Web cùng truy cập SQL Server, WinForms không gọi API Web.

Đây là sơ đồ tổng thể theo phiên bản triển khai. Sequence, Class và lược đồ quan hệ dữ liệu sẽ được thực hiện ở các phiên tiếp theo. Source ứng dụng và SQL không được sửa trong phiên vẽ sơ đồ.

## Phiên 02 — Cơ sở dữ liệu

Một lược đồ quan hệ gồm 27 bảng, 156 cột và 37 khóa ngoại. Mở [20-CSDL.drawio](20-CSDL.drawio) để sửa đủ 9 trang: một tổng thể và tám hình chi tiết. Có các bản draw.io từng trang và PNG cùng tên từ 20-CSDL-01 đến 20-CSDL-09. Xem [kết quả đối chiếu](20-CSDL-REVIEW.md), [schema](20-CSDL-schema.json) và [ánh xạ từng hình](20-CSDL-manifest.json). Không có khung ghi chú trong hình.
