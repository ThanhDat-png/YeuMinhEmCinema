# Đối chiếu Admin với báo cáo

Mốc ngày 28/10/2026, commit `5a0ee37`. Tập trung hoàn thiện WinForms Admin trong hôm nay. Hồ sơ này là danh sách thực hiện, chưa phải biên bản nghiệm thu sản phẩm.

## Nguồn đang áp dụng

Đúng bản `C#_Nhóm1.docx` trong thư mục C_SHARP: 632 khối văn bản/bảng, 8 chương và phụ lục; SHA-256 `329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853`.
Đề bài `De tai mon Ngon ngu lap trinh CSharp - 2026.docx`: SHA-256 `e6c3597ca806dd8c11628351470b601c8cf0063b49780feb825c2b7546c61365`.

Bản `C#_Nhom1.docx` không dấu, 599 khối/45 UC, là bản người dùng xác nhận gửi nhầm. Các nhận định tồn kho, Web nhân viên hoặc doanh thu nhân viên từ bản đó không được dùng để bổ sung chức năng trong phiên này. Không sửa hai file Word gốc trong Phiên 1.

Không dùng số trang từ mục lục làm định vị đã xác minh. Các tham chiếu dưới đây dùng tên mục/UC trong đúng tài liệu.

## Quyết định phạm vi

### D01 Giữ nền tảng hiện tại

.NET 10, WinForms, Microsoft.Data.SqlClient/ADO.NET, SQL Server và stored procedure. Không hạ .NET hoặc viết lại EF/API/JWT.

### D02 Giới hạn trách nhiệm

Phạm vi hôm nay là WinForms Admin và SQL phục vụ Admin. Web/tài khoản/đặt vé phía khách do người khác đảm nhận; chỉ ghi nhận điểm tích hợp cần phối hợp.

### D03 Giữ cấu trúc dữ liệu dùng chung

Không đổi tên bảng/cột tiếng Việt thành schema tiếng Anh trong báo cáo; không chuyển sang ShowtimeSeats/EF để khớp ERD. Vẽ lại tài liệu theo bảng hiện có.

### D04 Giữ hạn giữ ghế

Tối đa 10 phút và không vượt giờ chiếu theo SQL hiện tại; chỉnh mô tả 5 phút trong báo cáo. Không đổi quy tắc chung chỉ cho riêng Admin.

### D05 Giữ thời gian cho vào rạp

Từ 30 phút trước giờ bắt đầu đến trước giờ kết thúc như SQL hiện tại. Điểm cần bổ sung là kiểm đúng suất/phòng được chọn, không đổi mốc chung sang +15 phút hôm nay.

### D06 Giữ danh mục và giá dùng chung

Phim, bảng giá/F&B hiện có dữ liệu dùng chung. Không cấp quyền sửa toàn cục cho QUAN_LY để giả lập quản lý theo rạp; ghi đúng ma trận thực tế, tách chỉ xem khi phù hợp.

### D07 Giữ nguyên lịch sử và tiền đã chốt

Dùng ngừng hoạt động/đóng bán, không xóa dữ liệu đã tham chiếu. Thanh toán/hoàn chỉ ghi nhận và phải rõ là không tích hợp ngân hàng.

### D08 Bổ sung nhỏ phải tương thích

Ưu tiên UI, bộ lọc, truy vấn chỉ đọc và kiểm quyền. SQL mới/mở rộng phải có script áp dụng, ca rollback và kiểm lời gọi cũ; không tự đổi hợp đồng Web.

### D09 Thể loại chưa được coi là đã có

Đây là thiếu thật trong bản đúng. Giữ ở backlog P2, chỉ bổ sung additive không làm Web phải đổi. Nếu chưa làm trong ngày, báo cáo phải ghi rõ giới hạn; không xóa dấu vết thiếu để đánh đạt.

### D10 Loại bỏ bản gửi nhầm

Không lấy 45 UC, tồn kho, Web cho nhân viên hoặc doanh thu theo nhân viên của C#_Nhom1.docx gửi nhầm làm yêu cầu hôm nay. Chỉ dùng C#_Nhóm1.docx hash 329d4cf1… và đề bài hash e6c3597c….

## Cách đọc trạng thái

