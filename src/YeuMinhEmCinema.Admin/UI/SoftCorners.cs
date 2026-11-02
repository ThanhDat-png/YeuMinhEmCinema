using System.Drawing.Drawing2D;

namespace YeuMinhEmCinema.Admin;

/// <summary>Bo góc control WinForms thật; không dùng WebView hoặc thư viện UI ngoài.</summary>
internal static class SoftCorners
{
    private static readonly System.Runtime.CompilerServices.ConditionalWeakTable<Control, object> Attached = new();

    internal static void Attach(Control control, int radius)
    {
        if (Attached.TryGetValue(control, out _))
        {
            return;
        }

        Attached.Add(control, new object());
        control.SizeChanged += (_, _) => Update(control, radius);
        Update(control, radius);
    }

    private static void Update(Control control, int radius)
    {
        if (control.IsDisposed || control.Width < 2 || control.Height < 2)
        {
            return;
        }

        using var path = CreatePath(new Rectangle(0, 0, control.Width, control.Height), radius);
        var previous = control.Region;
        control.Region = new Region(path);
        previous?.Dispose();
    }

    internal static GraphicsPath CreatePath(Rectangle bounds, int radius)
    {
        var path = new GraphicsPath();
        int diameter = Math.Max(1, Math.Min(radius * 2, Math.Min(bounds.Width, bounds.Height)));
        path.AddArc(bounds.Left, bounds.Top, diameter, diameter, 180, 90);
        path.AddArc(bounds.Right - diameter, bounds.Top, diameter, diameter, 270, 90);
        path.AddArc(bounds.Right - diameter, bounds.Bottom - diameter, diameter, diameter, 0, 90);
        path.AddArc(bounds.Left, bounds.Bottom - diameter, diameter, diameter, 90, 90);
        path.CloseFigure();
        return path;
    }
}
