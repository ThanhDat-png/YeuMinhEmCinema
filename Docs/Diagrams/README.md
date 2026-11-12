# Sơ đồ tổng thể YeuMinhEm Cinema

Phiên 01 ngày 29/10/2026. Gồm 19 sơ đồ chỉnh sửa trực tiếp bằng draw.io và 19 ảnh PNG xuất bằng draw.io ở tỷ lệ 2x. Không có khung ghi chú hoặc dòng commit trong hình.

## Danh mục

1. [Biểu đồ phân rã chức năng hệ thống](01-BFD.drawio) — [PNG](png/01-BFD.png)
2. [Use Case tổng quát hệ thống](02-UC-Tong-quat.drawio) — [PNG](png/02-UC-Tong-quat.png)
3. [Use Case 01 — Đăng nhập và phiên làm việc](03-UC01.drawio) — [PNG](png/03-UC01.png)
4. [Use Case 02 — Quản lý nhân viên tài khoản và quyền](04-UC02.drawio) — [PNG](png/04-UC02.png)
5. [Use Case 03 — Quản lý phim và thể loại](05-UC03.drawio) — [PNG](png/05-UC03.png)
6. [Use Case 04 — Quản lý rạp phòng và ghế](06-UC04.drawio) — [PNG](png/06-UC04.png)
7. [Use Case 05 — Quản lý lịch chiếu](07-UC05.drawio) — [PNG](png/07-UC05.png)
8. [Use Case 06 — Quản lý giá vé](08-UC06.drawio) — [PNG](png/08-UC06.png)
9. [Use Case 07 — Quản lý sản phẩm và combo F&B](09-UC07.drawio) — [PNG](png/09-UC07.png)
10. [Use Case 08 — Bán vé tại quầy](10-UC08.drawio) — [PNG](png/10-UC08.png)
11. [Use Case 09 — Quản lý đơn hàng và hoàn tiền](11-UC09.drawio) — [PNG](png/11-UC09.png)
12. [Use Case 10 — Kiểm tra và xác nhận vé](12-UC10.drawio) — [PNG](png/12-UC10.png)
13. [Use Case 11 — Quản lý khách hàng](13-UC11.drawio) — [PNG](png/13-UC11.png)
14. [Use Case 12 — Tổng quan và báo cáo](14-UC12.drawio) — [PNG](png/14-UC12.png)
15. [Use Case 13 — Tra cứu công khai trên Web](15-UC13.drawio) — [PNG](png/15-UC13.png)
16. [Use Case 14 — Tài khoản khách hàng trên Web](16-UC14.drawio) — [PNG](png/16-UC14.png)
17. [Use Case 15 — Đặt vé và thanh toán mô phỏng trên Web](17-UC15.drawio) — [PNG](png/17-UC15.png)
18. [Use Case 16 — Đơn hàng và vé cá nhân trên Web](18-UC16.drawio) — [PNG](png/18-UC16.png)
19. [Sơ đồ kiến trúc triển khai](19-Kien-truc-trien-khai.drawio) — [PNG](png/19-Kien-truc-trien-khai.png)

## Căn cứ đối chiếu

Source được đối chiếu tại commit `a217f8216aa606aaf0029b84f0c6997f0447652b`. Các nguồn cụ thể và vị trí trong báo cáo nằm trong `manifest.json`. 16 sơ đồ nhóm bao phủ đủ 66 mã Use Case hiện hành, không thêm chức năng ngoài source.

Tác nhân “Nhân sự có quyền tương ứng” biểu diễn tài khoản Desktop đã được cấp quyền cho thao tác và phạm vi rạp. Bộ quyền có thể cấu hình nên sơ đồ không mặc định mọi vai trò đều có mọi quyền. Đăng nhập là tiền điều kiện ở các chức năng cần phiên; không gán quan hệ include đăng nhập cho mọi Use Case.

Khởi tạo Admin chỉ dành cho lần đầu. Khách Web chỉ quản lý hồ sơ/đơn của mình. Thanh toán Web là mô phỏng; không có ngân hàng ngoài hệ thống. WinForms và Web cùng truy cập SQL Server, WinForms không gọi API Web.

