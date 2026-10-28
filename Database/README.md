# YeuMinhEmCinema — bộ SQL cho Admin WinForms và Web C#

Đây là bộ database và stored procedure, không chứa mã C# và không thay thế ứng dụng hiện tại.
Nền tảng: SQL Server 2017 trở lên, compatibility level tối thiểu 140; SQL Server Express dùng được.
Tất cả SQL dùng UTF-8 BOM và N'...' cho văn bản tiếng Việt.

## Chạy trên máy bạn

1. Giải nén ZIP. Chép thư mục này vào `Database` của dự án, hoặc giữ riêng để đọc.
2. Đóng ứng dụng Admin/Web đang kết nối database.
3. Trong SSMS kết nối `.\SQLEXPRESS` bằng Windows Authentication.
4. Mở `CAI-DAT-TAT-CA.sql` bằng File → Open → File.
5. Nhấn F5 chạy TOÀN BỘ file. Không cần SQLCMD Mode, không cần chọn đoạn code.
6. Kết quả cuối phải có: `HOÀN TẤT CẤU TRÚC SQL. Dữ liệu mẫu chưa được thêm.`
7. Chạy `KIEM-TRA-CAI-DAT.sql`. Cột thiếu bảng/procedure phải không có dòng; các cột đếm là số thực tế trên máy.
8. Chạy `Scripts/20_KiemThu_NghiepVu.sql`: các truy vấn lỗi trả về 0 dòng là kết quả mong đợi.

File tổng tạo database nếu chưa tồn tại; nếu đã có thì giữ lại ID và dữ liệu.
Nó tạo bảng còn thiếu và cập nhật định nghĩa procedure/view/function. Nó không tự sửa cấu trúc bảng cùng tên có schema khác.
Nếu báo lỗi, gửi NGUYÊN THÔNG BÁO để kiểm tra; đừng xóa database đang dùng.
Các thay đổi cấu trúc trong một lần cài được đặt trong transaction; nếu thất bại sẽ rollback phần cài đặt.
Database mới được tạo trước transaction; nếu cài lỗi, database rỗng có thể vẫn tồn tại.
Việc tạo database và cập nhật cấu trúc cần tài khoản SQL có quyền tương ứng.

Không chạy riêng script 05 sau khi cài đủ rồi bỏ qua 22: file 22 nâng cấp kiểm tra liên quan đến đơn hàng.
Để áp dụng lại phiên bản này, chạy file tổng thay vì chọn ngẫu nhiên các file cũ.
Các cặp quyền mặc định chỉ gán ở lần đầu tạo VaiTro; cài lại không tự cấp lại quyền đã thu hồi.

## Database hiện tại đã có dữ liệu

Chỉ chạy file tổng và các câu kiểm tra. KHÔNG chạy lại seed chỉ để sửa font.
Không xóa rạp/phòng/loại ghế cũ, không đổi ID và không reset identity.
Các sửa lỗi tiếng Việt trước đây của bạn được giữ nguyên.
Nếu đã tạo file 10 từ nội dung chat trước đó, cấu trúc tương ứng được tái sử dụng.

## Database mới muốn có dữ liệu mẫu

Sau khi cài cấu trúc thành công, tùy chọn chạy lần lượt:

1. `Seed/01_DuLieuMau_Phim.sql`.
2. `Seed/02_DuLieuMau_Rap_Phong_Ghe.sql`.
3. `Seed/03_GiaVe_Fnb_Mau.sql`.

Seed là dữ liệu minh họa, không phải dữ liệu thật. Seed 03 chỉ có mẫu giá cho ghế thường và định dạng tìm được, chưa phủ toàn bộ VIP/Sweetbox/định dạng.
Hãy tạo bảng giá đủ các tổ hợp trước khi bán; hệ thống sẽ báo lỗi nếu thiếu giá.
Không có mật khẩu/admin mặc định. Khi làm C#, dùng PasswordHasher tạo chuỗi băm rồi gọi `sp_YMC_KhoiTaoAdmin` một lần.
Script không tự tạo SQL Login và không lưu mật khẩu gốc. Không dùng chuỗi hash X trong file kiểm thử để đăng nhập thực tế.