OPEN là mục chưa đóng. Sau phiên sửa, DONE chỉ áp dụng đúng phạm vi đã kiểm chứng; PARTIAL là còn phần chưa làm. `KIEM_THU`/`GIU_VA_KIEM_THU` nghĩa là đã có code hoặc bằng chứng trước, còn cần nghiệm thu phù hợp. `SUA_ADMIN` là lỗi hoặc hành vi cần chỉnh; `BO_SUNG_ADMIN` là thiếu có thể làm trong phạm vi Admin; `SUA_BAO_CAO` là giữ sản phẩm và sửa cách mô tả; `THIEU_CO_DIEU_KIEN` vẫn là thiếu, không phải đã hoàn thành.

P1 là phải ưu tiên trước demo; P2 làm sau khi P1 ổn định. Không hoàn thành P1 thì không dành thời gian viết lại kiến trúc hay thêm phần mở rộng. Không kết luận phần thiếu là đạt chỉ vì đã bỏ mô tả khỏi báo cáo.

## Danh sách đối chiếu

### ADM-01 Đăng nhập và mật khẩu

- Báo cáo: 4.1.1; 4.3.2; 6.2.3 ca 8.
- Hiện trạng: Có hash/salt, khởi tạo Admin đầu tiên, khóa tạm, đăng xuất và đổi mật khẩu. Kiểm thử hash đã đạt; chưa nghiệm thu GUI mọi vai trò.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/TaiKhoanDAL.cs`, `src/YeuMinhEmCinema.Admin/BaoMatMatKhau.cs`, `src/YeuMinhEmCinema.Admin/FormDangNhap.cs`.
- Điều kiện đóng mục: Đúng/sai/khóa tài khoản cho kết quả đúng; không lộ hash; không đổi mật khẩu người dùng để làm test.

### ADM-02 Quyền menu và quyền thao tác

- Báo cáo: 4.5; ma trận quyền.
- Hiện trạng: Có kiểm quyền menu và SQL. Màn hình rạp, lịch, giá hiện gộp quyền xem và sửa nên một số vai trò chỉ xem chưa mở được màn hình.
- Xử lý: **SUA_ADMIN — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/Form1.PhanQuyen.cs`, `Database/Scripts/10_TaiKhoan_PhanQuyen.sql`.
- Điều kiện đóng mục: Tách xem/sửa hợp lý; người chỉ xem tra cứu được nhưng không ghi được; ghi vẫn kiểm quyền hiện tại ở SQL.

### ADM-03 Phạm vi rạp khi sửa danh mục

- Báo cáo: 4.3.2; 4.5.
- Trạng thái: **SUA_ADMIN — P1 — DONE**, chốt ở Phiên 2.
- Đã sửa LuuRap, LuuPhong, LuuGhe, LuuLoaiGhe, TaoGheTheoLo và CapNhatLoGhe; kiểm rạp nguồn/đích, toàn lô, tạo rạp/loại ghế toàn cục chỉ dành cho Admin.
- Có SQL 25 cho nâng cấp và cùng bản vá cuối hai bộ cài mới; không đổi tham số/result set.
- Kiểm chứng: 19 ca từ chối + 6 ca cho phép đạt trên Test nâng cấp và database cài mới tạm. Script test có rollback fixture. Bản cũ thất bại đúng ca thu hồi rạp trước khi sửa.
- Vị trí: `Database/Scripts/17_QuanLyDanhMuc.sql`, `Database/Scripts/23_WinForms_HoanThien.sql`, `Database/Scripts/25_Admin_PhamViRap.sql`, `Database/Tests/05_Admin_PhamViRap.sql`.
- Giới hạn: chưa chạy thao tác thu hồi rạp bằng hai phiên GUI nhân viên/Admin đồng thời; không suy diễn thành đã nghiệm thu toàn bộ phân quyền GUI.

### ADM-04 Hồ sơ và tìm nhân viên

