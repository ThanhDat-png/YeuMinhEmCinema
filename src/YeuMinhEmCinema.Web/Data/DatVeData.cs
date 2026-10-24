using System.Data;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.ViewModels;
using static YeuMinhEmCinema.Web.Data.WebDb;

namespace YeuMinhEmCinema.Web.Data;

/// <summary>Đặt vé Web qua procedure hiện có, luôn lấy chủ đơn từ tài khoản xác thực.</summary>
public class DatVeData
{
    private readonly WebDb db;

    public DatVeData(WebDb db)
    {
        this.db = db;
    }

    public DataRow? Suat(int id)
    {
        var table = db.Table("""
            SELECT s.MaSuatChieu,s.MaPhim,f.TenPhim,r.TenRap,p.TenPhong,p.DinhDang,s.GioBatDau
            FROM dbo.SuatChieu s JOIN dbo.Phim f ON f.MaPhim=s.MaPhim
            JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong JOIN dbo.Rap r ON r.MaRap=p.MaRap
            WHERE s.MaSuatChieu=@Id AND s.TrangThai=N'Mở bán' AND s.GioBatDau>dbo.fn_YMC_GioVietNam()
                AND f.TrangThai=N'Đang chiếu' AND p.TrangThai=N'Đang hoạt động' AND r.TrangThai=N'Đang hoạt động'
            """, false, P("@Id", id));
        return table.Rows.Count == 0 ? null : table.Rows[0];
    }

    public DataTable Ghe(int suat)
    {
        var table = db.Table("dbo.sp_YMC_SoDoGheTheoSuat", true, P("@MaSuatChieu", suat));
        table.Columns.Add("Gia", typeof(decimal));
        var gia = db.Table("""
            SELECT g.MaGhe, CASE WHEN COUNT(v.MaGiaVe)=1 THEN MIN(v.DonGia) END AS Gia
            FROM dbo.SuatChieu s JOIN dbo.PhongChieu p ON p.MaPhong=s.MaPhong
            JOIN dbo.Ghe g ON g.MaPhong=s.MaPhong
            LEFT JOIN dbo.GiaVe v ON v.MaLoaiGhe=g.MaLoaiGhe AND v.DinhDang=p.DinhDang
                AND v.LoaiNgay=CASE WHEN (DATEDIFF(DAY,'19000101',CONVERT(DATE,s.GioBatDau))%7+7)%7>=4
                    THEN N'Cuối tuần' ELSE N'Ngày thường' END
                AND v.DangApDung=1 AND v.TuNgay<=CONVERT(DATE,s.GioBatDau)
                AND (v.DenNgay IS NULL OR v.DenNgay>=CONVERT(DATE,s.GioBatDau))
            WHERE s.MaSuatChieu=@Id GROUP BY g.MaGhe
            """, false, P("@Id", suat));
        var dictionary = gia.AsEnumerable().ToDictionary(r => (int)r["MaGhe"], r => r["Gia"]);
        foreach (DataRow row in table.Rows)
        {
            row["Gia"] = dictionary.GetValueOrDefault((int)row["MaGhe"], DBNull.Value);
        }
        return table;
    }

    public DataTable Menu()
    {
        return db.Table("SELECT MaSanPham,TenSanPham,Nhom,DonGia FROM dbo.v_YMC_FnbMenu WHERE CoTheBan=1 ORDER BY Nhom,TenSanPham");
    }

    public long TaoDon(int id, DatVeModel model)
    {
        var ghe = new DataTable();
        ghe.Columns.Add("MaGhe", typeof(int));
        foreach (var ma in model.Ghe)
        {
            ghe.Rows.Add(ma);
        }
        var fnb = new DataTable();
        fnb.Columns.Add("MaSanPham", typeof(int));
        fnb.Columns.Add("SoLuong", typeof(int));
        foreach (var item in model.Fnb.Where(f => f.SoLuong > 0))
        {
            fnb.Rows.Add(item.MaSanPham, item.SoLuong);
        }
        var result = db.Table("dbo.sp_YMC_TaoDonGiuGhe", true,
            P("@NguoiThucHien", id), P("@MaYeuCau", model.MaYeuCau), P("@MaSuatChieu", model.MaSuatChieu),
            P("@Kenh", "WEB"), P("@HoTenLienHe", model.HoTen.Trim()), P("@DienThoaiLienHe", model.DienThoai),
            new SqlParameter("@DanhSachGhe", SqlDbType.Structured) { TypeName = "dbo.YMC_DanhSachGhe", Value = ghe },
            new SqlParameter("@DanhSachFnb", SqlDbType.Structured) { TypeName = "dbo.YMC_DanhSachFnb", Value = fnb });
        return (long)result.Rows[0]["MaDonHang"];
    }

