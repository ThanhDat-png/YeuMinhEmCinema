# T08 — Kết quả nghiệm thu Admin

Ngày 29/10/2026 (giờ Việt Nam). Nhánh `main`, nền `ade6414`. Working tree sạch trước T08. Kết luận: **ĐẠT CÓ GIỚI HẠN**, chờ người dùng duyệt; chưa commit/push, không T09.

## Phạm vi và cách tính

Đã đối chiếu đúng `C#_Nhóm1.docx` (SHA256 `329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853`), tracker, tồn tại T07 và checklist Windows. Giữ .NET10/WinForms/ADO.NET/SQL Server; không sửa source Admin/Web, schema, procedure, trigger, function hoặc Word.

Bảng dưới đếm **tiêu chí chức năng có mã A01–E09 trong tài liệu này**, không cộng số assertion của các bộ test vào số ca GUI. Đã kiểm = PASS + FAIL. PASS ghi rõ lớp kiểm; SQL/DAL PASS không có nghĩa mọi thao tác GUI đã đạt. Bằng chứng T03–T07 còn áp dụng được ghi rõ là tái sử dụng, không phải chạy mới trong T08.

| Nhóm | Tổng tiêu chí | Đã kiểm | PASS | FAIL | NOT RUN | OUT OF SCOPE |
|---|---:|---:|---:|---:|---:|---:|
| A | 10 | 8 | 8 | 0 | 2 | 0 |
| B | 25 | 22 | 22 | 0 | 3 | 0 |
| C | 24 | 20 | 20 | 0 | 4 | 0 |
| D | 15 | 15 | 13 | 2 | 0 | 0 |
| E | 9 | 9 | 9 | 0 | 0 | 0 |
| Tổng | 83 | 74 | 72 | 2 | 9 | 0 |

Không có tỷ lệ hoàn thành sản phẩm. Thanh toán ngân hàng thật, quản lý kho, viết lại kiến trúc, sửa Web/Word và T09 nằm ngoài phạm vi, không đưa vào mẫu số trên.

## Môi trường và kiểm thử mới

- Admin và Web build `--no-restore`: PASS, 0 lỗi/0 cảnh báo. Admin output riêng `src/YeuMinhEmCinema.Admin/bin/AdminT08/`; Web `bin/Review/`.
- SQL thực tế: `MSI\SQLEXPRESS`, `YeuMinhEmCinema_Test`, compatibility160. Bản kiểm cài đặt chỉ đọc đã đổi USE sang Test: không thiếu bảng/procedure/hàm/view/TVP trong danh sách hiện hành đến SQL30; SQL24 có sẵn, không cần cài lại.
- Admin được mở với `YMC_CONNECTION`, Web với `ConnectionStrings__Cinema`; Program Web ưu tiên biến môi trường sau appsettings.Local. DMV xác nhận hai phiên có `database_id` trỏ cùng Test, Application Name riêng và PID đối chiếu tiến trình thật. Không chỉ đọc cấu hình mặc định (Admin mặc định vẫn trỏ database chính; không dùng mặc định đó để test).
- AdminSmoke:37 kiểm PASS; CsvSmoke:PASS; PricingIntegration:14 assertion PASS và thông báo tổng PASS; SqlIntegration:20 assertion PASS. Fixture tự dọn.
- WEBIT = `Tests/WebCustomerIntegration`:34 lần thông báo PASS khi chạy không bật browser.mjs. HTTP thật + DAL Web + SQL Test, không mock. Bao gồm auth/CSRF/ownership, giá2 combo, hold/retry/race/expiry/payment/QR/cancel và chặn mô phỏng trong Production. Không coi đây là thao tác trình duyệt tự động. Fixture tự dọn.
- SQL01 luồng thành công/retry/soát/hoàn:PASS rollback; SQL02:6 từ chối PASS; SQL05:25 ca PASS; SQL09:32 ca PASS. Không chạy lại toàn bộ T01–T07.
- AUTH:13 kiểm PASS qua TaiKhoanDAL/BaoMatMatKhau/CauHinh liên kết trực tiếp mã sản phẩm hiện tại, fixture nhân viên không nhận ADMIN. STAFF:6 assertion với procedure nhân viên/vai trò/phân công thật, rollback. CATALOG:10 kiểm hợp lệ/từ chối, thêm bảo vệ ghế đang giữ và hạn giữ; các thay đổi hợp lệ rollback.
- MIXED: hai luồng đồng thời, HTTP Web và `sp_YMC_TaoDonGiuGhe` kênh QUAY, tranh ghế 2374/suất 998. Web thất bại, quầy thành công; SQL chỉ có đơn 1252 CHO_THANH_TOAN cho ghế đó. Đây là cạnh tranh HTTP/procedure quầy, không phải hai chuột GUI đồng thời.
- Harness AUTH ngoài repo khi restore có cảnh báo NuGet về Pkcs9.0.18. Đây là dependency của harness tạm; không quy cảnh báo đó thành lỗi sản phẩm. Admin assets không có package Pkcs, Web assets dùng10.0.13. Không sửa/thêm thư viện vào repository.

