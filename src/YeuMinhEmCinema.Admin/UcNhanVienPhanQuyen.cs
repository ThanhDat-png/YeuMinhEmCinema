using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcNhanVienPhanQuyen:DataPage
{
 private readonly TextBox search=AdminUi.Text();
 public UcNhanVienPhanQuyen():base("Nhân viên, tài khoản và phân quyền")
 {
  Bar.Controls.Add(search);Action("Tìm",Reload);Action("Tạo nhân viên",Create,"NHAN_VIEN_QUAN_LY");Action("Sửa hồ sơ",Edit,"NHAN_VIEN_QUAN_LY");
  Action("Phân công rạp",Assign,"NHAN_VIEN_QUAN_LY");Action("Vai trò tài khoản",Roles,"PHAN_QUYEN_QUAN_LY");Action("Quyền theo vai trò",Permissions,"PHAN_QUYEN_QUAN_LY");
  Action("Bật / khóa tài khoản",AccountStatus,"TAI_KHOAN_QUAN_LY");Action("Đặt lại mật khẩu",ResetPassword,"TAI_KHOAN_QUAN_LY");StandardActions(Reload);Load+=(_,_)=>Run(Reload);
 }
 private void Reload(){Db.Require("NHAN_VIEN_QUAN_LY");AdminUi.Bind(Grid,Db.Query(@"SELECT t.MaTaiKhoan,t.TenDangNhap,t.Email,t.DangHoatDong,t.KhoaDenLuc,t.PhienBan TaiKhoanPhienBan,
 n.MaNhanVien,n.HoTen,n.DienThoai,n.DangLamViec,n.PhienBan NhanVienPhienBan,
 (SELECT STRING_AGG(v.TenHienThi,N', ') FROM dbo.TaiKhoanVaiTro tv JOIN dbo.VaiTro v ON v.MaVaiTro=tv.MaVaiTro WHERE tv.MaTaiKhoan=t.MaTaiKhoan) VaiTro,
 (SELECT STRING_AGG(r.TenRap,N', ') FROM dbo.NhanVienRap nr JOIN dbo.Rap r ON r.MaRap=nr.MaRap WHERE nr.MaNhanVien=n.MaNhanVien) RapLamViec
 FROM dbo.TaiKhoan t LEFT JOIN dbo.NhanVien n ON n.MaTaiKhoan=t.MaTaiKhoan
 WHERE @K=N'' OR CHARINDEX(@K,t.TenDangNhap)>0 OR CHARINDEX(@K,n.HoTen)>0 ORDER BY t.MaTaiKhoan",("@K",search.Text.Trim())));}
 private void Create(){Db.Require("TAI_KHOAN_QUAN_LY");Db.Require("PHAN_QUYEN_QUAN_LY");using var f=new EditDialog("Tạo nhân viên và tài khoản");var name=f.TextField("Họ tên");var user=f.TextField("Tên đăng nhập (3–50 ký tự không dấu)",max:50);var pass=f.TextField("Mật khẩu từ 12 ký tự",max:256);pass.UseSystemPasswordChar=true;
  var confirm=f.TextField("Nhập lại mật khẩu",max:256);confirm.UseSystemPasswordChar=true;var role=f.Field("Vai trò",AdminUi.Combo());role.Items.AddRange(new object[]{"QUAN_LY","BAN_VE","SOAT_VE"});role.SelectedIndex=1;
  var rap=f.Field("Rạp làm việc",AdminUi.Combo());AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");f.Save(()=>{if(pass.Text!=confirm.Text)throw new ArgumentException("Mật khẩu nhập lại không khớp.");Db.Call("dbo.sp_YMC_TaoNhanVien",("@NguoiThucHien",Db.Actor),("@TenDangNhap",user.Text.Trim()),("@MatKhauHash",BaoMatMatKhau.TaoHash(pass.Text)),("@HoTen",name.Text.Trim()),("@MaRap",AdminUi.Id(rap)),("@TenVaiTro",role.Text));});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private DataRow Employee(){var r=AdminUi.Row(Grid);if(r["MaNhanVien"]==DBNull.Value)throw new ArgumentException("Tài khoản này không có hồ sơ nhân viên. ADMIN không bắt buộc có hồ sơ nhân viên.");return r;}
 private void Edit(){var r=Employee();using var f=new EditDialog("Sửa nhân viên");var name=f.TextField("Họ tên",Convert.ToString(r["HoTen"])!);var phone=f.TextField("Điện thoại",Convert.ToString(r["DienThoai"])!,20);
  var active=f.Field("Tình trạng làm việc",new CheckBox{Text="Đang làm việc",Checked=(bool)r["DangLamViec"],AutoSize=true});f.Save(()=>Db.Call("dbo.sp_YMC_CapNhatNhanVien",("@NguoiThucHien",Db.Actor),("@MaNhanVien",r["MaNhanVien"]),("@HoTen",name.Text.Trim()),("@DienThoai",phone.Text.Trim()),("@DangLamViec",active.Checked),("@PhienBan",r["NhanVienPhienBan"])));if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private void Assign(){var r=Employee();using var f=new EditDialog("Phân công / thu hồi rạp");var rap=f.Field("Rạp",AdminUi.Combo());AdminUi.Bind(rap,Db.Raps(),"MaRap","TenRap");
  var on=f.Field("Thao tác",new CheckBox{Text="Phân công (bỏ tích để thu hồi)",Checked=true,AutoSize=true});f.Save(()=>Db.Call("dbo.sp_YMC_PhanCongRap",("@NguoiThucHien",Db.Actor),("@MaNhanVien",r["MaNhanVien"]),("@MaRap",AdminUi.Id(rap)),("@PhanCong",on.Checked)));if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private void Roles(){var r=AdminUi.Row(Grid);using var f=new EditDialog("Cấp / thu hồi vai trò tài khoản");var role=f.Field("Vai trò",AdminUi.Combo());role.Items.AddRange(new object[]{"QUAN_LY","BAN_VE","SOAT_VE","KHACH_HANG"});role.SelectedIndex=0;
  var on=f.Field("Thao tác",new CheckBox{Text="Cấp vai trò (bỏ tích để thu hồi)",Checked=true,AutoSize=true});f.Save(()=>Db.Call("dbo.sp_YMC_GanVaiTro",("@NguoiThucHien",Db.Actor),("@MaTaiKhoan",r["MaTaiKhoan"]),("@TenVaiTro",role.Text),("@Cap",on.Checked)));if(f.ShowDialog(this)==DialogResult.OK)Reload();}
 private void Permissions()
 {
  Db.Require("PHAN_QUYEN_QUAN_LY");using var f=new EditDialog("Bộ quyền dùng chung của vai trò");var role=f.Field("Vai trò (không sửa ADMIN)",AdminUi.Combo());role.Items.AddRange(new object[]{"QUAN_LY","BAN_VE","SOAT_VE","KHACH_HANG"});
  var list=f.Field("Áp dụng cho tất cả tài khoản thuộc vai trò",new CheckedListBox{Height=260,CheckOnClick=true,DisplayMember="TenQuyen",ValueMember="MaQuyen"});
  void LoadRights(){var all=Db.Query("SELECT MaQuyen,TenQuyen FROM dbo.Quyen ORDER BY NhomChucNang,MaQuyen");list.Items.Clear();foreach(DataRow r in all.Rows)list.Items.Add(new QuyenItem((string)r["MaQuyen"],(string)r["TenQuyen"]));
   var granted=Db.Query("SELECT q.MaQuyen FROM dbo.VaiTroQuyen q JOIN dbo.VaiTro v ON v.MaVaiTro=q.MaVaiTro WHERE v.TenVaiTro=@V",("@V",role.Text));var set=granted.AsEnumerable().Select(r=>(string)r[0]).ToHashSet();for(int i=0;i<list.Items.Count;i++)list.SetItemChecked(i,set.Contains(((QuyenItem)list.Items[i]).MaQuyen));}
  role.SelectedIndexChanged+=(_,_)=>AdminUi.Guard(LoadRights);role.SelectedIndex=0;
  f.Save(()=>{if(!AdminUi.Confirm($"Thay toàn bộ quyền vai trò {role.Text}?"))throw new ArgumentException("Đã hủy thay đổi.");var t=new DataTable();t.Columns.Add("MaQuyen",typeof(string));foreach(QuyenItem q in list.CheckedItems)t.Rows.Add(q.MaQuyen);
   Db.Call("dbo.sp_YMC_LuuBoQuyenVaiTro",("@NguoiThucHien",Db.Actor),("@TenVaiTro",role.Text),("@Quyen",new Tvp("dbo.YMC_MaQuyen",t)));});f.ShowDialog(this);
 }
 private sealed record QuyenItem(string MaQuyen,string TenQuyen){public override string ToString()=>TenQuyen;}
 private void AccountStatus(){var r=AdminUi.Row(Grid);if(!AdminUi.Confirm("Đổi trạng thái đăng nhập tài khoản này?"))return;Db.Call("dbo.sp_YMC_DoiTrangThaiTaiKhoan",("@NguoiThucHien",Db.Actor),("@MaTaiKhoan",r["MaTaiKhoan"]),("@DangHoatDong",!(bool)r["DangHoatDong"]),("@PhienBan",r["TaiKhoanPhienBan"]));Reload();}
 private void ResetPassword(){var r=AdminUi.Row(Grid);using var f=new EditDialog("Đặt lại mật khẩu nhân viên/khách");var p=f.TextField("Mật khẩu mới (ít nhất 12 ký tự)",max:256);p.UseSystemPasswordChar=true;var c=f.TextField("Nhập lại",max:256);c.UseSystemPasswordChar=true;
  f.Save(()=>{if(p.Text!=c.Text)throw new ArgumentException("Mật khẩu nhập lại không khớp.");Db.Call("dbo.sp_YMC_AdminDatLaiMatKhau",("@NguoiThucHien",Db.Actor),("@MaTaiKhoan",r["MaTaiKhoan"]),("@MatKhauHash",BaoMatMatKhau.TaoHash(p.Text)),("@PhienBan",r["TaiKhoanPhienBan"]));});if(f.ShowDialog(this)==DialogResult.OK)Reload();}
}
