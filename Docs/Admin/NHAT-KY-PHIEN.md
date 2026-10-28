# Nhật ký các phiên Admin

## Phiên 1 ngày 28/10/2026

Trạng thái: HOÀN THÀNH việc chốt nguồn, phạm vi và danh sách; chưa hoàn thành sản phẩm Admin.

### Đã làm

- Đọc lại hai file Word đúng trong C_SHARP; xác minh báo cáo 8 chương và dấu vân tay. Bản 45 UC gửi nhầm được loại khỏi yêu cầu.
- Đối chiếu với source commit 5a0ee37 và bằng chứng kiểm tra Admin trước đó.
- Lập 32 mục ADM, 10 quyết định giữ/sửa phạm vi và 9 đầu việc T01–T09 có điều kiện nghiệm thu.
- Thu gọn tiến trình cho mục tiêu hôm nay: Phiên 2 sửa quyền/bố cục; Phiên 3 bổ sung Admin theo ưu tiên; Phiên 4 demo, hồi quy và cập nhật phần Admin trong báo cáo.
- Ghi rõ phần Web/người dùng không thuộc người phụ trách Admin; không triển khai lại API, EF, JWT hay .NET 8.

### Kiểm chứng của phiên này

Đã kiểm tra đủ đường dẫn evidence trong 32 mục; ID duy nhất; nguồn đúng hash; danh sách công việc tham chiếu ID hợp lệ. Đã kiểm trạng thái Git và phân biệt tài liệu với source sản phẩm.
Không chạy lại toàn bộ ứng dụng hoặc SQL trong Phiên 1 vì chưa đổi code. Kết quả build 0 lỗi/cảnh báo, 4 project kiểm thử .NET, 3 script SQL và quan sát GUI trong evidence là từ lượt kiểm tra Admin trước trong ngày 28/10, không phải kết quả mới phát sinh từ Phiên 1.

### Thay đổi

Chỉ bổ sung thư mục `Docs/Admin` gồm tài liệu theo dõi và bản sao bằng chứng trước. Không đổi `src`, `Database`, `Tests`, project/solution hoặc hai DOCX nguồn. Chưa commit/push.

### Kết quả đối chiếu quan trọng

- Giữ .NET 10/ADO.NET/stored procedure và schema hiện tại; báo cáo cần điều chỉnh tương ứng.
- Giữ hạn 10 phút và khung soát vé hiện tại; không sửa hành vi chung riêng cho Admin.
- Thiếu chắc chắn trong Admin: thể loại; ngữ cảnh suất/phòng đang soát; nhập tiền khách đưa/tính tiền thừa; tra cứu nhanh đơn; lọc báo cáo theo phim/suất. Các bộ lọc tìm nhân viên/phòng/quầy là cải thiện Admin cần thiết, không vay yêu cầu từ bản gửi nhầm.
- Lỗi đã tái hiện từ lượt trước: ghi rạp/phòng/ghế sau khi thu hồi phân công trong điều kiện được cấp RAP_QUAN_LY. Cùng với hai lỗi bố cục, chưa được sửa trong phiên này.
- Không đưa doanh thu theo nhân viên, tồn kho hay Web nhân viên từ bản gửi nhầm vào phạm vi.

### Còn thiếu và phiên tiếp theo

T01–T09 đều OPEN. Phiên 2 thực hiện T01/T02; chưa chuyển sang xây phần người dùng. Nếu thời gian ngắn, hoàn tất P1 và minh chứng trước; các mục P2 chưa xong phải ghi rõ khi tổng kết ngày.

## Mẫu chốt phiên tiếp theo

- Ngày và phiên; commit/mốc bắt đầu và trạng thái kết thúc.
- Mục T/ADM đã làm; file thay đổi; thay đổi SQL và cách áp dụng.
- Kiểm thử đã chạy, kết quả thực tế và đường dẫn minh chứng; ca chưa chạy.
- Mục báo cáo đã đối chiếu/cần sửa; quyết định phạm vi mới nếu có.
- Caller Web dùng chung có bị ảnh hưởng hay không và căn cứ.
- Lỗi/phần thiếu còn lại; trạng thái từng mục; việc cụ thể cho phiên sau.
- Đóng góp thực tế của người phụ trách; không nhận code cũ của nhóm là code vừa viết.

## Phiên 2 ngày 28/10/2026 thực hiện T01 T02

Trạng thái: HOÀN THÀNH hai đầu việc sửa đã chốt; xem `PHIEN-02-KET-QUA.md` cho file, kiểm thử, giới hạn và cách áp dụng.