- Báo cáo: 4.1.1; 4.3.2; 5.4.2.
- Hiện trạng: Có tạo/sửa nhân viên, ngừng làm việc và khóa tài khoản. Tìm mới theo tên đăng nhập/họ tên; chưa theo mã và SĐT.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcNhanVienPhanQuyen.cs`, `Database/Scripts/11_KhachHang_NhanVien.sql`, `Database/Scripts/21_QuanTriTaiKhoan.sql`.
- Điều kiện đóng mục: Tìm theo tên, mã, SĐT trên dữ liệu hiện có; hồ sơ/tài khoản được phân biệt; dùng ngừng hoạt động để giữ lịch sử.

### ADM-05 Vai trò và phân công nhân viên

- Báo cáo: 4.3.2; 4.5.
- Hiện trạng: Có gán/thu hồi rạp, vai trò và thay bộ quyền. QUAN_LY mặc định không có quyền quản lý phim/rạp/giá như báo cáo mô tả rộng.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcNhanVienPhanQuyen.cs`, `Database/Scripts/10_TaiKhoan_PhanQuyen.sql`, `Database/Scripts/21_QuanTriTaiKhoan.sql`.
- Điều kiện đóng mục: Có ma trận quyền thực tế; thử thu hồi khi đang mở form. Không cấp thêm quyền toàn cục cho quản lý chỉ để khớp báo cáo.

### ADM-06 Quản lý phim

- Báo cáo: 4.1.1; 4.3.2; 5.4.2.
- Hiện trạng: Có thêm/sửa/ngừng chiếu, tìm tên và lọc trạng thái. Tìm tên qua GUI đã đạt; chưa chạy toàn bộ CRUD qua GUI.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/Form1.cs`, `src/YeuMinhEmCinema.Admin/FormThemSuaPhim.cs`, `src/YeuMinhEmCinema.Admin/PhimDAL.cs`, `Database/Scripts/17_QuanLyDanhMuc.sql`.
- Điều kiện đóng mục: CRUD/trạng thái, dữ liệu sai và phim có lịch tương lai được kiểm; dữ liệu liên quan không mất; Web vẫn đọc được hợp đồng hiện tại.

### ADM-07 Thể loại phim

- Báo cáo: 4.1.1; 5.2 bảng Genres/MovieGenres.
- Hiện trạng: Chưa có bảng thể loại, quan hệ phim-thể loại hoặc UI quản lý thể loại trong mã hiện tại.
- Xử lý: **THIEU_CO_DIEU_KIEN — P2 — OPEN**.
- Vị trí: `Database/Scripts/00_TaoDatabase_Phim.sql`, `src/YeuMinhEmCinema.Admin/PhimDAL.cs`, `src/YeuMinhEmCinema.Admin/FormThemSuaPhim.cs`.
- Điều kiện đóng mục: Nếu bổ sung: migration cộng thêm, không đổi cột/hợp đồng cũ và không bắt Web sửa theo. Nếu chưa làm trong ngày: ghi rõ chưa có, không đánh dấu đạt và bỏ khẳng định đã triển khai trong báo cáo.

### ADM-08 Rạp và phòng chiếu

- Báo cáo: 4.1.1; 4.3.2; 5.4.2.
- Hiện trạng: Có thêm/sửa/trạng thái rạp/phòng, sức chứa tính từ ghế. Trạng thái thực tế gồm Đang hoạt động/Ngừng hoạt động.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/RapDAL.cs`, `src/YeuMinhEmCinema.Admin/PhongChieuDAL.cs`, `src/YeuMinhEmCinema.Admin/UcRapPhongChieu.cs`, `Database/Scripts/17_QuanLyDanhMuc.sql`.
- Điều kiện đóng mục: Tên trùng, dữ liệu sai, phòng chưa có ghế và phòng có lịch được xử lý đúng; không đổi schema chỉ để thêm tên trạng thái trong sơ đồ.

### ADM-09 Tra cứu phòng cho vai trò chỉ xem

- Báo cáo: 4.5; đề bài CRUD/xem/tìm.
- Hiện trạng: Có cây rạp/phòng; chưa có bộ tìm phòng riêng. Menu hiện đòi cả RAP_XEM và RAP_QUAN_LY.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcRapPhongChieu.cs`, `src/YeuMinhEmCinema.Admin/Form1.PhanQuyen.cs`, `src/YeuMinhEmCinema.Admin/PhongChieuDAL.cs`.
- Điều kiện đóng mục: Tìm phòng theo mã/tên trong phạm vi; nhân viên chỉ xem mở được tra cứu; các nút ghi bị khóa và SQL vẫn kiểm quyền.

### ADM-10 Sơ đồ ghế

- Báo cáo: 4.1.1; 4.3.2; 5.4.2.
- Hiện trạng: Có tạo theo lô, đổi loại/trạng thái và sơ đồ lấy SQL. Đã kiểm tạo lặp không trùng; cần kiểm GUI với ghế đang giữ/đã bán.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/GheDAL.cs`, `src/YeuMinhEmCinema.Admin/FormTaoSoDoGhe.cs`, `Database/Scripts/23_WinForms_HoanThien.sql`.
- Điều kiện đóng mục: Không tạo trùng; ghế hỏng không bán; có ghế bị bảo vệ thì cả lô bị từ chối; không làm sai thông tin vé cũ.

