# Phiên 7 — T07 thể loại phim

Người dùng duyệt triển khai T07 với 10 yêu cầu; chỉ WinForms Admin và SQL. Nền a4e3ae6. Trạng thái: đã triển khai và kiểm thử, xem PHIEN-07-KET-QUA.md.

1. Đọc lại báo cáo C#_Nhóm1.docx, phần4.1.1,5.2 Genres/MovieGenres và5.4 giao diện.
2. Bổ sung danh mục thể loại (tên/mô tả/trạng thái) và quan hệ nhiều-nhiều phim/thể loại. Phim cũ có thể không có thể loại.
3. Chỉ migration additive; không sửa bảng Phim, schema giao dịch hoặc hợp đồng Web. Giữ .NET10/WinForms/ADO.NET/SQL Server.
4. Kiểm PHIM_XEM/PHIM_QUAN_LY tại SQL; không tự cấp thêm quyền. Không mở rộng Web để khớp phần lọc thể loại trong báo cáo.
5. Test nâng cấp/cài mới, lỗi dữ liệu và quyền, hồi quy phim/lịch/bán vé/Web; kiểm GUI riêng trên Test.
6. Cập nhật tracker, nhật ký, kết quả, checklist chỉnh Word và tồn tại. Không sửa DOCX, commit/push hoặc làm T08.
