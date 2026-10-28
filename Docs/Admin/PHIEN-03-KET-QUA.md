# Kết quả phiên 3: soát vé đúng suất/phòng

Ngày 28/10/2026, nền commit ed8b4a2. Chỉ WinForms Admin và SQL phục vụ soát vé; chưa commit/push phiên này.

## Đối chiếu trước triển khai

Đã đọc lại `C#_Nhóm1.docx` đúng trong C_SHARP, SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853. UC05 và 5.5.3 yêu cầu chọn suất đang soát, vé đúng suất, chưa dùng và trong thời gian cho phép. Nhánh thay thế hình 5.8 yêu cầu chặn sai suất và chỉ cập nhật vé chưa dùng. Giữ .NET10/ADO.NET/SQL, giữ khung -30 phút đến trước giờ kết thúc theo quyết định D05; chưa chỉnh file Word.

## Thay đổi đã làm

- Form Kiểm tra vé có chọn ngày, Tải suất và danh sách hiển thị mã suất/rạp/phòng/giờ/phim. Không tự chọn suất đầu tiên. Chưa chọn suất thì khóa Tra cứu/Xác nhận. Enter tra cứu, không tự soát.
- Lấy suất bằng sp_YMC_LaySuatSoatVe: quyền VE_KIEM_TRA, đúng phạm vi rạp; không đòi quyền quản lý lịch, bỏ suất hủy và lấy cả suất hôm trước còn chiếu trong ngày chọn.
- sp_YMC_KiemTraVe thêm hai tham số cuối @MaSuatChieu/@MaPhong mặc định NULL. Nếu truyền, cả tra cứu/xác nhận đều kiểm; lỗi 50343/50344 khi không khớp. Admin mới luôn truyền cả hai. Caller cũ bỏ tham số vẫn dùng được, result set giữ nguyên.
- Giữ khóa giao dịch, guard thời gian/đã trả/quyền. UPDATE thêm điều kiện HIEU_LUC và kiểm số dòng. Tra cứu không tự ghi sử dụng và vẫn tra được thông tin vé hợp lệ ngoài giờ vào như hành vi cũ.
- Hộp xác nhận nêu lại suất/phòng. Đổi suất/ngày/tải lại/nhập mã mới xóa kết quả cũ tránh nhầm. Giữ ô mã sau tra cứu sai để người soát sửa lựa chọn.
- Source SQL16 đồng bộ kiểm vé; SQL26 là nâng cấp đầy đủ kèm list mới. Hai bộ cài tổng kèm SQL26 sau25. Không đổi schema, Web, framework hay chính sách vai trò mặc định.

## Kiểm thử thực tế

- Trước nâng cấp, SQL06 lỗi “too many arguments” vì server chưa có hợp đồng mới; đây là kiểm xác nhận cần nâng cấp, không tuyên bố là ca sai suất đã chạy trên mã cũ.
- Sau SQL26: 31/31 ca đạt. Có đúng/sai suất cùng phòng, sai phòng cùng rạp, ID không tồn tại, tra/xác nhận, caller cũ/optional, vé dùng/hủy/không có, đơn chưa trả/hoàn, suất hủy, cửa vào quá sớm/đã hết, sau giờ chiếu 20 phút vẫn được vào theo luật hiện tại, thu hồi rạp/quyền, khóa tài khoản/ngừng việc, Admin và nhân viên chỉ SOAT_VE, danh sách có suất qua đêm/bỏ hủy/lọc rạp. Trạng thái từ chối được dựng trong transaction để kiểm guard, không thay thế kiểm luồng hoàn tiền riêng.
- SQL26 chạy lại không lỗi. Cài mới đầy đủ ở YMC_CheckinInstall_8aaa1858_Test và chạy 31/31 ca đạt, sau đó xóa đúng database tạm. Không xóa database Test người dùng.
- Hồi quy SQL01 bán/thanh toán/phát vé/soát/hoàn, SQL02 từ chối nghiệp vụ, SQL04 quyền/ghế, SQL05 25 ca phạm vi Admin đều đạt; fixture rollback.
- Build Admin: 0 lỗi/0 cảnh báo. AdminSmoke đạt. Kết quả .NET ở output công cụ, không có log tệp kèm.
- GUI bản bin/AdminCheckin sau người dùng đăng nhập: trạng thái không có suất, hai nút khóa khi chưa chọn; sai suất cùng phòng bị từ chối rõ; đổi về đúng suất tra ra vé HIEU_LUC, xác nhận thành DA_SU_DUNG; nhập lại/Enter bị chặn đã dùng. SQL kiểm trạng thái sau GUI rồi dọn đúng fixture.
- Đã xem bố cục thường khoảng1172×850 và phóng to1536×816 qua capture công cụ; controls không đè nhau trong hai kích thước đó. Chưa xác nhận mọi DPI hay máy quét USB vật lý. Không lưu PNG vào repo.

Log SQL thật nằm ở evidence/2026-10-28/session-03. Fixture GUI tạm đã dọn; không có tài khoản/mật khẩu thực tế được thêm vào repo. Chưa thử hai GUI soát đồng thời; khóa transaction hiện có được giữ nguyên.

## Áp dụng và trạng thái

Máy đã có SQL23/25: chạy Database/Scripts/26_Admin_SoatVeTheoSuat.sql trên đúng database, rồi chạy Admin mới. Không seed; SQL24 Web không phải điều kiện. Với Test đổi dòng USE. Database Test local đã áp dụng; database chính/máy nhóm chưa được nâng cấp tự động.

T03/ADM-24 DONE. ADM-23 PARTIAL vì còn sửa mô tả khung +15 phút trong DOCX ở T09; guard sản phẩm đã kiểm. T04–T07 chưa triển khai, kế tiếp T04 tiền khách đưa/tra cứu giao dịch; demo và sửa báo cáo sau đó. Chưa commit/push, chỉ thực hiện khi có lệnh mới của người dùng.
