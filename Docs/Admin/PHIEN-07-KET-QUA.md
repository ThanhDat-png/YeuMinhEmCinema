# Kết quả T07 — thể loại phim

Ngày 28/10/2026; nền a4e3ae6; chỉ database Test. Chưa commit/push. Không triển khai T08.

## Đối chiếu trước sửa

Đã đọc lại đúng C#_Nhóm1.docx trong C_SHARP, SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853. Phần4.1.1 yêu cầu quản lý phim/thể loại;5.2 mô tả Genres (tên, mô tả, active) và MovieGenres (khóa ghép). Code/SQL trước T07 chưa có thể loại. Mô tả phim MoTa đã có, không thêm cột trùng. Phần Web lọc thể loại/đồng bộ thể loại và kiến trúc API/EF không triển khai trong T07.

## Thay đổi

- SQL30 chỉ tạo thêm TheLoai, PhimTheLoai, TVP YMC_DanhSachTheLoai và5 procedure mới. Không đổi/xóa/seed bảng Phim hoặc giao dịch; không bắt phim cũ có thể loại. Hai bộ cài tổng đồng bộ migration mới.
- TheLoai: mã, tên tối đa100 ký tự, mô tả tùy chọn tối đa1000 ký tự, DangSuDung. Tên trim, duy nhất không phân biệt hoa/thường (Vietnamese_100_CI_AS), kể cả thể loại đã ngừng; từ chối rỗng/NULL/quá dài/tab/xuống dòng. Có sử dụng lại, không có xóa vật lý trên UI.
- PhimTheLoai có khóa ghép(MaPhim,MaTheLoai), FK không cascade và index chiều thể loại. TVP khóa chính chặn mã trùng. Gán theo tập mong muốn, giữ/bỏ/thêm liên kết trong một transaction, dùng khóa ứng dụng chung cho thao tác ghi thể loại để tránh race với ngừng sử dụng.
- Ngừng thể loại giữ liên kết cũ; giao diện đánh dấu ngừng sử dụng. Có thể giữ hoặc bỏ liên kết cũ; không gán mới thể loại ngừng. Danh sách chọn gồm loại đang dùng và loại ngừng đã gán cho phim. Danh mục cho xem số phim được gán.
- SQL kiểm PHIM_XEM khi đọc và PHIM_QUAN_LY khi ghi, gọi guard hiện hành mỗi lần. Đây là danh mục phim chung toàn hệ thống; giữ quyền hiện có, không tự cấp PHIM_QUAN_LY cho QUAN_LY theo mô tả báo cáo.
- Admin: thêm hai nút Danh mục thể loại / Thể loại của phim và cột thể loại. Form danh mục thêm/sửa/ngừng/sử dụng lại; hộp chọn nhiều thể loại cho phim đang chọn. Người chỉ xem mở được danh mục/danh sách đã gán nhưng không ghi.
- Tạo phim vẫn theo form cũ; lưu phim xong chọn dòng phim rồi bấm Thể loại của phim để gán. Không ghép hai bước giả thành một giao dịch; hủy hộp thể loại không hủy phim đã lưu.
- Admin đọc một procedure mới gộp thể loại trước khi trả một dòng/phim; không nhân bản phim khi có nhiều thể loại. Không sửa code Web, csproj hay procedure Web/lưu phim cũ.

## Kiểm thử đã chạy

- Build .NET10: 0 lỗi,0 cảnh báo, đầu ra bin/AdminGenre.
- SQL30 áp dụng2 lần trên YeuMinhEmCinema_Test; 37/37 ca SQL10 đạt. Snapshot trước/sau migration giống nhau: hash định nghĩa các SQL module cũ, cột Phim, count/checksum Phim/SuatChieu/DonHang/ChiTietVe và tham số/cột kết quả3 procedure phim Web. Snapshot chứng minh các đối tượng được kiểm; checksum không thay thế backup hay kiểm toàn bộ dữ liệu từng ô.
- Cài từ đầu vào YMC_GenreInstall_6bd94117_Test từ CAI-DAT-TEST: 37/37 ca đạt; đã xóa đúng database tạm. Không chạy bộ cài trên database thật.
- 37 ca bao gồm tạo/sửa, Unicode/trim, ngừng/sử dụng lại, liên kết cũ, nhiều thể loại, thay/bỏ tập gán, phim cũ không thể loại, dữ liệu rỗng/dài/trùng/sai mã, stale form, quyền đọc/ghi, thu hồi quyền, khóa tài khoản/ngừng việc, quản lý rạp không được tự nâng quyền, Web danh sách/chi tiết và caller lưu phim cũ. Fixture từng ca rollback.
- Hồi quy SQL01 bán–thanh toán–soát–hoàn/retry (bản chạy Test thêm2 thể loại cho phim và kiểm WebLichChieu vẫn1 suất/2 ghế); SQL02 từ chối nghiệp vụ; SQL04 quyền/ghế; SQL09 báo cáo32 ca: đạt.
- SqlIntegration (bao gồm chống trùng/copy lịch/2 kết nối đồng thời), AdminSmoke, WebSmoke và CatalogSmoke: đạt; có log riêng. CatalogSmoke kiểm HTTP/Razor với dữ liệu giả, không coi là test WebSQL thực tế. SQLWeb đã được kiểm riêng nêu trên.
- GUI thật với admin sau đăng nhập: phim fixture591, gán80+81 và lưu; bảng phim vẫn1 dòng, SQL xác nhận2 liên kết. Tạo thể loại82 với mô tả tiếng Việt; sửa mô tả80 và bỏ trạng thái đang dùng; danh mục giữ SoPhim=1, bảng phim hiện ngừng sử dụng. Bố cục mặc định1172×850, hộp chọn/danh mục/nhập liệu hiển thị và có nút Lưu. Một số bảng dài có cuộn ngang.
- Đã dọn đúng phim591/thể loại80,81,82 bằng ID+kèm tên và kiểm không có liên kết ngoài fixture. Chưa lưu PNG GUI; ảnh quan sát trong phiên công cụ, có SQL đối chứng sau thao tác.

## Giới hạn nghiệm thu

Chưa kiểm GUI bằng mọi vai trò, GUI sửa tập gán/bỏ hết/sử dụng lại/nút chuyển trạng thái riêng, độ phân giải/DPI khác và tải lớn. Các nghiệp vụ này đã có SQL test nếu liệt kê ở trên; không suy ra đã kiểm GUI. Chưa benchmark hoặc stress đồng thời riêng thể loại. Màn hình không có rowversion chống ghi đè khi hai người sửa cùng danh mục; khóa giao dịch chỉ bảo vệ ràng buộc, lần lưu sau cùng thắng.

ADM-07/T07 đóng theo phạm vi sản phẩm. ADM-32 còn mở cho tài liệu tổng/Word tại T09. Checklist Word: PHIEN-07-DIEU-CHINH-BAO-CAO.md. Tồn tại toàn bộ: PHIEN-07-CON-TON-TAI.md. Chỉ Test local đã nâng cấp SQL30; máy nhóm/database thật chưa áp dụng. Không sửa DOCX, tự commit/push hoặc chuyển T08.

Cập nhật Git 28/10/2026: người dùng đã duyệt commit/push T07 và đổi thông điệp5 commit Admin trước sang tiếng Việt. Mã commit lịch sử đối chiếu tại Docs/Admin/DOI-CHIEU-COMMIT.md; không chuyển T08.