### ADM-11 Tạo và sửa suất chiếu

- Báo cáo: UC04; 4.1.1; 5.4.2.
- Hiện trạng: Có form chung sửa phim/phòng/ngày/giờ và trạng thái; không cần tách một form cho mỗi thao tác mô tả trong báo cáo.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/FormSuatChieuBase.cs`, `src/YeuMinhEmCinema.Admin/SuatChieuDAL.cs`, `Database/Scripts/22_TichHop_PhanQuyen_Lich_Gia.sql`.
- Điều kiện đóng mục: Thời lượng/kết thúc/dọn phòng hợp lệ; chỉ phim/phòng đủ điều kiện; đúng phạm vi rạp.

### ADM-12 Chống trùng lịch và bảo vệ lịch có đơn

- Báo cáo: UC04; 6.2.3 ca 7.
- Hiện trạng: Các test lịch trùng, qua đêm, đồng thời và đơn giữ đã đạt ở lớp SQL. Chưa thao tác đầy đủ GUI.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `Database/Scripts/05_ThemSuatChieu.sql`, `Database/Scripts/06_SuaSuatChieu.sql`, `Database/Scripts/22_TichHop_PhanQuyen_Lich_Gia.sql`.
- Điều kiện đóng mục: Thử biên dọn phòng, qua đêm, sửa chính nó; đơn đang giữ/đã trả chặn đổi/hủy; ngừng bán vẫn chiếm phòng.

### ADM-13 Sao chép lịch và xuất lịch

- Báo cáo: 5.4.2; phần mở rộng đang có.
- Hiện trạng: Có xem trước, chữ ký nguồn, sao chép nguyên nhóm và CSV; test SQL đã đạt.
- Xử lý: **GIU_VA_KIEM_THU — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/FormSaoChepLich.cs`, `src/YeuMinhEmCinema.Admin/UcLichChieu.cs`, `Database/Scripts/08_SaoChepLich.sql`.
- Điều kiện đóng mục: Nguồn/đích đổi phải xem trước lại; một suất lỗi không ghi dở nhóm; CSV đúng danh sách đang xem.

### ADM-14 Giá vé và chốt giá giao dịch

- Báo cáo: 4.1.1; 5.5.1; 5.2.3.
- Hiện trạng: Có giá theo loại ghế/định dạng/ngày thường-cuối tuần, khoảng hiệu lực, rowversion; giá giao dịch được chụp. Giá hiện dùng chung, không có MaRap.
- Xử lý: **GIU_VA_KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/GiaVeFnbDAL.cs`, `src/YeuMinhEmCinema.Admin/FormGiaVe.cs`, `Database/Scripts/09_GiaVe_Fnb.sql`, `Database/Scripts/13_DatVe_GiuGhe.sql`.
- Điều kiện đóng mục: Giá chồng bị chặn; thay bảng giá không đổi đơn đã chốt; không tự thêm mô hình giá riêng từng rạp hoặc ngày lễ hôm nay.

### ADM-15 F&B và combo

- Báo cáo: 4.1.1; 7.2.
- Hiện trạng: Đã có sản phẩm, giá và combo; báo cáo còn đặt việc này ở hướng phát triển. Không có tồn kho; đúng bản báo cáo hiện tại cũng không yêu cầu triển khai kho.
- Xử lý: **SUA_BAO_CAO — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcGiaVeVaFnb.cs`, `src/YeuMinhEmCinema.Admin/FormFnb.cs`, `Database/Scripts/09_GiaVe_Fnb.sql`.
- Điều kiện đóng mục: Chuyển danh mục/giá/combo vào kết quả đã có sau khi kiểm GUI; giữ giới hạn chưa có tồn kho; không lấy yêu cầu kho từ bản báo cáo gửi nhầm.

### ADM-16 Tìm suất trong bán vé tại quầy