## Các file chức năng

| File Scripts | Chức năng |
|---|---|
| 00 | Database, phim |
| 01 | Rạp, phòng, loại ghế, ghế |
| 03 | Tra cứu dữ liệu rạp/phòng/ghế |
| 04–08 | Suất chiếu, xung đột, dọn phòng, sửa, đổi trạng thái, sao chép |
| 09 | Giá vé, menu bắp nước, combo, tra giá |
| 10 | Tài khoản, vai trò, quyền, kết quả đăng nhập |
| 11 | Khách hàng, nhân viên, phạm vi rạp, đăng ký, bootstrap admin |
| 12 | Đơn, chi tiết, giữ ghế, thanh toán, vé, hoàn tiền; kiểu TVP |
| 13 | Tạo đơn giữ ghế, dọn hết hạn, sơ đồ ghế |
| 14 | Ghi nhận thanh toán và xem chi tiết đơn |
| 15 | Hủy đơn chưa trả tiền, ghi nhận hoàn toàn bộ đơn |
| 16 | Xem/kiểm vé, ngăn kiểm hai lần |
| 17 | Thêm/sửa danh mục, đổi trạng thái tài khoản, đổi mật khẩu |
| 18 | Báo cáo thu/hoàn, doanh số phim, bắp nước |
| 19 | Danh sách phim/chi tiết/lịch Web, đơn cá nhân, danh sách đơn Admin |
| 20 | Truy vấn phát hiện vi phạm nghiệp vụ |
| 21 | Gán vai trò, sửa quyền, nhân viên, phân công rạp |
| 22 | Wrapper kiểm quyền cho lịch chiếu/giá/menu và tích hợp bảo vệ đơn |

Không có Scripts/02: dữ liệu mẫu được đặt duy nhất trong Seed để tránh chạy nhầm.
File tổng không chạy seed, không chạy các bài kiểm thử ghi dữ liệu và không tự bán vé.

## Quy tắc nghiệp vụ của phiên bản này

- Giờ suất chiếu là giờ Việt Nam (UTC+7) trong DATETIME2; ngày giao dịch/khóa/giữ ghế lưu UTC.
- Một đơn thuộc một suất, có 1–8 ghế và tối đa 20 dòng bắp nước, mỗi dòng 1–99 sản phẩm.
- Chưa hỗ trợ đơn chỉ mua bắp nước, tồn kho, khuyến mãi, điểm thưởng, ngày lễ hoặc nhiều lần trả tiền cho một đơn.
- Thứ Hai–Thứ Năm là ngày thường; Thứ Sáu–Chủ nhật là cuối tuần. Giá tính theo NGÀY CHIẾU.
- Sweetbox hiện là một MaGhe và một đơn giá; không tự nhân đôi. Khi thiết kế sơ đồ đôi sẽ chốt cách biểu diễn cùng bạn.
- Giá vé và bắp nước, tên phim/rạp/phòng/ghế, giờ chiếu, thành phần combo được chụp vào chi tiết đơn.
- Giữ ghế tối đa 10 phút, không vượt quá giờ bắt đầu chiếu. Giá đã chụp được giữ trong thời hạn này.
- Bảng GiuGhe có khóa chính (MaSuatChieu, MaGhe). Transaction và khóa ứng dụng tuần tự hóa việc đặt/thu/hoàn/kiểm vé.
- Dọn ghế hết hạn được gọi khi tạo đơn; sơ đồ tự xem ghế hết hạn là trống. C# có thể gọi dọn định kỳ khi hoạt động, không bắt buộc SQL Agent.
- Một MaYeuCau duy nhất cho một lệnh tạo đơn. Retry dùng lại mã cũ; thay nội dung phải tạo mã mới. Retry trả lại đơn gốc, không sửa đơn gốc.
- Một giao dịch thu thành công và tối đa một giao dịch hoàn toàn bộ trên mỗi đơn. Callback lặp cùng thông tin trả về kết quả cũ.
- Khách không tự xác nhận thanh toán. Quầy/backend tin cậy có quyền BAN_VE mới ghi nhận thu tiền.
- SQL chỉ GHI NHẬN kết quả thu/hoàn: không tự kết nối ngân hàng, không tự chuyển hay hoàn tiền.
- Xác thực chữ ký callback, số tiền, mã giao dịch và xử lý tiền đến sau hạn là việc của backend C# khi tích hợp cổng thật.
- Hoàn toàn bộ trước giờ chiếu nếu chưa có vé nào được sử dụng; hoàn gồm cả bắp nước của đơn. Không hỗ trợ hoàn một phần.
- Kiểm vào rạp từ 30 phút trước giờ bắt đầu đến trước giờ kết thúc. Vé kiểm rồi không kiểm lần hai.
- Đơn đang giữ còn hạn hoặc đã thanh toán chặn sửa/hủy suất. Muốn hủy suất đã bán, xử lý hoàn đơn trước.
- Không xóa vật lý danh mục có lịch sử. Sửa lịch/đổi trạng thái qua các procedure tương ứng.
- Báo cáo thu/hoàn tính theo ngày giao dịch; thống kê phim tính theo ngày chiếu. Tỷ lệ lấp đầy dùng sức chứa ghế đang hoạt động hiện tại, chưa phải snapshot lịch sử của cả phòng.
- Phân loại tuổi được lưu/hiển thị; xác minh tuổi người xem tại quầy là quy trình vận hành, chưa tự suy ra từ chủ tài khoản.

