# Class Diagram YeuMinhEm Cinema

Ngày thực hiện: 29/10/2026. HEAD trước phiên: `1934214566cc8f71d954b3a4359b041bc7148ee8`. Mã ứng dụng vẫn ở trạng thái commit `a217f8216aa606aaf0029b84f0c6997f0447652b`; các commit sau đó chỉ bổ sung tài liệu.

## Phạm vi và tệp bàn giao

- `21-Class-WinForms.drawio`: 13 trang, gồm một tổng quát và 12 hình chi tiết; bao phủ 57 kiểu khai báo của WinForms.
- `22-Class-Web.drawio`: 8 trang, gồm một tổng quát và 7 hình chi tiết; bao phủ 25 kiểu khai báo của Web.
- Các tệp cùng tiền tố có hậu tố số là từng trang draw.io và PNG xuất ở tỷ lệ 2x.
- `Class-inventory.json`: khai báo lớp, field/property, constructor/method, nguồn dòng và SHA-256 của 84 tệp C# thực tế; có cả thành phần Designer để truy vết.
- `Class-manifest.json`: ánh xạ lớp, thành phần được thể hiện và quan hệ vào từng hình; mỗi quan hệ có căn cứ tệp/dòng.
- `Class-QA.json`: kết quả kiểm tra bao phủ và đối chiếu thành phần.

Hai sơ đồ tổng quát chọn lớp trung tâm để dễ theo dõi. 19 hình chi tiết bao phủ đủ 82 kiểu tự định nghĩa, gồm cả record struct Tvp và các lớp/record lồng. Các phần partial được gộp; không tạo thêm lớp từ các bảng SQL. Hình trình bày các thuộc tính và phương thức chính, không liệt kê toàn bộ controls và hàm Designer. Danh sách khai báo đầy đủ được giữ trong inventory.

## Các điểm đối chiếu cần giữ

1. WinForms: DataPage là abstract class kế thừa UserControl. Chỉ sáu UserControl nghiệp vụ khai báo trực tiếp kế thừa DataPage; UcTongQuan kế thừa UcBaoCaoThongKe. UcRapPhongChieu, UcLichChieu và UcGiaVeVaFnb kế thừa trực tiếp UserControl.
2. FormSuatChieuBase là lớp thường kế thừa Form, không phải abstract class. FormThemSuatChieu và FormSuaSuatChieu kế thừa lớp này.
3. Db, các DAL và các tiện ích static được đánh dấu đúng; thành phần static được gạch chân. Tvp được biểu diễn là record struct, không phải entity giao dịch.
4. TaiKhoanDAL tự tạo SqlConnection. SuatChieuDAL và GiaVeFnbDAL có hàm kết nối/đọc riêng và dùng Db để lấy người thao tác hoặc kiểm quyền. Các DAL khác như GiaoDichDAL, PhimDAL, RapDAL, PhongChieuDAL và GheDAL dùng các hàm Db. Không mô tả mọi truy cập SQL đều đi qua Db.Read.
5. Web: năm controller kế thừa Controller, giữ tham chiếu tới data qua constructor injection. PhimData, TaiKhoanData và DatVeData giữ WebDb. TrangChuData nhận IConfiguration và tự mở SqlConnection trong TaoKetNoi; không giữ WebDb.
6. DangKyModel kế thừa DangNhapModel; KhachHangSession kế thừa CookieAuthenticationEvents. WebErrors hiện thực IExceptionFilter, dùng đường realization nét đứt và tam giác rỗng.
7. TrangChuViewModel giữ các danh sách Phim/Rap; DatVeModel giữ List<FnbChon>. DonModel, LichSuModel và LichModel chứa tập kết quả ADO.NET. Không gán trách nhiệm lưu SQL cho view model.
8. HienThi được gọi trong các Razor View để định dạng dữ liệu. Không tạo quan hệ controller–HienThi nếu source C# không có lời gọi tương ứng.
9. Cả hai ứng dụng chia sẻ SQL Server và hợp đồng procedure; không có lớp C# của WinForms gọi lớp Web hoặc ngược lại.

## Quan hệ UML

- Kế thừa: nét liền, tam giác rỗng hướng về lớp cha.
- Hiện thực interface: nét đứt, tam giác rỗng hướng về interface.
- Tham chiếu giữ trong field/property: liên kết có hướng nét liền.
- Gọi hàm, tạo đối tượng hoặc dùng kiểu: phụ thuộc nét đứt.
- Không suy diễn composition/aggregation và lực lượng quan hệ từ khóa ngoại SQL.
- Ô xám là lớp tham chiếu hoặc kiểu framework; các bảng/lớp được lặp giữa các hình để đọc theo nhóm.

## Kiểm tra

Sử dụng Roslyn để đọc khai báo và phân giải kiểu/lời gọi của hai ứng dụng. Bộ phân tích chạy trong thư mục tài liệu riêng, không build hoặc sửa project ứng dụng. Cấu hình phân tích bổ sung implicit usings và stub cho ApplicationConfiguration được .NET sinh; stub không đi vào inventory hay sơ đồ. Không còn lỗi phân giải trong cấu hình phân tích.

Kiểm tra đủ 82 kiểu khai báo xuất hiện trong hình chi tiết, 438 thành phần được chọn đều khớp inventory và toàn bộ 37 quan hệ kế thừa/hiện thực khai báo trực tiếp đều có hình thể hiện. Mỗi quan hệ dùng trong sơ đồ được truy vết về source. Kiểm tra ảnh xuất và bố cục PDF trên Google Docs trước khi chốt.

Báo cáo được cập nhật trực tiếp tại https://docs.google.com/document/d/1hDL_3iifGChbgmfrZx9s-QtM2gAU6ksF1o17qEAWMr8 . Các hình Class dùng số 3.28–3.48; kiến trúc được đổi thành 3.49. Mã và tên 66 mục Sequence được giữ nguyên.

Không chỉnh sửa source C#, SQL hay dữ liệu trong phiên tài liệu này.
