using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcDonDatVe:DataPage
{
 private readonly ComboBox rap=AdminUi.Combo(),tt=AdminUi.Combo();
 private readonly DateTimePicker tu=new(){Value=DateTime.Today.AddDays(-7),Width=140,Format=DateTimePickerFormat.Short},den=new(){Width=140,Format=DateTimePickerFormat.Short};
 private readonly TextBox search=AdminUi.Text(100);
 private readonly Button before,after;
 private bool loading;
 private readonly Label page=new(){AutoSize=true,Margin=new Padding(8)};private int trang=1;
 public UcDonDatVe():base("Đơn đặt vé và giao dịch")
 {
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Rạp"),rap,AdminUi.Label("Từ"),tu,AdminUi.Label("Đến"),den,tt});
  tt.Items.AddRange(new object[]{"Tất cả","CHO_THANH_TOAN","DA_THANH_TOAN","DA_HUY","HET_HAN","DA_HOAN_TIEN"});tt.SelectedIndex=0;
  search.Width=330;search.PlaceholderText="Mã đơn / mã thu tiền / GUID vé";search.AccessibleName="Tìm mã đơn, giao dịch hoặc vé";
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Tìm chính xác theo mã"),search});
  Action("Lọc / tìm",()=>{trang=1;Reload();});
  before=AdminUi.Button("Trước",()=>Run(()=>{trang=Math.Max(1,trang-1);Reload();}));
  after=AdminUi.Button("Sau",()=>Run(()=>{trang++;Reload();}));
  before.Enabled=after.Enabled=false;Bar.Controls.AddRange(new Control[]{before,after,page});
  void Reset(){if(loading)return;trang=1;Grid.DataSource=null;before.Enabled=after.Enabled=false;page.Text="Bộ lọc đã đổi — bấm Lọc / tìm (mã kết hợp rạp/ngày/trạng thái).";}
  search.TextChanged+=(_,_)=>Reset();rap.SelectedIndexChanged+=(_,_)=>Reset();tt.SelectedIndexChanged+=(_,_)=>Reset();
  tu.ValueChanged+=(_,_)=>Reset();den.ValueChanged+=(_,_)=>Reset();
  search.KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Enter){e.SuppressKeyPress=true;Run(()=>{trang=1;Reload();});}};
  Action("Chi tiết / xuất vé QR",Detail);Action("Hủy đơn chưa trả",Cancel,"DON_HANG_HUY");Action("Ghi nhận hoàn tiền",Refund,"HOAN_TIEN");
  if(Db.Has("BAN_VE")&&!Db.Has("DON_HANG_HUY"))Action("Hủy đơn quầy tự tạo",Cancel,"BAN_VE");
  StandardActions(Reload);Load+=(_,_)=>Run(()=>{loading=true;try{AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");}finally{loading=false;}Reload();});
 }
 private void Reload()
 {
  before.Enabled=after.Enabled=false;Grid.DataSource=null;
  page.Text="Đang tải…";
  try
  {
   if(tu.Value.Date>den.Value.Date)throw new ArgumentException("Từ ngày phải trước hoặc bằng đến ngày.");
   var result=GiaoDichDAL.Don(AdminUi.Id(rap),tu.Value,den.Value,tt.SelectedIndex==0?null:tt.Text,trang,search.Text.Trim());
   int pages=Math.Max(1,(int)Math.Ceiling(result.TongKetQua/50m));
   if(trang>pages){trang=pages;result=GiaoDichDAL.Don(AdminUi.Id(rap),tu.Value,den.Value,tt.SelectedIndex==0?null:tt.Text,trang,search.Text.Trim());pages=Math.Max(1,(int)Math.Ceiling(result.TongKetQua/50m));}
   AdminUi.Bind(Grid,result.DuLieu);
   if(Grid.Columns["TongKetQua"] is DataGridViewColumn countColumn)countColumn.Visible=false;
   page.Text=result.TongKetQua==0?"Không có đơn phù hợp với mã và bộ lọc.":$"Trang {trang}/{pages} — {result.DuLieu.Rows.Count} dòng / {result.TongKetQua} đơn";
   before.Enabled=trang>1;after.Enabled=trang<pages;
  }
  catch{page.Text="Không tải được đơn. Kiểm tra bộ lọc rồi thử lại.";throw;}
 }
 private long Selected()=>Convert.ToInt64(AdminUi.Row(Grid)["MaDonHang"]);
 private void Detail(){long id=Selected();var ds=GiaoDichDAL.ChiTiet(id);using var f=AdminUi.Dialog($"Đơn #{id}");var tabs=new TabControl{Dock=DockStyle.Fill};
  string[] names={"Đơn hàng","Vé","Bắp nước","Thu tiền","Hoàn tiền","Thành phần combo"};for(int i=0;i<ds.Tables.Count;i++){var p=new TabPage(names[i]);var g=AdminUi.Grid();AdminUi.Bind(g,ds.Tables[i]);p.Controls.Add(g);tabs.TabPages.Add(p);}
  var export=AdminUi.Button("Xuất phiếu / vé QR",()=>HoaDonExporter.Xuat(id));export.Dock=DockStyle.Bottom;f.Controls.Add(tabs);f.Controls.Add(export);f.ShowDialog(this);}
 private void Cancel(){long id=Selected();using var f=new EditDialog("Hủy đơn chưa thanh toán");var reason=f.TextField("Lý do",max:500);f.Save(()=>{if(string.IsNullOrWhiteSpace(reason.Text))throw new ArgumentException("Nhập lý do.");GiaoDichDAL.Huy(id,reason.Text.Trim());});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private void Refund(){long id=Selected();using var f=new EditDialog("Ghi nhận hoàn TOÀN BỘ đơn");f.Field("Chỉ lưu sau khi đã hoàn tiền thực tế cho khách.",new Label{Text="SQL không tự chuyển tiền.",AutoSize=true});var code=f.TextField("Mã giao dịch hoàn (duy nhất)",max:100);var reason=f.TextField("Lý do",max:500);
  var checkedBox=f.Field("Xác nhận",new CheckBox{Text="Đã hoàn tiền và đối chiếu chứng từ",AutoSize=true});f.Save(()=>{if(!checkedBox.Checked||string.IsNullOrWhiteSpace(code.Text)||string.IsNullOrWhiteSpace(reason.Text))throw new ArgumentException("Điền mã/lý do và xác nhận đã hoàn tiền.");
   Db.Call("dbo.sp_YMC_GhiNhanHoanTien",("@NguoiThucHien",Db.Actor),("@MaDonHang",id),("@MaGiaoDichHoan",code.Text.Trim()),("@LyDo",reason.Text.Trim()));});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
}