## Cách nối với C# sau này

Đọc `HUONG-DAN-CSharp.md`. Làm từng module, chưa cần sửa tất cả màn hình cùng lúc.
Các procedure mới bổ sung không tự nối vào nút hiện có. WinForms hiện tại vẫn phải được cập nhật DAL/sự kiện.
SQL phân quyền là tầng nghiệp vụ ứng dụng: backend lấy MaTaiKhoan từ phiên đã xác thực, KHÔNG lấy từ dữ liệu client tự khai.
Người có quyền dbo/sysadmin hoặc quyền ghi bảng trực tiếp vẫn có thể vượt procedure; bộ này không cấu hình một hệ thống SQL least-privilege độc lập.
Không đưa connection string hay mật khẩu SQL lên JavaScript. Web phải gọi backend C#.
Các procedure legacy 05–09 vẫn giữ để tương thích; code C# mới dùng wrapper ở file 22.

## Kiểm thử và mức xác nhận

`KET-QUA-KIEM-TRA.md` ghi những kiểm tra thực sự đã chạy và giới hạn.
Các test ghi dữ liệu chỉ chạy trên BẢN SAO database, từng file một:

- `Tests/01_LuongThanhCong.sql`: tạo đơn → thu → phát vé → kiểm vé, đơn khác → thu → hoàn; có kiểm retry; rollback fixture.
- `Tests/02_TuChoiNghiepVu.sql`: trùng ghế, sai tiền, sửa suất có đơn, kiểm vé lần hai, trả quá hạn, xem đơn người khác; rollback từng fixture.
- `Tests/03_KiemThuDongThoi.md`: hướng dẫn hai cửa sổ để kiểm tranh chấp ghế/callback.

Nếu test lỗi, gửi cả Messages. Không coi kiểm cú pháp là đã chạy thành công SQL Server.

## Nâng cấp Admin SQL 25

Sau khi đã cài SQL 23, chạy `Scripts/25_Admin_PhamViRap.sql` trên đúng database. Script chỉ cập nhật 6 thủ tục ghi danh mục, giữ nguyên tham số/result set; kiểm quyền rạp nguồn/đích và cả lô ghế. Tạo rạp mới và quản lý loại ghế dùng chung dành cho Admin. Không seed, không đổi mật khẩu, không đổi bảng dữ liệu. Có thể chạy lại.

`CAI-DAT-TAT-CA.sql` và `CAI-DAT-TEST.sql` đã kèm bản vá cuối file. Nếu chạy lại 17 hoặc 23 từ bản source cũ, phải áp dụng lại 25 sau cùng. Không cần SQL 24 của Web để áp dụng 25.