Các helper/CSV/HTML/log mới được giữ ngoài repository tại `C:\Users\Admin\OneDrive\Documents\ChatGPT\C_sharpCINEMA`: `t08-auth/`, `t08-http.py`, `t08-staff.sql`, `t08-catalog.sql`, `t08-extra.sql`, `t08-race.json`, `t08-orders.csv`, `t08-admin-ticket-1250.html`, `t08-*.txt`. Helper chứa ID fixture của đúng lần chạy, không phải bộ cài/seed hoặc script để chạy trên máy khác. Không lưu mật khẩu Test trong repo.

## Danh sách tiêu chí và bằng chứng

### Nhóm A

- **A01 — PASS:** Đăng nhập Admin thành công; DAL với BAN_VE/SOAT_VE/QUAN_LY. Bằng chứng: GUI + AUTH.
- **A02 — PASS:** Sai mật khẩu bị từ chối. Bằng chứng: AUTH.
- **A03 — PASS:** Tài khoản khóa/ngừng và nhân viên ngừng việc bị từ chối. Bằng chứng: AUTH.
- **A04 — NOT RUN:** Đăng xuất rồi đăng nhập tài khoản khác ngay trên cùng GUI trong T08. Bằng chứng: Chưa thực hiện.
- **A05 — PASS:** Tạo nhân viên/tài khoản và sửa hồ sơ bằng procedure sản phẩm. Bằng chứng: STAFF.
- **A06 — PASS:** Cấp/thu hồi SOAT_VE bằng procedure sản phẩm. Bằng chứng: STAFF.
- **A07 — PASS:** Phân công/thu hồi rạp; SQL chặn thao tác sau thu hồi. Bằng chứng: STAFF + SQL05.
- **A08 — PASS:** Chỉ xem phòng: xem được, không sửa được. Bằng chứng: GUI T05 tái sử dụng + SQL05.
- **A09 — PASS:** Không đủ quyền/ngoài rạp bị SQL từ chối. Bằng chứng: SQL05.
- **A10 — NOT RUN:** Thu hồi quyền bằng một GUI rồi thao tác tiếp trên GUI nhân viên đang mở. Bằng chứng: SQL đã kiểm; chưa thử hai GUI đồng thời.

### Nhóm B

