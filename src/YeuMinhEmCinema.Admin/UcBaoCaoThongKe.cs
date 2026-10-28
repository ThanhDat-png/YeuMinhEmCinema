using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcBaoCaoThongKe : DataPage
{
 private readonly ComboBox rap=AdminUi.Combo(),phim=AdminUi.Combo();
 private readonly DateTimePicker tu=new(){Value=DateTime.Today.AddDays(-6),Width=130,Format=DateTimePickerFormat.Custom,CustomFormat="dd/MM/yyyy"},
  den=new(){Width=130,Format=DateTimePickerFormat.Custom,CustomFormat="dd/MM/yyyy"};
 private readonly Label totals=new(){Dock=DockStyle.Fill,UseMnemonic=false,Padding=new Padding(10,4,10,2)};
 private readonly DoanhThuChart chart=new(){Dock=DockStyle.Fill};
 private string kind="Thu";
 private bool loading;

 public UcBaoCaoThongKe() : base("Báo cáo doanh thu, phim và suất chiếu")
 {
  rap.AccessibleName="Rạp báo cáo";phim.AccessibleName="Phim báo cáo";phim.Width=260;
  tu.AccessibleName="Từ ngày báo cáo";den.AccessibleName="Đến ngày báo cáo";
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Rạp"),rap,AdminUi.Label("Phim"),phim,
   AdminUi.Label("Từ (VN)"),tu,AdminUi.Label("Đến (VN)"),den});
  Action("Thu / hoàn tiền",()=>{kind="Thu";Reload();});
  Action("Hiệu quả phim",()=>{kind="Phim";Reload();});
  Action("Từng suất chiếu",()=>{kind="Suat";Reload();});
  Action("Bắp nước bán",()=>{kind="Fnb";Reload();});
  StandardActions(Reload);
  var split=new TableLayoutPanel{Dock=DockStyle.Fill,RowCount=3,ColumnCount=1};
  split.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));
  split.RowStyles.Add(new RowStyle(SizeType.Absolute,95));
  split.RowStyles.Add(new RowStyle(SizeType.Percent,60));split.RowStyles.Add(new RowStyle(SizeType.Percent,40));
  PageLayout.Controls.Remove(Grid);split.Controls.Add(totals,0,0);split.Controls.Add(Grid,0,1);split.Controls.Add(chart,0,2);PageLayout.Controls.Add(split,0,2);
  rap.SelectedIndexChanged+=(_,_)=>{if(!loading)Run(LoadMovies);};
  phim.SelectedIndexChanged+=(_,_)=>{if(!loading)Clear("Bộ lọc đã đổi. Bấm loại báo cáo hoặc Tải lại để áp dụng.");};
  tu.ValueChanged+=(_,_)=>{if(!loading)Clear("Khoảng ngày đã đổi. Bấm loại báo cáo hoặc Tải lại.");};
  den.ValueChanged+=(_,_)=>{if(!loading)Clear("Khoảng ngày đã đổi. Bấm loại báo cáo hoặc Tải lại.");};
  Load+=(_,_)=>Run(()=>{loading=true;try{AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");}finally{loading=false;}LoadMovies();Reload();});
 }

 private void Clear(string text){Grid.DataSource=null;Grid.Columns.Clear();chart.Values=Array.Empty<(string,decimal)>();chart.Invalidate();totals.Text=text;}
 private void LoadMovies()
 {
  Clear("Chọn loại báo cáo để tải số liệu.");loading=true;
  try
  {
   phim.DataSource=null;
   if(rap.SelectedValue is not int id)return;
   var t=Db.Table("dbo.sp_YMC_LayPhimBaoCao",("@NguoiThucHien",Db.Actor),("@MaRap",id));
   var all=t.NewRow();all["MaPhim"]=0;all["TenPhim"]="Tất cả phim";t.Rows.InsertAt(all,0);
   AdminUi.Bind(phim,t,"MaPhim","TenPhim");
  }
  finally{loading=false;}
 }
 private void Reload()
 {
  Clear("Đang tải báo cáo…");
  try
  {
   if(rap.SelectedValue is not int id){totals.Text="Chưa có rạp trong phạm vi tài khoản.";return;}
   if(tu.Value.Date>den.Value.Date)throw new ArgumentException("Từ ngày phải trước hoặc bằng đến ngày.");
   if(phim.SelectedValue is not int movie)throw new ArgumentException("Chọn phim hoặc tải lại danh sách rạp/phim.");
   string proc=kind switch{"Phim"=>"dbo.sp_YMC_ThongKePhim","Fnb"=>"dbo.sp_YMC_ThongKeFnb","Suat"=>"dbo.sp_YMC_BaoCaoTheoSuat",_=>"dbo.sp_YMC_BaoCaoThuChiTiet"};
   var t=Db.Table(proc,("@NguoiThucHien",Db.Actor),("@MaRap",id),("@TuNgay",tu.Value.Date),("@DenNgay",den.Value.Date),("@MaPhim",movie==0?null:(object)movie));
   AdminUi.Bind(Grid,t);Headers();
   decimal Sum(string col)=>t.AsEnumerable().Sum(r=>Convert.ToDecimal(r[col]));
   if(kind is "Thu" or "Suat")
   {
    totals.Text=$"Thu vé (trước hoàn): {Sum("ThuVe"):N0} đ | Thu F&B (trước hoàn): {Sum("ThuFnb"):N0} đ\nTổng thu: {Sum("TienDaThu"):N0} đ | Hoàn toàn đơn: {Sum("TienDaHoan"):N0} đ | Thuần (thu − hoàn): {Sum("DoanhThuThuan"):N0} đ\n"+
     (kind=="Thu"?"Theo NGÀY THU/HOÀN (VN), không theo ngày chiếu. Hoàn ghi đúng ngày hoàn, thuần có thể âm.":"Theo NGÀY BẮT ĐẦU CHIẾU (VN); tiền là lũy kế giao dịch của các suất, gồm cả suất hủy. Biểu đồ tối đa 15 suất.");
    chart.Values=kind=="Thu"?t.AsEnumerable().Select(r=>(((DateTime)r["Ngay"]).ToString("dd/MM"),(decimal)r["DoanhThuThuan"])).ToArray():
     t.AsEnumerable().Take(15).Select(r=>($"#{r["MaSuatChieu"]}",(decimal)r["DoanhThuThuan"])).ToArray();
   }
   else if(kind=="Phim")
   {
    totals.Text=$"Tiền vé của đơn chưa hoàn: {Sum("TienVe"):N0} đ | Vé bán chưa hoàn: {Sum("VeDaBan"):N0}\nTheo NGÀY BẮT ĐẦU CHIẾU (VN); giữ cách tính cũ: chỉ đơn đã trả chưa hoàn, bỏ suất hủy.\nTỷ lệ lấp đầy dùng sức chứa hiện tại; biểu đồ tối đa 15 phim. Không phải tổng thu gồm F&B.";
    chart.Values=t.AsEnumerable().Take(15).Select(r=>((string)r["TenPhim"],(decimal)r["TienVe"])).ToArray();
   }
   else
   {
    totals.Text=$"F&B bán từ đơn chưa hoàn: {Sum("TienBan"):N0} đ\nTheo NGÀY THU TIỀN (VN); giữ cách tính cũ: loại đơn đã hoàn, kể cả hoàn sau khoảng ngày đang xem.\nDùng Thu / hoàn tiền để xem thu F&B trước hoàn và hoàn theo ngày giao dịch. Biểu đồ tối đa 15 sản phẩm.";
    chart.Values=t.AsEnumerable().Take(15).Select(r=>((string)r["TenSanPham"],(decimal)r["TienBan"])).ToArray();
   }
   if(t.Rows.Count==0)totals.Text+="\nKhông có dữ liệu phù hợp bộ lọc.";
   chart.Invalidate();
  }
  catch{Clear("Không tải được báo cáo. Kiểm tra bộ lọc và quyền rồi thử lại.");throw;}
 }
 private void Headers()
 {
  var titles=new Dictionary<string,string>{{"Ngay","Ngày giao dịch (VN)"},{"ThuVe","Thu vé trước hoàn (đ)"},{"ThuFnb","Thu F&B trước hoàn (đ)"},
   {"TienDaThu","Tổng thu (đ)"},{"TienDaHoan","Hoàn toàn đơn (đ)"},{"DoanhThuThuan","Thuần = thu − hoàn (đ)"},
   {"MaSuatChieu","Mã suất"},{"MaPhim","Mã phim"},{"GioBatDau","Bắt đầu chiếu (VN)"},{"GioKetThuc","Kết thúc (VN)"},
   {"VePhatHanh","Vé đã phát hành"},{"VeDaHoan","Vé đã hoàn"},{"VeChuaHoan","Vé chưa hoàn"},{"TienVe","Tiền vé đơn chưa hoàn (đ)"},
   {"TienBan","F&B đơn chưa hoàn (đ)"},{"SoSuat","Số suất chưa hủy"},{"TongGheHienTai","Sức chứa hiện tại"},{"VeDaBan","Vé bán chưa hoàn"},{"TyLeLapDay","Lấp đầy (%)"}};
  foreach(DataGridViewColumn c in Grid.Columns){if(titles.TryGetValue(c.Name,out var text))c.HeaderText=text;if(c.Name=="Ngay")c.DefaultCellStyle.Format="dd/MM/yyyy";}
 }
}
internal sealed class DoanhThuChart:Panel
{
 internal (string Label,decimal Value)[] Values=Array.Empty<(string,decimal)>();
 internal DoanhThuChart(){DoubleBuffered=true;BackColor=Color.White;}
 protected override void OnPaint(PaintEventArgs e)
 {
  base.OnPaint(e);if(Values.Length==0){e.Graphics.DrawString("Chưa có dữ liệu trong khoảng chọn.",Font,Brushes.Gray,15,20);return;}
  int w=Math.Max(1,(Width-80)/Values.Length),zero=Height/2;decimal max=Math.Max(1,Values.Max(x=>Math.Abs(x.Value)));e.Graphics.DrawLine(Pens.Gray,35,zero,Width-10,zero);
  for(int i=0;i<Values.Length;i++){var (label,val)=Values[i];int h=(int)(Math.Abs(val)/max*Math.Max(10,Height/2-45)),x=40+i*w;using var brush=new SolidBrush(val>=0?AdminUi.Primary:Color.IndianRed);
   e.Graphics.FillRectangle(brush,x,val>=0?zero-h:zero,Math.Max(2,w-8),Math.Max(1,h));e.Graphics.DrawString(val.ToString("N0"),Font,Brushes.Black,x,val>=0?zero-h-20:zero+h+2);
   e.Graphics.DrawString(label.Length>13?label[..13]+"…":label,Font,Brushes.DimGray,x,Height-25);}
 }
}
