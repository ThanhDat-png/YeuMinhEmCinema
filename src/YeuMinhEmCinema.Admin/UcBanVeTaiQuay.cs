using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcBanVeTaiQuay:DataPage
{
 private readonly ComboBox rap=AdminUi.Combo(),suat=AdminUi.Combo(),payment=AdminUi.Combo();
 private readonly DateTimePicker day=new(){Format=DateTimePickerFormat.Short,Width=135};
 private readonly TextBox name=AdminUi.Text(),phone=AdminUi.Text(20),txn=AdminUi.Text(100);
 private readonly FlowLayoutPanel seats=new(){Dock=DockStyle.Fill,AutoScroll=true,BackColor=Color.WhiteSmoke};
 private readonly DataGridView menu=AdminUi.Grid();
 private readonly Label summary=new(){Dock=DockStyle.Fill,AutoSize=false,Padding=new Padding(8),ForeColor=Color.FromArgb(211, 47, 47)};
 private readonly ToolTip seatTip=new();
 private readonly HashSet<int> selected=new();private DataTable seatTable=new();
 private Pending? pending;private long? order;private decimal total;
 private sealed record Pending(Guid Request,int Suat,DataTable Ghe,DataTable Fnb,string Ten,string Phone);
 private readonly System.Windows.Forms.Timer timer=new(){Interval=1000};private DateTime? expires;private string message="Chọn suất và ghế; giá thực tế được SQL chốt khi giữ chỗ.";
 public UcBanVeTaiQuay():base("Bán vé tại quầy — giữ ghế → thu tiền → phát vé")
 {
  suat.Width=520;name.PlaceholderText="Tên liên hệ (bắt buộc)";phone.PlaceholderText="Điện thoại";txn.PlaceholderText="Mã giao dịch / biên nhận";
  Bar.Controls.AddRange(new Control[]{AdminUi.Label("Rạp"),rap,day});Action("Tải suất",LoadShows);
  Bar.Controls.Add(suat);Action("Tải ghế / menu",LoadSeats);Bar.Controls.AddRange(new Control[]{name,phone,payment,txn});
  payment.Items.AddRange(new object[]{"TIEN_MAT","CHUYEN_KHOAN"});payment.SelectedIndex=0;
  Action("1. Giữ ghế / thử lại",Reserve,"BAN_VE");Action("2. Xác nhận đã thu tiền",Pay,"BAN_VE");Action("Xuất vé / phiếu QR",()=>HoaDonExporter.Xuat(order??throw new ArgumentException("Chưa có đơn.")));
  Action("Hủy giữ / đơn mới",NewCart);
  var body=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=2,RowCount=2};body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,60));body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,40));
  body.RowStyles.Add(new RowStyle(SizeType.Percent,100));body.RowStyles.Add(new RowStyle(SizeType.Absolute,110));body.Controls.Add(seats,0,0);body.Controls.Add(menu,1,0);body.Controls.Add(summary,0,1);body.SetColumnSpan(summary,2);
  PageLayout.Controls.Remove(Grid);PageLayout.Controls.Add(body,0,2);
  menu.ReadOnly=false;menu.CellValidating+=(_,e)=>{if(e.ColumnIndex>=0&&menu.Columns[e.ColumnIndex].Name=="SoLuong"&&(!int.TryParse(Convert.ToString(e.FormattedValue),out int n)||n<0||n>99)){e.Cancel=true;menu.Rows[e.RowIndex].ErrorText="Số lượng phải từ 0 đến 99.";}};
  menu.CellEndEdit+=(_,e)=>{menu.Rows[e.RowIndex].ErrorText="";UpdateQuote();};
  timer.Tick+=(_,_)=>UpdateSummary();Load+=(_,_)=>Run(()=>{AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");LoadShows();timer.Start();});Disposed+=(_,_)=>{timer.Dispose();seatTip.Dispose();};
 }
 private void EnsureEditable(){if(pending!=null||order!=null)throw new ArgumentException("Đơn đã có yêu cầu giữ. Hoàn tất hoặc bấm Hủy giữ / đơn mới trước khi đổi giỏ.");}
 private void LoadShows(){EnsureEditable();AdminUi.Bind(suat,GiaoDichDAL.Suat(AdminUi.Id(rap),day.Value),"MaSuatChieu","TenHienThi");if(suat.Items.Count==0){seats.Controls.Clear();message="Không có suất mở bán trong ngày/rạp này.";UpdateSummary();}else LoadSeats();}
 private void LoadSeats()
 {
  EnsureEditable();int id=AdminUi.Id(suat);seatTable=GiaoDichDAL.Ghe(id);
  var prices=Db.Query(@"SELECT g.MaGhe,MIN(v.DonGia) DonGia,COUNT(v.MaGiaVe) SoGia FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Ghe g ON g.MaPhong=p.MaPhong
  LEFT JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=p.DinhDang AND v.DangApDung=1 AND v.TuNgay<=CONVERT(DATE,s.GioBatDau) AND(v.DenNgay IS NULL OR v.DenNgay>=CONVERT(DATE,s.GioBatDau))
  AND v.LoaiNgay=CASE WHEN(DATEDIFF(DAY,CONVERT(DATE,'19000101'),CONVERT(DATE,s.GioBatDau))%7+7)%7>=4 THEN N'Cuối tuần' ELSE N'Ngày thường' END
  WHERE s.MaSuatChieu=@S GROUP BY g.MaGhe",("@S",id));
  seatTable.Columns.Add("DonGia",typeof(decimal));foreach(DataRow r in seatTable.Rows){var p=prices.AsEnumerable().FirstOrDefault(x=>(int)x["MaGhe"]==(int)r["MaGhe"]);if(p!=null&&(int)p["SoGia"]==1)r["DonGia"]=p["DonGia"];}
  selected.Clear();foreach(Control c in seats.Controls.Cast<Control>().ToArray())c.Dispose();seats.Controls.Clear();
  foreach(var group in seatTable.AsEnumerable().GroupBy(r=>(string)r["HangGhe"]))
  {var row=new FlowLayoutPanel{AutoSize=true,WrapContents=false,Margin=new Padding(5)};row.Controls.Add(new Label{Text=group.Key,Width=30,Margin=new Padding(3,15,0,0)});
   foreach(var r in group){int gid=(int)r["MaGhe"];bool free=(string)r["TinhTrang"]=="Trống"&&r["DonGia"]!=DBNull.Value;
    var b=new Button{Text=$"{r["HangGhe"]}{r["SoGhe"]}",Size=new Size(58,40),Margin=new Padding(3),Enabled=free,BackColor=free?Color.White:Color.LightGray};
    seatTip.SetToolTip(b,$"{r["TenLoai"]} — {r["TinhTrang"]} — {(r["DonGia"]==DBNull.Value?"Chưa có giá duy nhất":$"{r["DonGia"]:N0} đ")}");
    b.Click+=(_,_)=>Run(()=>{EnsureEditable();if(!selected.Add(gid))selected.Remove(gid);b.BackColor=selected.Contains(gid)?Color.LightSkyBlue:Color.White;UpdateQuote();});row.Controls.Add(b);}
   seats.SetFlowBreak(row,true);seats.Controls.Add(row);}
  var m=GiaoDichDAL.Fnb();m.Columns.Add("SoLuong",typeof(int));foreach(DataRow r in m.Rows)r["SoLuong"]=0;AdminUi.Bind(menu,m);foreach(DataGridViewColumn c in menu.Columns)c.ReadOnly=c.Name!="SoLuong";
  message="Trắng: trống có giá; xanh: đang chọn; xám: không chọn được. Tối đa 8 ghế. Bắp nước nhập số lượng ở cột cuối.";UpdateQuote();
 }
 private void UpdateQuote(){if(order.HasValue)return;decimal v=seatTable.AsEnumerable().Where(r=>selected.Contains((int)r["MaGhe"])).Sum(r=>r["DonGia"]==DBNull.Value?0:(decimal)r["DonGia"]);
  if(menu.DataSource is DataTable t)v+=t.AsEnumerable().Sum(r=>(decimal)r["DonGia"]*Convert.ToInt32(r["SoLuong"]));total=v;UpdateSummary();}
 private void UpdateSummary(){string time=expires.HasValue?$" | Hạn giữ VN: {expires.Value.AddHours(7):HH:mm:ss} | Còn {Math.Max(0,(int)(expires.Value-DateTime.UtcNow).TotalSeconds)} giây":"";
  summary.Text=$"{message}\nGhế: {selected.Count} — Tổng {(order.HasValue?"đơn":"tạm tính")}: {total:N0} đ{time}\n{(order.HasValue?$"Mã đơn: {order}":"")}";}
 private void LockInputs(bool yes){rap.Enabled=day.Enabled=suat.Enabled=name.Enabled=phone.Enabled=menu.Enabled=seats.Enabled=!yes;}
 private void Reserve()
 {
  if(order.HasValue){MessageBox.Show("Đã giữ đơn này. Bấm xác nhận thu tiền hoặc hủy giữ.");return;}
  if(pending==null){if(!menu.EndEdit())throw new ArgumentException("Sửa số lượng bắp nước chưa hợp lệ trước khi giữ ghế.");if(menu.DataSource is DataTable mt)BindingContext?[mt]?.EndCurrentEdit();
   if(selected.Count is <1 or >8)throw new ArgumentException("Chọn từ 1 đến 8 ghế.");if(string.IsNullOrWhiteSpace(name.Text))throw new ArgumentException("Nhập tên liên hệ.");
   var g=new DataTable();g.Columns.Add("MaGhe",typeof(int));foreach(int id in selected)g.Rows.Add(id);
   var f=new DataTable();f.Columns.Add("MaSanPham",typeof(int));f.Columns.Add("SoLuong",typeof(int));if(menu.DataSource is DataTable t)foreach(DataRow r in t.Rows){int n=Convert.ToInt32(r["SoLuong"]);if(n is <0 or >99)throw new ArgumentException("Số lượng bắp nước 0–99.");if(n>0)f.Rows.Add(r["MaSanPham"],n);}
   pending=new Pending(Guid.NewGuid(),AdminUi.Id(suat),g,f,name.Text.Trim(),phone.Text.Trim());LockInputs(true);}
  try{var p=pending;var r=GiaoDichDAL.Tao(p.Request,p.Suat,p.Ghe,p.Fnb,p.Ten,p.Phone);SetOrder(r);}
  catch{message="Yêu cầu giữ chưa được xác nhận. Bấm Giữ ghế / thử lại dùng cùng mã; muốn bỏ yêu cầu bấm Hủy giữ / đơn mới.";UpdateSummary();throw;}
 }
 private void SetOrder(DataRow r){order=Convert.ToInt64(r["MaDonHang"]);total=Convert.ToDecimal(r["TongTien"]);expires=DateTime.SpecifyKind((DateTime)r["HanThanhToanUtc"],DateTimeKind.Utc);
  message=$"Đơn {r["TrangThai"]}. Chỉ xác nhận thanh toán sau khi thực sự nhận tiền.";LockInputs(true);UpdateSummary();}
 private void Pay()
 {
  if(!order.HasValue)throw new ArgumentException("Giữ ghế trước khi thu tiền.");if(payment.Text=="CHUYEN_KHOAN"&&string.IsNullOrWhiteSpace(txn.Text))throw new ArgumentException("Nhập mã giao dịch đã đối soát. SQL không kiểm ngân hàng tự động.");
  if(string.IsNullOrWhiteSpace(txn.Text))txn.Text="QUAY_"+Guid.NewGuid().ToString("N");
  if(!AdminUi.Confirm($"Xác nhận đã nhận đủ {total:N0} đ bằng {payment.Text}?\nMã: {txn.Text}\nGiữ nguyên mã này nếu thao tác cần thử lại."))return;
  GiaoDichDAL.Thu(order.Value,txn.Text.Trim(),payment.Text,total);expires=null;message="Đã thanh toán, vé đã phát hành. Xuất vé / phiếu QR hoặc bắt đầu đơn mới.";UpdateSummary();MessageBox.Show("Thanh toán đã được ghi nhận. Có thể xuất vé QR.");
 }
 private void NewCart()
 {
  if(!AdminUi.Confirm("Bắt đầu giỏ mới? Đơn chưa thanh toán đang giữ sẽ được hủy; đơn đã thanh toán vẫn giữ nguyên."))return;
  if(pending!=null)
  {Db.Require("BAN_VE");var t=Db.Query(@"SELECT d.* FROM dbo.DonHang d JOIN dbo.SuatChieu s ON s.MaSuatChieu=d.MaSuatChieu JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
   WHERE d.MaYeuCau=@Q AND d.NguoiTao=@A AND dbo.fn_YMC_CoPhamViRap(@A,p.MaRap)=1",("@Q",pending.Request),("@A",Db.Actor));
   if(t.Rows.Count>0){var r=t.Rows[0];if((string)r["TrangThai"]=="CHO_THANH_TOAN")GiaoDichDAL.Huy(Convert.ToInt64(r["MaDonHang"]),"Khách đổi giỏ tại quầy");}}
  pending=null;order=null;expires=null;selected.Clear();txn.Clear();LockInputs(false);LoadShows();
 }
}
