using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcBaoCaoThongKe:DataPage
{
 private readonly ComboBox rap=AdminUi.Combo();private readonly DateTimePicker tu=new(){Value=DateTime.Today.AddDays(-6),Width=140,Format=DateTimePickerFormat.Short},den=new(){Width=140,Format=DateTimePickerFormat.Short};
 private readonly Label totals=new(){AutoSize=true,Margin=new Padding(10)};private readonly DoanhThuChart chart=new(){Dock=DockStyle.Fill};private string kind="Thu";
 public UcBaoCaoThongKe():base("Báo cáo và tổng quan — dữ liệu SQL")
 {
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Rạp"),rap,AdminUi.Label("Từ"),tu,AdminUi.Label("Đến"),den});Action("Thu / hoàn tiền",()=>{kind="Thu";Reload();});Action("Hiệu quả phim",()=>{kind="Phim";Reload();});Action("Bắp nước bán",()=>{kind="Fnb";Reload();});StandardActions(Reload);Bar.Controls.Add(totals);
  var split=new TableLayoutPanel{Dock=DockStyle.Fill,RowCount=2,ColumnCount=1};split.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));split.RowStyles.Add(new RowStyle(SizeType.Percent,60));split.RowStyles.Add(new RowStyle(SizeType.Percent,40));PageLayout.Controls.Remove(Grid);split.Controls.Add(Grid,0,0);split.Controls.Add(chart,0,1);PageLayout.Controls.Add(split,0,2);
  Load+=(_,_)=>Run(()=>{AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");Reload();});
 }
 private void Reload(){if(rap.Items.Count==0){totals.Text="Chưa có rạp trong phạm vi tài khoản.";return;}string proc=kind switch{"Phim"=>"dbo.sp_YMC_ThongKePhim","Fnb"=>"dbo.sp_YMC_ThongKeFnb",_=>"dbo.sp_YMC_BaoCaoDoanhThu"};var t=Db.Table(proc,("@NguoiThucHien",Db.Actor),("@MaRap",AdminUi.Id(rap)),("@TuNgay",tu.Value.Date),("@DenNgay",den.Value.Date));AdminUi.Bind(Grid,t);
  if(kind=="Thu"){decimal thu=t.AsEnumerable().Sum(r=>(decimal)r["TienDaThu"]),hoan=t.AsEnumerable().Sum(r=>(decimal)r["TienDaHoan"]);totals.Text=$"Thu: {thu:N0} đ | Hoàn: {hoan:N0} đ | Thuần: {thu-hoan:N0} đ";
   chart.Values=t.AsEnumerable().Select(r=>(((DateTime)r["Ngay"]).ToString("dd/MM"),(decimal)r["DoanhThuThuan"])).ToArray();}
  else{totals.Text=kind=="Phim"?"Theo ngày chiếu; tỷ lệ lấp đầy dùng sức chứa hiện tại.":"Đơn đã trả chưa hoàn, theo ngày thu tiền.";string label=kind=="Phim"?"TenPhim":"TenSanPham",value=kind=="Phim"?"TienVe":"TienBan";chart.Values=t.AsEnumerable().Take(15).Select(r=>(Convert.ToString(r[label])??"",Convert.ToDecimal(r[value]))).ToArray();}
  chart.Invalidate();
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
