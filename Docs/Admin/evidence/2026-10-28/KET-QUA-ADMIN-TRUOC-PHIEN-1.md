# Kiểm tra WinForms Admin ngày 28/10/2026

## Kết luận

Admin đã có mã xử lý SQL cho 11 mục điều hướng. Bản local tại `C:\Users\Admin\OneDrive\Documents\C_SHARP\YeuMinhEmCinema`, commit `5a0ee37`, build thành công với 0 lỗi và 0 cảnh báo. Không sửa mã nguồn sản phẩm trong lượt kiểm tra này.

Đã mở ứng dụng thật, người dùng đăng nhập, sau đó kiểm tra các mục Tổng quan, Phim, Rạp/phòng/ghế, Lịch chiếu, Giá vé/F&B, Đơn, Bán vé tại quầy, Kiểm vé, Khách hàng, Nhân viên/quyền và Báo cáo. Tìm phim bằng từ khóa “Chuyến” trả đúng hai phim demo. Đã quan sát sơ đồ ghế thực lấy từ SQL.

Đây là kiểm tra chức năng và rà soát code, chưa phải nghiệm thu đầy đủ mọi thao tác GUI. Các ca thu/hoàn tiền chỉ mô phỏng trên database Test.

## Những gì đã có

- Đăng nhập, khởi tạo Admin đầu tiên, phân quyền menu, làm mới quyền, đổi mật khẩu và đăng xuất.
- Danh mục phim; thêm/sửa/ngừng chiếu và kiểm tra phim có lịch tương lai.
- Rạp/phòng/loại ghế/sơ đồ ghế; tạo ghế theo lô và bảo vệ ghế đang có giao dịch.
- Lịch chiếu: lọc, thêm/sửa, đổi trạng thái, lịch phòng, sao chép có xem trước và CSV.
- Giá theo loại ghế/định dạng/ngày, thời gian hiệu lực và kiểm tra chồng giá; sản phẩm và combo.
- Quầy bán vé: chọn suất/ghế/F&B, giữ ghế, tính giá ở SQL, ghi nhận đã thu tiền, xuất phiếu HTML có QR.
- Đơn: lọc/phân trang, xem chi tiết, hủy chưa trả và ghi nhận hoàn toàn bộ.
- Soát vé GUID/QR, kiểm tra phạm vi rạp và chống sử dụng lại.
- Khách hàng, nhân viên, tài khoản, vai trò và phân công rạp.
- Tổng quan và báo cáo thu/hoàn/thuần, hiệu quả phim, F&B và CSV.

Tổng quan hiện tái sử dụng màn hình báo cáo (`UcTongQuan : UcBaoCaoThongKe`), chưa phải dashboard KPI riêng.

## Kiểm thử đã chạy đạt trong lượt này

1. `Tests/AdminSmoke`: băm mật khẩu/salt, mật khẩu sai và hash hỏng, CSV tiếng Việt và chống công thức, QR PNG.
2. `Tests/CsvSmoke`: BOM, Unicode, dấu phẩy, dấu nháy, nhiều dòng, NULL, ngày và công thức.
3. `Tests/SqlIntegration`: xung đột lịch, dọn phòng, suất qua đêm, sao chép nguyên nhóm, nguồn thay đổi và hai kết nối đồng thời.
4. `Tests/PricingIntegration`: giá chồng ngày, phiên bản dữ liệu, giá ngày thường/cuối tuần, sản phẩm và combo.
5. `Database/Tests/01_LuongThanhCong.sql`: tạo đơn lặp, thu lặp, phát hành vé, soát vé, hoàn lặp và giải phóng ghế.
6. `Database/Tests/02_TuChoiNghiepVu.sql`: giữ ghế trùng, sai số tiền, sửa lịch có đơn giữ, soát lần hai, thanh toán hết hạn và truy cập đơn người khác.
7. `Database/Tests/04_WinForms_QuyenVaGhe.sql`: phạm vi rạp, tạo ghế lặp, nhân viên hủy đơn quầy do mình tạo và chặn thao tác giao dịch rạp khác.

Các bản sao SQL 01/02 trong thư mục kiểm tra này chỉ thay `USE` thành `YeuMinhEmCinema_Test`, giữ nguyên ca kiểm tra. Đã dùng `sqlcmd -I -f 65001` để giữ QUOTED_IDENTIFIER và Unicode. Fixture của các bài thử đã rollback hoặc được dọn.

## Lỗi đã tái hiện cần ưu tiên

### P1 Thiếu kiểm tra phạm vi rạp khi ghi danh mục

Điều kiện: vai trò `QUAN_LY` được cấp `RAP_QUAN_LY` qua cơ chế tùy chỉnh quyền hợp lệ của ứng dụng. Bộ quyền QUAN_LY mặc định hiện chưa cấp quyền này, nên cần nói rõ điều kiện thay vì kết luận mọi quản lý mặc định đều bị ảnh hưởng.

Tái hiện bằng `scope-repro.sql`: tạo quản lý và hai rạp trong transaction, phân công hai rạp rồi thu hồi rạp B. Hàm `fn_YMC_CoPhamViRap(actor, B)` trả 0, nhưng cả ba thao tác sau vẫn thành công:

- `sp_YMC_LuuRap` sửa rạp B.
- `sp_YMC_LuuPhong` sửa phòng thuộc rạp B.
- `sp_YMC_CapNhatLoGhe` sửa ghế thuộc rạp B.

