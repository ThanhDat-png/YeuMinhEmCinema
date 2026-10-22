using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin
{
    /// <summary>
    /// Lớp truy xuất dữ liệu (Data Access Layer - DAL) cho bảng dbo.Phim.
    /// Tách biệt hoàn toàn các câu lệnh SQL khỏi giao diện người dùng.
    /// </summary>
    public static class PhimDAL
    {
        /// <summary>
        /// Lấy danh sách phim có hỗ trợ tìm kiếm theo tên và lọc theo trạng thái.
        /// </summary>
        public static DataTable LayDanhSachPhim(string? tuKhoa = null, string? trangThai = null)
        {
            DataTable bangPhim = new DataTable();

            string sql = @"
                SELECT MaPhim, TenPhim, ThoiLuong,
                       NgayKhoiChieu, GioiHanTuoi, TrangThai,
                       Poster, Trailer, MoTa
                FROM dbo.Phim
                WHERE 1 = 1";

            if (!string.IsNullOrWhiteSpace(tuKhoa))
            {
                sql += " AND TenPhim LIKE @TuKhoa";
            }

            if (!string.IsNullOrWhiteSpace(trangThai) && trangThai != "Tất cả" && trangThai != "Tất cả trạng thái")
            {
                sql += " AND TrangThai = @TrangThai";
            }

            sql += " ORDER BY MaPhim DESC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);

            if (!string.IsNullOrWhiteSpace(tuKhoa))
            {
                lenh.Parameters.Add("@TuKhoa", SqlDbType.NVarChar, 200).Value = "%" + tuKhoa.Trim() + "%";
            }

            if (!string.IsNullOrWhiteSpace(trangThai) && trangThai != "Tất cả" && trangThai != "Tất cả trạng thái")
            {
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 30).Value = trangThai.Trim();
            }

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangPhim);

            return bangPhim;
        }

        /// <summary>
        /// Lấy thông tin chi tiết một bộ phim theo mã phim.
        /// </summary>
        public static DataRow? LayPhimTheoMa(int maPhim)
        {
            string sql = @"
                SELECT MaPhim, TenPhim, ThoiLuong,
                       NgayKhoiChieu, GioiHanTuoi, TrangThai,
                       Poster, Trailer, MoTa
                FROM dbo.Phim
                WHERE MaPhim = @MaPhim;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaPhim", SqlDbType.Int).Value = maPhim;

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            DataTable bang = new DataTable();
            boDoc.Fill(bang);

            return bang.Rows.Count > 0 ? bang.Rows[0] : null;
        }

        /// <summary>
        /// Thêm phim mới vào cơ sở dữ liệu.
        /// Kiểm tra dữ liệu hợp lệ và sử dụng truy vấn có tham số.
        /// </summary>
        public static (bool thanhCong, string thongBao) ThemPhim(
            string tenPhim,
            string? moTa,
            int thoiLuong,
            DateTime ngayKhoiChieu,
            string gioiHanTuoi,
            string? poster,
            string? trailer,
            string trangThai)
        {
            // Kiểm tra tính hợp lệ của dữ liệu đầu vào
            if (string.IsNullOrWhiteSpace(tenPhim))
            {
                return (false, "Tên phim không được để trống.");
            }
            if (tenPhim.Trim().Length > 200)
            {
                return (false, "Tên phim không được vượt quá 200 ký tự.");
            }
            if (thoiLuong <= 0)
            {
                return (false, "Thời lượng phim phải lớn hơn 0 phút.");
            }
            if (string.IsNullOrWhiteSpace(gioiHanTuoi) || gioiHanTuoi.Trim().Length > 10)
            {
                return (false, "Giới hạn tuổi không được để trống và tối đa 10 ký tự.");
            }
            if (trangThai != "Sắp chiếu" && trangThai != "Đang chiếu" && trangThai != "Ngừng chiếu")
            {
                return (false, "Trạng thái không hợp lệ (chỉ chấp nhận: Sắp chiếu, Đang chiếu, Ngừng chiếu).");
            }
            if (!string.IsNullOrWhiteSpace(poster) && poster.Trim().Length > 500)
            {
                return (false, "Đường dẫn poster không được vượt quá 500 ký tự.");
            }
            if (!string.IsNullOrWhiteSpace(trailer) && trailer.Trim().Length > 500)
            {
                return (false, "Đường dẫn trailer không được vượt quá 500 ký tự.");
            }

            string sql = @"
                INSERT INTO dbo.Phim (TenPhim, MoTa, ThoiLuong, NgayKhoiChieu, GioiHanTuoi, Poster, Trailer, TrangThai)
                VALUES (@TenPhim, @MoTa, @ThoiLuong, @NgayKhoiChieu, @GioiHanTuoi, @Poster, @Trailer, @TrangThai);";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);

                lenh.Parameters.Add("@TenPhim", SqlDbType.NVarChar, 200).Value = tenPhim.Trim();
                lenh.Parameters.Add("@MoTa", SqlDbType.NVarChar, -1).Value = string.IsNullOrWhiteSpace(moTa) ? DBNull.Value : moTa.Trim();
                lenh.Parameters.Add("@ThoiLuong", SqlDbType.Int).Value = thoiLuong;
                lenh.Parameters.Add("@NgayKhoiChieu", SqlDbType.Date).Value = ngayKhoiChieu.Date;
                lenh.Parameters.Add("@GioiHanTuoi", SqlDbType.VarChar, 10).Value = gioiHanTuoi.Trim();
                lenh.Parameters.Add("@Poster", SqlDbType.NVarChar, 500).Value = string.IsNullOrWhiteSpace(poster) ? DBNull.Value : poster.Trim();
                lenh.Parameters.Add("@Trailer", SqlDbType.NVarChar, 500).Value = string.IsNullOrWhiteSpace(trailer) ? DBNull.Value : trailer.Trim();
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 30).Value = trangThai.Trim();

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();

                if (soDong > 0)
                {
                    return (true, "Thêm phim mới thành công vào cơ sở dữ liệu!");
                }
                else
                {
                    return (false, "Không có dòng dữ liệu nào được ghi nhận.");
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi thêm phim:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Cập nhật thông tin phim hiện có.
        /// </summary>
        public static (bool thanhCong, string thongBao) CapNhatPhim(
            int maPhim,
            string tenPhim,
            string? moTa,
            int thoiLuong,
            DateTime ngayKhoiChieu,
            string gioiHanTuoi,
            string? poster,
            string? trailer,
            string trangThai)
        {
            if (maPhim <= 0)
            {
                return (false, "Mã phim không hợp lệ.");
            }
            if (string.IsNullOrWhiteSpace(tenPhim))
            {
                return (false, "Tên phim không được để trống.");
            }
            if (tenPhim.Trim().Length > 200)
            {
                return (false, "Tên phim không được vượt quá 200 ký tự.");
            }
            if (thoiLuong <= 0)
            {
                return (false, "Thời lượng phim phải lớn hơn 0 phút.");
            }
            if (string.IsNullOrWhiteSpace(gioiHanTuoi) || gioiHanTuoi.Trim().Length > 10)
            {
                return (false, "Giới hạn tuổi không được để trống và tối đa 10 ký tự.");
            }
            if (trangThai != "Sắp chiếu" && trangThai != "Đang chiếu" && trangThai != "Ngừng chiếu")
            {
                return (false, "Trạng thái không hợp lệ (chỉ chấp nhận: Sắp chiếu, Đang chiếu, Ngừng chiếu).");
            }
            if (!string.IsNullOrWhiteSpace(poster) && poster.Trim().Length > 500)
            {
                return (false, "Đường dẫn poster không được vượt quá 500 ký tự.");
            }
            if (!string.IsNullOrWhiteSpace(trailer) && trailer.Trim().Length > 500)
            {
                return (false, "Đường dẫn trailer không được vượt quá 500 ký tự.");
            }

            string sql = @"
                UPDATE dbo.Phim
                SET TenPhim = @TenPhim,
                    MoTa = @MoTa,
                    ThoiLuong = @ThoiLuong,
                    NgayKhoiChieu = @NgayKhoiChieu,
                    GioiHanTuoi = @GioiHanTuoi,
                    Poster = @Poster,
                    Trailer = @Trailer,
                    TrangThai = @TrangThai
                WHERE MaPhim = @MaPhim;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);

                lenh.Parameters.Add("@MaPhim", SqlDbType.Int).Value = maPhim;
                lenh.Parameters.Add("@TenPhim", SqlDbType.NVarChar, 200).Value = tenPhim.Trim();
                lenh.Parameters.Add("@MoTa", SqlDbType.NVarChar, -1).Value = string.IsNullOrWhiteSpace(moTa) ? DBNull.Value : moTa.Trim();
                lenh.Parameters.Add("@ThoiLuong", SqlDbType.Int).Value = thoiLuong;
                lenh.Parameters.Add("@NgayKhoiChieu", SqlDbType.Date).Value = ngayKhoiChieu.Date;
                lenh.Parameters.Add("@GioiHanTuoi", SqlDbType.VarChar, 10).Value = gioiHanTuoi.Trim();
                lenh.Parameters.Add("@Poster", SqlDbType.NVarChar, 500).Value = string.IsNullOrWhiteSpace(poster) ? DBNull.Value : poster.Trim();
                lenh.Parameters.Add("@Trailer", SqlDbType.NVarChar, 500).Value = string.IsNullOrWhiteSpace(trailer) ? DBNull.Value : trailer.Trim();
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 30).Value = trangThai.Trim();

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();

                if (soDong > 0)
                {
                    return (true, "Cập nhật thông tin phim thành công!");
                }
                else
                {
                    return (false, "Không tìm thấy phim có mã tương ứng để cập nhật.");
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi cập nhật phim:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Ngừng chiếu phim (không xóa vật lý khỏi cơ sở dữ liệu).
        /// </summary>
        public static (bool thanhCong, string thongBao) NgungChieuPhim(int maPhim)
        {
            if (maPhim <= 0)
            {
                return (false, "Mã phim không hợp lệ.");
            }

            string sql = @"
                UPDATE dbo.Phim
                SET TrangThai = N'Ngừng chiếu'
                WHERE MaPhim = @MaPhim;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);
                lenh.Parameters.Add("@MaPhim", SqlDbType.Int).Value = maPhim;

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();

                if (soDong > 0)
                {
                    return (true, "Đã chuyển trạng thái phim sang 'Ngừng chiếu' thành công!");
                }
                else
                {
                    return (false, "Không tìm thấy phim để cập nhật trạng thái.");
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi ngừng chiếu phim:\n" + ex.Message);
            }
        }
    }
}