- Báo cáo: 4.1.1; 5.4.2.
- Hiện trạng: Có chọn rạp/ngày rồi chọn suất, chưa có ô lọc tên phim trong màn hình quầy.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcBanVeTaiQuay.cs`, `src/YeuMinhEmCinema.Admin/GiaoDichDAL.cs`.
- Điều kiện đóng mục: Lọc tên phim trên suất được phép bán trong rạp/ngày hiện tại; không thay API hoặc hợp đồng Web.

### ADM-17 Giữ ghế và hết hạn

- Báo cáo: 5.5.1; 6.2.3 ca 2/4.
- Hiện trạng: SQL giữ tối đa 10 phút, không vượt giờ chiếu; UI chỉ hiển thị đếm ngược. Báo cáo ghi 5 phút.
- Xử lý: **SUA_BAO_CAO — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcBanVeTaiQuay.cs`, `Database/Scripts/13_DatVe_GiuGhe.sql`.
- Điều kiện đóng mục: Giữ hành vi SQL hiện có; mô tả đúng hết hạn theo server, retry cùng mã và tranh ghế; kiểm GUI không thu được đơn hết hạn.

### ADM-18 Tiền khách đưa và tiền thừa

- Báo cáo: 5.4.2; 6.2.3 ca 5.
- Hiện trạng: Hiện chỉ xác nhận đã nhận đủ tổng đơn; chưa có trường tiền khách đưa/tính tiền thừa.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcBanVeTaiQuay.cs`, `src/YeuMinhEmCinema.Admin/GiaoDichDAL.cs`.
- Điều kiện đóng mục: Bổ sung hỗ trợ tiền mặt ở UI, chặn thiếu tiền và hiện tiền thừa; số tiền ghi ThanhToan vẫn đúng tổng đơn, không thay schema tài chính hay luồng Web.

### ADM-19 Ghi nhận thu và phát hành vé

- Báo cáo: 5.5.2; 6.2.3 ca 5.
- Hiện trạng: SQL ghi tiền, đổi đơn và tạo vé trong cùng transaction; test thu lặp/thiếu tiền đã đạt. Không tích hợp ngân hàng thật.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/GiaoDichDAL.cs`, `Database/Scripts/14_BanVe_ThanhToan.sql`.
- Điều kiện đóng mục: Retry không tạo trùng ThanhToan/Ve; lỗi không báo thành công; chỉ ghi nhận thu sau khi người thao tác xác nhận.

### ADM-20 Tra cứu đơn và giao dịch

- Báo cáo: 4.1.1; 4.3.2; 5.4.2.
- Hiện trạng: Có lọc rạp/ngày/trạng thái, phân trang và chi tiết. Chưa có tìm trực tiếp theo mã đơn/giao dịch/vé; nút Sau chưa dựa trên tổng trang.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcDonDatVe.cs`, `src/YeuMinhEmCinema.Admin/GiaoDichDAL.cs`, `Database/Scripts/19_TruyVan_Web.sql`.
- Điều kiện đóng mục: Tra cứu nhanh theo mã trên đúng phạm vi; giới hạn trang; vẫn giữ tương thích lời gọi proc cũ nếu bổ sung tham số tùy chọn.

### ADM-21 Hủy và hoàn đơn

- Báo cáo: 4.3.2; giới hạn/hướng phát triển.
- Hiện trạng: Có hủy chưa trả, hoàn toàn bộ có xác nhận và giữ lịch sử; test SQL đã đạt. Không hoàn ngân hàng tự động.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcDonDatVe.cs`, `Database/Scripts/15_HuyDon_HoanTien.sql`, `Database/Scripts/23_WinForms_HoanThien.sql`.
- Điều kiện đóng mục: Chặn hoàn đơn đã dùng vé/không đủ điều kiện; không hoàn hai lần; hủy giải phóng ghế; GUI thể hiện đúng trạng thái.

### ADM-22 Xuất và in vé QR