    /// <summary>Không dựa vào quyền Admin khi tra đơn; kiểm tra chủ sở hữu trước procedure dùng chung.</summary>
    public bool ThuocKhach(int id, long don)
    {
        return db.Table("""
            SELECT d.MaDonHang FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
            WHERE d.MaDonHang=@Don AND k.MaTaiKhoan=@Id AND k.DangHoatDong=1
            """, false, P("@Don", don), P("@Id", id)).Rows.Count == 1;
    }

    public DataSet ChiTiet(int id, long don)
    {
        return db.Read("dbo.sp_YMC_XemChiTietDon", true, P("@NguoiThucHien", id), P("@MaDonHang", don));
    }

    public void Huy(int id, long don)
    {
        db.Read("dbo.sp_YMC_HuyDonChuaThanhToan", true, P("@NguoiThucHien", id),
            P("@MaDonHang", don), P("@LyDo", "Khách hủy đơn trên Web."));
    }

    public void MoPhong(int id, long don)
    {
        db.Read("dbo.sp_YMC_WebMoPhongThanhToan", true, P("@MaTaiKhoan", id), P("@MaDonHang", don));
    }

    public byte[]? Ve(int id, Guid ve)
    {
        var table = db.Table("""
            SELECT v.MaVe FROM dbo.Ve v JOIN dbo.DonHang d ON d.MaDonHang=v.MaDonHang
            JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
            WHERE v.MaVe=@Ve AND k.MaTaiKhoan=@Id AND k.DangHoatDong=1
                AND d.TrangThai='DA_THANH_TOAN' AND v.TrangThai IN('HIEU_LUC','DA_SU_DUNG')
            """, false, P("@Ve", ve), P("@Id", id));
        if (table.Rows.Count == 0)
        {
            return null;
        }
        using var generator = new QRCoder.QRCodeGenerator();
        using var data = generator.CreateQrCode(ve.ToString("D"), QRCoder.QRCodeGenerator.ECCLevel.M);
        using var qr = new QRCoder.PngByteQRCode(data);
        return qr.GetGraphic(5);
    }

    public LichSuModel LichSu(int id, string? trangThai, int trang)
    {
        // Hết hạn được suy ra bằng giờ server khi đọc, không thay đổi dữ liệu bằng GET.
        var result = db.Read("""
            SELECT d.MaDonHang,d.MaThamChieu,d.TongTien,d.NgayTaoUtc,
                CASE WHEN d.TrangThai='CHO_THANH_TOAN' AND d.HanThanhToanUtc<=SYSUTCDATETIME()
                    THEN 'HET_HAN' ELSE d.TrangThai END AS TrangThai
            INTO #Don FROM dbo.DonHang d JOIN dbo.KhachHang k ON k.MaKhachHang=d.MaKhachHang
            WHERE k.MaTaiKhoan=@Id AND k.DangHoatDong=1;
            SELECT COUNT(*) AS Tong FROM #Don WHERE @TT IS NULL OR TrangThai=@TT;
            SELECT * FROM #Don WHERE @TT IS NULL OR TrangThai=@TT ORDER BY MaDonHang DESC
                OFFSET (@Trang-1)*10 ROWS FETCH NEXT 10 ROWS ONLY;
            """, false, P("@Id", id), P("@TT", trangThai), P("@Trang", trang));
        return new LichSuModel
        {
            Tong = (int)result.Tables[0].Rows[0]["Tong"],
            Don = result.Tables[1],
            Trang = trang,
            TrangThai = trangThai
        };
    }
}
