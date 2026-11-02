using System.Drawing.Drawing2D;

namespace YeuMinhEmCinema.Admin;

/// <summary>Banner trang trí trang Tổng quan, không hiển thị số liệu giả hoặc gọi CSDL.</summary>
internal sealed class AdminWelcomeCard : Control
{
    private readonly Font _title = new("Segoe UI", 17F, FontStyle.Bold);
    private readonly Font _smallTitle = new("Segoe UI", 14F, FontStyle.Bold);
    private readonly Font _caption = new("Segoe UI", 9F);
    private readonly Font _eyebrow = new("Segoe UI", 8F, FontStyle.Bold);

    internal AdminWelcomeCard()
    {
        DoubleBuffered = true;
        ResizeRedraw = true;
        TabStop = false;
        BackColor = AdminTheme.Background;
        AccessibleName = "YeuMinhEm Cinema — Không gian quản trị";
    }

    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        if (Width < 10 || Height < 10)
        {
            return;
        }

        e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;
        var bounds = new Rectangle(0, 0, Width - 1, Height - 1);
        using var path = SoftCorners.CreatePath(bounds, 18);
        using var background = new LinearGradientBrush(bounds,
            Color.FromArgb(18, 48, 89), Color.FromArgb(24, 91, 160), 12F);
        using var border = new Pen(Color.FromArgb(57, 122, 192));
        e.Graphics.FillPath(background, path);
        e.Graphics.DrawPath(border, path);

        int top = Height < 100 ? 10 : 17;
        int textWidth = Math.Max(50, Width - 180);
        const TextFormatFlags flags = TextFormatFlags.Left | TextFormatFlags.NoPrefix
            | TextFormatFlags.EndEllipsis | TextFormatFlags.SingleLine;
        TextRenderer.DrawText(e.Graphics, "YEUMINHEM CINEMA / KHÔNG GIAN QUẢN TRỊ", _eyebrow,
            new Rectangle(22, top, textWidth, 20), Color.FromArgb(196, 224, 248), flags);
        TextRenderer.DrawText(e.Graphics, "Mỗi suất chiếu, một trải nghiệm.", Height < 100 ? _smallTitle : _title,
            new Rectangle(20, top + 22, textWidth, 34), Color.White, flags);
        TextRenderer.DrawText(e.Graphics, "Lịch chiếu · Phim · Đơn vé · Báo cáo", _caption,
            new Rectangle(22, top + 58, textWidth, 22), Color.FromArgb(196, 224, 248), flags);

        DrawCinemaArt(e.Graphics);
    }

    private void DrawCinemaArt(Graphics graphics)
    {
        // Hình cuộn phim tự vẽ bằng GDI+, không cần tải ảnh hoặc font bên ngoài.
        float size = Math.Min(Height - 18, 98);
        float x = Width - size - 35;
        float y = (Height - size) / 2;
        using var disc = new SolidBrush(Color.FromArgb(89, 180, 232));
        using var hole = new SolidBrush(Color.FromArgb(22, 65, 112));
        using var line = new Pen(Color.FromArgb(143, 220, 255), 2);
        graphics.FillEllipse(disc, x, y, size, size);
        graphics.DrawEllipse(line, x + 4, y + 4, size - 8, size - 8);
        float centreX = x + size / 2;
        float centreY = y + size / 2;
        float holeSize = size * .2F;
        for (int i = 0; i < 4; i++)
        {
            double angle = i * Math.PI / 2;
            float hx = centreX + (float)Math.Cos(angle) * size * .25F - holeSize / 2;
            float hy = centreY + (float)Math.Sin(angle) * size * .25F - holeSize / 2;
            graphics.FillEllipse(hole, hx, hy, holeSize, holeSize);
        }

        using var centre = new SolidBrush(Color.FromArgb(221, 246, 255));
        graphics.FillEllipse(centre, centreX - 5, centreY - 5, 10, 10);
        graphics.DrawBezier(line, x + size * .8F, y + size * .85F,
            x + size * 1.12F, y + size * .6F,
            x + size * 1.2F, y + size * 1.02F,
            x + size * 1.03F, y + size * .95F);
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing)
        {
            _title.Dispose();
            _smallTitle.Dispose();
            _caption.Dispose();
            _eyebrow.Dispose();
        }

        base.Dispose(disposing);
    }
}
