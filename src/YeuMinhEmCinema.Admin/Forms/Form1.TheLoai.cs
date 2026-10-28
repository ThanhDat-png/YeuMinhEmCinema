namespace YeuMinhEmCinema.Admin;
public partial class Form1
{
 private readonly Button btnDanhMucTheLoai=AdminUi.Button("Danh mục thể loại",()=>{});
 private readonly Button btnGanTheLoai=AdminUi.Button("Thể loại của phim",()=>{});
 private void KhoiTaoTheLoai()
 {
  var group=new FlowLayoutPanel{AutoSize=true,WrapContents=false,Margin=new Padding(3)};
  group.Controls.Add(btnDanhMucTheLoai);group.Controls.Add(btnGanTheLoai);pnlChucNang.Controls.Add(group);
  btnDanhMucTheLoai.Click+=(_,_)=>AdminUi.Guard(()=>{using var f=new FormTheLoai();f.ShowDialog(this);TaiDanhSachPhim();});
  btnGanTheLoai.Click+=(_,_)=>AdminUi.Guard(()=>{
   var row=AdminUi.Row(dgvPhim);using var f=new FormGanTheLoai((int)row["MaPhim"],(string)row["TenPhim"]);
   if(f.ShowDialog(this)==DialogResult.OK)TaiDanhSachPhim();});
 }
}