- **B01 — PASS:** Tạo phim hợp lệ từ GUI Admin. Bằng chứng: GUI: phim 656.
- **B02 — PASS:** Sửa phim/đổi trạng thái khi chưa có lịch. Bằng chứng: CATALOG: rollback.
- **B03 — PASS:** Tìm phim theo tên và trạng thái rỗng. Bằng chứng: GUI T05 tái sử dụng.
- **B04 — PASS:** Từ chối tên rỗng, thời lượng 0 và tuổi sai. Bằng chứng: CATALOG.
- **B05 — PASS:** Phim có lịch tương lai: chặn đổi thời lượng/trạng thái. Bằng chứng: CATALOG: SQL50504.
- **B06 — PASS:** Thể loại: tạo/sửa/ngừng, nhiều loại, thay/bỏ gán, quyền SQL. Bằng chứng: SQL10/GUI T07 tái sử dụng.
- **B07 — PASS:** Phim cũ không có thể loại vẫn đọc được. Bằng chứng: GUI danh sách + SQL10 T07.
- **B08 — NOT RUN:** Thêm/sửa/ngừng rạp và phòng đầy đủ qua GUI trong T08. Bằng chứng: Đã mở form; SQL05 kiểm ghi trong phạm vi, chưa đủ toàn bộ CRUD GUI.
- **B09 — PASS:** Phòng thiếu tên bị GUI từ chối. Bằng chứng: GUI thông báo Thiếu thông tin.
- **B10 — NOT RUN:** Thử riêng tên rạp/phòng trùng trên GUI. Bằng chứng: Chưa thực hiện.
- **B11 — PASS:** Có lịch chưa kết thúc: chặn ngừng rạp/phòng. Bằng chứng: CATALOG: SQL50506/50509.
- **B12 — PASS:** Tìm mã/tên phòng, rỗng và phạm vi chỉ xem. Bằng chứng: GUI/SQL08 T05 tái sử dụng.
- **B13 — PASS:** Tạo sơ đồ lặp không trùng; lô sai phạm vi không ghi dở. Bằng chứng: SQL05 + SQL04 T07 tái sử dụng.
- **B14 — NOT RUN:** Đổi loại/trạng thái ghế hợp lệ bằng GUI. Bằng chứng: Chưa thực hiện trong T08.
- **B15 — PASS:** Ghế hỏng không bán được. Bằng chứng: CATALOG: SQL50309, rollback.
- **B16 — PASS:** Ghế đang giữ/đã bán không sửa được. Bằng chứng: CATALOG + ca bổ sung: SQL50513.
- **B17 — PASS:** Tạo/sửa lịch và tự loại chính suất khi kiểm xung đột. Bằng chứng: SqlIntegration.
- **B18 — PASS:** Trùng lịch, dọn phòng, qua đêm, ngừng bán vẫn chiếm lịch. Bằng chứng: SqlIntegration.
- **B19 — PASS:** Sao chép lịch nguyên nhóm, nguồn đổi, cạnh tranh hai kết nối. Bằng chứng: SqlIntegration.
- **B20 — PASS:** Có đơn giữ: chặn sửa lịch. Bằng chứng: SQL02.
- **B21 — PASS:** Giá theo loại ghế/định dạng/ngày thường-cuối tuần. Bằng chứng: PricingIntegration.
- **B22 — PASS:** Chặn khoảng giá chồng, stale version và hai kết nối. Bằng chứng: PricingIntegration.
- **B23 — PASS:** Báo cáo dùng giá đã chốt sau khi sửa giá hiện tại. Bằng chứng: SQL09.
- **B24 — PASS:** Tạo F&B tiếng Việt bằng GUI; số lượng/thành tiền qua HTTP thật. Bằng chứng: GUI: sản phẩm 221 + WEBIT.
- **B25 — PASS:** Combo rỗng/lồng/ngừng thành phần/phiên bản không hợp lệ bị chặn. Bằng chứng: PricingIntegration.

### Nhóm C

