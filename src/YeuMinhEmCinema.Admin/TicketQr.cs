using QRCoder;
namespace YeuMinhEmCinema.Admin;
internal static class TicketQr
{
 internal static byte[] Create(Guid ticket)
 {
  using var generator=new QRCodeGenerator();using var data=generator.CreateQrCode(ticket.ToString("D"),QRCodeGenerator.ECCLevel.M);
  using var qr=new PngByteQRCode(data);return qr.GetGraphic(5);
 }
}
