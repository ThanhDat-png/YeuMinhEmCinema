using YeuMinhEmCinema.Admin;

var day = new DateTime(2026, 11, 1);
DateTime At(int hour, int minute = 0) => day.AddHours(hour).AddMinutes(minute);
int count = 0;

void Check(bool result, string name)
{
    if (!result)
    {
        throw new InvalidOperationException($"FAIL: {name}");
    }

    count++;
    Console.WriteLine($"PASS: {name}");
}

var evening = new RoomBooking(1, At(18), At(20, 15));
Check(RoomSchedule.Overlaps(At(20), At(22), evening), "Dọn phòng vẫn chiếm phòng");
Check(!RoomSchedule.Overlaps(At(20, 15), At(22), evening), "Bắt đầu đúng lúc dọn xong được phép");
Check(!RoomSchedule.Overlaps(At(16), At(18), evening), "Kết thúc chiếm phòng đúng lúc suất sau bắt đầu");
Check(RoomSchedule.Overlaps(At(17), At(19), evening), "Chồng lấn một phần");
Check(RoomSchedule.Overlaps(At(17), At(21), evening), "Suất mới bao trùm suất cũ");

var overnight = new RoomBooking(2, day.AddDays(-1).AddHours(23), At(1, 15));
Check(RoomSchedule.Overlaps(At(0, 30), At(2), overnight), "Suất từ ngày trước còn chiếm phòng");
var tomorrow = new RoomBooking(3, day.AddDays(1).AddMinutes(30), day.AddDays(1).AddHours(3));
Check(RoomSchedule.Overlaps(At(23), day.AddDays(1).AddHours(2), tomorrow), "Suất mới trùng lịch ngày kế tiếp");

var chain = new[] { evening, new RoomBooking(4, At(20, 15), At(22, 30)) };
Check(RoomSchedule.NextStart(chain, At(19), TimeSpan.FromHours(2)) == At(22, 30), "Gợi ý đi qua hai suất liền nhau");
Check(RoomSchedule.NextStart(new[] { evening }, At(16), TimeSpan.FromHours(2)) == At(16), "Giữ khoảng trống vừa đủ");
Check(RoomSchedule.NextStart(Array.Empty<RoomBooking>(), At(16), TimeSpan.FromHours(2)) == At(16), "Phòng chưa có lịch");
var seconds = new RoomBooking(5, At(18), At(20, 15).AddSeconds(20));
Check(RoomSchedule.NextStart(new[] { seconds }, At(19), TimeSpan.FromHours(1)) == At(20, 16), "Làm tròn lên phút tránh gợi ý chồng vài giây");
var unsorted = new[] { chain[1], chain[0] };
Check(RoomSchedule.NextStart(unsorted, At(19), TimeSpan.FromHours(2)) == At(22, 30), "Đầu vào chưa sắp xếp");
var nested = new[] { new RoomBooking(6, At(18), At(23)), new RoomBooking(7, At(19), At(20)) };
Check(RoomSchedule.NextStart(nested, At(19), TimeSpan.FromHours(1)) == At(23), "Khoảng lồng nhau không đẩy giờ lùi lại");
var edited = new[] { evening }.Where(item => item.Id != 1);
Check(!edited.Any(item => RoomSchedule.Overlaps(At(18), At(20, 15), item)), "Bỏ qua chính suất đang sửa");
Console.WriteLine($"{count} checks passed.");
