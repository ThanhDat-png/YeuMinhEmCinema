using System.Data;
using System.Diagnostics;
using System.Net;
using System.Text;
using QRCoder;
namespace YeuMinhEmCinema.Admin;
internal static class HoaDonExporter
{
 internal static void Xuat(long maDon)
 {
  var ds=GiaoDichDAL.ChiTiet(maDon);var d=ds.Tables[0].Rows[0];
  string E(object? v)=>WebUtility.HtmlEncode(Convert.ToString(v)??"");
  var b=new StringBuilder("<!doctype html><html lang='vi'><meta charset='utf-8'><title>YeuMinhEm Cinema</title><style>body{font:16px Arial;max-width:800px;margin:30px auto;color:#151515}table{width:100%;border-collapse:collapse}td,th{border:1px solid #bbb;padding:10px}.ticket{break-inside:avoid;border:1px solid #888;margin:18px 0;padding:14px;display:flex;align-items:center;gap:18px}img{width:150px;height:150px}h1{color:#195fbe}@media print{button{display:none}}</style>");
  b.Append($"<h1>YeuMinhEm Cinema</h1><h2>Phiếu đơn hàng #{maDon}</h2><p>Trạng thái: {E(d["TrangThai"])} — Khách: {E(d["HoTenLienHe"])}</p><table><tr><th>Phim / phòng / ghế</th><th>Giờ chiếu VN</th><th>Tiền vé</th></tr>");
  foreach(DataRow r in ds.Tables[1].Rows)b.Append($"<tr><td>{E(r["TenPhim"])} / {E(r["TenRap"])} / {E(r["TenPhong"])} / {E(r["NhanGhe"])}</td><td>{E(((DateTime)r["GioBatDau"]).ToString("dd/MM/yyyy HH:mm"))}</td><td>{(decimal)r["DonGia"]:N0} đ</td></tr>");
  b.Append("</table><h3>Bắp nước</h3><table>");
  foreach(DataRow r in ds.Tables[2].Rows)b.Append($"<tr><td>{E(r["TenSanPham"])}</td><td>{r["SoLuong"]} × {(decimal)r["DonGia"]:N0} đ</td></tr>");
  b.Append($"</table><h2>Tổng đơn: {(decimal)d["TongTien"]:N0} đ</h2>");
  if((string)d["TrangThai"]!="DA_THANH_TOAN")b.Append("<p>Phiếu này không xác nhận vé còn hiệu lực. Tra trạng thái tại quầy.</p>");
  foreach(DataRow r in ds.Tables[1].Rows)
  {if(r["MaVe"]==DBNull.Value)continue;string id=Convert.ToString(r["MaVe"])!;
   var png=TicketQr.Create(Guid.Parse(id));
   b.Append($"<section class='ticket'><img alt='Mã QR vé' src='data:image/png;base64,{Convert.ToBase64String(png)}'><div><b>Ghế {E(r["NhanGhe"])}</b><p>{E(id)}</p><p>{E(r["TrangThaiVe"])}</p></div></section>");}
  b.Append("<p>Quét QR cần kết nối hệ thống để xác minh vé. Không chia sẻ mã vé.</p><button onclick='window.print()'>In phiếu / lưu PDF</button></html>");
  using var dialog=new SaveFileDialog{Filter="Phiếu HTML có QR|*.html",FileName=$"Don-{maDon}.html"};if(dialog.ShowDialog()!=DialogResult.OK)return;
  File.WriteAllText(dialog.FileName,b.ToString(),new UTF8Encoding(true));Process.Start(new ProcessStartInfo(dialog.FileName){UseShellExecute=true});
 }
}