Các mục dưới đây ghi nhận tiến độ CSDL và Class Diagram. Sequence Diagram sẽ tiếp tục được triển khai theo phương thức trong source. Source ứng dụng và SQL không được sửa trong các phiên vẽ sơ đồ.

## Phiên 02 — Cơ sở dữ liệu

Một lược đồ quan hệ gồm 27 bảng, 156 cột và 37 khóa ngoại. Mở [20-CSDL.drawio](20-CSDL.drawio) để sửa đủ 9 trang: một tổng thể và tám hình chi tiết. Có các bản draw.io từng trang và PNG cùng tên từ 20-CSDL-01 đến 20-CSDL-09. Xem [kết quả đối chiếu](20-CSDL-REVIEW.md), [schema](20-CSDL-schema.json) và [ánh xạ từng hình](20-CSDL-manifest.json). Không có khung ghi chú trong hình.

## Phiên 03 — Class Diagram

Hai bộ sơ đồ: [WinForms — 13 trang](21-Class-WinForms.drawio) và [Web — 8 trang](22-Class-Web.drawio). Gồm hai hình tổng quát và 19 hình chi tiết, bao phủ 82 kiểu khai báo thực tế: 57 ở WinForms và 25 ở Web. Hình thể hiện thuộc tính, phương thức chính và quan hệ có căn cứ trong source; không có khung ghi chú. Có từng trang draw.io và PNG cùng tên.

Xem [đối chiếu và phạm vi thể hiện](Class-REVIEW.md), [inventory đầy đủ](Class-inventory.json), [ánh xạ từng hình](Class-manifest.json) và [kết quả kiểm tra](Class-QA.json). Báo cáo Google Docs dùng Hình 3.28–3.48 cho Class; kiến trúc đổi thành Hình 3.49. 66 mục Sequence giữ nguyên mã và tên.


## Phiên 04 — Sequence Diagram (Mục 1.7 Báo cáo)

28 sơ đồ tuần tự mức mã nguồn (Code-level Sequence Diagram) chuẩn hóa theo yêu cầu:
- Phong cách đơn sắc (Monochrome: trắng/đen, không tô màu ô, không đổ bóng, chữ đen chuẩn).
- Lược bỏ các lớp hệ thống/hạ tầng (.NET Framework), chỉ mô hình hóa các lớp của nhóm (Form, UserControl, Controller, DAL, Data, Helper, Database/SP).
- Toàn bộ tệp PNG được lưu tập trung tại thư mục png/.

### Danh sách 28 sơ đồ:

