namespace YeuMinhEmCinema.Admin;
internal sealed class KetQuaDangNhap {public int MaTaiKhoan{get;init;}public string TenDangNhap{get;init;}="";public IReadOnlyCollection<string> DanhSachQuyen{get;init;}=Array.Empty<string>();}
internal static class PhienDangNhap{internal static KetQuaDangNhap? TaiKhoan{get;set;}}
