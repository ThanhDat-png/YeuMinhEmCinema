namespace YeuMinhEmCinema.Admin;
public partial class UcKiemTraVe:DataPage
{
 private readonly TextBox code=AdminUi.Text(100);
 public UcKiemTraVe():base("Kiểm vé — quét QR hoặc dán mã vé")
 {
  code.Width=380;Bar.Controls.Add(code);Action("Tra cứu",()=>Check(false));Action("Xác nhận vào rạp",()=>{if(AdminUi.Confirm("Xác nhận người cầm vé đã vào rạp?"))Check(true);},"VE_KIEM_TRA");
  code.KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Enter){e.SuppressKeyPress=true;Run(()=>Check(false));}};
 }
 private void Check(bool confirm){if(!Guid.TryParse(code.Text.Trim(),out var id))throw new ArgumentException("Mã QR/mã vé phải là GUID hợp lệ.");var t=Db.Table("dbo.sp_YMC_KiemTraVe",("@NguoiThucHien",Db.Actor),("@MaVe",id),("@XacNhanVaoRap",confirm));AdminUi.Bind(Grid,t);if(confirm){MessageBox.Show("Đã xác nhận vé vào rạp.");code.Clear();code.Focus();}}
}
