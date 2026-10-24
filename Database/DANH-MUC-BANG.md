# Các bảng và quan hệ chính

| Nhóm | Bảng | Quan hệ / ý nghĩa |
|---|---|---|
| Phim | Phim | Phim và metadata hiển thị |
| Rạp | Rap, PhongChieu | Một rạp có nhiều phòng |
| Ghế | LoaiGhe, Ghe | Ghế thuộc một phòng; loại tham chiếu LoaiGhe.MaLoai |
| Lịch | SuatChieu | Một phim, một phòng, thời gian và thời gian dọn |
| Giá | GiaVe | Loại ghế + định dạng + loại ngày + khoảng hiệu lực |
| FNB | FnbSanPham, FnbComboChiTiet | Menu và các thành phần combo một cấp |
| Quyền | TaiKhoan, VaiTro, Quyen, TaiKhoanVaiTro, VaiTroQuyen | Quan hệ nhiều–nhiều cho tài khoản/vai trò/quyền |
| Hồ sơ | KhachHang, NhanVien, NhanVienRap | Khách có thể không có tài khoản nếu mua tại quầy; nhân viên bắt buộc có tài khoản; nhiều rạp phân công |
| Đơn | DonHang | Một suất, một người tạo, tùy chọn một khách; mã yêu cầu chống lặp và hạn giữ |
| Chi tiết | ChiTietVe, ChiTietDonFnb, ChiTietComboDaBan | Snapshot giá/tên/giờ/thành phần tại lúc đặt |
| Chỗ | GiuGhe | Khóa chính suất + ghế; liên kết một đơn hiện sở hữu chỗ |
| Thu | ThanhToan | Một giao dịch thu thành công trên một đơn |
| Vé | Ve | Chỉ phát hành khi thu thành công; duy nhất đơn + ghế; GUID dùng trong QR |
| Hoàn | HoanTien | Một lần hoàn toàn bộ; giữ lịch sử thu cũ |

DonHang.TrangThai: CHO_THANH_TOAN → DA_THANH_TOAN → DA_HOAN_TIEN; CHO_THANH_TOAN → DA_HUY hoặc HET_HAN.
Ve.TrangThai: HIEU_LUC → DA_SU_DUNG hoặc DA_HUY (khi hoàn).
GiuGhe được giữ lại sau thu/kiểm vé, xóa khi hủy/hoàn/hết hạn; không dùng để lưu lịch sử. Lịch sử nằm trong DonHang/ChiTietVe/Ve.

Định nghĩa cột, khóa ngoại, CHECK và chỉ mục đầy đủ nằm trong Scripts. Không tạo cascade delete lịch sử.
