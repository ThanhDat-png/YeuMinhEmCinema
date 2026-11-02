namespace YeuMinhEmCinema.Admin;

internal sealed record RoomBooking(int Id, DateTime Start, DateTime Ready);

/// <summary>Khoảng chiếm phòng là [bắt đầu, kết thúc dọn phòng).</summary>
internal static class RoomSchedule
{
    internal static bool Overlaps(DateTime start, DateTime ready, RoomBooking booking)
    {
        return start < booking.Ready && booking.Start < ready;
    }

    private static DateTime RoundUpMinute(DateTime value)
    {
        var remainder = value.Ticks % TimeSpan.TicksPerMinute;
        return remainder == 0 ? value : value.AddTicks(TimeSpan.TicksPerMinute - remainder);
    }

    internal static DateTime NextStart(IEnumerable<RoomBooking> bookings, DateTime start, TimeSpan duration)
    {
        if (duration <= TimeSpan.Zero)
        {
            throw new ArgumentOutOfRangeException(nameof(duration));
        }

        var candidate = RoundUpMinute(start);

        foreach (var booking in bookings.OrderBy(item => item.Start))
        {
            if (booking.Ready <= candidate)
            {
                continue;
            }

            if (candidate.Add(duration) <= booking.Start)
            {
                return candidate;
            }

            if (booking.Start < candidate.Add(duration))
            {
                candidate = RoundUpMinute(booking.Ready);
            }
        }

        return candidate;
    }
}
