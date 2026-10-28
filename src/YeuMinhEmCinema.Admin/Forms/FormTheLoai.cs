using System.Data;
namespace YeuMinhEmCinema.Admin;

// Danh mục chung toàn hệ thống, dùng quyền phim hiện có, không tự cấp quyền cho quản lý rạp.
internal sealed class FormTheLoai:Form
{
 private readonly DataGridView grid=AdminUi.Grid();
 internal FormTheLoai()
 {
  Text="Danh mục thể loại phim";StartPosition=FormStartPosition.CenterParent;
  Font=new Font("Segoe UI",10);ClientSize=new Size(820,500);MinimumSize=new Size(640,380);
  var layout=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=3};
  layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));
  layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));layout.RowStyles.Add(new RowStyle(SizeType.Percent,100));
  var bar=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoSize=true,Padding=new Padding(6)};
  void Button(string label,Action action,bool edit=false){var b=AdminUi.Button(label,action);b.Enabled=!edit||Db.Has("PHIM_QUAN_LY");bar.Controls.Add(b);}
  Button("Thêm thể loại",()=>Edit(null),true);Button("Sửa thể loại",()=>Edit(AdminUi.Row(grid)),true);
  Button("Ngừng / Sử dụng lại",Toggle,true);Button("Tải lại",LoadData);
  layout.Controls.Add(new Label{Text="Ngừng sử dụng giữ nguyên các phim đã gán; không xóa lịch sử. Tên thể loại là duy nhất.",AutoSize=true,MaximumSize=new Size(760,0),Padding=new Padding(10)},0,0);
  layout.Controls.Add(bar,0,1);layout.Controls.Add(grid,0,2);Controls.Add(layout);
  LoadData();
 }
 private void LoadData()
 {
  AdminUi.Bind(grid,Db.Table("dbo.sp_YMC_LayTheLoaiAdmin",("@NguoiThucHien",Db.Actor)));
  foreach(var (col,title) in new[]{("MaTheLoai","Mã thể loại"),("TenTheLoai","Tên thể loại"),("MoTa","Mô tả"),("DangSuDung","Đang sử dụng"),("SoPhim","Số phim đã gán")})if(grid.Columns[col] is DataGridViewColumn column)column.HeaderText=title;
 }
 private void Save(int? id,string name,string? description,bool active)=>Db.Call("dbo.sp_YMC_LuuTheLoai",
  ("@NguoiThucHien",Db.Actor),("@MaTheLoai",id),("@TenTheLoai",name),("@MoTa",description),("@DangSuDung",active));
 private void Edit(DataRow? row)
 {
  Db.Require("PHIM_QUAN_LY");using var f=new EditDialog(row==null?"Thêm thể loại":"Sửa thể loại");
  var name=f.TextField("Tên thể loại (*) — tối đa 100 ký tự",row?["TenTheLoai"].ToString()??"",100);
  var description=f.TextField("Mô tả — tối đa 1000 ký tự",row?["MoTa"].ToString()??"",1000);description.Multiline=true;description.Height=110;description.ScrollBars=ScrollBars.Vertical;
  var active=f.Field("Trạng thái",new CheckBox{Text="Đang sử dụng",Checked=row==null||(bool)row["DangSuDung"],AutoSize=true});
  f.Save(()=>{if(string.IsNullOrWhiteSpace(name.Text))throw new ArgumentException("Nhập tên thể loại.");Save(row==null?null:(int)row["MaTheLoai"],name.Text,description.Text,active.Checked);});
  if(f.ShowDialog(this)==DialogResult.OK)LoadData();
 }
 private void Toggle()
 {
  Db.Require("PHIM_QUAN_LY");var row=AdminUi.Row(grid);bool active=(bool)row["DangSuDung"];
  if(!AdminUi.Confirm($"{(active?"Ngừng sử dụng":"Sử dụng lại")} thể loại '{row["TenTheLoai"]}'?\nCác liên kết phim hiện có được giữ nguyên."))return;
  Save((int)row["MaTheLoai"],(string)row["TenTheLoai"],row["MoTa"] as string,!active);LoadData();
 }
}

internal sealed class FormGanTheLoai:Form
{
 private readonly int movie;
 private readonly CheckedListBox list=new(){Dock=DockStyle.Fill,CheckOnClick=true,IntegralHeight=false,HorizontalScrollbar=true};
 private DataTable data=new();
 private sealed record Item(int Id,string Name){public override string ToString()=>Name;}
 internal FormGanTheLoai(int movieId,string name)
 {
  movie=movieId;Text="Thể loại của phim";StartPosition=FormStartPosition.CenterParent;Font=new Font("Segoe UI",10);
  ClientSize=new Size(650,480);MinimumSize=new Size(500,360);
  var layout=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=3,Padding=new Padding(10)};
  layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));layout.RowStyles.Add(new RowStyle(SizeType.Percent,100));layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
  layout.Controls.Add(new Label{Text=$"[{movie}] {name}\nChọn nhiều thể loại hoặc bỏ hết để để trống.\nThể loại ngừng sử dụng đã gán có thể giữ hoặc bỏ; không gán mới.",UseMnemonic=false,AutoSize=true,MaximumSize=new Size(580,0),Padding=new Padding(0,0,0,10)},0,0);
  list.Enabled=Db.Has("PHIM_QUAN_LY");layout.Controls.Add(list,0,1);
  var bar=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoSize=true};
  var save=AdminUi.Button("Lưu thể loại",Save);save.Enabled=Db.Has("PHIM_QUAN_LY");bar.Controls.Add(save);
  bar.Controls.Add(AdminUi.Button("Tải lại",LoadData));bar.Controls.Add(AdminUi.Button("Đóng",Close));layout.Controls.Add(bar,0,2);Controls.Add(layout);LoadData();
 }
 private void LoadData()
 {
  data=Db.Table("dbo.sp_YMC_LayTheLoaiCuaPhim",("@NguoiThucHien",Db.Actor),("@MaPhim",movie));list.Items.Clear();
  foreach(DataRow r in data.Rows)list.Items.Add(new Item((int)r["MaTheLoai"],(string)r["TenTheLoai"]+((bool)r["DangSuDung"]?"":" (ngừng sử dụng)")),(bool)r["DaGan"]);
 }
 private void Save()
 {
  if(list.CheckedItems.Count==0 && !AdminUi.Confirm("Lưu phim không có thể loại?"))return;
  var ids=new DataTable();ids.Columns.Add("MaTheLoai",typeof(int));foreach(Item item in list.CheckedItems)ids.Rows.Add(item.Id);
  Db.Call("dbo.sp_YMC_GanTheLoaiPhim",("@NguoiThucHien",Db.Actor),("@MaPhim",movie),("@DanhSach",new Tvp("dbo.YMC_DanhSachTheLoai",ids)));
  DialogResult=DialogResult.OK;Close();
 }
}