- Đã rà báo cáo 4.3.2/4.5 và 4.4.2/5.4.2 trước sửa; hash đúng bản.
- Đã vá 6 thủ tục ghi danh mục theo phạm vi; có SQL 25 nâng cấp, cài mới và 25 ca hồi quy. Đã kiểm trước/sau, cài mới, chạy lại migration và luồng bán/hoàn/soát vé.
- Đã sửa TableLayout rạp/phòng, banner phim và Dock thanh đáy; đã xem GUI cửa sổ thường/phóng to sau bản sửa cuối.
- 4 project test .NET + SQL 01/02/04/05 đạt; build cuối 0 lỗi/cảnh báo. Không sửa Web hoặc runtime.
- ADM-03 DONE, ADM-28 PARTIAL; ADM-02/ADM-09 vẫn mở. Không coi việc chỉ đọc code menu là đã hoàn thành màn hình chỉ xem.
- Chỉ áp dụng SQL trên Test; database cài mới tạm đã dọn. File Word báo cáo giữ nguyên, phần chỉnh mô tả được ghi lại trong hồ sơ.
- Người dùng yêu cầu luôn rà báo cáo trước triển khai, chỉ commit/push khi có lệnh. Phiên này chưa stage/commit/push.
- Tiếp theo T03 kiểm ngữ cảnh soát vé; các P2 theo kế hoạch nếu còn thời gian.

## Phiên 3 — 28/10/2026: T03 soát vé đúng suất/phòng

- Trước sửa đọc lại DOCX đúng hash 329d4cf1…: UC05, 5.5.3 và nhánh thay thế hình 5.8 yêu cầu chọn suất, đúng suất, không dùng lặp. Giữ quyết định khung giờ -30 phút đến trước kết thúc thay vì đổi quy tắc toàn hệ thống.
- Thêm SQL26, list suất theo VE_KIEM_TRA và phạm vi; tham số ngữ cảnh optional để caller cũ giữ hợp đồng. Admin mới bắt chọn suất và truyền cả suất/phòng.
- Build 0 lỗi/0 cảnh báo. SQL06 31/31 đạt trên nâng cấp và cài mới; SQL01/02/04/05 và AdminSmoke đạt. GUI sau người dùng đăng nhập: chưa chọn bị khóa, sai suất bị chặn, đúng suất tra/xác nhận thành công, quét lại bị chặn; bố cục thường/phóng to đã xem.
- Đã dọn fixture GUI đúng ID/nhãn, rollback các fixture hồi quy và xóa database cài mới tạm. Chỉ Test được nâng cấp; không sửa Web/.NET10/schema.
- Chi tiết và log: PHIEN-03-KET-QUA.md, evidence/2026-10-28/session-03. Không lưu PNG GUI; ảnh xem trực tiếp trong công cụ. Không tạo log .NET giả.
- T03/ADM-24 đóng; ADM-23 còn phần sửa DOCX ở T09. Chưa làm T04–T07; chuyển phiên 4. Phiên 3 không commit/push, chờ lệnh riêng.

## Phiên 4 — 28/10/2026: T04 tiền mặt và tra cứu

- Trước sửa đọc lại DOCX đúng hash329d4cf1…:5.4.2/6.2.3 ca5 về tiền khách đưa;4.1.1/4.3.2 về tra cứu. Giữ .NET10/ADO.NET/SQL, Web và schema tài chính.
- Thêm TienMat production +28 ca dưới 2 culture; UI tiền khách đưa/thừa, chặn thiếu, reset phương thức/giỏ và khóa đã trả.
- SQL 27 mở rộng tùy chọn từ khóa/output tổng, caller cũ giữ nguyên; source19 và bộ cài đồng bộ. UI tìm mã đơn/thu/vé, reset trang, khóa biên.
-24/24 ca SQL đạt trên nâng cấp/cài mới; SQL01/02/04/05/06 và AdminSmoke đạt, build0 lỗi/0 cảnh báo. GUI tiền thiếu/thừa, đổi phương thức, thu thành công/thu lại, tìm3 loại mã,57 đơn chia50/7, chi tiết và rỗng đều đạt. DB ghi80000 dù khách đưa100000,1 thu/1 vé.
- Đã rollback fixture test, dọn đúng fixture GUI và database cài mới tạm. Chỉ Test local được nâng cấp. Không lưu PNG GUI; ảnh xem qua công cụ. Kết quả .NET ở output công cụ, không tạo log giả.
- T04/ADM-18/ADM-20 đóng. T05–T07 chưa làm, dự kiến phiên 5; T08–T09 phiên 6. Chưa sửa DOCX hoặc commit/push phiên 4.

