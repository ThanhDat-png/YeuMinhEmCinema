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
