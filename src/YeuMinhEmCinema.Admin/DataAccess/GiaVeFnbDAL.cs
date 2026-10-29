using System.Data;
using Microsoft.Data.SqlClient;
namespace YeuMinhEmCinema.Admin;

public static class GiaVeFnbDAL
{
    private static DataTable Doc(SqlCommand c)
    {
        if (c.CommandType == CommandType.StoredProcedure)
            c.Parameters.Add("@NguoiThucHien", SqlDbType.Int).Value = Db.Actor;
        else
            Db.Require(c.CommandText.Contains("dbo.GiaVe") || c.CommandText.Contains("dbo.LoaiGhe")
                    || c.CommandText.Contains("dbo.PhongChieu") ? "GIA_VE_XEM" : "FNB_XEM");
        using var cn = new SqlConnection(CauHinh.ChuoiKetNoi);
        c.Connection = cn;
        using var da = new SqlDataAdapter(c);
        var dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    private static void P(SqlCommand c, string n, SqlDbType t, object? v, int size = 0)
    {
        var p = size == 0 ? c.Parameters.Add(n, t) : c.Parameters.Add(n, t, size);
        p.Value = v ?? DBNull.Value;
        if (t == SqlDbType.Decimal)
        {
            p.Precision = 18;
            p.Scale = 0;
        }
    }

    public static DataTable LoaiGhe()
    {
        using var c = new SqlCommand("SELECT MaLoai,TenLoai FROM dbo.LoaiGhe ORDER BY MaLoai");
        return Doc(c);
    }

    public static DataTable DinhDang()
    {
        using var c = new SqlCommand("SELECT DISTINCT DinhDang FROM dbo.PhongChieu WHERE LEN(LTRIM(RTRIM(DinhDang)))>0 ORDER BY DinhDang");
        return Doc(c);
    }

    public static DataTable GiaVe(string tuKhoa = "", int? loai = null, bool? bat = null)
    {
        using var c = new SqlCommand(@"SELECT g.MaGiaVe,l.TenLoai,g.DinhDang,g.LoaiNgay,g.TuNgay,g.DenNgay,
            g.DonGia,g.DangApDung,g.MaLoaiGhe,g.PhienBan FROM dbo.GiaVe g JOIN dbo.LoaiGhe l ON l.MaLoai=g.MaLoaiGhe
            WHERE (@Loai IS NULL OR g.MaLoaiGhe=@Loai) AND (@Bat IS NULL OR g.DangApDung=@Bat)
              AND (@TK=N'' OR l.TenLoai LIKE @Like OR g.DinhDang LIKE @Like)
            ORDER BY l.TenLoai,g.DinhDang,g.LoaiNgay,g.TuNgay DESC,g.MaGiaVe;");
        P(c, "@Loai", SqlDbType.Int, loai);
        P(c, "@Bat", SqlDbType.Bit, bat);
        P(c, "@TK", SqlDbType.NVarChar, tuKhoa.Trim(), 200);
        P(c, "@Like", SqlDbType.NVarChar, "%" + tuKhoa.Trim() + "%", 402);
        return Doc(c);
    }

    public static int LuuGia(int? ma,
        int loai,
        string dd,
        string ln,
        DateTime tu,
        DateTime? den,
        decimal gia,
        bool bat,
        byte[]? phienBan)
    {
        using var c = new SqlCommand("dbo.sp_YMC_AdminLuuGiaVe")
        {
            CommandType = CommandType.StoredProcedure
        };
        P(c, "@MaGiaVe", SqlDbType.Int, ma);
        P(c, "@MaLoaiGhe", SqlDbType.Int, loai);
        P(c, "@DinhDang", SqlDbType.NVarChar, dd.Trim(), 50);
        P(c, "@LoaiNgay", SqlDbType.NVarChar, ln, 20);
        P(c, "@TuNgay", SqlDbType.Date, tu.Date);
        P(c, "@DenNgay", SqlDbType.Date, den?.Date);
        P(c, "@DonGia", SqlDbType.Decimal, gia);
        P(c, "@DangApDung", SqlDbType.Bit, bat);
        P(c, "@PhienBan", SqlDbType.Binary, phienBan, 8);
        return Convert.ToInt32(Doc(c).Rows[0][0]);
    }

    public static DataTable TraGia(int loai, string dd, DateTime ngay)
    {
        using var c = new SqlCommand(@"SELECT MaGiaVe,DonGia,LoaiNgay,TuNgay,DenNgay FROM dbo.GiaVe
            WHERE MaLoaiGhe=@Loai AND DinhDang=@DD AND DangApDung=1 AND TuNgay<=@Ngay
            AND (DenNgay IS NULL OR DenNgay>=@Ngay)
            AND LoaiNgay=CASE WHEN (DATEDIFF(DAY,CONVERT(DATE,'19000101'),@Ngay)%7+7)%7>=4
                             THEN N'Cuối tuần' ELSE N'Ngày thường' END;");
        P(c, "@Loai", SqlDbType.Int, loai);
        P(c, "@DD", SqlDbType.NVarChar, dd.Trim(), 50);
        P(c, "@Ngay", SqlDbType.Date, ngay.Date);
        return Doc(c);
    }

    public static DataTable Fnb(string tk = "", string? nhom = null, bool? ban = null)
    {
        using var c = new SqlCommand(@"SELECT MaSanPham,MaHang,TenSanPham,Nhom,KichCo,DonGia,DangBan,CoTheBan,
            CASE WHEN DangBan=0 THEN N'Ngừng bán' WHEN CoTheBan=0 THEN N'Chặn do thành phần' ELSE N'Đang bán' END AS TinhTrang,
            PhienBan FROM dbo.v_YMC_FnbMenu WHERE (@Nhom IS NULL OR Nhom=@Nhom)
            AND (@Ban IS NULL OR DangBan=@Ban) AND (@TK=N'' OR TenSanPham LIKE @Like OR MaHang LIKE @Like)
            ORDER BY Nhom,TenSanPham,MaSanPham;");
        P(c, "@Nhom", SqlDbType.NVarChar, nhom, 20);
        P(c, "@Ban", SqlDbType.Bit, ban);
        P(c, "@TK", SqlDbType.NVarChar, tk.Trim(), 200);
        P(c, "@Like", SqlDbType.NVarChar, "%" + tk.Trim() + "%", 402);
        return Doc(c);
    }

    public static DataTable ThanhPhan(int ma)
    {
        using var c = new SqlCommand(@"SELECT c.MaThanhPhan,p.MaHang,p.TenSanPham,c.SoLuong,p.DangBan
            FROM dbo.FnbComboChiTiet c JOIN dbo.FnbSanPham p ON p.MaSanPham=c.MaThanhPhan
            WHERE c.MaCombo=@Ma ORDER BY p.MaHang;");
        P(c, "@Ma", SqlDbType.Int, ma);
        return Doc(c);
    }

    public static DataTable MonLe()
    {
        using var c = new SqlCommand("SELECT MaSanPham,MaHang+N' — '+TenSanPham AS TenHienThi FROM dbo.FnbSanPham WHERE Nhom<>N'Combo' AND DangBan=1 ORDER BY MaHang;");
        return Doc(c);
    }

    public static DataTable TaoThanhPhan()
    {
        var dt = new DataTable();
        dt.Columns.Add("MaThanhPhan", typeof(int));
        dt.Columns.Add("SoLuong", typeof(int));
        return dt;
    }

    public static int LuuFnb(int? ma,
        string code,
        string ten,
        string nhom,
        string size,
        decimal gia,
        bool ban,
        DataTable thanhPhan,
        byte[]? phienBan)
    {
        using var c = new SqlCommand("dbo.sp_YMC_AdminLuuFnb")
        {
            CommandType = CommandType.StoredProcedure
        };
        P(c, "@MaSanPham", SqlDbType.Int, ma);
        P(c, "@MaHang", SqlDbType.VarChar, code.Trim().ToUpperInvariant(), 30);
        P(c, "@TenSanPham", SqlDbType.NVarChar, ten.Trim(), 150);
        P(c, "@Nhom", SqlDbType.NVarChar, nhom, 20);
        P(c, "@KichCo", SqlDbType.NVarChar, size.Trim(), 50);
        P(c, "@DonGia", SqlDbType.Decimal, gia);
        P(c, "@DangBan", SqlDbType.Bit, ban);
        P(c, "@PhienBan", SqlDbType.Binary, phienBan, 8);
        var tp = TaoThanhPhan();
        foreach (DataRow row in thanhPhan.Rows)
            tp.Rows.Add(row["MaThanhPhan"], row["SoLuong"]);
        var p = c.Parameters.Add("@ThanhPhan", SqlDbType.Structured);
        p.TypeName = "dbo.YMC_FnbThanhPhan";
        p.Value = tp;
        return Convert.ToInt32(Doc(c).Rows[0][0]);
    }
}
