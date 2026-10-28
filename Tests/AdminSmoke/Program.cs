using Microsoft.AspNetCore.Identity;
using System.Data;
using System.Text;
using YeuMinhEmCinema.Admin;
void Check(bool good,string name){if(!good)throw new Exception("FAIL: "+name);Console.WriteLine("PASS: "+name);}
string pass="Mật khẩu thử có dấu 123!";string a=BaoMatMatKhau.TaoHash(pass),b=BaoMatMatKhau.TaoHash(pass);
Check(a!=b,"Hai tài khoản cùng mật khẩu nhận salt/hash khác nhau");
Check(BaoMatMatKhau.KiemTra(a,pass)!=PasswordVerificationResult.Failed,"Mật khẩu tiếng Việt kiểm tra đúng");
Check(BaoMatMatKhau.KiemTra(a,pass+" ")==PasswordVerificationResult.Failed,"Không tự Trim mật khẩu");
Check(BaoMatMatKhau.KiemTra(a,"SaiMatKhau123")==PasswordVerificationResult.Failed,"Sai mật khẩu bị từ chối");
Check(BaoMatMatKhau.KiemTra("not-a-hash",pass)==PasswordVerificationResult.Failed,"Hash hỏng bị từ chối");
bool shortRejected=false;try{BaoMatMatKhau.TaoHash("123");}catch(ArgumentException){shortRejected=true;}Check(shortRejected,"Mật khẩu ngắn không được tạo");
var dt=new DataTable();dt.Columns.Add("Tên");dt.Columns.Add("Ghi chú");dt.Rows.Add("Nguyễn Đạt","=SUM(A1:A2)");dt.Rows.Add("A, B","Một \"vé\"\r\nhai dòng");
string path=Path.Combine(Path.GetTempPath(),"cinema-smoke-"+Guid.NewGuid()+".csv");try{CsvUtility.Ghi(path,dt);var bytes=File.ReadAllBytes(path);Check(bytes.Take(3).SequenceEqual(new byte[]{239,187,191}),"CSV có UTF-8 BOM");var csv=File.ReadAllText(path,Encoding.UTF8);Check(csv.Contains("Nguyễn Đạt")&&csv.Contains("'=SUM")&&csv.Contains("\"\"vé\"\""),"CSV giữ tiếng Việt, escape dấu nháy và chặn công thức");}finally{File.Delete(path);}
Guid ticket=Guid.Parse("abc12345-1234-4321-9123-0123456789ab");var png=TicketQr.Create(ticket);Check(png.Take(8).SequenceEqual(new byte[]{137,80,78,71,13,10,26,10}),"QR vé tạo được PNG hợp lệ");
if(args.Length>0)File.WriteAllBytes(args[0],png);

// Kiểm quy tắc tiền mặt production dưới cả hai culture thường gặp trên máy nhóm.
var originalCulture=System.Globalization.CultureInfo.CurrentCulture;
try
{
 foreach(var culture in new[]{"vi-VN","en-US"})
 {
  System.Globalization.CultureInfo.CurrentCulture=new(culture);
  Check(TienMat.TienThua(80000,"80000")==0,$"{culture}: tiền vừa đủ");
  Check(TienMat.TienThua(80000,"100.000")==20000,$"{culture}: tiền thừa và dấu ngăn nghìn Việt Nam");
  Check(TienMat.Doc(" 100000 ")==100000,$"{culture}: khoảng trắng hai đầu");
  foreach(var invalid in new[]{"", "-1", "1,5", "80.50", "1e5", "100,000", "100 000", "abc", "1000000000000000000"})
  {
   bool rejected=false;try{TienMat.Doc(invalid);}catch(ArgumentException){rejected=true;}
   Check(rejected,$"{culture}: chặn tiền không hợp lệ '{invalid}'");
  }
  bool shortCash=false;try{TienMat.TienThua(80000,"79000");}catch(ArgumentException){shortCash=true;}
  Check(shortCash,$"{culture}: chặn thiếu tiền");
 }
 Check(TienMat.Doc("999999999999999999")==999999999999999999m,"Biên số tiền 18 chữ số chính xác");
 bool noTotal=false;try{TienMat.TienThua(0,"100000");}catch(ArgumentException){noTotal=true;}
 Check(noTotal,"Không thu tiền khi chưa có tổng đơn hợp lệ");
}
finally{System.Globalization.CultureInfo.CurrentCulture=originalCulture;}
