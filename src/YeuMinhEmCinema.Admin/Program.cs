namespace YeuMinhEmCinema.Admin;

internal static class Program
{
    [STAThread] static void Main()
    {
        ApplicationConfiguration.Initialize();
        while (true)
        {
            using var login = new FormDangNhap();
            if (login.ShowDialog() != DialogResult.OK || login.TaiKhoanDaDangNhap is null)
                return;
            PhienDangNhap.TaiKhoan = login.TaiKhoanDaDangNhap;
            try
            {
                using var main = new Form1();
                Application.Run(main);
                if (!main.YeuCauDangXuat)
                    return;
            }
            catch (Exception e)
            {
                MessageBox.Show(Db.Error(e), "Không mở được Admin");
                return;
            }
            finally
            {
                PhienDangNhap.TaiKhoan = null;
            }
        }
    }
}

internal static class PhienDangNhap
{
    internal static KetQuaDangNhap? TaiKhoan
    {
        get;
        set;
    }
}
