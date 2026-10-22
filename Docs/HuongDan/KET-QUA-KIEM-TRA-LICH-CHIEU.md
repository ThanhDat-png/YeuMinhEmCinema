# Kiểm chứng bản sửa lịch chiếu

- Admin: dotnet build, SDK 10.0.100, EnableWindowsTargeting=true: 0 lỗi, 0 cảnh báo.
- Cú pháp mọi file SQL trong Database: Microsoft ScriptDom TSql160Parser, 0 lỗi.
- CSV smoke test: đã chạy PASS.
- SQL integration test project: build 0 lỗi, 0 cảnh báo; chưa chạy vì không có SQL Server.
- Chưa chạy WinForms trên Windows; chưa xác nhận bố cục 1366×768/DPI trên máy thật.

## File C# thay đổi hoặc bổ sung

- CsvUtility.cs
- FormLichPhongTrongNgay.cs
- FormSaoChepLich.cs
- FormSuaSuatChieu.Designer.cs
- FormSuaSuatChieu.cs
- FormSuatChieuBase.cs
- FormThemSuatChieu.Designer.cs
- FormThemSuatChieu.cs
- LichChieuUi.cs
- SuatChieuDAL.cs
- UcLichChieu.Designer.cs
- UcLichChieu.cs

## SQL và tài liệu

Script 05–08 đã sửa; cần người dùng chạy trong SSMS theo thứ tự.
README, BAT-DAU-O-DAY, hướng dẫn lịch chiếu và Tests/README mô tả phạm vi, cách chạy và giới hạn.
Designer cũ của hai form thêm/sửa được thay bằng file ghi chú để copy ghi đè không còn code trùng.
Các module khác không được coi là hoàn thiện bởi bản sửa này.
