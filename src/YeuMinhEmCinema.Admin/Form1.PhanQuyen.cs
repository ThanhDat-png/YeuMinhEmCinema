namespace YeuMinhEmCinema.Admin;
public partial class Form1
{
 private bool rightsReady;
 internal bool YeuCauDangXuat {get;private set;}
 private readonly Dictionary<string,string[]> screenRights=new(){
 ["TongQuan"]=new[]{"BAO_CAO_XEM"},["QuanLyPhim"]=new[]{"PHIM_XEM"},["RapPhong"]=new[]{"RAP_XEM"},
 ["LichChieu"]=new[]{"LICH_CHIEU_XEM","LICH_CHIEU_QUAN_LY"},["GiaVeFnb"]=new[]{"GIA_VE_XEM","GIA_VE_QUAN_LY","FNB_XEM","FNB_QUAN_LY"},
 ["DonDatVe"]=new[]{"DON_HANG_XEM"},["BanVe"]=new[]{"BAN_VE"},["KiemTraVe"]=new[]{"VE_KIEM_TRA"},["KhachHang"]=new[]{"KHACH_HANG_XEM"},
 ["NhanVien"]=new[]{"NHAN_VIEN_QUAN_LY","TAI_KHOAN_QUAN_LY","PHAN_QUYEN_QUAN_LY"},["BaoCao"]=new[]{"BAO_CAO_XEM"}};
 private bool Allowed(string screen)=>rightsReady&&screenRights.TryGetValue(screen,out var p)&&p.All(Db.Has);
 private void ApplyRights()
 {
  string[] ids={"TongQuan","QuanLyPhim","RapPhong","LichChieu","GiaVeFnb","DonDatVe","BanVe","KiemTraVe","KhachHang","NhanVien","BaoCao"};
  for(int i=0;i<ids.Length;i++)_danhSachNutMenu[i].Enabled=Allowed(ids[i]);
  bool phim=Db.Has("PHIM_XEM"),edit=phim&&Db.Has("PHIM_QUAN_LY");btnThemPhim.Enabled=btnSuaPhim.Enabled=btnNgungChieu.Enabled=edit;
  btnTimKiemPhim.Enabled=btnLamMoiPhim.Enabled=cboLocTrangThai.Enabled=txtTimKiemPhim.Enabled=phim;
  lblUserName.Text=PhienDangNhap.TaiKhoan?.TenDangNhap??"";
  var role=Db.Query("SELECT v.TenHienThi FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=@A AND v.DangHoatDong=1",("@A",Db.Actor));
  lblUserRole.Text=string.Join(", ",role.Rows.Cast<System.Data.DataRow>().Select(r=>r[0]));
 }
 private void KhoiTaoPhanQuyen()
 {
  rightsReady=true;pnlQuanLyPhim.Visible=false;ApplyRights();
  var tools=new FlowLayoutPanel{Dock=DockStyle.Top,AutoSize=true,FlowDirection=FlowDirection.RightToLeft,Padding=new Padding(3),BackColor=Color.WhiteSmoke};
  tools.Controls.Add(AdminUi.Button("Đăng xuất",()=>{if(AdminUi.Confirm("Đăng xuất tài khoản hiện tại?")){YeuCauDangXuat=true;Close();}}));
  tools.Controls.Add(AdminUi.Button("Đổi mật khẩu",DoiMatKhau));
  tools.Controls.Add(AdminUi.Button("Cập nhật quyền",()=>{Db.RefreshRights();foreach(var u in _danhSachManHinhPhu.Values)u.Dispose();_danhSachManHinhPhu.Clear();pnlQuanLyPhim.Visible=false;ApplyRights();OpenFirst();}));
  // Đặt thanh đáy sau cùng trong Z-order để Dock giữ chỗ trước vùng nội dung Fill.
  Controls.Add(tools);tools.Dock=DockStyle.Bottom;tools.SendToBack();
  Shown+=(_,_)=>AdminUi.Guard(OpenFirst);
 }
 private void OpenFirst()
 {
  string[] ids={"TongQuan","QuanLyPhim","RapPhong","LichChieu","GiaVeFnb","DonDatVe","BanVe","KiemTraVe","KhachHang","NhanVien","BaoCao"};
  for(int i=0;i<ids.Length;i++)if(Allowed(ids[i])){ChuyenManHinh(ids[i],_danhSachNutMenu[i].Text,_danhSachNutMenu[i]);return;}
  MessageBox.Show("Tài khoản hiện không còn quyền mở màn hình nào.");Close();
 }
 private void DoiMatKhau()
 {
  using var f=new EditDialog("Đổi mật khẩu của tôi");var old=f.TextField("Mật khẩu hiện tại",max:256);old.UseSystemPasswordChar=true;
  var pass=f.TextField("Mật khẩu mới từ 12 ký tự",max:256);pass.UseSystemPasswordChar=true;var confirm=f.TextField("Nhập lại mật khẩu mới",max:256);confirm.UseSystemPasswordChar=true;
  f.Save(()=>{if(pass.Text!=confirm.Text)throw new ArgumentException("Mật khẩu nhập lại không khớp.");
   var row=Db.Table("dbo.sp_YMC_LayThongTinDangNhap",("@TenDangNhap",PhienDangNhap.TaiKhoan!.TenDangNhap)).Rows[0];
   bool ok=BaoMatMatKhau.KiemTra((string)row["MatKhauHash"],old.Text)!=Microsoft.AspNetCore.Identity.PasswordVerificationResult.Failed;
   Db.Call("dbo.sp_YMC_GhiNhanDangNhap",("@MaTaiKhoan",Db.Actor),("@ThanhCong",ok),("@PhienBan",row["PhienBan"]));if(!ok)throw new ArgumentException("Mật khẩu hiện tại không đúng.");
   row=Db.Table("dbo.sp_YMC_LayThongTinDangNhap",("@TenDangNhap",PhienDangNhap.TaiKhoan!.TenDangNhap)).Rows[0];
   Db.Call("dbo.sp_YMC_DoiMatKhau",("@MaTaiKhoan",Db.Actor),("@MatKhauHashMoi",BaoMatMatKhau.TaoHash(pass.Text)),("@PhienBan",row["PhienBan"]));});
  if(f.ShowDialog(this)==DialogResult.OK)MessageBox.Show("Đã đổi mật khẩu.");
 }
}
