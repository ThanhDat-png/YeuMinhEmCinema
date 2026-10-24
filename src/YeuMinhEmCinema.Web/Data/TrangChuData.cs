using System.Data;
using Microsoft.Data.SqlClient;
using YeuMinhEmCinema.Web.Models;

namespace YeuMinhEmCinema.Web.Data;

/// <summary>Đọc dữ liệu công khai; không sửa database hoặc chạy seed.</summary>
public class TrangChuData
{
    private readonly IConfiguration configuration;

    /// <summary>Nhận cấu hình tập trung thay vì lưu chuỗi kết nối trong mã.</summary>
    public TrangChuData(IConfiguration configuration)
    {
        this.configuration = configuration;
    }

    /// <summary>Tạo kết nối riêng cho lần đọc, tránh dùng chung kết nối giữa request.</summary>
    private SqlConnection TaoKetNoi()
    {
        var chuoi = configuration.GetConnectionString("Cinema")
            ?? Environment.GetEnvironmentVariable("YMC_CONNECTION");
        if (string.IsNullOrWhiteSpace(chuoi))
        {
            throw new InvalidOperationException("Chưa cấu hình kết nối Cinema.");
        }
        return new SqlConnection(chuoi);
    }

    /// <summary>Dùng phân trang tại SQL để không tải toàn bộ danh mục.</summary>
    public virtual async Task<(List<Phim> phim, int tong)> LayPhimAsync(
        string? tuKhoa, string? trangThai, int trang, int kichThuoc, CancellationToken cancellationToken)
    {
        using var connection = TaoKetNoi();
        using var command = new SqlCommand("dbo.sp_YMC_WebDanhSachPhim", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.Add("@TuKhoa", SqlDbType.NVarChar, 200).Value = (object?)tuKhoa ?? DBNull.Value;
        command.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 30).Value = (object?)trangThai ?? DBNull.Value;
        command.Parameters.Add("@Trang", SqlDbType.Int).Value = trang;
        command.Parameters.Add("@KichThuocTrang", SqlDbType.Int).Value = kichThuoc;
        await connection.OpenAsync(cancellationToken);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var phim = new List<Phim>();
        var tong = 0;
        while (await reader.ReadAsync(cancellationToken))
        {
            phim.Add(new Phim
            {
                MaPhim = (int)reader["MaPhim"],
                TenPhim = (string)reader["TenPhim"],
                ThoiLuong = (int)reader["ThoiLuong"],
                NgayKhoiChieu = (DateTime)reader["NgayKhoiChieu"],
                GioiHanTuoi = (string)reader["GioiHanTuoi"],
                TrangThai = (string)reader["TrangThai"],
                Poster = reader["Poster"] as string
            });
            tong = (int)reader["TongKetQua"];
        }
        // COUNT OVER không có dòng mang tổng khi OFFSET vượt danh sách.
        // Đọc tối đa một phim ở trang đầu để lấy tổng, giữ nguyên procedure dùng chung.
        if (phim.Count == 0 && trang > 1)
        {
            var trangDau = await LayPhimAsync(tuKhoa, trangThai, 1, 1, cancellationToken);
            tong = trangDau.tong;
        }
        return (phim, tong);
    }

    /// <summary>Truy vấn các cột đã xác nhận trong schema, chỉ lấy rạp đang hoạt động.</summary>
    public virtual async Task<List<Rap>> LayRapAsync(CancellationToken cancellationToken)
    {
        using var connection = TaoKetNoi();
        using var command = new SqlCommand(
            "SELECT TenRap, DiaChi FROM dbo.Rap WHERE TrangThai = @TrangThai ORDER BY MaRap", connection);
        command.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 30).Value = "Đang hoạt động";
        await connection.OpenAsync(cancellationToken);
        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var rap = new List<Rap>();
        while (await reader.ReadAsync(cancellationToken))
        {
            rap.Add(new Rap
            {
                TenRap = (string)reader["TenRap"],
                DiaChi = reader["DiaChi"] as string ?? ""
            });
        }
        return rap;
    }
}
