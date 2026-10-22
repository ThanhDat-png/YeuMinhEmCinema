using Microsoft.Data.SqlClient;
using System.Data;

// Chỉ chạy thủ công sau khi cài script 04–08. Tạo và dọn fixture riêng, không sửa dữ liệu người dùng.
var cs=Environment.GetEnvironmentVariable("YMC_TEST_CONNECTION")??
    @"Server=.\SQLEXPRESS;Database=YeuMinhEmCinema;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;";
var tag="YMC_TEST_"+Guid.NewGuid().ToString("N");
int rap=0,phim=0,loai=0,phong=0,phong2=0;
var ngay=DateTime.Today.AddDays(14);var gio=ngay.AddHours(18);
SqlConnection Open(){var c=new SqlConnection(cs);c.Open();return c;}
int Insert(string sql,params (string,object)[] ps)
{
    using var cn=Open();using var c=new SqlCommand(sql+"; SELECT CONVERT(INT,SCOPE_IDENTITY());",cn);
    foreach(var (k,v) in ps)c.Parameters.AddWithValue(k,v);
    return Convert.ToInt32(c.ExecuteScalar());
}
DataTable Proc(string name,params (string,object)[] ps)
{
    using var cn=Open();using var c=new SqlCommand(name,cn){CommandType=CommandType.StoredProcedure,CommandTimeout=45};
    foreach(var(k,v)in ps)c.Parameters.AddWithValue(k,v);
    using var da=new SqlDataAdapter(c);var dt=new DataTable();da.Fill(dt);return dt;
}
int Add(int room,DateTime start)=>Convert.ToInt32(Proc("dbo.sp_ThemSuatChieu",("@MaPhim",phim),("@MaPhong",room),("@GioBatDau",start),("@PhutDonPhong",15)).Rows[0][0]);
void Edit(int id,int room,DateTime start)=>Proc("dbo.sp_SuaSuatChieu",("@MaSuatChieu",id),("@MaPhim",phim),("@MaPhong",room),("@GioBatDau",start),("@PhutDonPhong",15));
void State(int id,string tt)=>Proc("dbo.sp_DoiTrangThaiSuatChieu",("@MaSuatChieu",id),("@TrangThaiMoi",tt));
DataTable Copy(DateTime dest,bool preview,string? sig=null)=>Proc("dbo.sp_SaoChepLich",("@NgayNguon",ngay),("@NgayDich",dest),("@MaRap",rap),("@MaPhong",phong),("@XemTruoc",preview),("@ChuKy",(object?)sig??DBNull.Value));
void Expected(Action f,int code,string label)
{
    try{f();}catch(SqlException ex)when(ex.Number==code){Console.WriteLine("PASS: "+label);return;}
    throw new Exception("Không chặn đúng: "+label);
}
int Count(DateTime date)
{
    using var cn=Open();using var c=new SqlCommand("SELECT COUNT(*) FROM dbo.SuatChieu WHERE MaPhong=@p AND GioBatDau>=@n AND GioBatDau<DATEADD(DAY,1,@n)",cn);
    c.Parameters.AddWithValue("@p",phong);c.Parameters.AddWithValue("@n",date.Date);return Convert.ToInt32(c.ExecuteScalar());
}
try
{
    rap=Insert("INSERT dbo.Rap(TenRap,TrangThai) VALUES(@t,N'Đang hoạt động')",("@t",tag));
    phim=Insert("INSERT dbo.Phim(TenPhim,ThoiLuong,NgayKhoiChieu,GioiHanTuoi,TrangThai) VALUES(@t,118,@n,'P',N'Đang chiếu')",("@t",tag),("@n",ngay));
    loai=Insert("INSERT dbo.LoaiGhe(TenLoai) VALUES(@t)",("@t",tag));
    phong=Insert("INSERT dbo.PhongChieu(MaRap,TenPhong,TrangThai) VALUES(@r,'TEST1',N'Đang hoạt động')",("@r",rap));
    phong2=Insert("INSERT dbo.PhongChieu(MaRap,TenPhong,TrangThai) VALUES(@r,'TEST2',N'Đang hoạt động')",("@r",rap));
    foreach(int p in new[]{phong,phong2})Insert("INSERT dbo.Ghe(MaPhong,HangGhe,SoGhe,MaLoaiGhe,TrangThai) VALUES(@p,'A',1,@l,N'Hoạt động')",("@p",p),("@l",loai));
    int first=Add(phong,gio);
    Expected(()=>Add(phong,gio),50009,"Trùng giờ");
    Expected(()=>Add(phong,gio.AddMinutes(30)),50009,"Bắt đầu nằm trong suất cũ");
    Expected(()=>Add(phong,gio.AddMinutes(-60)),50009,"Bắt đầu trước và giao suất cũ");
    Expected(()=>Add(phong,gio.AddMinutes(132)),50009,"Thiếu một phút dọn phòng");
    int second=Add(phong,gio.AddMinutes(133));Console.WriteLine("PASS: Đúng ranh giới 20:13");
    Add(phong2,gio);Console.WriteLine("PASS: Phòng khác cùng giờ");
    Edit(second,phong,gio.AddMinutes(133));Console.WriteLine("PASS: Sửa không xung đột với chính mình");
    Expected(()=>Edit(first,phong2,gio),50009,"Đổi phòng trùng lịch");
    State(first,"Ngừng bán");Expected(()=>Add(phong,gio),50009,"Ngừng bán vẫn chiếm lịch");
    State(first,"Đã hủy");Expected(()=>State(first,"Mở bán"),50022,"Không mở lại suất đã hủy");
    Add(phong,gio);Console.WriteLine("PASS: Hủy giải phóng lịch");
    Expected(()=>Add(phong,DateTime.Now.AddMinutes(-10)),50003,"Giờ quá khứ");
    int night=Add(phong,ngay.AddHours(23).AddMinutes(30));Console.WriteLine("PASS: Suất qua đêm");
    Expected(()=>Add(phong,ngay.AddDays(1).AddMinutes(30)),50009,"Xung đột từ suất hôm trước qua đêm");
    var preview=Copy(ngay.AddDays(2),true);string sig=preview.Rows[0]["ChuKy"].ToString()!;
    int copied=Convert.ToInt32(Copy(ngay.AddDays(2),false,sig).Rows[0][0]);
    if(copied!=preview.Rows.Count)throw new Exception("Sai số suất sao chép");
    Console.WriteLine("PASS: Sao chép toàn nhóm, không lấy suất hủy");
    Expected(()=>Copy(ngay.AddDays(2),false,sig),50009,"Sao chép trùng ngày đích");
    var p3=Copy(ngay.AddDays(4),true);string sig3=p3.Rows[0]["ChuKy"].ToString()!;
    int before=Count(ngay.AddDays(4));
    Add(phong,ngay.AddDays(4).AddHours(23).AddMinutes(30));
    Expected(()=>Copy(ngay.AddDays(4),false,sig3),50009,"Cả nhóm bị chặn khi suất cuối xung đột");
    if(Count(ngay.AddDays(4))!=before+1)throw new Exception("Đã tạo dữ liệu dở dang");
    Console.WriteLine("PASS: Không có suất sao chép dở dang");
    var stale=Copy(ngay.AddDays(6),true);string old=stale.Rows[0]["ChuKy"].ToString()!;
    State(second,"Ngừng bán");Expected(()=>Copy(ngay.AddDays(6),false,old),50034,"Nguồn đổi sau xem trước");
    var results=await Task.WhenAll(Enumerable.Range(0,2).Select(_=>Task.Run(()=>
    {
        try{Add(phong2,ngay.AddDays(8).AddHours(18));return true;}
        catch(SqlException ex)when(ex.Number==50009){return false;}
    })));
    if(results.Count(x=>x)!=1)throw new Exception("Lỗi chống ghi đồng thời");
    Console.WriteLine("PASS: Hai kết nối đồng thời chỉ tạo một suất");
}
finally
{
    using var cn=Open();using var c=new SqlCommand(@"SET XACT_ABORT ON; BEGIN TRAN;
        DELETE sc FROM dbo.SuatChieu sc JOIN dbo.PhongChieu p ON p.MaPhong=sc.MaPhong WHERE p.MaRap=@r;
        DELETE g FROM dbo.Ghe g JOIN dbo.PhongChieu p ON p.MaPhong=g.MaPhong WHERE p.MaRap=@r;
        DELETE dbo.PhongChieu WHERE MaRap=@r; DELETE dbo.Rap WHERE MaRap=@r;
        DELETE dbo.Phim WHERE MaPhim=@f; DELETE dbo.LoaiGhe WHERE MaLoai=@l; COMMIT;",cn);
    c.Parameters.AddWithValue("@r",rap);c.Parameters.AddWithValue("@f",phim);c.Parameters.AddWithValue("@l",loai);c.ExecuteNonQuery();
    Console.WriteLine("Đã dọn fixture: "+tag);
}
