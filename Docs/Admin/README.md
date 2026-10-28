# Hoàn thiện WinForms Admin

Đây là điểm bắt đầu cho các phiên tiếp theo. Người phụ trách Admin là người dùng trong cuộc trò chuyện; không gán quyền tác giả đối với code nhóm đã có.

1. Đọc `DOI-CHIEU-ADMIN.md` để biết nguồn, phạm vi và từng mục ADM.
2. Đọc `NHAT-KY-PHIEN.md` và kiểm tra `git status` trước khi tiếp tục.
3. Cập nhật trạng thái trong `THEO-DOI.json` và phần đối chiếu tương ứng; không ghi DONE khi mới build.
4. Kết thúc mỗi phiên ghi file thay đổi, kiểm thử, kết quả thật, mục báo cáo liên quan, việc còn thiếu và đầu việc phiên sau.

## Phạm vi cố định

Giữ .NET 10 + WinForms + ADO.NET + SQL Server/stored procedure. Sửa báo cáo khi nó mô tả kiến trúc khác; không đổi cả hệ thống để khớp tài liệu. Làm Admin và SQL cần cho Admin. Web/người dùng do người khác phụ trách.

## Mốc và nguồn

Baseline source: `5a0ee37c406746b2a23c0db6e2b5f17b46d8f6d6`.
Hai file Word nguồn nằm ở thư mục cha repo `C_SHARP`, không được coi là đã sửa trong Phiên 1. `THEO-DOI.json` lưu SHA-256 để phát hiện việc thay bản.
Bằng chứng kiểm tra trước được giữ ở `evidence/2026-10-28/`. Nó xác nhận phạm vi thử trước, không thay cho kiểm thử sau khi sửa.

## Điều kiện đóng chức năng

Hành vi phù hợp phạm vi đã chốt; có test hoặc minh chứng GUI phù hợp; kiểm các caller bị ảnh hưởng; ghi đối chiếu báo cáo và giới hạn. Chức năng có code nhưng chưa thử GUI phải ghi rõ mức xác nhận. Chức năng chưa làm phải được giữ trong danh sách thiếu hoặc ghi ngoài phạm vi có lý do, không đổi nhãn thành đã đạt.

## Cách bắt đầu Phiên 2

Đọc hồ sơ này, kiểm thay đổi hiện tại rồi thực hiện T01/T02. Ưu tiên lỗi thiếu kiểm phạm vi rạp trong các thao tác ghi danh mục và hai lỗi bố cục đã quan sát. Dùng database Test, giữ nguyên dữ liệu/tài khoản người dùng, không ghi mật khẩu vào source hoặc nhật ký.

## Tiêu chuẩn kiểm thử thay đổi SQL

Kiểm quyền lúc ghi, rạp cũ và rạp mới, cả lô và phiên bản dữ liệu khi áp dụng. Có script tăng dần; không bắt chạy lại toàn bộ seed/cài đặt trên database đang dùng. Rà cả cài mới và nâng cấp để tránh định nghĩa procedure bị script cũ ghi đè. Giữ tương thích với caller hiện có của Web.

## Quy định người dùng về báo cáo và Git

Trước mỗi lượt triển khai phải đọc lại phần báo cáo liên quan và kiểm bản nguồn. Sau kiểm thử ghi đối chiếu và nhật ký. Không tự commit hoặc push; chỉ thực hiện khi người dùng ra lệnh rõ ràng. Việc test đạt không phải là lệnh Git.

## Mốc sau phiên sửa đầu tiên

Phiên 1 trong hồ sơ là chuẩn bị đối chiếu; Phiên 2 là lượt triển khai T01/T02 đầu tiên. Đã hoàn thành T01/T02, chưa commit/push. Đọc `PHIEN-02-KET-QUA.md` trước khi bắt đầu phiên tiếp theo. SQL 25 đã áp dụng trên database Test cục bộ; database chính/máy khác cần nâng cấp riêng theo hướng dẫn.

Phiên 3 đã hoàn tất T03. Xem `PHIEN-03-KET-QUA.md`; ADM-24 DONE, ADM-23 còn chỉnh DOCX ở T09. Kế tiếp T04 tiền khách đưa/tra cứu; P2 khác chưa làm. Commit nền sau phiên 2: ed8b4a2. Phiên 3 chưa commit/push; vẫn cần lệnh mới của người dùng.

Phiên 4 hoàn tất T04: xem `PHIEN-04-KET-QUA.md`. ADM-18/ADM-20 DONE. Nền commit834ab95, phiên 4 chưa commit/push. Tiếp theo T05 tìm kiếm khác; T06/T07 còn mở. Báo cáo Word chưa chỉnh trong phiên code này.
