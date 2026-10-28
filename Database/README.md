# YeuMinhEmCinema — SQL Server cho Admin WinForms và Web

Giữ nguyên cấu trúc Scripts/Seed/Tests và các đường dẫn hiện có. SQL Server 2017 trở lên, compatibility level tối thiểu140; văn bản SQL UTF-8, dùng N'...' cho tiếng Việt.

## 1. Cài đặt database mới

1. Trong SSMS, kết nối đúng SQL Server; chọn một bộ cài: `CAI-DAT-TAT-CA.sql` cho YeuMinhEmCinema, hoặc `CAI-DAT-TEST.sql` cho YeuMinhEmCinema_Test.
2. Đọc tên database trong các dòng USE/CREATE DATABASE trước khi chạy. Chạy toàn bộ file bằng F5, không cần SQLCMD Mode. Không chạy đồng thời với ứng dụng hoặc một lần cài khác.
3. Đợi hết file, kiểm tra lỗi ở Messages. Thông báo “HOÀN TẤT CẤU TRÚC SQL” nằm trước các phần nối thêm; chỉ thấy dòng đó chưa chứng minh toàn bộ file đã thành công.
4. Chạy `KIEM-TRA-CAI-DAT.sql` sau khi chọn đúng USE (với Test đổi thành YeuMinhEmCinema_Test). Các tập thiếu bảng/procedure/function/view/kiểu bảng phải rỗng. Script chỉ kiểm sự tồn tại, không chứng minh đủ hành vi/tham số nghiệp vụ.
5. Seed là tùy chọn, thực hiện riêng theo mục3. Không có tài khoản/mật khẩu Admin mặc định; khởi tạo qua ứng dụng theo hướng dẫn hiện có.

Hai bộ cài tổng chứa phần nền00–22 cần thiết, SQL23 và25–30. Không tự chạy seed hoặc các bài thử ghi dữ liệu. SQL24 thanh toán mô phỏng Web được cài riêng, không mặc định nằm trong hai bộ cài tổng.

Giới hạn transaction: phần nền có transaction riêng và COMMIT trước các phần nối thêm từ SQL23; database được tạo trước transaction đó. Lỗi ở phần sau không bảo đảm rollback mọi phần đã thành công trước đó. Kiểm tra toàn bộ Messages và các đối tượng còn thiếu; không xóa database để thử lại.

## 2. Nâng cấp database hiện có

Xác định mức SQL đang có trước khi chọn bản nâng cấp; sao lưu theo quy trình của nhóm và đóng ứng dụng khi triển khai. Trong phiên kiểm thử chỉ dùng Test. Không chạy seed để sửa font hoặc nâng cấp; không xóa/reset ID hay ghi đè dữ liệu hiện có.

Với database đã có nền00–22, thứ tự nâng cấp Admin thống nhất là:

`23 → 25 → 26 → 27 → 28 → 29 → 30`

- SQL23: hoàn thiện WinForms, phạm vi rạp, thao tác khách/ghế/quyền và guard phân quyền.
- SQL25: vá quyền/phạm vi các thao tác ghi danh mục, kể cả lô ghế.
- SQL26: soát vé theo suất/phòng và danh sách suất soát.
- SQL27: mở rộng tra cứu đơn; tiền khách đưa được kiểm trong C#, không tạo schema tiền mặt mới.
- SQL28: tìm kiếm nhân viên, phòng và suất tại quầy.
- SQL29: báo cáo thu/hoàn chi tiết, phim và từng suất.
- SQL30: thể loại phim, quan hệ gán nhiều thể loại và procedure Admin; phim cũ không bắt buộc gán.

Chỉ áp dụng phần còn thiếu sau mức đã xác nhận. SQL24 (`Scripts/24_Web_MoPhongThanhToan.sql`) là phần Web cài riêng sau nền/phân quyền cần thiết, không phải điều kiện của chuỗi25–30; tham khảo hướng dẫn Web hiện có. Không tự bổ sung SQL24 vào bộ cài trong lần chuẩn hóa này.

