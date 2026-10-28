using System.Data;
using System.Globalization;
namespace YeuMinhEmCinema.Admin;
internal static class AdminUi
{
 internal static Color Primary=Color.FromArgb(211, 47, 47);
 internal static Button Button(string text,Action action)=>MakeButton(text,(_,_)=>Guard(action));
 private static Button MakeButton(string text,EventHandler h){var b=new Button{Text=text,AutoSize=true,MinimumSize=new Size(95,34),Margin=new Padding(4),FlatStyle=FlatStyle.Flat,BackColor=Primary,ForeColor=Color.White};b.Click+=h;return b;}
 internal static void Guard(Action action){try{action();}catch(Exception ex){MessageBox.Show(Db.Error(ex),"Thông báo",MessageBoxButtons.OK,MessageBoxIcon.Warning);}}
 internal static bool Confirm(string text)=>MessageBox.Show(text,"Xác nhận",MessageBoxButtons.YesNo,MessageBoxIcon.Question)==DialogResult.Yes;
 internal static DataGridView Grid()=>new(){Dock=DockStyle.Fill,ReadOnly=true,AllowUserToAddRows=false,AllowUserToDeleteRows=false,
  AutoSizeColumnsMode=DataGridViewAutoSizeColumnsMode.DisplayedCells,SelectionMode=DataGridViewSelectionMode.FullRowSelect,MultiSelect=false,
  BackgroundColor=Color.White,BorderStyle=BorderStyle.None,RowHeadersVisible=false,AutoGenerateColumns=true};
 internal static void Bind(DataGridView g,DataTable t)
 {
  BindTable(g,t);
  var names=new Dictionary<string,string>{{"MaDonHang","Mã đơn"},{"TenPhim","Tên phim"},{"TenRap","Rạp"},{"TenPhong","Phòng"},{"HoTen","Họ tên"},
   {"TrangThai","Trạng thái"},{"TongTien","Tổng tiền (đ)"},{"NhanGhe","Ghế"},{"DienThoai","Điện thoại"},{"TenDangNhap","Tên đăng nhập"},
   {"MaTaiKhoan","Mã tài khoản"},{"MaNhanVien","Mã nhân viên"},{"MaKhachHang","Mã khách"},{"GioBatDau","Giờ chiếu (VN)"},
   {"NgayTaoUtc","Tạo lúc (UTC)"},{"TenSanPham","Sản phẩm"},{"DonGia","Đơn giá (đ)"},{"SoLuong","Số lượng"},{"MaVe","Mã vé / QR"}};
  foreach(DataGridViewColumn c in g.Columns){if(names.TryGetValue(c.Name,out var title))c.HeaderText=title;
   if(c.Name.Contains("PhienBan")||c.Name is "MatKhauHash")c.Visible=false;
   if(c.ValueType==typeof(decimal))c.DefaultCellStyle.Format="N0";
   if(c.ValueType==typeof(DateTime))c.DefaultCellStyle.Format=c.Name is "TuNgay" or "DenNgay" or "NgaySinh" or "NgayKhoiChieu" ? "dd/MM/yyyy" : "dd/MM/yyyy HH:mm";}
 }
 // rowversion is binary concurrency data, never an image; keep it in the DataRow only.
 internal static void BindTable(DataGridView g,DataTable t)
 {
  g.DataSource=null;g.AutoGenerateColumns=false;g.Columns.Clear();
  foreach(DataColumn c in t.Columns)
  {
   if(c.DataType==typeof(byte[])||c.ColumnName.Contains("PhienBan")||c.ColumnName=="MatKhauHash")continue;
   DataGridViewColumn column=c.DataType==typeof(bool)?new DataGridViewCheckBoxColumn():new DataGridViewTextBoxColumn();
   column.Name=c.ColumnName;column.DataPropertyName=c.ColumnName;column.HeaderText=c.ColumnName;column.ValueType=c.DataType;
   g.Columns.Add(column);
  }
  g.DataSource=t;
 }
 internal static DataRow Row(DataGridView g)=> (g.CurrentRow?.DataBoundItem as DataRowView)?.Row ?? throw new ArgumentException("Chọn một dòng trong bảng trước.");
 internal static ComboBox Combo()=>new(){DropDownStyle=ComboBoxStyle.DropDownList,Width=230,Margin=new Padding(5)};
 internal static void Bind(ComboBox c,DataTable t,string value,string display){c.DataSource=null;c.ValueMember=value;c.DisplayMember=display;c.DataSource=t;}
 internal static int Id(ComboBox c)=>c.SelectedValue is int n?n:throw new ArgumentException("Chọn đủ thông tin từ danh sách.");
 internal static Label Label(string s)=>new(){Text=s,AutoSize=true,Margin=new Padding(6,10,2,2)};
 internal static TextBox Text(int max=150)=>new(){Width=230,MaxLength=max,Margin=new Padding(5)};
 internal static void Export(DataGridView g){if(g.DataSource is not DataTable t)throw new ArgumentException("Chưa có dữ liệu để xuất.");using var d=new SaveFileDialog{Filter="CSV UTF-8|*.csv",FileName=$"Cinema-{DateTime.Now:yyyyMMdd-HHmm}.csv"};if(d.ShowDialog()==DialogResult.OK)
  {
   var columns=g.Columns.Cast<DataGridViewColumn>().Where(c=>c.Visible&&t.Columns.Contains(c.DataPropertyName)).OrderBy(c=>c.DisplayIndex).Select(c=>c.DataPropertyName).Distinct().ToArray();
   if(columns.Length==0)throw new ArgumentException("Không có cột dữ liệu đang hiển thị để xuất.");
   CsvUtility.Ghi(d.FileName,t.DefaultView.ToTable(false,columns));
  }}
 internal static Form Dialog(string title)=>new(){Text=title,StartPosition=FormStartPosition.CenterParent,ClientSize=new Size(600,540),MinimumSize=new Size(500,400),Font=new Font("Segoe UI",10),AutoScroll=true};
}
internal sealed class EditDialog:Form
{
 private readonly FlowLayoutPanel body=new(){Dock=DockStyle.Fill,FlowDirection=FlowDirection.TopDown,WrapContents=false,AutoScroll=true,Padding=new Padding(20)};
 internal EditDialog(string title){Text=title;StartPosition=FormStartPosition.CenterParent;ClientSize=new Size(510,570);Font=new Font("Segoe UI",10);Controls.Add(body);}
 internal T Field<T>(string label,T c) where T:Control {body.Controls.Add(AdminUi.Label(label));c.Width=430;body.Controls.Add(c);return c;}
 internal TextBox TextField(string label,string value="",int max=150){var t=AdminUi.Text(max);t.Text=value;return Field(label,t);}
 internal void Save(Action save){body.Controls.Add(AdminUi.Button("Lưu",()=>{save();DialogResult=DialogResult.OK;Close();}));}
}
public abstract class DataPage:UserControl
{
 protected readonly FlowLayoutPanel Bar=new(){Dock=DockStyle.Fill,AutoSize=true,WrapContents=true,Padding=new Padding(8)};
 protected readonly DataGridView Grid=AdminUi.Grid();
 protected readonly TableLayoutPanel PageLayout=new(){Dock=DockStyle.Fill,ColumnCount=1,RowCount=3};
 private bool busy;
 protected DataPage(string title)
 {
  Dock=DockStyle.Fill;Font=new Font("Segoe UI",10);BackColor=Color.White;
  PageLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));
  PageLayout.RowStyles.Add(new RowStyle(SizeType.Absolute,45));PageLayout.RowStyles.Add(new RowStyle(SizeType.AutoSize));PageLayout.RowStyles.Add(new RowStyle(SizeType.Percent,100));
  PageLayout.Controls.Add(new Label{Text=title,Font=new Font("Segoe UI",14,FontStyle.Bold),Dock=DockStyle.Fill,Padding=new Padding(12,9,0,0)},0,0);
  PageLayout.Controls.Add(Bar,0,1);PageLayout.Controls.Add(Grid,0,2);Controls.Add(PageLayout);
 }
 protected void Action(string text,Action action,string? right=null){var b=AdminUi.Button(text,()=>Run(action));if(right!=null)b.Enabled=Db.Has(right);Bar.Controls.Add(b);}
 protected void Run(Action action){if(busy)return;busy=true;UseWaitCursor=true;try{AdminUi.Guard(action);}finally{UseWaitCursor=false;busy=false;}}
 protected void StandardActions(Action reload){Action("Tải lại",reload);Action("Xuất CSV",()=>AdminUi.Export(Grid));}
}
