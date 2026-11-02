# Đối chiếu CSDL YeuMinhEm Cinema

Ngày đối chiếu: 29/10/2026. Mã ứng dụng và SQL ở commit `a217f8216aa606aaf0029b84f0c6997f0447652b`; HEAD trước phiên tài liệu là `2e5b770fc57347d07089690b759bbcc23aa4a7e7`.

## Kết quả

- 27 bảng, 156 cột, 37 khóa ngoại trong schema được cài bởi bộ SQL hiện hành.
- 27 bảng mô tả chi tiết trên Google Docs khớp tên cột, thứ tự cột và kiểu dữ liệu với script trong repo.
- Một lược đồ quan hệ, trình bày bằng 9 hình: một hình tổng thể và tám hình chi tiết. Các hình chi tiết bao phủ đầy đủ thuộc tính của 27 bảng và đủ 37 khóa ngoại.
- Không thêm bảng, khóa ngoại hoặc quan hệ kế thừa do suy đoán nghiệp vụ. Bảng ký hiệu ↗ chỉ là bản lặp để nối nhóm dữ liệu.
- Không sửa mã ứng dụng, script cài đặt hay dữ liệu SQL Server.

## Các điểm đã thể hiện chính xác

1. `KhachHang.MaTaiKhoan` cho phép NULL, duy nhất khi khác NULL; `NhanVien.MaTaiKhoan` bắt buộc và duy nhất. `TaiKhoan.Email` duy nhất khi khác NULL.
2. `Ve(MaDonHang,MaGhe)` tham chiếu đúng khóa ghép của `ChiTietVe`, có thêm UNIQUE trên cùng cặp. Không vẽ hai khóa ngoại đơn tới DonHang và Ghe thay cho khóa ghép thực tế.
3. `HoanTien.MaDonHang` tham chiếu `ThanhToan.MaDonHang`, không trực tiếp tham chiếu DonHang. Quan hệ DonHang–ThanhToan và ThanhToan–HoanTien có tối đa một bản ghi con.
4. `ChiTietComboDaBan(MaDonHang,MaSanPham)` tham chiếu khóa ghép của ChiTietDonFnb. MaThanhPhan tham chiếu FnbSanPham.
5. FnbComboChiTiet có hai khóa ngoại khác vai trò tới FnbSanPham: MaCombo và MaThanhPhan.
6. GiuGhe có khóa chính (MaSuatChieu,MaGhe), ngăn hai bản ghi chiếm cùng ghế trong một suất. Điều kiện 1–8 ghế, phòng của ghế, trạng thái và hạn giữ được kiểm tra thêm bằng procedure.
7. Tên, giờ, nhãn ghế, giá và thành phần combo được lưu chốt khi tạo đơn giữ ghế. Dữ liệu lịch sử tách khỏi danh mục hiện tại.
8. Lực lượng quan hệ trên sơ đồ phản ánh PK/FK, NULL và UNIQUE. Không gán số con tối thiểu 1 vào schema chỉ vì luồng tạo đơn yêu cầu 1–8 ghế.

## Nguồn

- Database/Scripts/00_TaoDatabase_Phim.sql
- Database/Scripts/01_CauTruc_Rap_Phong_Ghe.sql
- Database/Scripts/04_TaoBang_SuatChieu.sql
- Database/Scripts/09_GiaVe_Fnb.sql
- Database/Scripts/10_TaiKhoan_PhanQuyen.sql
- Database/Scripts/11_KhachHang_NhanVien.sql
- Database/Scripts/12_DonHang_Ve_ThanhToan.sql
- Database/Scripts/13_DatVe_GiuGhe.sql
- Database/Scripts/14_BanVe_ThanhToan.sql
- Database/Scripts/15_HuyDon_HoanTien.sql
- Database/Scripts/23_WinForms_HoanThien.sql
- Database/Scripts/24_Web_MoPhongThanhToan.sql
- Database/Scripts/30_Admin_TheLoaiPhim.sql
- src/YeuMinhEmCinema.Admin/DataAccess/GiaoDichDAL.cs
- src/YeuMinhEmCinema.Web/Data/DatVeData.cs

Chi tiết cột, khóa và SHA-256 của các script SQL nằm trong `20-CSDL-schema.json`; ánh xạ bảng/quan hệ vào từng hình nằm trong `20-CSDL-manifest.json`.

## Tệp

`20-CSDL.drawio` chứa đủ 9 trang có thể sửa bằng diagrams.net. Các tệp `20-CSDL-01.drawio` đến `20-CSDL-09.drawio` là từng trang tách riêng; PNG cùng tên được xuất bằng draw.io ở tỷ lệ 2x. Hình không chứa khung ghi chú hay dòng mã commit.