- **C01 — PASS:** Quầy: chọn suất/ghế, giữ, thu, phát vé hoàn chỉnh. Bằng chứng: GUI: đơn 1250, vé A2.
- **C02 — NOT RUN:** Mua F&B trong giỏ quầy qua GUI đến hết thanh toán. Bằng chứng: F&B được kiểm riêng qua GUI danh mục/HTTP SQL.
- **C03 — PASS:** Vé + 2 combo tính đúng 140.000đ. Bằng chứng: WEBIT: 80.000 + 2 × 30.000.
- **C04 — PASS:** Đổi bộ lọc/phim xóa suất/ghế/tổng cũ. Bằng chứng: GUI T05 tái sử dụng.
- **C05 — PASS:** Khách đưa thiếu: chặn thu và không phát vé. Bằng chứng: GUI 70.000/80.000; SQL 0 thu/0 vé.
- **C06 — NOT RUN:** Nhập đúng bằng tổng tiền rồi xác nhận ngay trên GUI. Bằng chứng: Smoke tiền vừa đủ đạt; chưa thử GUI trường hợp này.
- **C07 — PASS:** Khách đưa thừa: tiền thừa đúng. Bằng chứng: GUI 100.000/80.000, trả 20.000.
- **C08 — PASS:** Hộp xác nhận đang mở: chưa ghi thu/vé. Bằng chứng: GUI + SQL đơn 1250: 0/0.
- **C09 — PASS:** Sau xác nhận: đúng một thu và một vé. Bằng chứng: GUI + SQL đơn 1250: 1/1.
- **C10 — PASS:** Gửi lại giữ/thanh toán không trùng. Bằng chứng: SQL01 + WEBIT + HTTP đơn 1249.
- **C11 — PASS:** Giữ ghế tại quầy thành công, khóa giỏ và hiện hạn. Bằng chứng: GUI đơn 1250.
- **C12 — PASS:** Tranh cùng ghế: chỉ một yêu cầu thành công. Bằng chứng: WEBIT hai khách; MIXED Web HTTP/quầy SQL.
- **C13 — PASS:** Đơn hết hạn bị từ chối thanh toán, Web hiện hết hạn. Bằng chứng: SQL02 + WEBIT.
- **C14 — PASS:** Hạn giữ thực tế ≤600 giây và không vượt giờ chiếu. Bằng chứng: Đối chiếu 4 đơn T08 trong SQL.
- **C15 — PASS:** Hủy chưa thanh toán giải phóng ghế. Bằng chứng: WEBIT + SQL01.
- **C16 — PASS:** Hoàn đơn khác chưa soát: đơn/vé/ghế đồng bộ. Bằng chứng: GUI + Web + SQL: đơn 1251.
- **C17 — PASS:** Vé đã sử dụng không được hoàn. Bằng chứng: SQL50334: đơn 1249.
- **C18 — PASS:** Hoàn thử lại cùng mã chỉ một dòng. Bằng chứng: SQL: đơn 1251, 1 dòng HoanTien.
- **C19 — PASS:** Soát vé Web đúng suất/phòng trong khung giờ. Bằng chứng: GUI: đơn 1249/997/1305, DA_SU_DUNG.
- **C20 — PASS:** Từ chối sai suất/phòng, dùng lặp, vé hủy và ngoài giờ. Bằng chứng: 31 ca SQL06 T03/T05 tái sử dụng.
- **C21 — PASS:** Xuất HTML QR từ GUI, không phát sinh thêm thu/vé. Bằng chứng: GUI đơn 1250; trước/sau 1 thu/1 vé.
- **C22 — NOT RUN:** Xuất/in lại liên tiếp hai lần trên GUI. Bằng chứng: Chưa thử lần xuất thứ hai.
- **C23 — NOT RUN:** Giải mã QR độc lập/thiết bị quét vật lý. Bằng chứng: Chưa có bộ giải mã/thiết bị; không suy PASS từ ảnh QR.
- **C24 — PASS:** GUID in trên phiếu Admin khớp vé SQL. Bằng chứng: 2d043c50-4de9-4996-8549-70a55f85897d.

### Nhóm D

