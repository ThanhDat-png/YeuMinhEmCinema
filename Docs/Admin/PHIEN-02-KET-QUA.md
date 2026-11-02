# Kết quả Phiên 2 sửa quyền và bố cục Admin

Ngày 28/10/2026. Đây là phiên triển khai đầu tiên sau phiên chuẩn bị đối chiếu. Mốc Git bắt đầu: `5a0ee37`; chưa commit hoặc push.

## Đối chiếu báo cáo trước khi sửa

Đã đọc lại bản đúng `C#_Nhóm1.docx` trong C_SHARP, SHA-256 `329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853`. Phần liên quan: 4.3.2/4.5 yêu cầu quyền theo rạp và giữ lịch sử; 4.4.2/5.4.2 yêu cầu giao diện quản lý rõ ràng. Giữ .NET 10, ADO.NET và mô hình dữ liệu hiện có. Không chỉnh nội dung file Word trong phiên sửa code này.

## Đã sửa

- `sp_YMC_LuuRap`: sửa phải còn quyền rạp; tạo rạp mới là quyền Admin toàn cục.
- `sp_YMC_LuuPhong`: kiểm cả rạp hiện tại và rạp đích trước khi chuyển/sửa.
- `sp_YMC_LuuGhe`: kiểm rạp cũ và mới, kể cả lời gọi thủ tục cũ không đi qua UI hiện tại.
- `sp_YMC_TaoGheTheoLo`: kiểm đúng rạp của phòng, chặn form cũ sau thu hồi phân công.
- `sp_YMC_CapNhatLoGhe`: kiểm mọi ghế; lô có một ghế ngoài phạm vi bị từ chối trước UPDATE.
- `sp_YMC_LuuLoaiGhe`: danh mục dùng chung được giới hạn cho Admin.
- Không đổi chữ ký 6 procedure hoặc result set. Rà source Web không có caller trực tiếp của 6 procedure ghi danh mục này. Không sửa file Web.
- Thêm SQL 25 cho nâng cấp; hai bộ cài tổng kèm cùng định nghĩa cuối file. Source 17/23 cũng đã đồng bộ; script 17 không phụ thuộc hàm chỉ được tạo ở 23 cho kiểm Admin toàn cục.
- Cây rạp/phòng và các nút dùng ba hàng TableLayoutPanel riêng; không còn đè danh sách.
- Tiêu đề phim và nhãn trạng thái dùng hai ô; rút nhãn thành “Dữ liệu SQL Server”, bỏ chuỗi tên máy chủ hardcode khỏi nhãn.
- Sửa thứ tự Dock thanh công cụ đáy của Form chính để không che hàng nút cuối; lỗi này được phát hiện khi kiểm GUI sau sửa.

## Kiểm thử

- Trước sửa: bộ hồi quy mới thất bại đúng ca thu hồi rạp vẫn sửa rạp được (`before-fix.txt`).
- Sau sửa: 25 ca quyền đạt trên Test nâng cấp (19 từ chối, 6 cho phép). Bao gồm rạp cũ/đích, ghế đơn/lô trộn phạm vi, quyền chỉ xem, khóa tài khoản, ngừng việc, Admin toàn cục và quản lý có phân công.
- Cài mới: database tạm `YMC_AdminInstall_1e251dfe_Test` cài bằng bản sao CAI-DAT-TEST và chạy đủ 25 ca đạt. Database tạm đã dọn; không xóa database Test hoặc database người dùng.
- Nâng cấp: SQL 25 chạy lại hai lần thành công; tiếp tục chạy 25 ca đạt.
- Hồi quy đã đạt: AdminSmoke, CsvSmoke, SqlIntegration, PricingIntegration; SQL 01 luồng thành công, SQL 02 ca từ chối, SQL 04 quyền/ghế. Fixture được rollback/dọn.
- Build Admin cuối: 0 lỗi, 0 cảnh báo; output riêng `bin/AdminReview/` để không ghi đè ứng dụng đang chạy.
- Đã kiểm GUI thực tế trên bản mới sau người dùng đăng nhập: phim và rạp/phòng ở cửa sổ thường khoảng 1172×850 và phóng to khoảng 1536×816 trong ảnh công cụ. Nhãn không đè tiêu đề, cây không bị nút che, cả hai hàng nút không bị thanh đáy che. Đây là kích thước capture quan sát, không phải tuyên bố đã thử mọi DPI.
- Đã kiểm diff và tính đồng nhất của chữ ký procedure/canonical migration trong hai bộ cài. Không có thay đổi Web/project/runtime.

Các log SQL nằm tại `evidence/2026-10-28/session-02/`. Ảnh GUI đã được xem qua công cụ trong cuộc trò chuyện; không có PNG được lưu kèm trong repo. Kết quả .NET build/test ở đầu ra công cụ; không tạo file log giả cho các lần chạy đó.

## Áp dụng trên máy khác

Database đã có SQL 23: chạy `Database/Scripts/25_Admin_PhamViRap.sql` trên đúng database, sau đó chạy Admin mới. Không cần seed hoặc chạy lại bộ cài tổng. Đối với Test, đổi dòng USE sang database Test. SQL 25 không phụ thuộc SQL 24 thanh toán mô phỏng Web. Hướng dẫn đã cập nhật trong BAT-DAU-O-DAY, Database/README và Tests/README.

Database Test của phiên này đã được áp dụng. Database chính/máy nhóm chưa được tự động nâng cấp.

## Còn lại

- ADM-03 và công việc T01/T02 đã đóng đúng phạm vi. ADM-28 vẫn PARTIAL vì còn nhãn kỹ thuật, ngày giờ và DPI khác.
- Màn hình chỉ xem cho từng vai trò và ma trận quyền mặc định vẫn cần hoàn thiện ở ADM-02/ADM-09; phiên này không tự cấp thêm quyền toàn cục cho quản lý.
- Chưa thử thu hồi bằng hai GUI Admin/nhân viên đang hoạt động; bộ SQL đã mô phỏng trạng thái bị thu hồi trước thao tác ghi, không phải thử mọi cạnh tranh thời gian thực.
- Chưa sửa các tính năng tiền khách đưa, tìm nhanh đơn, ngữ cảnh soát vé, thể loại hay báo cáo theo suất.
- Phần báo cáo cần cập nhật sau: mô tả kiểm quyền tại DAL/SQL thay vì API; ghi kết quả test mới và ảnh GUI thật. Không đánh đạt phần Web do người khác phụ trách.

## Phiên tiếp theo

Ưu tiên T03: chọn suất/phòng đang soát và từ chối vé sai ngữ cảnh tại server, giữ tương thích caller cũ. Sau đó mới làm P2 tiền khách đưa/tra cứu nhanh và các bộ lọc theo danh sách đã chốt.

Không commit hoặc push. Chỉ thực hiện khi người dùng có lệnh rõ ràng.