Không chạy lại riêng các file cũ rồi bỏ qua bản vá mới:17 có thủ tục được25 cập nhật,16 được26 cập nhật,19 được27 cập nhật,18 được29 cập nhật;11/15/22 cũng liên quan tích hợp23. Không chạy hàng loạt mọi file trong Scripts theo tên. Nếu cần áp dụng lại bộ cài tổng theo hướng dẫn hiện có, phải đọc toàn bộ lỗi và kiểm tra các phần nối thêm như mục1; bộ cài không tự sửa mọi schema cùng tên nhưng khác cấu trúc.

Các script nâng cấp mặc định USE YeuMinhEmCinema; khi thử phải đổi bản chạy sang đúng Test trước khi thực thi. Vai trò/quyền mặc định không được tự cấp lại chỉ vì cài lại. Không đưa mật khẩu, SQL Login hoặc dữ liệu mẫu tài khoản vào luồng nâng cấp.

## 3. Dữ liệu mẫu — chỉ dùng khi chủ động chọn

Nguồn seed chính thức nằm trong `Seed/`, không thuộc luồng nâng cấp. Sau khi cấu trúc đã cài thành công, có thể chạy theo thứ tự:

1. `Seed/01_DuLieuMau_Phim.sql`.
2. `Seed/02_DuLieuMau_Rap_Phong_Ghe.sql`.
3. `Seed/03_GiaVe_Fnb_Mau.sql` (cần phần giá/menu SQL09 và dữ liệu loại ghế/phòng phù hợp).
4. `Seed/25_PhimDemo_Web.sql` là lựa chọn bổ sung16 phim hư cấu phục vụ giao diện Web; số25 không phải bản vá Admin SQL25.

Các seed mặc định USE database chính: phải kiểm tên đích, và chỉ dùng bản trỏ Test khi thử. Giá mẫu chưa phủ hết mọi loại ghế/định dạng; cần đủ bảng giá trước khi bán. Không chạy seed trên dữ liệu thật trong phiên kiểm thử.

`Scripts/02_DuLieuMau_Rap_Phong_Ghe.sql` là bản trùng nội dung với Seed/02, đang giữ để tương thích. Chọn Seed/02, không chạy thêm bản Scripts/02 trong cùng quy trình.

## 4. Kiểm tra chỉ đọc

- `KIEM-TRA-CAI-DAT.sql`: bảng/procedure/function/view/TVP còn thiếu; thống kê vai trò, quyền, tài khoản. SQL24 được hiển thị riêng như thành phần Web tùy chọn.
- `KIEM-TRA-WINFORMS.sql`: kiểm một số đối tượng hỗ trợ WinForms/SQL23, không thay thế kiểm tra cài đặt đầy đủ.
- `KIEM-TRA-LOI-TONG-QUAN.sql`: chẩn đoán truy vấn Tổng quan.
- `Scripts/03_KiemTraDuLieu.sql`: tra cứu dữ liệu rạp/phòng/ghế.
- `Scripts/20_KiemThu_NghiepVu.sql`: truy vấn phát hiện vi phạm; tập lỗi rỗng là kết quả mong đợi.

Các file trên không ghi dữ liệu nghiệp vụ, nhưng vẫn phải kiểm dòng USE. Kiểm đối tượng tồn tại không đồng nghĩa đã nghiệm thu giao diện hoặc toàn bộ nghiệp vụ.

## 5. Kiểm thử có tạo dữ liệu tạm

`Tests/01_LuongThanhCong.sql`, `02_TuChoiNghiepVu.sql` và04–10 tạo fixture/thay đổi trạng thái hoặc quyền trong kiểm thử; chỉ chạy trên database có hậu tố `_Test`. Mặc định là YeuMinhEmCinema_Test. Từng ca dùng rollback/dọn fixture theo cơ chế sẵn có. Rollback không hoàn lại số identity đã cấp.

Tests01/02 kiểm hậu tố database trước khi ghi; riêng02 kiểm từng batch vì SSMS có thể tiếp tục sau lỗi ở một batch GO. Với sqlcmd dùng `-I -b -f 65001` để giữ QUOTED_IDENTIFIER, dừng khi lỗi và đọc UTF-8. Không đổi USE sang database thật hoặc bỏ guard. `Tests/03_KiemThuDongThoi.md` là hướng dẫn kiểm nhiều phiên, cũng chỉ trên bản Test.