- **D01 — PASS:** Thu/hoàn theo ngày giao dịch Việt Nam. Bằng chứng: GUI + SQL09.
- **D02 — PASS:** Từng suất theo ngày bắt đầu chiếu Việt Nam. Bằng chứng: GUI + SQL09.
- **D03 — PASS:** Lọc theo rạp. Bằng chứng: GUI: rạp 1139 + SQL09.
- **D04 — PASS:** Lọc theo phim. Bằng chứng: SQL09; GUI bộ chọn đã mở, chưa thử mọi tổ hợp.
- **D05 — PASS:** Tách vé/F&B/tổng thu/hoàn/thuần. Bằng chứng: SQL09; GUI:240.000/0/240.000/80.000/160.000.
- **D06 — PASS:** Ngày chỉ hoàn, thuần âm và biên ngày Việt Nam. Bằng chứng: SQL09.
- **D07 — PASS:** Nhiều vé/F&B không nhân đôi tiền khi JOIN. Bằng chứng: SQL09.
- **D08 — PASS:** Không tính lại giao dịch bằng giá hiện tại. Bằng chứng: SQL09.
- **D09 — PASS:** Hiệu quả phim và bắp nước theo cách tính cũ. Bằng chứng: SQL09 + GUI T06 tái sử dụng; không xem thuần là lợi nhuận.
- **D10 — PASS:** Quyền báo cáo/phạm vi rạp được kiểm tại SQL. Bằng chứng: SQL09.
- **D11 — PASS:** Tra chính xác mã đơn Web/quầy và tải lại sau hoàn. Bằng chứng: GUI:1251/1250.
- **D12 — PASS:** Biên phân trang/tìm mã giao dịch-vé. Bằng chứng: 24 ca SQL07 T04/T05 tái sử dụng.
- **D13 — FAIL:** CSV chỉ xuất các cột nghiệp vụ đang hiển thị. Bằng chứng: P2-01: còn PhienBan/TongKetQua.
- **D14 — FAIL:** Định dạng ngày nhất quán giữa các màn hình. Bằng chứng: P2-02: POS/đơn mm/dd, lịch/báo cáo dd/MM.
- **D15 — PASS:** Dữ liệu rỗng và tiếng Việt hiển thị không lỗi khởi tạo. Bằng chứng: GUI tổng quan/F&B/phòng/khách + CSV UTF8 BOM.

### Nhóm E

- **E01 — PASS:** Admin/Web thực tế dùng cùng database Test. Bằng chứng: DMV: YMC_T08_Admin PID24296, YMC_T08_Web PID6504.
- **E02 — PASS:** Phim tạo ở Admin xuất hiện trên Web. Bằng chứng: GUI phim 656 + Chrome /Phim/ChiTiet/656.
- **E03 — PASS:** Phim/suất/phòng/ghế/giá dùng chung. Bằng chứng: Chrome lịch997/998; HTTP sơ đồ997 và giá80.000.
- **E04 — PASS:** Web giữ A1, Admin tải thấy A1 disabled. Bằng chứng: HTTP đơn 1249 + GUI POS.
- **E05 — PASS:** Quầy/Web không bán trùng cùng ghế. Bằng chứng: MIXED: Web thua/quầy thắng; SQL50310 khi bán lại A1.
- **E06 — PASS:** Web mô phỏng trả tiền/phát QR; Admin tra/soát được. Bằng chứng: HTTP1249 + GUI kiểm vé + Chrome Đã sử dụng.
- **E07 — PASS:** Admin hoàn đơn Web khác, Web/SQL/ghế cập nhật. Bằng chứng: GUI1251 + Chrome Đã hoàn tiền + SQL A3 trống.
- **E08 — PASS:** Đơn gắn đúng khách; khách khác không xem đơn/lấy QR. Bằng chứng: WEBIT HTTP/SQL thật.
- **E09 — PASS:** Phạm vi Admin bảo vệ tại SQL dùng chung. Bằng chứng: SQL05/SQL09, không cấp thêm ADMIN.

## GUI Windows và giới hạn