## Phiên 5 — 28/10/2026: T05 tìm kiếm và phòng chỉ xem

- Trước triển khai đọc lại báo cáo đúng hash329d4cf1…:4.1.1/4.3.2/4.5/5.4.2 yêu cầu tìm kiếm và quyền theo rạp. Giữ .NET10/ADO/SQL, không sửa Web/schema.
- SQL28 có ba procedure đọc: nhân viên (mã/tên/SĐT), phòng (mã/tên/phạm vi), suất tại quầy (tên phim/rạp/ngày/còn bán). DAL/UI dùng chính các procedure được test, bộ cài mới đồng bộ.
- Mở menu RAP_XEM, khóa mọi control/menu ghi khi thiếu RAP_QUAN_LY. Đổi bộ lọc quầy xóa giỏ tạm tránh dùng ghế/tổng cũ; giữ khóa giỏ khi đã yêu cầu giữ.
- Build 0 lỗi/0 cảnh báo;34/34 ca SQL đạt trên nâng cấp/cài mới, SQL01/02/05/06/07 và AdminSmoke đạt. Kỳ vọng test đã chỉnh cho mã hồ sơ trùng mã tài khoản và nhiều hồ sơ trùng SĐT/tên; không sửa nghiệp vụ để ép dữ liệu duy nhất.
- GUI Admin tìm mã/SĐT; GUI BAN_VE xác nhận menu phòng chỉ xem, tìm mã/tên có dấu, ngoài phạm vi trả rỗng, nút/menu ghi khóa sau chọn ghế; POS lọc phim/xóa giỏ tạm/kết quả rỗng đạt. Quan sát thường1172×850 và POS phóng to1536×816.
- Đã dọn đúng fixture GUI/tài khoản tạm và database cài mới tạm; không lưu mật khẩu tạm hoặc hash thực tế vào repo. Chỉ Test local nâng cấp.
- Kết quả chi tiết PHIEN-05-KET-QUA.md; ảnh đã xem trong công cụ, không có PNG lưu. Log.NET ở output công cụ; bằng chứng SQL thật ở evidence/2026-10-28/session-05.
- T05 đóng; T06/T07 và các phần menu khác/tài liệu còn mở. Chưa commit/push phiên 5.

## Phiên 6 — 28/10/2026: chỉ T06 báo cáo

- Đọc lại DOCX đúng hash329d4cf1… và chốt công thức trước sửa. Người dùng duyệt T06 với tám ràng buộc, không tự chuyển T07/commit/push.
- Mở rộng UcBaoCaoThongKe (Tổng quan cũng dùng lớp này), SQL 18 thêm filter tùy chọn giữ nghĩa cũ; SQL 29 có thu chi tiết, từng suất và danh sách phim có kiểm quyền/phạm vi tại SQL. Không đổi schema/Web/runtime.
- Thu vé/F&B cộng snapshot riêng từng đơn, tổng/hoàn lấy giao dịch; thuần thu−hoàn. Chia ngày giao dịch VN và ngày chiếu; báo cáo cũ chỉ đơn chưa hoàn được giữ và giải thích nhãn.
-32/32 SQL test đạt nâng cấp/cài mới; SQL01/02/07, AdminSmoke 37 kiểm và build0 lỗi/0 cảnh báo đạt. GUI Admin trên bản cuối đã kiểm thu/hoàn/lọc phim/từng suất/Hiệu quả phim/F&B/rỗng, chart âm và bố cục thường/phóng to.
- Sửa thêm UseMnemonic=false cho nhãn F&B và cột ngày chỉ hiện ngày; bản cuối bin/AdminReportFinal đã mở lại/kiểm thật sau người dùng đăng nhập.
- Dọn đúng fixture GUI gồm thu/hoàn/đơn giữ, xóa database cài mới tạm. Chỉ Test local được nâng cấp. Không lưu PNG GUI/log.NET giả.
- Kết quả PHIEN-06-KET-QUA.md; checklist chỉnh Word PHIEN-06-DIEU-CHINH-BAO-CAO.md; mọi yêu cầu còn mở ở PHIEN-06-CON-TON-TAI.md. DOCX chưa sửa.
- T06 đóng; T07 chưa bắt đầu. Chưa commit/push phiên 6.