Chạy đúng bài liên quan thay đổi; không tự chạy toàn bộ chỉ vì sắp xếp hướng dẫn. Hash X trong fixture không phải tài khoản đăng nhập thực tế. Kết quả cũ ở `KET-QUA-KIEM-TRA.md` và các nhật ký hiện có chỉ chứng minh phạm vi đã ghi nhận.

## 6. Script lịch sử và nguồn SQL hiện hành

- `Scripts/00_Full_Setup_Rap_Phong_Ghe.sql`: file gộp cũ cho rạp/phòng/ghế, kèm seed; không phải bộ cài đầy đủ hiện tại. Giữ nguyên file, không dùng thay CAI-DAT-TAT-CA/CAI-DAT-TEST hoặc chạy kèm bộ cài mới.
- Scripts02 là bản seed trùng, dùng nguồn chính thức trong Seed như mục3.
- Các script nền00/01/04–19/21–22 vẫn cần để dựng nền hoặc đối chiếu, không xóa vì procedure được định nghĩa lại ở bản nâng cấp. Scripts03/20 thuộc nhóm chỉ đọc.
- Hai bộ cài nhúng SQL, không đọc các script con bằng đường dẫn lúc chạy. Khi có thay đổi SQL được duyệt sau này phải giữ đồng bộ nguồn và cả hai bộ cài; phiên này không đổi nội dung bộ cài hay đối tượng nghiệp vụ.

Giữ SQL Server, ADO.NET và các hợp đồng dùng chung Admin/Web. Chi tiết nghiệp vụ và từng bản nâng cấp đã có ở các mục dưới.

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

## Nâng cấp Admin SQL 28 — tìm kiếm

Chạy Scripts/28_Admin_TimKiem.sql trên database đã có SQL 23/25/26/27 rồi chạy Admin mới; đổi USE cho Test. Không seed/schema mới/SQL 24. Hai bộ cài tổng đã kèm cùng định nghĩa SQL 28.

- sp_YMC_TimNhanVienAdmin: kiểm NHAN_VIEN_QUAN_LY; tìm tên đăng nhập/họ tên/SĐT bằng CHARINDEX hoặc mã nhân viên/mã tài khoản chính xác bằng TRY_CONVERT. Giữ phạm vi quản trị nhân sự toàn cục của màn hình cũ; không tự cấp quyền này cho quản lý rạp. Hồ sơ/tài khoản và rowversion vẫn riêng.
- sp_YMC_TraCuuPhongAdmin: kiểm RAP_XEM; lọc fn_YMC_CoPhamViRap, mã/tên phòng, rạp tùy chọn; gồm cả phòng ngừng hoạt động để tra lịch sử. Cột/sức chứa tương đương truy vấn DAL trước.
- sp_YMC_TimSuatTaiQuay: kiểm BAN_VE và rạp, lọc tên phim theo chuỗi literal, ngày, suất Mở bán/chưa bắt đầu, phim Đang chiếu, rạp/phòng hoạt động. Không tự thay quy tắc giá hoặc giữ ghế.

Đây là ba procedure đọc mới, không đổi hợp đồng procedure cũ, không sửa quyền mặc định hoặc thủ tục ghi. Nút bị khóa chỉ hỗ trợ UI; các procedure ghi vẫn kiểm quyền/phạm vi tại SQL. Test08 có 34 ca riêng lẻ tự rollback dữ liệu và thay đổi quyền.

## Nâng cấp SQL 29 — báo cáo trong module hiện có

Áp dụng Scripts/29_Admin_BaoCaoPhimSuat.sql sau SQL 23/25/26/27/28; đổi USE khi dùng Test. Không seed/đổi schema giao dịch/SQL 24. Hai bộ cài mới đã đồng bộ29. Chỉ database Test local được nâng cấp trong phiên T06.

