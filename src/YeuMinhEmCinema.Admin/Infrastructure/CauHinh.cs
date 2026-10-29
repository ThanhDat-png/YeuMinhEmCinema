namespace YeuMinhEmCinema.Admin;

public static class CauHinh
{
    public static string ChuoiKetNoi
    {
        get;
        set;
    } = Environment.GetEnvironmentVariable("YMC_CONNECTION")
    ?? @"Server=.\SQLEXPRESS;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;";
}