Đã mở đủ 11 màn hình: Tổng quan, Phim, Rạp/Phòng, Lịch chiếu, Giá/F&B, Đơn, POS, Kiểm vé, Khách hàng, Nhân viên/Quyền, Báo cáo. Không thấy exception khởi tạo/resource/điều hướng. Có dữ liệu rỗng và tải lại sau tạo phim/F&B/hoàn. Việc mở được màn hình không thay cho nghiệm thu CRUD.

Form đã kiểm trực tiếp: thêm phim và lưu; thêm phòng và từ chối tên rỗng; thêm suất (Lưu khóa khi thiếu chọn); thêm F&B và lưu tiếng Việt; hoàn toàn đơn; chi tiết6 tab; lịch sử khách; dialog lưu CSV/HTML. GUI thể loại tái sử dụng bằng chứng T07, không nhận là chạy mới. Menu chuột phải chỉ xem ghế tái sử dụng T05; chưa kiểm mọi menu khác.

Kích thước capture Admin thực tế1172×850. Thử kéo đổi kích thước chưa cho được1366×768; không đánh PASS độ phân giải đó hoặc DPI125%. Chưa thử mất kết nối SQL rồi phục hồi khi đang có giỏ. Designer Visual Studio vẫn CHƯA XÁC MINH: giới hạn từ nghiệm thu refactor được giữ nguyên, không tự chỉnh namespace/partial/csproj.

Chrome đã xem phim/lịch tạo từ Admin, đơn đã hoàn, vé đã sử dụng và ảnh QR. Web mở xem trước in2 trang, có QR; đã hủy, không gửi job in. Admin lưu HTML QR, kiểm BOM/nội dung/ảnh nhúng, GUID khớp SQL và số thu/vé vẫn1/1. Khi mở thêm cửa sổ Chrome xem phiếu xuất, Chrome báo Application Error/Breakpoint0x80000003; HTML vẫn hiện phía sau. Chưa chứng minh lỗi do Admin. Không đánh PASS in giấy, lần in lại thứ hai hoặc giải mã QR độc lập.

## Số liệu tích hợp tiêu biểu

- Phim 656 được tạo bằng GUI Admin; rạp 1139/phòng 1305/8 ghế 2371–2378, định dạngT08_FMT, giá thường80.000/cuối tuần90.000. Suất 997 bắt đầu29/10/2026 01:11:45, kết thúc03:11:45; suất 998 lúc05:11:45. Dữ liệu phụ trợ tạo riêng trên Test.
- Web giữ A1 → đơn 1249, chủ tài khoản 1507/khách 5, GUI quầy khóa A1. Web mô phỏng trả tiền/retry →1 thu/1vé. GUID `da98938f-74f5-40df-8903-fa169810aa9d` soát bằng GUI Admin lúc00:51:16 VN, đúng khoảng[start−30min,end). SQL/Chrome đều hiện vé đã sử dụng.
- Quầy tạo đơn 1250/A2:70.000 bị chặn;100.000 trả20.000; trước xác nhận0 thu/0 vé, sau xác nhận1 thu/1 vé. Phiếu xuất có GUID `2d043c50-4de9-4996-8549-70a55f85897d` khớp SQL.
- Đơn Web1251/A3 được thanh toán riêng và chưa soát: GUI Admin hoàn80.000 với mãT08_REFUND_WEB_1251; đơnDA_HOAN_TIEN, véDA_HUY, ghếTrống. Web hiển thị đúng cả đơn và tiền hoàn. Retry vẫn1 dòng hoàn; hoàn đơn 1249 đã dùng bịSQL50334 từ chối.
- Báo cáo thu/hoàn GUI và SQL cho rạp 1139/phim 656: vé240.000,F&B 0,tổng240.000,hoàn80.000,thuần160.000; suất 997 có3 vé phát hành,1 hoàn,2 chưa hoàn; suất 998 chưa thanh toán không vào doanh thu. F&B nhiều dòng/khác ngày/giá đã đổi được đối chứng thêm bằng SQL09 và WEBIT.
- Đã dọn4 đơn 1249–1252,2 suất 997/998,phim/rạp/phòng/ghế/giá/F&B 221 và2 khách Test bằng ID+kèm nhãn. Cleanup kiểm phụ thuộc lạ trước khi xóa, có transaction/rollback. Đối chứng sau dọn:0 đơn fixture,0 tài khoản fixture. Không reset identity, không xóa Test database; dữ liệu trước T08 được giữ.