- Ba procedure cũ trong SQL 18 thêm tham số cuối @MaPhim INT=NULL. Caller bốn tham số, các cột và ý nghĩa không đổi. Hiệu quả phim vẫn dùng ngày chiếu, đơn DA_THANH_TOAN và bỏ suất hủy; F&B vẫn theo ngày thu và loại đơn hiện đã hoàn, kể cả hoàn sau kỳ xem.
- sp_YMC_BaoCaoThuChiTiet: nhóm theo ngày thu/hoàn UTC+7. ThuVe=SUM(ChiTietVe.DonGia), ThuFnb=SUM(SoLuong*DonGia) của chi tiết đã chốt thuộc các đơn có giao dịch thu trong ngày. TienDaThu lấy ThanhToan.SoTien; TienDaHoan lấy HoanTien.SoTien theo ngày hoàn; DoanhThuThuan=thu−hoàn. Thu đã có vẫn được ghi nhận dù đơn được hoàn sau này. Ngày chỉ hoàn có thể âm.
- sp_YMC_BaoCaoTheoSuat: lọc ngày bắt đầu chiếu VN, một dòng/suất kể cả suất hủy, cộng lũy kế thu/hoàn của các đơn thuộc suất. Đơn chưa trả không tính. Vé phát hành/hoàn/chưa hoàn dựa các dòng vé của đơn đã thu và hoàn toàn đơn hiện có; không có hoàn từng vé/phần lẻ trong phiên này.
- sp_YMC_LayPhimBaoCao: danh sách phim có suất trong rạp đã được kiểm quyền; gồm phim cũ/ngừng để tra cứu lịch sử.
- Cả sáu procedure đều kiểm BAO_CAO_XEM và MaRap tại SQL trước khi trả dữ liệu. Lọc phim không nới phạm vi rạp. Không ghi dữ liệu nghiệp vụ khi xem báo cáo.

Chi tiết vé và F&B được tổng hợp riêng từng đơn trước khi join với giao dịch duy nhất mỗi đơn, tránh nhân nhiều vé×nhiều F&B. Không dùng bảng giá hiện tại hoặc thành phần combo để tính lại tiền đã thu. Khoản hoàn là toàn đơn gồm vé/F&B, không tự phân bổ thành hai khoản hoàn giả. Thuần ở đây là thu trừ hoàn, chưa phải lợi nhuận sau chi phí.

Không cộng chéo kết quả theo ngày thu với kết quả theo ngày chiếu. Từng suất là số lũy kế hiện tại cho tập suất đã chọn, không phải báo cáo đóng sổ theo thời điểm quá khứ. Tên phim/phòng và sức chứa báo cáo cũ vẫn theo danh mục hiện tại; tiền dùng snapshot/giao dịch đã chốt. Chưa đo hiệu năng trên dữ liệu lớn.

## SQL30 — thể loại phim cho Admin

Sau các script hiện có đến29, áp dụng `Scripts/30_Admin_TheLoaiPhim.sql`; đổi USE thành database Test khi thử. Hai bộ cài tổng đã kèm30. Chỉ Test local đã nâng cấp trong T07; không tự chạy trên dữ liệu thật.

Tạo thêm TheLoai (tên UNIQUE không phân biệt hoa/thường, mô tả, DangSuDung), PhimTheLoai (PK ghép,FK không cascade), YMC_DanhSachTheLoai và5 proc mới: LayTheLoaiAdmin/LuuTheLoai/LayTheLoaiCuaPhim/GanTheLoaiPhim/LayPhimKemTheLoaiAdmin (đều tiền tố sp_YMC_). Đọc kiểm PHIM_XEM, ghi kiểm PHIM_QUAN_LY; không cấp quyền mới. Danh mục chung như phim, không theo rạp.

Tên trim, tối đa100 ký tự; mô tả1000; không trùng kể cả đã ngừng. Phim cũ để trống hợp lệ. Ngừng giữ liên kết cũ, không cho gán mới; sử dụng lại được. Gán tập thể loại bằng TVP trong transaction và khóa YMC_Genre_Write. Không có UI xóa vật lý; không có rowversion chống ghi đè danh mục. Không đổi bảng Phim/giao dịch hoặc hợp đồng procedure Web/lưu phim cũ.

Test10 có37 ca rollback; trước/sau upgrade giữ nguyên đối tượng/dữ liệu được audit. Chi tiết Docs/Admin/PHIEN-07-KET-QUA.md.
