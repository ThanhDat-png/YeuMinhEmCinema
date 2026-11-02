# Các thay đổi so với ZIP gốc

## File đã sửa

- `Design/Web/dist/admin.css`
- `src/YeuMinhEmCinema.Admin/DataAccess/SuatChieuDAL.cs`
- `src/YeuMinhEmCinema.Admin/Forms/Form1.cs`
- `src/YeuMinhEmCinema.Admin/Forms/FormSuatChieuBase.cs`
- `src/YeuMinhEmCinema.Admin/Program.cs`
- `src/YeuMinhEmCinema.Admin/UI/AdminUi.cs`
- `src/YeuMinhEmCinema.Web/Views/Shared/_Layout.cshtml`
- `src/YeuMinhEmCinema.Web/wwwroot/css/site.css`

## File đã thêm

- `DANH-SACH-THAY-DOI-COSMIC.md`
- `Design/CosmicPreview/assets/blue-hour.svg`
- `Design/CosmicPreview/assets/reference.png`
- `Design/CosmicPreview/assets/signal.svg`
- `Design/CosmicPreview/assets/starlight.svg`
- `Design/CosmicPreview/assets/voyager.svg`
- `Design/CosmicPreview/index.html`
- `HUONG-DAN-COSMIC-BLUE.md`
- `HUONG-DAN-LICH-PHONG.md`
- `Tests/RoomScheduleSmoke/Program.cs`
- `Tests/RoomScheduleSmoke/RoomScheduleSmoke.csproj`
- `src/YeuMinhEmCinema.Admin/UI/AdminTheme.cs`
- `src/YeuMinhEmCinema.Admin/UI/RoomSchedule.cs`
- `src/YeuMinhEmCinema.Web/wwwroot/css/cosmic-theme.css`
- `src/YeuMinhEmCinema.Web/wwwroot/images/cosmic/constellations.png`
- `src/YeuMinhEmCinema.Web/wwwroot/js/cosmic-sky.js`

## Phạm vi

- Bao gồm bản màu Cosmic Blue và bản xem lịch phòng trong cửa sổ Thêm/Sửa suất.
- SuatChieuDAL thêm truy vấn đọc theo khoảng thời gian, có tham số và kiểm quyền.
- Không sửa script SQL, controller, xác thực hoặc phân quyền.
- Procedure ghi dữ liệu hiện có vẫn quyết định xung đột và điều kiện lưu.
- Chưa build/chạy C# hoặc 14 ca kiểm tra vì môi trường không có .NET SDK/Windows/SQL Server.