## Lỗi và việc chưa nghiệm thu

**P2-01 — CSV đơn hàng có cột kỹ thuật.** Vị trí `src/YeuMinhEmCinema.Admin/UI/AdminUi.cs:45` và `Helpers/CsvUtility.cs`. Tái hiện: Đơn → chọn rạpTest → tìm1251 → Xuất CSV. File đúng1 dòng đã lọc, UTF8BOM, nhưng còn `PhienBan="System.Byte[]"`, `TongKetQua="1"` dù bảng đã ẩn. Không sai tổng tiền, nhưng không đúng tập cột trình bày và gây nhiễu bàn giao. Đề xuất xuất bản sao gồm cột visible hoặc danh sách cột nghiệp vụ rõ ràng; không đổi procedure/hợp đồng Web. Chưa sửa.

**P2-02 — Ngày không thống nhất.** Vị trí `UserControls/UcBanVeTaiQuay.cs` và `UcDonDatVe.cs` (DateTimePicker Short); so với lịch/soát/báo cáo dùng dd/MM. Trên máy kiểm, POS hiện10/29/2026 và lọc đơn 10/22/2026, báo cáo29/10/2026. Có nguy cơ người dùng hiểu nhầm ngày/tháng ở ngày≤12. Đề xuất CustomFormat dd/MM/yyyy cho bộ lọc; không đổi cách lưuUTC/giờVN tạiSQL. Chưa sửa.

Chưa phát hiện P0/P1 trong ca đã kiểm; không suy ra toàn bộ hệ thống không có lỗi. Các NOT RUN ở trên, mất kết nối/phục hồi GUI, kích thước1366×768/DPI125%, Designer, QRdecode/thiết bị/in thật và lỗi Chrome môi trường vẫn cần xác minh. Không gán lỗi Chrome vào Admin/Web khi chưa có bằng chứng.

## Tracker và nội dung cần điều chỉnh Word sau T08

ADM-19 đủ bằng chứng điều kiện thu/phát vé/retry và được DONE. Các mục có thêm bằng chứng nhưng thiếu GUI/ca biên giữ PARTIAL; ADM-29/32 chưa đủ, giữ OPEN. ADM-30 có lỗiCSV nên không đóng. T08 là PARTIAL/chờ duyệt theo giới hạn công bố; T09 chưa triển khai.

Khi người dùng duyệt T09: mô tả đúng .NET10/ADO.NET/DAL+SQLguard thayAPI/EF/JWT; vai trò và phạm vi rạp thực tế;10 phút giữ trước giờchiếu; soát[start−30min,end);F&B/giá snapshot; vé phát sau thu, hoàn toàn đơn trước chiếu/chưa dùng; tách ngày thu/ngàychiếu, gross/refund/net≠profit; thể loại tùy chọn phimcũ; thanh toán Web chỉ môphỏng. Dùng bằng chứng GUI/HTTP/SQL trong tài liệu này và nêu rõ giới hạn. Word chưa sửa.

**Kết luận: ĐẠT CÓ GIỚI HẠN.** Luồng thu–vé–soát, hoàn đơn khác, dữ liệu chung và chống bán trùng đã kiểm thực tế theo các lớp nêu rõ. Hai lỗi P2 và các NOT RUN còn mở; dừng chờ duyệt, không commit/push hoặc chuyểnT09.