Hồi quy chỉ chạy trên database hậu tố `_Test`: `Tests/05_Admin_PhamViRap.sql` (25 ca, fixture rollback). Dùng `sqlcmd -I -b -f 65001` khi chạy từ terminal để bật QUOTED_IDENTIFIER và giữ Unicode.

## Nâng cấp Admin SQL 26 — soát đúng suất/phòng

Chạy `Scripts/26_Admin_SoatVeTheoSuat.sql` trên database đã có SQL 23 (và giữ bản vá danh mục 25). Không cần schema/seed mới hoặc SQL 24. Hai bộ cài tổng đã kèm 26 ở cuối. Mặc định USE database chính; với Test đổi USE cho đúng trước khi chạy.

- `sp_YMC_KiemTraVe` giữ ba tham số cũ và result set; thêm `@MaSuatChieu INT=NULL,@MaPhong INT=NULL` ở cuối. Nếu truyền, cả tra cứu lẫn xác nhận đều đối chiếu; sai suất trả 50343, sai phòng trả 50344, không cập nhật vé.
- Caller cũ bỏ hai tham số vẫn chạy theo hành vi cũ. Admin mới luôn bắt chọn suất rồi truyền cả suất/phòng; không tự suy ra suất đang soát từ vé.
- `sp_YMC_LaySuatSoatVe @NguoiThucHien,@Ngay=NULL` chỉ cần VE_KIEM_TRA, lọc quyền theo rạp, bỏ suất hủy và gồm suất qua đêm giao với ngày chọn. Không cần LICH_CHIEU_XEM. NULL ngày dùng ngày Việt Nam hiện tại.
- Giữ khóa giao dịch và khung vào -30 phút đến trước kết thúc; UPDATE chỉ nhận vé HIEU_LUC và kiểm số dòng. Tra cứu không đổi trạng thái, chưa áp khung thời gian xác nhận cho thao tác tra cứu.
- `Tests/06_Admin_SoatVeTheoSuat.sql`: 31 ca tự tạo/rollback fixture trên `_Test`, kiểm đúng/sai suất/phòng, caller cũ, vé hủy/chưa trả/hoàn, khung giờ, soát lặp, thu hồi quyền và danh sách suất.

## Nâng cấp Admin SQL 27 — tra cứu theo mã

`Scripts/27_Admin_ThuTien_TraCuuDon.sql` chỉ mở rộng sp_YMC_DanhSachDonAdmin; không đổi schema hoặc hợp đồng thanh toán. Cài trên database có SQL 23/25/26, không cần SQL 24 hoặc seed. Hai bộ cài mới đã kèm27; source19 đồng bộ riêng procedure Admin, các procedure Web trong file19 giữ nguyên.

Hai tham số cuối mới: `@TuKhoa NVARCHAR(100)=NULL,@TongKetQua INT=NULL OUTPUT`. Caller cũ không truyền vẫn dùng được; giữ một result set các cột đơn và TongKetQua. Từ khóa rỗng bỏ tìm; mã đơn BIGINT, GUID tham chiếu hoặc GUID vé và mã thu tiền được tìm chính xác (theo collation SQL cho chuỗi), không dùng wildcard. GUID chỉ chuyển khi đủ36 ký tự tránh cắt đuôi. Luôn kết hợp rạp, ngày tạo theo Việt Nam, trạng thái và quyền DON_HANG_XEM.

Tập đơn phù hợp được chụp vào bảng tạm một lần, trả output tổng ngay cả trang rỗng và sắp theo MaDonHang DESC. Admin dùng output để hiện tổng/trang, khóa biên và điều chỉnh khi tải lại trang vượt cuối. Đây không phải snapshot cố định xuyên nhiều lần bấm trang.

Tiền khách đưa/tiền thừa được tính trong WinForms, không lưu vào ThanhToan. SoTien ghi thu vẫn là tổng đơn; thiếu tiền chặn ở UI, SQL tiếp tục kiểm đúng tổng/hạn/quyền/retry như trước. Tests/07_Admin_TraCuuDon.sql có 24 ca rollback trên Test.
