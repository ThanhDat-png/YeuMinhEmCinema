using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcDonDatVe:DataPage
{
 private readonly ComboBox rap=AdminUi.Combo(),tt=AdminUi.Combo();
 private readonly DateTimePicker tu=new(){Value=DateTime.Today.AddDays(-7),Width=140,Format=DateTimePickerFormat.Short},den=new(){Width=140,Format=DateTimePickerFormat.Short};
 private readonly Label page=new(){AutoSize=true,Margin=new Padding(8)};private int trang=1;
 public UcDonDatVe():base("Đơn đặt vé và giao dịch")
 {
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Rạp"),rap,AdminUi.Label("Từ"),tu,AdminUi.Label("Đến"),den,tt});
  tt.Items.AddRange(new object[]{"Tất cả","CHO_THANH_TOAN","DA_THANH_TOAN","DA_HUY","HET_HAN","DA_HOAN_TIEN"});tt.SelectedIndex=0;
  Action("Lọc",()=>{trang=1;Reload();});Action("Trước",()=>{trang=Math.Max(1,trang-1);Reload();});Action("Sau",()=>{trang++;Reload();});Bar.Controls.Add(page);
  Action("Chi tiết / xuất vé QR",Detail);Action("Hủy đơn chưa trả",Cancel,"DON_HANG_HUY");Action("Ghi nhận hoàn tiền",Refund,"HOAN_TIEN");
  if(Db.Has("BAN_VE")&&!Db.Has("DON_HANG_HUY"))Action("Hủy đơn quầy tự tạo",Cancel,"BAN_VE");
  StandardActions(Reload);Load+=(_,_)=>Run(()=>{AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");Reload();});
 }
 private void Reload(){var t=GiaoDichDAL.Don(AdminUi.Id(rap),tu.Value,den.Value,tt.SelectedIndex==0?null:tt.Text,trang);AdminUi.Bind(Grid,t);page.Text=$"Trang {trang} — {t.Rows.Count} dòng";}
 private long Selected()=>Convert.ToInt64(AdminUi.Row(Grid)["MaDonHang"]);
 private void Detail(){long id=Selected();var ds=GiaoDichDAL.ChiTiet(id);using var f=AdminUi.Dialog($"Đơn #{id}");var tabs=new TabControl{Dock=DockStyle.Fill};
  string[] names={"Đơn hàng","Vé","Bắp nước","Thu tiền","Hoàn tiền","Thành phần combo"};for(int i=0;i<ds.Tables.Count;i++){var p=new TabPage(names[i]);var g=AdminUi.Grid();AdminUi.Bind(g,ds.Tables[i]);p.Controls.Add(g);tabs.TabPages.Add(p);}
  var export=AdminUi.Button("Xuất phiếu / vé QR",()=>HoaDonExporter.Xuat(id));export.Dock=DockStyle.Bottom;f.Controls.Add(tabs);f.Controls.Add(export);f.ShowDialog(this);}
 private void Cancel(){long id=Selected();using var f=new EditDialog("Hủy đơn chưa thanh toán");var reason=f.TextField("Lý do",max:500);f.Save(()=>{if(string.IsNullOrWhiteSpace(reason.Text))throw new ArgumentException("Nhập lý do.");GiaoDichDAL.Huy(id,reason.Text.Trim());});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private void Refund(){long id=Selected();using var f=new EditDialog("Ghi nhận hoàn TOÀN BỘ đơn");f.Field("Chỉ lưu sau khi đã hoàn tiền thực tế cho khách.",new Label{Text="SQL không tự chuyển tiền.",AutoSize=true});var code=f.TextField("Mã giao dịch hoàn (duy nhất)",max:100);var reason=f.TextField("Lý do",max:500);
  var checkedBox=f.Field("Xác nhận",new CheckBox{Text="Đã hoàn tiền và đối chiếu chứng từ",AutoSize=true});f.Save(()=>{if(!checkedBox.Checked||string.IsNullOrWhiteSpace(code.Text)||string.IsNullOrWhiteSpace(reason.Text))throw new ArgumentException("Điền mã/lý do và xác nhận đã hoàn tiền.");
   Db.Call("dbo.sp_YMC_GhiNhanHoanTien",("@NguoiThucHien",Db.Actor),("@MaDonHang",id),("@MaGiaoDichHoan",code.Text.Trim()),("@LyDo",reason.Text.Trim()));});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
}