- Báo cáo: 5.4.2; 6.4.
- Hiện trạng: Có xuất phiếu HTML tự chứa QR, dùng trình duyệt In/lưu PDF; chưa phải máy in nhiệt hay xuất PDF trực tiếp.
- Xử lý: **KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/HoaDonExporter.cs`, `src/YeuMinhEmCinema.Admin/TicketQr.cs`.
- Điều kiện đóng mục: QR giải mã đúng GUID; chỉ có vé sau thanh toán; in lại không tạo giao dịch; thử tên có ký tự HTML; mô tả đúng phương thức in.

### ADM-23 Kiểm tra vé và chống dùng lặp

- Báo cáo: UC05; 5.5.3; 6.2.3 ca 6.
- Hiện trạng: Có nhập GUID/USB dạng bàn phím, tra và xác nhận; thời gian cho vào từ trước 30 phút đến trước kết thúc. Test soát lặp đạt.
- Xử lý: **GIU_VA_KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcKiemTraVe.cs`, `Database/Scripts/16_KiemTraVe.sql`.
- Điều kiện đóng mục: Giữ khung thời gian SQL hiện tại; chỉnh báo cáo mốc +15 phút; thử vé đã dùng/hủy/chưa trả, đúng phạm vi; không thêm camera hôm nay.

### ADM-24 Đúng suất/phòng đang soát

- Báo cáo: UC05; 5.5.3.
- Hiện trạng: Form chỉ có ô mã vé, không có ngữ cảnh suất/phòng đang kiểm soát. SQL kiểm thông tin suất của vé, chưa so với một suất được nhân viên chọn.
- Xử lý: **BO_SUNG_ADMIN — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcKiemTraVe.cs`, `Database/Scripts/16_KiemTraVe.sql`.
- Điều kiện đóng mục: Chọn suất/phòng soát và kiểm tại server; sai suất phải bị từ chối. Bổ sung theo cách tương thích lời gọi cũ, không phá Web hoặc tự thay toàn bộ hợp đồng proc.

### ADM-25 Doanh thu theo thời gian

- Báo cáo: 4.1.1; 5.4.2.
- Hiện trạng: Có thu/hoàn/thuần theo ngày thu/hoàn Việt Nam. Tổng tiền có cả vé và F&B; cần phân biệt với báo cáo chỉ doanh thu vé.
- Xử lý: **GIU_VA_KIEM_THU — P1 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcBaoCaoThongKe.cs`, `Database/Scripts/18_BaoCao_ThongKe.sql`.
- Điều kiện đóng mục: Số liệu đối chiếu SQL; không nhân dòng join; ngày thu khác ngày chiếu được giải thích; nhãn thu/hoàn/thuần rõ ràng.

### ADM-26 Báo cáo phim và suất chiếu

- Báo cáo: 4.1.1; 5.4.2.
- Hiện trạng: Có tổng theo phim và số vé theo ngày chiếu; chưa có bộ lọc phim riêng/bảng tách từng suất như phạm vi báo cáo mô tả.
- Xử lý: **BO_SUNG_ADMIN — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcBaoCaoThongKe.cs`, `Database/Scripts/18_BaoCao_ThongKe.sql`.
- Điều kiện đóng mục: Bổ sung truy vấn chỉ đọc theo phim/suất, dùng giá vé đã chốt; không đổi bảng giao dịch; các báo cáo cũ không đổi nghĩa.

### ADM-27 Khách hàng trong Admin

- Báo cáo: 4.1.1; 4.3.2.
- Hiện trạng: Có tìm/thêm/sửa/ngừng hồ sơ khách và xem đơn. Đây là màn hình Admin, không phải luồng tài khoản Web.
- Xử lý: **KIEM_THU — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcKhachHang.cs`, `Database/Scripts/11_KhachHang_NhanVien.sql`, `Database/Scripts/23_WinForms_HoanThien.sql`.
- Điều kiện đóng mục: Kiểm phạm vi khách gắn với đơn trong rạp, phiên bản dữ liệu và lịch sử; không sửa đăng ký/đăng nhập Web.

### ADM-28 Bố cục và nhãn giao diện

- Báo cáo: 4.4.2; 5.4.2; tiêu chí giao diện.
- Hiện trạng: Đã sửa nút che cây rạp/phòng, nhãn che tiêu đề phim và Dock thanh đáy; đã xem cửa sổ thường/phóng to. Chuẩn hóa cột kỹ thuật/ngày giờ/DPI khác chưa hoàn tất.
- Xử lý: **SUA_ADMIN — P1 — PARTIAL**.
- Vị trí: `src/YeuMinhEmCinema.Admin/UcRapPhongChieu.Designer.cs`, `src/YeuMinhEmCinema.Admin/Form1.Designer.cs`, `src/YeuMinhEmCinema.Admin/AdminUi.cs`.
- Điều kiện đóng mục: Không che nội dung/nút ở cửa sổ thực tế; thử 1366x768 và DPI phổ biến nếu môi trường cho phép; nhãn tiếng Việt và ngày giờ rõ ràng.

