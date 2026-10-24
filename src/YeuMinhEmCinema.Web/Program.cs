using YeuMinhEmCinema.Web.Data;
using YeuMinhEmCinema.Web.Services;
using Microsoft.AspNetCore.Authentication.Cookies;

// Mỗi request dùng DAL riêng; không chia sẻ kết nối SQL giữa các khách.
var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.Local.json", optional: true);
// Biến môi trường và tham số chạy được ưu tiên hơn file cấu hình riêng của máy.
// File Local dùng Windows Authentication và đã được gitignore, không ghi bí mật vào Git.
builder.Configuration.AddEnvironmentVariables();
builder.Configuration.AddCommandLine(args);
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add(new Microsoft.AspNetCore.Mvc.AutoValidateAntiforgeryTokenAttribute());
    options.Filters.Add<WebErrors>();
});
builder.Services.AddScoped<TrangChuData>();
builder.Services.AddScoped<WebDb>();
builder.Services.AddScoped<PhimData>();
builder.Services.AddScoped<TaiKhoanData>();
builder.Services.AddScoped<DatVeData>();
builder.Services.AddScoped<KhachHangSession>();
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/TaiKhoan/DangNhap";
        options.AccessDeniedPath = "/TaiKhoan/DangNhap";
        options.Cookie.Name = "YMC.KhachHang";
        options.Cookie.HttpOnly = true;
        options.Cookie.SameSite = SameSiteMode.Lax;
        options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
        options.ExpireTimeSpan = TimeSpan.FromHours(2);
        options.EventsType = typeof(KhachHangSession);
    });
builder.Services.AddAuthorization();
var app = builder.Build();
app.UseExceptionHandler("/Home/Loi");
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllerRoute("default", "{controller=Home}/{action=Index}/{id?}");
app.Run();