1. [1.7.1. Khởi tạo Quản trị viên đầu tiên](23-Sequence-01-KhoiTaoAdmin.drawio) — [PNG](png/23-Sequence-01-KhoiTaoAdmin.png)
2. [1.7.2. Đăng nhập ứng dụng Quản trị](23-Sequence-02-DangNhapAdmin.drawio) — [PNG](png/23-Sequence-02-DangNhapAdmin.png)
3. [1.7.3. Đổi mật khẩu Quản trị viên và Nhân viên](23-Sequence-03-DoiMatKhauAdmin.drawio) — [PNG](png/23-Sequence-03-DoiMatKhauAdmin.png)
4. [1.7.4. Tạo nhân viên và tài khoản](23-Sequence-04-TaoNhanVien.drawio) — [PNG](png/23-Sequence-04-TaoNhanVien.png)
5. [1.7.5. Thêm hoặc cập nhật thông tin phim](23-Sequence-05-ThemSuaPhim.drawio) — [PNG](png/23-Sequence-05-ThemSuaPhim.png)
6. [1.7.6. Gán hoặc bỏ thể loại của phim](23-Sequence-06-GanTheLoaiPhim.drawio) — [PNG](png/23-Sequence-06-GanTheLoaiPhim.png)
7. [1.7.7. Tạo bổ sung sơ đồ ghế theo lô](23-Sequence-07-TaoSoDoGhe.drawio) — [PNG](png/23-Sequence-07-TaoSoDoGhe.png)
8. [1.7.8. Tạo suất chiếu](23-Sequence-08-TaoSuatChieu.drawio) — [PNG](png/23-Sequence-08-TaoSuatChieu.png)
9. [1.7.9. Xem trước và xác nhận sao chép lịch chiếu](23-Sequence-09-SaoChepLichChieu.drawio) — [PNG](png/23-Sequence-09-SaoChepLichChieu.png)
10. [1.7.10. Thêm hoặc cập nhật giá vé](23-Sequence-10-QuanLyGiaVe.drawio) — [PNG](png/23-Sequence-10-QuanLyGiaVe.png)
11. [1.7.11. Lưu sản phẩm F&B và cấu hình combo](23-Sequence-11-QuanLyFnb.drawio) — [PNG](png/23-Sequence-11-QuanLyFnb.png)
12. [1.7.12. Tạo đơn và giữ ghế tại quầy](23-Sequence-12-TaoDonGiuGheQuay.drawio) — [PNG](png/23-Sequence-12-TaoDonGiuGheQuay.png)
13. [1.7.13. Xác nhận thu tiền và phát hành vé tại quầy](23-Sequence-13-XacNhanThanhToanQuay.drawio) — [PNG](png/23-Sequence-13-XacNhanThanhToanQuay.png)
14. [1.7.14. Xuất phiếu và vé QR tại quầy](23-Sequence-14-XuatPhieuVaQrQuay.drawio) — [PNG](png/23-Sequence-14-XuatPhieuVaQrQuay.png)
15. [1.7.15. Ghi nhận hoàn toàn bộ đơn hàng](23-Sequence-15-HoanTienDonHang.drawio) — [PNG](png/23-Sequence-15-HoanTienDonHang.png)
16. [1.7.16. Xác nhận vé vào đúng suất chiếu và phòng](23-Sequence-16-SoatVeVaoRap.drawio) — [PNG](png/23-Sequence-16-SoatVeVaoRap.png)
17. [1.7.17. Cập nhật hồ sơ khách hàng tại quầy](23-Sequence-17-CapNhatKhachHangQuay.drawio) — [PNG](png/23-Sequence-17-CapNhatKhachHangQuay.png)
18. [1.7.18. Xem báo cáo thu tiền, hoàn tiền và doanh thu thuần](23-Sequence-18-BaoCaoDoanhThu.drawio) — [PNG](png/23-Sequence-18-BaoCaoDoanhThu.png)
19. [1.7.19. Đăng ký tài khoản khách hàng trên Web](23-Sequence-19-DangKyWeb.drawio) — [PNG](png/23-Sequence-19-DangKyWeb.png)
20. [1.7.20. Đăng nhập khách hàng trên Web](23-Sequence-20-DangNhapWeb.drawio) — [PNG](png/23-Sequence-20-DangNhapWeb.png)
21. [1.7.21. Đổi mật khẩu khách hàng trên Web](23-Sequence-21-DoiMatKhauWeb.drawio) — [PNG](png/23-Sequence-21-DoiMatKhauWeb.png)
22. [1.7.22. Xem chi tiết phim và lịch chiếu trên Web](23-Sequence-22-XemChiTietPhimLichWeb.drawio) — [PNG](png/23-Sequence-22-XemChiTietPhimLichWeb.png)
23. [1.7.23. Cập nhật hồ sơ và email khách hàng trên Web](23-Sequence-23-CapNhatHoSoWeb.drawio) — [PNG](png/23-Sequence-23-CapNhatHoSoWeb.png)
24. [1.7.24. Tạo đơn và giữ ghế trên Web](23-Sequence-24-TaoDonGiuGheWeb.drawio) — [PNG](png/23-Sequence-24-TaoDonGiuGheWeb.png)
25. [1.7.25. Thanh toán mô phỏng và phát hành vé trên Web](23-Sequence-25-ThanhToanMoPhongWeb.drawio) — [PNG](png/23-Sequence-25-ThanhToanMoPhongWeb.png)
26. [1.7.26. Tra cứu danh sách và chi tiết đơn hàng cá nhân](23-Sequence-26-TraCuuDonHangWeb.drawio) — [PNG](png/23-Sequence-26-TraCuuDonHangWeb.png)
27. [1.7.27. Hủy đơn cá nhân chưa thanh toán](23-Sequence-27-HuyDonWeb.drawio) — [PNG](png/23-Sequence-27-HuyDonWeb.png)
28. [1.7.28. Xem ảnh QR của vé cá nhân](23-Sequence-28-XemQrVeWeb.drawio) — [PNG](png/23-Sequence-28-XemQrVeWeb.png)
