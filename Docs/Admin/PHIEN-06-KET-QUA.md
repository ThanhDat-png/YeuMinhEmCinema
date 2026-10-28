# Kết quả phiên T06 — báo cáo phim/suất

Ngày 28/10/2026, nền commit c6db703. Người dùng duyệt riêng T06; không làm T07, không tự commit/push.

## Đối chiếu và thay đổi

Đã đọc lại C#_Nhóm1.docx đúng trong C_SHARP, SHA256 329d4cf19788d45e77011816e5215c8e4f400f2f0f5e06288a17266fd0c8a853. Phần4.1.1/5.4.2 yêu cầu doanh thu/phim/suất,4.5 yêu cầu quyền theo rạp. Giữ .NET10/ADO.NET/schema giao dịch/Web; không viết lại module. Chưa chỉnh DOCX.

- Mở rộng UcBaoCaoThongKe hiện có; Tổng quan dùng cùng lớp. Thêm bộ lọc phim theo rạp, bảng Từng suất và phần giải thích cơ sở ngày. Đổi lọc xóa dữ liệu cũ, không đọc nhầm.
- Thu/hoàn theo ngày giao dịch VN: thu vé/F&B trước hoàn lấy snapshot, tổng thu và hoàn lấy giao dịch, thuần=thu−hoàn. Ngày chỉ hoàn có thể âm. Không tính lại từ GiaVe/menu hiện tại.
- Từng suất theo ngày bắt đầu chiếu VN, một dòng/suất kể cả hủy, số vé phát hành/hoàn/chưa hoàn và lũy kế thu vé/F&B/tổng/hoàn/thuần. Chỉ đơn có thu mới có doanh số. Không phải sổ giao dịch theo ngày thu hoặc snapshot quá khứ.
- Giữ các báo cáo phim/F&B cũ: phim theo ngày chiếu, đơn chưa hoàn/bỏ suất hủy; F&B theo ngày thu nhưng loại đơn hiện đã hoàn. Ghi rõ nhãn khác với sổ thu/hoàn. LegacySQL 18 chỉ thêm @MaPhim=NULL cuối, caller/cột/nghĩa mặc định giữ nguyên.
- SQL 29 có ba procedure mới cùng ba proc cũ mở rộng; tất cả kiểm BAO_CAO_XEM và MaRap tại SQL. Bộ lọc phim không nới phạm vi rạp. Bộ cài mới đồng bộ; chỉ Test local đã áp dụng, database chính/máy nhóm chưa nâng cấp.
- Vé và F&B được cộng riêng từng đơn trước khi join ThanhToan/HoanTien một dòng mỗi đơn. Không dùng SUM(DISTINCT giá) để che nhân dòng hoặc cộng tiền thành phần combo lần hai.
- Sửa nhãn F&B không bị WinForms coi & là phím tắt; ngày giao dịch chỉ hiện dd/MM/yyyy. Grid nhiều cột có cuộn ngang; chart phim/suất/F&B tối đa15 mục đầu, grid/CSV đủ dòng.

## Kiểm thử đã thực hiện

- Trước nâng cấp: SQL09 báo thiếu sp_YMC_BaoCaoThuChiTiet, xác nhận server chưa có hợp đồng mới.
- Sau SQL 29:32/32 ca đạt trên Test nâng cấp; dữ liệu qua procedure giữ/thu/hoàn thật rồi điều chỉnh timestamp trong fixture để kiểm ngày VN, rollback từng ca. Gồm nhiều vé×nhiều F&B, giá đổi sau bán, đơn chưa trả, hoàn khác ngày, ranh giớiUTC+7, suất hủy, lọc phim/rạp, đối chiếu legacy.
- Kiểm trực tiếp sáu procedure bằng manager ngoài rạp (50404), người không BAO_CAO_XEM (50403), thu hồi phân công/khóa actor và ngày không hợp lệ. GUI không được dùng thay bằng chứng quyền SQL.
- Cài mới ở YMC_ReportInstall_b80ed2a4_Test chạy32/32 đạt; database tạm đã dọn. SQL 29 chạy lại không lỗi. Hồi quySQL01 bán/thu/soát/hoàn/retry, SQL02 từ chối, SQL07 tra cứu/phân trang đều đạt.
- AdminSmoke 37 kiểm đạt. Build bản cuối bin/AdminReportFinal:0 lỗi/0 cảnh báo. Output.NET ở công cụ, không tạo tệp log giả.
- GUI Admin bản cuối sau người dùng đăng nhập: thu460000/hoàn230000/thuần230000, trong đó vé320000/F&B140000; ngày chỉ hoàn âm. Lọc phim A còn thu340000/hoàn230000/thuần110000. Ngày chiếu07/11 tách ngày thu25–26/10 và hoàn27/10. Từng suất có 3 dòng (một hủy0), net110000/120000/0; legacy phim160000, legacy F&B70000; F&B chọn riêng ngày chiếu trả rỗng đúng nghĩa.
- Đã quan sát bản thường1172×850 và phóng to1536×816, nhãn/biểu đồ/bộ lọc không đè nhau trong hai kích thước. Ngày chỉ hiện ngày, chữ F&B giữ dấu& trên bản cuối. Chưa khẳng định mọi DPI/vai trò GUI hoặc test hộp lưu CSV.
- Fixture GUI gồm đơn thu/hoàn/đơn giữ, hai rạp và tài khoản thử đã dọn đúng ID/nhãn. Log cleanup xác nhận giữ dữ liệu người dùng. Không có dữ liệu thật bị thay đổi.

Log SQL thật: evidence/2026-10-28/session-06. Ảnh GUI đã xem trực tiếp qua công cụ, không lưu PNG vào repo. Chưa benchmark dữ liệu lớn hoặc kiểm báo cáo khi đồng thời phát sinh giao dịch.

## Bàn giao

ADM-25,ADM-26 và T06 DONE theo phạm vi. Áp dụng SQL 29 sau SQL 23/25/26/27/28 trên đúng DB rồi chạy Admin mới; không seed/SQL 24/schema mới. Việc áp dụng ngoài Test cần làm riêng theo người dùng.

Nội dung cần chỉnh Word: [PHIEN-06-DIEU-CHINH-BAO-CAO.md](PHIEN-06-DIEU-CHINH-BAO-CAO.md). Tất cả yêu cầu/công việc còn mở và giới hạn: [PHIEN-06-CON-TON-TAI.md](PHIEN-06-CON-TON-TAI.md). Word chưa sửa; T07 chưa bắt đầu. Chưa commit/push phiên 6, chờ lệnh riêng.