### ADM-29 Tải lại dữ liệu và lỗi kết nối

- Báo cáo: 4.1.2; 6.2.
- Hiện trạng: Nhiều SQL call đồng bộ, UserControl có cache. Chưa đo độ trễ hay thử timeout GUI.
- Xử lý: **KIEM_THU — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/Db.cs`, `src/YeuMinhEmCinema.Admin/Form1.cs`, `src/YeuMinhEmCinema.Admin/AdminUi.cs`.
- Điều kiện đóng mục: Lỗi không làm mất giỏ hoặc báo thành công giả; phục hồi/kết nối lại được; chỉ chuyển async chỗ thật sự gây chờ, không viết lại toàn app.

### ADM-30 CSV và lịch sử dữ liệu

- Báo cáo: 4.5; phần mở rộng.
- Hiện trạng: Có CSV BOM/escape/chống công thức, trạng thái thay xóa vật lý dữ liệu giao dịch; test CSV đã đạt.
- Xử lý: **GIU_VA_KIEM_THU — P2 — OPEN**.
- Vị trí: `src/YeuMinhEmCinema.Admin/CsvUtility.cs`, `src/YeuMinhEmCinema.Admin/AdminUi.cs`, `src/YeuMinhEmCinema.Admin/UcLichChieu.cs`.
- Điều kiện đóng mục: Xuất đúng tập dữ liệu, tiếng Việt đọc được; giữ nguyên lịch sử đơn/vé; không lộ hash và cột concurrency trong giao diện.

### ADM-31 Bộ dữ liệu và demo Admin xuyên suốt

- Báo cáo: 6.2.3; 6.5.
- Hiện trạng: Có dữ liệu danh mục Test và test fixture rollback; chưa có bộ demo nghiệp vụ bền vững để thao tác GUI toàn luồng.
- Xử lý: **BO_SUNG_ADMIN — P1 — OPEN**.
- Vị trí: `Database/CAI-DAT-TEST.sql`, `Docs/HuongDan/KIEM-THU-WINDOWS.md`.
- Điều kiện đóng mục: Script Test riêng, chạy lại được, không reset database khác; có lịch/giá/ghế/F&B, ca bán-soát-hoàn và nhật ký kết quả.

### ADM-32 Minh chứng, thiết kế dữ liệu và phần đóng góp

- Báo cáo: 5.1–5.3; 6.3–6.5; phụ lục.
- Hiện trạng: Sơ đồ còn dùng API/EF/schema tiếng Anh dự kiến; báo cáo để chưa kiểm chứng. Có bằng chứng chạy tự động nhưng chưa đủ ảnh GUI.
- Xử lý: **SUA_BAO_CAO — P1 — OPEN**.
- Vị trí: `YeuMinhEmCinema.slnx`, `src/YeuMinhEmCinema.Admin/Db.cs`, `Database/Scripts/12_DonHang_Ve_ThanhToan.sql`.
- Điều kiện đóng mục: Lập bản đồ bảng/khóa/lớp thật, phân biệt SQL test với GUI test; cập nhật phần Admin và đóng góp thực tế; phần Web giao người phụ trách xác nhận.

## Công việc theo thứ tự

### T01 Khóa quyền theo phạm vi và rà menu chỉ xem

- Ưu tiên: P1; phiên dự kiến: 2; trạng thái: DONE (Phiên 2).
- Liên quan: ADM-02, ADM-03, ADM-05.
- Kết quả cần có: Sửa rạp/phòng/ghế sau thu hồi phải bị từ chối; rà TaoGheTheoLo và thao tác tương tự; có regression trên Test.

- Bằng chứng và giới hạn: `PHIEN-02-KET-QUA.md`.

### T02 Sửa hai lỗi bố cục đã thấy

- Ưu tiên: P1; phiên dự kiến: 2; trạng thái: DONE (Phiên 2).
- Liên quan: ADM-28.
- Kết quả cần có: Cây rạp không bị nút đè; tiêu đề phim không bị banner đè; chụp/kiểm GUI sau sửa.

- Bằng chứng và giới hạn: `PHIEN-02-KET-QUA.md`.

### T03 Soát vé theo suất hoặc phòng đang kiểm soát

- Ưu tiên: P1; phiên dự kiến: 3; trạng thái: OPEN.
- Liên quan: ADM-23, ADM-24.
- Kết quả cần có: Vé cùng rạp nhưng sai suất/phòng không được xác nhận; không soát trùng; caller cũ vẫn chạy.

### T04 Tiền khách đưa và tra cứu giao dịch

- Ưu tiên: P2; phiên dự kiến: 3; trạng thái: OPEN.
- Liên quan: ADM-18, ADM-20.
- Kết quả cần có: Tiền thiếu/thừa xử lý đúng ở UI; tìm nhanh mã và phân trang đúng, số tiền lưu không đổi hợp đồng tài chính.

### T05 Tìm kiếm phục vụ thao tác Admin

- Ưu tiên: P2; phiên dự kiến: 3; trạng thái: OPEN.
- Liên quan: ADM-04, ADM-09, ADM-16.
- Kết quả cần có: Tìm mã/SĐT nhân viên, phòng và phim trong quầy; đúng phạm vi, không cần sửa Web.

### T06 Báo cáo theo phim và suất

- Ưu tiên: P2; phiên dự kiến: 3; trạng thái: OPEN.
- Liên quan: ADM-25, ADM-26.
- Kết quả cần có: Bổ sung bằng dữ liệu đọc; chốt rõ ngày chiếu/ngày thu, doanh thu vé/tổng thu và cách tính hoàn.

### T07 Thể loại và phần mô tả còn thiếu

- Ưu tiên: P2; phiên dự kiến: 3; trạng thái: OPEN.
- Liên quan: ADM-07, ADM-32.
- Kết quả cần có: Ước lượng thay đổi schema additive sau P1; chỉ thực hiện nếu không làm Web đổi. Nếu chưa làm ghi thiếu rõ ràng.

### T08 Bộ demo và nghiệm thu Admin

- Ưu tiên: P1; phiên dự kiến: 4; trạng thái: OPEN.
- Liên quan: ADM-01, ADM-06, ADM-08, ADM-10, ADM-11, ADM-12, ADM-14, ADM-19, ADM-21, ADM-22, ADM-27, ADM-29, ADM-30, ADM-31.
- Kết quả cần có: Dữ liệu Test riêng; chạy đủ bán-soát-hoàn; thử vai trò; ghi đạt/không đạt/chưa thử, không suy diễn từ build.

### T09 Đồng bộ phần Admin trong báo cáo và nhật ký

- Ưu tiên: P1; phiên dự kiến: 4; trạng thái: OPEN.
- Liên quan: ADM-15, ADM-17, ADM-23, ADM-32.
- Kết quả cần có: Mô tả đúng .NET10/ADO/SQL, schema/lớp thật, khung giờ và F&B; ghi nguồn bằng chứng, phần đóng góp và các giới hạn còn lại.

## Ranh giới với người phụ trách Web

Không chỉnh Controller/View/DAL Web hay luồng tài khoản khách. SQL dùng chung chỉ được sửa khi phục vụ lỗi/yêu cầu Admin rõ ràng, giữ chữ ký/kết quả cũ hoặc thêm tham số tùy chọn tương thích. Mỗi thay đổi SQL cần chỉ ra caller Web liên quan và bài kiểm tra hồi quy; việc kiểm caller để tránh phá hệ thống không có nghĩa nhận làm phần Web.

Kiểm tra tích hợp cuối cần phối hợp với người làm Web: Admin sửa lịch thì Web đọc được, đơn Web xuất hiện ở Admin. Nếu chưa có người xác nhận thì ghi CHƯA KIỂM CHỨNG, không tự đánh đạt phần người dùng.

Ngoài phạm vi hôm nay: đổi runtime/ORM/kiến trúc, tồn kho, ngân hàng thật, email/SMS, camera QR, máy in nhiệt chuyên dụng, kho/membership/khuyến mãi. Hiệu năng chỉ xử lý điểm chờ được tái hiện, không hứa chịu tải khi chưa đo.

## Cập nhật sau Phiên 2

T01/T02 hoàn thành trong phạm vi sửa lỗi đã chốt. ADM-03 đóng; ADM-28 còn một phần, ADM-02/ADM-09 và các chức năng chưa làm vẫn mở. Không commit hoặc push khi chưa có lệnh người dùng.
