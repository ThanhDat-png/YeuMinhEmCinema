using System.Data;
using System.Net;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Hosting.Server.Features;
using YeuMinhEmCinema.Web.Controllers;
using YeuMinhEmCinema.Web.Data;

// Render controller + Razor thật qua HTTP; dữ liệu giả thay SQL để kiểm tra luồng trang.
var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders();
builder.WebHost.UseUrls("http://127.0.0.1:0");
builder.Services.AddControllersWithViews().AddApplicationPart(typeof(PhimController).Assembly);
var data = new DanhMucGia();
builder.Services.AddSingleton<PhimData>(data);
var app = builder.Build();
app.MapControllerRoute("default", "{controller=Phim}/{action=Lich}/{id?}");
await app.StartAsync();
try
{
    var address = app.Services.GetRequiredService<IServer>()
        .Features.Get<IServerAddressesFeature>()!.Addresses.Single();
    using var client = new HttpClient { BaseAddress = new Uri(address) };
    async Task<string> Get(string path)
    {
        var response = await client.GetAsync(path);
        var html = WebUtility.HtmlDecode(await response.Content.ReadAsStringAsync());
        if (!response.IsSuccessStatusCode)
            throw new Exception(path + ": " + response.StatusCode + " " + html);
        return html;
    }
    void Check(bool condition, string name)
    {
        if (!condition) throw new Exception("FAIL: " + name);
        Console.WriteLine("PASS: " + name);
    }

    var html = await Get("/Phim/Lich");
    Check(html.Contains("Các suất chiếu sắp tới") && html.Contains("Sau màn đêm")
        && html.Contains("/DatVe/Ghe/901") && data.BoLoc == (null, null, null),
        "Lịch mặc định tải suất gợi ý và có nút chọn ghế");
    html = await Get("/Phim/Lich?maRap=2");
    Check(html.Contains("Sau màn đêm") && data.BoLoc == (null, 2, null),
        "Gợi ý tôn trọng rạp ngay khi chưa chọn phim");
    await Get("/Phim/Lich?maRap=2&ngay=2026-11-05");
    Check(data.BoLoc == (null, 2, new DateTime(2026, 11, 5)),
        "Lọc ngày và rạp không bắt buộc chọn phim");
    html = await Get("/Phim/Rap");
    Check(html.Contains("/Phim/PhimTaiRap/2"), "Nút tại cụm rạp đi vào trang riêng của rạp");
    html = await Get("/Phim/PhimTaiRap/2");
    Check(html.Contains("Rạp kiểm tra") && html.Contains("Sau màn đêm")
        && html.Contains("/Phim/ChiTiet/1?maRap=2") && !html.Contains("#lich-chieu"),
        "Trang riêng rạp hiển thị phim và mở chi tiết với đúng rạp");
    html = await Get("/Phim/ChiTiet/1?maRap=2");
    Check(html.Contains("Sau màn đêm") && html.Contains("/Phim/PhimTaiRap/2")
        && data.BoLoc == (1, 2, null), "Chi tiết phim giữ rạp và có lối quay về");
    data.Rong = true;
    html = await Get("/Phim/Lich");
    Check(html.Contains("Chưa có suất mở bán phù hợp") && html.Contains("Khám phá phim"),
        "Lịch rỗng có thông báo và lối khám phá phim");
    html = await Get("/Phim/PhimTaiRap/2");
    Check(html.Contains("Rạp hiện chưa có suất"), "Rạp chưa có phim có thông báo riêng");
    Check((await client.GetAsync("/Phim/PhimTaiRap/999")).StatusCode == HttpStatusCode.NotFound,
        "Rạp không tồn tại trả 404");
    Check((await client.GetAsync("/Phim/Lich?maRap=-1")).StatusCode == HttpStatusCode.BadRequest,
        "Bộ lọc sai trả 400");
}
finally
{
    await app.StopAsync();
    await app.DisposeAsync();
}

class DanhMucGia : PhimData
{
    public bool Rong { get; set; }
    public (int?, int?, DateTime?) BoLoc { get; private set; }
    public DanhMucGia() : base(new WebDb(new ConfigurationBuilder().Build())) { }
    private static DataTable Table(params (string, Type)[] columns)
    {
        var t = new DataTable();
        foreach (var (name, type) in columns) t.Columns.Add(name, type);
        return t;
    }
    public override DataTable Rap()
    {
        var t = Table(("MaRap", typeof(int)), ("TenRap", typeof(string)), ("DiaChi", typeof(string)));
        t.Rows.Add(2, "Rạp kiểm tra", "Địa chỉ kiểm tra");
        return t;
    }
    public override DataTable DanhSach()
    {
        var t = Table(("MaPhim", typeof(int)), ("TenPhim", typeof(string)));
        t.Rows.Add(1, "Sau màn đêm");
        return t;
    }
    public override DataTable GanNhat(int? phim, int? rap, DateTime? ngay = null)
    {
        BoLoc = (phim, rap, ngay);
        var t = Table(("MaSuatChieu", typeof(int)), ("MaPhim", typeof(int)),
            ("TenPhim", typeof(string)), ("Poster", typeof(string)), ("TenRap", typeof(string)),
            ("DiaChi", typeof(string)), ("TenPhong", typeof(string)), ("DinhDang", typeof(string)),
            ("GioBatDau", typeof(DateTime)), ("SoGheTrong", typeof(int)));
        if (!Rong) t.Rows.Add(901, 1, "Sau màn đêm", "/images/poster-placeholder.svg",
            "Rạp kiểm tra", "Địa chỉ kiểm tra", "Phòng 01", "2D", DateTime.Now.AddDays(1), 30);
        return t;
    }
    public override DataTable PhimTaiRap(int rap)
    {
        var t = Table(("MaPhim", typeof(int)), ("TenPhim", typeof(string)), ("Poster", typeof(string)),
            ("ThoiLuong", typeof(int)), ("GioiHanTuoi", typeof(string)), ("SuatGanNhat", typeof(DateTime)));
        if (!Rong) t.Rows.Add(1, "Sau màn đêm", "/images/poster-placeholder.svg", 118, "T13", DateTime.Now.AddDays(1));
        return t;
    }
    public override DataRow? ChiTiet(int id)
    {
        var t = Table(("TenPhim", typeof(string)), ("Poster", typeof(string)), ("Trailer", typeof(string)),
            ("TrangThai", typeof(string)), ("GioiHanTuoi", typeof(string)), ("ThoiLuong", typeof(int)),
            ("NgayKhoiChieu", typeof(DateTime)), ("MoTa", typeof(string)));
        t.Rows.Add("Sau màn đêm", "/images/poster-placeholder.svg", "", "Đang chiếu", "T13", 118,
            DateTime.Today, "Mô tả phim");
        return t.Rows[0];
    }
}