Bằng chứng: `scope-repro.txt` có ScopeAfterRevocation = 0 và ba dòng FOUND. Toàn bộ quyền bổ sung và fixture đã rollback. Lượt đầu dùng QUAN_LY mặc định bị từ chối đúng vì không có RAP_QUAN_LY; lượt tái hiện chính bổ sung quyền đó trong transaction rồi rollback.

Nguyên nhân: các thủ tục chỉ gọi `sp_YMC_YeuCauQuyen` với quyền RAP_QUAN_LY mà không truyền rạp đích hoặc kiểm tra phạm vi từng phòng/ghế. Lọc danh sách trên giao diện không thay thế kiểm tra quyền lúc ghi. Tình huống thực tế đáng kiểm thử là thu hồi rạp khi người dùng còn mở sẵn màn hình chỉnh sửa.

Hướng sửa: kiểm tra rạp hiện tại và rạp mới khi đổi phòng; xác thực toàn bộ rạp của các ghế trong lô; từ chối cả transaction nếu có đối tượng ngoài phạm vi. Rà thêm `sp_YMC_TaoGheTheoLo` và các thủ tục ghi danh mục liên quan vì có cùng mẫu kiểm quyền, nhưng chưa tái hiện riêng từng thủ tục đó.

Vị trí: `Database/Scripts/17_QuanLyDanhMuc.sql` dòng 63, 96; `Database/Scripts/23_WinForms_HoanThien.sql` dòng 70.

### P2 Nút thao tác che cây rạp phòng

Đã nhìn thấy ở cửa sổ Admin hiện tại: nhóm nút Thêm rạp/Thêm phòng/Sửa/Ngừng phòng nằm đè lên giữa cây rạp/phòng, làm một số dòng khó nhìn và khó bấm. TreeView và panel nút đều đặt tọa độ/Anchor tuyệt đối; cần bố trí bằng Dock hoặc TableLayoutPanel có hàng riêng.

Vị trí: `src/YeuMinhEmCinema.Admin/UcRapPhongChieu.Designer.cs`, panel nút quanh dòng 169 và TreeView quanh dòng 244. Cần thử lại với nhiều kích thước cửa sổ/DPI sau khi sửa, chưa có bằng chứng cho mọi độ phân giải.

### P3 Nhãn trạng thái che tiêu đề danh sách phim

Đã nhìn thấy nhãn xanh “CƠ SỞ DỮ LIỆU HOẠT ĐỘNG THẬT” che một phần tiêu đề “DANH SÁCH PHIM ĐANG ĐƯỢC QUẢN LÝ”. Hai Label AutoSize dùng vị trí cố định và Anchor; cần hai ô bố cục hoặc rút gọn nhãn trạng thái.

Vị trí: `src/YeuMinhEmCinema.Admin/Form1.Designer.cs` quanh dòng 705–724.

## Điểm hoàn thiện nên làm

- Một số bảng còn hiện tên kỹ thuật như MaYeuCau, HanThanhToanUtc, TongKetQua, DangHoatDong, TienDaThu; nên đổi nhãn và ẩn cột nội bộ khỏi màn hình nhân viên.
- Ngày ở các màn hình mới dùng định dạng Short phụ thuộc hệ điều hành, còn một số màn hình khác dùng dd/MM/yyyy; nên thống nhất định dạng rõ ràng.
- Nhiều thao tác truy vấn đang chạy đồng bộ trên UI thread. Database chậm có thể làm giao diện chờ; chưa đo tải hoặc mô phỏng timeout trong lượt này.
- Các UserControl được cache; chuyển menu không đồng nghĩa luôn tải lại dữ liệu. Có nút Tải lại/Làm mới ở nhiều màn hình, cần thống nhất hành vi sau thao tác từ màn hình hoặc máy khác.
- Database Test hiện có phim/rạp/phòng/ghế demo nhưng chưa có bộ lịch/giá/đơn lưu lâu dài để demo xuyên suốt. Màn hình bán vé, đơn và báo cáo rỗng không có nghĩa chúng chỉ là giao diện giả.

## Những gì chưa được xác nhận qua GUI

Chưa thao tác hết thêm/sửa/lưu trên từng form; chưa bán vé, hoàn tiền, xuất phiếu và xác nhận soát vé bằng từng lần bấm trên GUI; chưa thử đăng nhập GUI lần lượt với quản lý, bán vé và soát vé; chưa thử máy quét, máy in hoặc nhiều mức DPI. Kiểm thử SQL đạt chỉ xác nhận phần nghiệp vụ tương ứng, không thay thế các bước này.

Nhận định sơ bộ về lỗi khởi động nhân viên soát vé đã được loại bỏ sau khi đọc đủ hàm `TaiDanhSachPhim`: hàm có guard `!Db.Has("PHIM_XEM")`, nên không ghi vào danh sách lỗi.

Ba loại ghế không được tham chiếu bị sai Unicode từ lần nạp dữ liệu Test trước đã được dọn, không sửa ghế hay giá đang được dùng. Đây là lỗi dữ liệu thử cục bộ, không phải lỗi WinForms. Không thay mật khẩu hoặc tài khoản admin của người dùng.

## Phần việc phù hợp để nhận

Ưu tiên nhận sửa kiểm tra phạm vi rạp ở DAL/SQL, kèm ca kiểm thử thu hồi rạp khi đang mở form. Sau đó chỉnh bố cục rạp/phòng và phim, chuẩn hóa nhãn/ngày, chuẩn bị dữ liệu demo rồi chạy checklist GUI theo từng vai trò. Các đầu việc có code, kiểm thử và minh chứng rõ ràng để ghi phần đóng góp Admin.
