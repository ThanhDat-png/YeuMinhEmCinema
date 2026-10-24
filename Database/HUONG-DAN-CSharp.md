# Hợp đồng SQL → C# ADO.NET

1. Đăng nhập: backend gọi sp_YMC_LayThongTinDangNhap, kiểm mật khẩu bằng PasswordHasher của C#, sau đó gọi sp_YMC_GhiNhanDangNhap với PhienBan đã đọc. Chỉ tạo session/token khi cả kiểm mật khẩu lẫn ghi nhận thành công; lỗi cạnh tranh thì đọc và xác thực lại. Gọi sp_YMC_LayQuyenTaiKhoan để hiển thị chức năng, vẫn kiểm quyền ở mỗi thao tác server.
2. Tạo admin đầu tiên: gọi sp_YMC_KhoiTaoAdmin bằng hash PasswordHasher tạo. Không gán ADMIN từ đăng ký Web.
3. Khách hàng: sp_YMC_DangKyKhachHang chỉ cấp KHACH_HANG. HoTen bắt buộc; tài khoản và hồ sơ tạo cùng transaction.
4. Nhân viên: sp_YMC_TaoNhanVien tạo hồ sơ/tài khoản/vai trò/rạp; quản lý sau đó qua file 21.
5. Danh mục: dùng các sp_YMC_LuuPhim/LuuRap/LuuPhong/LuuLoaiGhe/LuuGhe; giữ tên cột PK hiện tại: LoaiGhe.MaLoai.
6. Lịch: dùng sp_YMC_AdminThemSuatChieu, AdminSuaSuatChieu, AdminDoiTrangThaiSuat, AdminSaoChepLich. Tham số NguoiThucHien lấy từ session.
7. Giá/menu: dùng sp_YMC_AdminLuuGiaVe, AdminLuuFnb; sửa phải truyền byte[8] PhienBan. C# không ép rowversion sang DateTime hay chuỗi hiển thị.
8. Web: WebDanhSachPhim, WebChiTietPhim, WebLichChieu; SoDoGheTheoSuat chỉ là ảnh chụp, phải chấp nhận lỗi tranh chấp khi thực sự giữ.
9. Tạo đơn: sp_YMC_TaoDonGiuGhe; TVP Ghe gồm MaGhe:int; TVP Fnb gồm MaSanPham:int, SoLuong:int. DataTable có đúng tên/cột, SqlDbType.Structured và TypeName dbo.YMC_DanhSachGhe/dbo.YMC_DanhSachFnb.
10. Truyền Guid mới làm MaYeuCau; retry do timeout dùng lại Guid đó. Nếu đổi ghế/menu, hủy đơn cũ và tạo Guid mới. Tài khoản WEB chỉ đặt cho hồ sơ của chính mình.
11. Xem đơn: sp_YMC_XemChiTietDon trả 6 result set: DonHang, ChiTietVe+Ve, ChiTietDonFnb, ThanhToan, HoanTien, ChiTietComboDaBan. Dùng DataSet hoặc SqlDataReader.NextResult.
12. Thu: sp_YMC_XacNhanThanhToan. TIEN_MAT dùng mã biên nhận duy nhất; chuyển khoản/cổng dùng mã giao dịch đã xác minh. Đơn hết hạn không được đánh dấu trả tiền dù callback tới muộn; backend đưa sang xử lý đối soát/hoàn ngoài luồng.
13. Hủy: sp_YMC_HuyDonChuaThanhToan; hoàn: sp_YMC_GhiNhanHoanTien sau khi thực hiện hoàn thật hoặc mô phỏng có nhãn rõ trong demo.
14. QR chỉ chứa MaVe GUID. sp_YMC_KiemTraVe @XacNhanVaoRap=0 để xem, =1 để xác nhận. Không tin dữ liệu tên phim/ghế do QR client tự gửi.
15. Báo cáo: yêu cầu MaRap và khoảng ngày, procedure tự kiểm phạm vi. Chọn toàn hệ thống thì backend gọi từng rạp được phép và tổng hợp; không bỏ MaRap để vượt phạm vi.

Kiểu tham số: NVARCHAR dùng SqlDbType.NVarChar và Size; VARCHAR dùng VarChar; DECIMAL dùng Precision=18 Scale=0; DATETIME2 dùng DateTime2 Scale=0; SQL DATE dùng Date; BIGINT dùng long; GUID dùng Guid; NULL dùng DBNull.Value. Không ghép chuỗi SQL từ input.

Thời điểm *_Utc: khi đọc SQL DATETIME2 bằng C#, chỉ định DateTimeKind.Utc rồi chuyển giờ hiển thị UTC+7. GioBatDau/GioKetThuc là giờ địa phương Việt Nam không offset, đừng đổi UTC hai lần. Đồng hồ đếm ngược nên lấy thời gian server, không dùng đồng hồ máy client làm quyết định bán.

Lỗi nghiệp vụ 50000+ hiển thị nội dung phù hợp; 2601/2627 báo trùng dữ liệu; 1205/timeout cho retry có giới hạn bằng cùng MaYeuCau. Không retry toàn bộ thanh toán bằng mã giao dịch mới. Log kỹ thuật ở backend, không trả connection string/stack trace ra Web.

Đối với WinForms kết nối trực tiếp SQL bằng Windows Authentication, đây là mô hình đồ án trong môi trường tin cậy. Web production cần backend và phân quyền SQL/service riêng; các tham số actor không phải bằng chứng danh tính tự thân.
