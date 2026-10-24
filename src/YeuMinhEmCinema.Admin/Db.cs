using System.Data;
using Microsoft.Data.SqlClient;
namespace YeuMinhEmCinema.Admin;
internal readonly record struct Tvp(string TypeName,DataTable Value);
internal static class Db
{
 internal static int Actor => PhienDangNhap.TaiKhoan?.MaTaiKhoan ?? throw new InvalidOperationException("Bạn cần đăng nhập lại.");
 internal static SqlCommand Command(string text,bool proc,params (string Name,object? Value)[] args)
 {
  var c=new SqlCommand(text){CommandType=proc?CommandType.StoredProcedure:CommandType.Text,CommandTimeout=30};
  foreach(var (n,v) in args)
  {
   SqlParameter p;
   if(v is Tvp tv){p=c.Parameters.Add(n,SqlDbType.Structured);p.TypeName=tv.TypeName;p.Value=tv.Value;continue;}
   var type=v switch {int=>SqlDbType.Int,long=>SqlDbType.BigInt,bool=>SqlDbType.Bit,Guid=>SqlDbType.UniqueIdentifier,
    DateTime=>SqlDbType.DateTime2,decimal=>SqlDbType.Decimal,byte[]=>SqlDbType.Binary,_=>SqlDbType.NVarChar};
   p=c.Parameters.Add(n,type);p.Value=v??DBNull.Value;
   if(type==SqlDbType.NVarChar)p.Size=-1;
   if(type==SqlDbType.Binary)p.Size=8;
   if(type==SqlDbType.Decimal){p.Precision=18;p.Scale=0;}
   if(type==SqlDbType.DateTime2)p.Scale=0;
  }
  return c;
 }
 internal static DataSet Read(SqlCommand c)
 {
  using(c)using(var cn=new SqlConnection(CauHinh.ChuoiKetNoi))using(var da=new SqlDataAdapter(c))
  {c.Connection=cn;var ds=new DataSet();da.Fill(ds);return ds;}
 }
 internal static DataTable Query(string sql,params (string,object?)[] p)=>Read(Command(sql,false,p)).Tables[0];
 internal static DataSet Call(string name,params (string,object?)[] p)=>Read(Command(name,true,p));
 internal static DataTable Table(string name,params (string,object?)[] p)=>Call(name,p).Tables[0];
 internal static void Require(string right,int? rap=null)=>Call("dbo.sp_YMC_YeuCauQuyen",("@MaTaiKhoan",Actor),("@MaQuyen",right),("@MaRap",rap));
 internal static bool Has(string right)=>PhienDangNhap.TaiKhoan?.DanhSachQuyen.Contains(right)==true;
 internal static void RefreshRights()
 {
  var current=PhienDangNhap.TaiKhoan ?? throw new InvalidOperationException("Bạn chưa đăng nhập.");
  var t=Table("dbo.sp_YMC_LayQuyenTaiKhoan",("@MaTaiKhoan",Actor));
  PhienDangNhap.TaiKhoan=new KetQuaDangNhap{MaTaiKhoan=current.MaTaiKhoan,TenDangNhap=current.TenDangNhap,
   DanhSachQuyen=t.AsEnumerable().Select(r=>(string)r["MaQuyen"]).ToArray()};
 }
 internal static DataTable Raps()=>Query("SELECT MaRap,TenRap FROM dbo.Rap WHERE dbo.fn_YMC_CoPhamViRap(@A,MaRap)=1 ORDER BY MaRap",("@A",Actor));
 internal static int RoomRap(int room)=>Convert.ToInt32(Query("SELECT MaRap FROM dbo.PhongChieu WHERE MaPhong=@P",("@P",room)).Rows.Cast<DataRow>().FirstOrDefault()?[0]??throw new ArgumentException("Không tìm thấy phòng."));
 internal static DataRow? First(DataTable t)=>t.Rows.Count>0?t.Rows[0]:null;
 internal static string Error(Exception ex)
 {
  try{var dir=Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),"YeuMinhEmCinema","Logs");Directory.CreateDirectory(dir);
   File.AppendAllText(Path.Combine(dir,"admin.log"),$"{DateTime.UtcNow:O} {ex.GetType().Name} {(ex is SqlException se?se.Number:0)}\n{ex.StackTrace}\n");}catch{ }
  if(ex is SqlException s){if(s.Number>=50000)return s.Message;if(s.Number is 2601 or 2627)return "Dữ liệu bị trùng. Hãy tải lại và kiểm tra mã/tên.";
   return $"Lỗi SQL {s.Number} tại {s.Procedure} (dòng {s.LineNumber}).\nHãy gửi mã lỗi này để kiểm tra đúng nguyên nhân.";}
  return ex is ArgumentException or InvalidOperationException ? ex.Message : "Có lỗi xử lý. Hãy tải lại dữ liệu và thử lại.";
 }
}
