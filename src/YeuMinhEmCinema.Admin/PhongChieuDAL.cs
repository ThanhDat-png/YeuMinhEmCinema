using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin
{
    /// <summary>
    /// Lớp truy xuất dữ liệu (Data Access Layer - DAL) cho bảng dbo.PhongChieu.
    /// Quản lý thông tin phòng chiếu, định dạng phòng, và tính toán sức chứa.
    /// </summary>
    public static class PhongChieuDAL
    {
        /// <summary>
        /// Lấy danh sách tất cả phòng chiếu kèm sức chứa thực tế từ danh sách ghế.
        /// </summary>
        public static DataTable LayDanhSachTatCaPhong()
        {
            DataTable bangPhong = new DataTable();

            string sql = @"
                SELECT 
                    p.MaPhong,
                    p.MaRap,
                    r.TenRap,
                    p.TenPhong,
                    p.DinhDang,
                    p.TrangThai,
                    COUNT(g.MaGhe) AS SucChua,
                    COUNT(CASE WHEN g.TrangThai = N'Hoạt động' THEN 1 END) AS SoGheHoatDong,
                    COUNT(CASE WHEN g.TrangThai <> N'Hoạt động' THEN 1 END) AS SoGheHong
                FROM dbo.PhongChieu p
                INNER JOIN dbo.Rap r ON p.MaRap = r.MaRap
                LEFT JOIN dbo.Ghe g ON p.MaPhong = g.MaPhong
                GROUP BY p.MaPhong, p.MaRap, r.TenRap, p.TenPhong, p.DinhDang, p.TrangThai
                ORDER BY p.MaRap ASC, p.MaPhong ASC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangPhong);

            return bangPhong;
        }

        /// <summary>
        /// Lấy danh sách phòng chiếu thuộc về một cụm rạp xác định.
        /// </summary>
        public static DataTable LayDanhSachPhongTheoRap(int maRap)
        {
            DataTable bangPhong = new DataTable();

            string sql = @"
                SELECT 
                    p.MaPhong,
                    p.MaRap,
                    r.TenRap,
                    p.TenPhong,
                    p.DinhDang,
                    p.TrangThai,
                    COUNT(g.MaGhe) AS SucChua,
                    COUNT(CASE WHEN g.TrangThai = N'Hoạt động' THEN 1 END) AS SoGheHoatDong,
                    COUNT(CASE WHEN g.TrangThai <> N'Hoạt động' THEN 1 END) AS SoGheHong
                FROM dbo.PhongChieu p
                INNER JOIN dbo.Rap r ON p.MaRap = r.MaRap
                LEFT JOIN dbo.Ghe g ON p.MaPhong = g.MaPhong
                WHERE p.MaRap = @MaRap
                GROUP BY p.MaPhong, p.MaRap, r.TenRap, p.TenPhong, p.DinhDang, p.TrangThai
                ORDER BY p.MaPhong ASC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangPhong);

            return bangPhong;
        }

        /// <summary>
        /// Lấy thông tin chi tiết một phòng chiếu theo mã phòng.
        /// </summary>
        public static DataRow? LayPhongTheoMa(int maPhong)
        {
            if (maPhong <= 0) return null;

            string sql = @"
                SELECT 
                    p.MaPhong,
                    p.MaRap,
                    r.TenRap,
                    p.TenPhong,
                    p.DinhDang,
                    p.TrangThai,
                    COUNT(g.MaGhe) AS SucChua,
                    COUNT(CASE WHEN g.TrangThai = N'Hoạt động' THEN 1 END) AS SoGheHoatDong,
                    COUNT(CASE WHEN g.TrangThai <> N'Hoạt động' THEN 1 END) AS SoGheHong
                FROM dbo.PhongChieu p
                INNER JOIN dbo.Rap r ON p.MaRap = r.MaRap
                LEFT JOIN dbo.Ghe g ON p.MaPhong = g.MaPhong
                WHERE p.MaPhong = @MaPhong
                GROUP BY p.MaPhong, p.MaRap, r.TenRap, p.TenPhong, p.DinhDang, p.TrangThai;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            DataTable bang = new DataTable();
            boDoc.Fill(bang);

            return bang.Rows.Count > 0 ? bang.Rows[0] : null;
        }

        /// <summary>
        /// Tính toán sức chứa của phòng chiếu động từ số lượng ghế thực tế trong cơ sở dữ liệu.
        /// </summary>
        public static int LaySucChuaPhong(int maPhong)
        {
            if (maPhong <= 0) return 0;

            string sql = "SELECT dbo.fn_LaySucChuaPhong(@MaPhong);";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;

            try
            {
                ketNoi.Open();
                object? ketQua = lenh.ExecuteScalar();
                return ketQua != null && ketQua != DBNull.Value ? Convert.ToInt32(ketQua) : 0;
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Thêm phòng chiếu mới vào cụm rạp.
        /// Đảm bảo ràng buộc tên phòng không trùng trong cùng một rạp.
        /// </summary>
        public static (bool thanhCong, string thongBao, int maPhongMoi) ThemPhong(
            int maRap,
            string tenPhong,
            string dinhDang,
            string trangThai)
        {
            if (maRap <= 0)
            {
                return (false, "Vui lòng chọn cụm rạp hợp lệ.", 0);
            }
            if (string.IsNullOrWhiteSpace(tenPhong))
            {
                return (false, "Tên phòng không được để trống.", 0);
            }
            if (tenPhong.Trim().Length > 100)
            {
                return (false, "Tên phòng không được vượt quá 100 ký tự.", 0);
            }
            if (string.IsNullOrWhiteSpace(dinhDang))
            {
                dinhDang = "2D";
            }
            if (string.IsNullOrWhiteSpace(trangThai))
            {
                trangThai = "Đang hoạt động";
            }

            string sqlKiemTra = "SELECT COUNT(1) FROM dbo.PhongChieu WHERE MaRap = @MaRap AND TenPhong = @TenPhong;";
            string sqlInsert = @"
                INSERT INTO dbo.PhongChieu (MaRap, TenPhong, DinhDang, TrangThai)
                VALUES (@MaRap, @TenPhong, @DinhDang, @TrangThai);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                ketNoi.Open();

                // Kiểm tra ràng buộc trùng tên phòng trong cùng rạp
                using (SqlCommand lenhCheck = new SqlCommand(sqlKiemTra, ketNoi))
                {
                    lenhCheck.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    lenhCheck.Parameters.Add("@TenPhong", SqlDbType.NVarChar, 100).Value = tenPhong.Trim();

                    int tonTai = Convert.ToInt32(lenhCheck.ExecuteScalar());
                    if (tonTai > 0)
                    {
                        return (false, $"Tên phòng '{tenPhong.Trim()}' đã tồn tại trong cụm rạp đã chọn.", 0);
                    }
                }

                using (SqlCommand lenhInsert = new SqlCommand(sqlInsert, ketNoi))
                {
                    lenhInsert.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    lenhInsert.Parameters.Add("@TenPhong", SqlDbType.NVarChar, 100).Value = tenPhong.Trim();
                    lenhInsert.Parameters.Add("@DinhDang", SqlDbType.NVarChar, 50).Value = dinhDang.Trim();
                    lenhInsert.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThai.Trim();

                    int maMoi = Convert.ToInt32(lenhInsert.ExecuteScalar());
                    return (true, "Thêm phòng chiếu mới thành công!", maMoi);
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi thêm phòng chiếu:\n" + ex.Message, 0);
            }
        }

        /// <summary>
        /// Cập nhật thông tin phòng chiếu hiện có.
        /// </summary>
        public static (bool thanhCong, string thongBao) CapNhatPhong(
            int maPhong,
            int maRap,
            string tenPhong,
            string dinhDang,
            string trangThai)
        {
            if (maPhong <= 0)
            {
                return (false, "Mã phòng không hợp lệ.");
            }
            if (maRap <= 0)
            {
                return (false, "Vui lòng chọn cụm rạp hợp lệ.");
            }
            if (string.IsNullOrWhiteSpace(tenPhong))
            {
                return (false, "Tên phòng không được để trống.");
            }
            if (tenPhong.Trim().Length > 100)
            {
                return (false, "Tên phòng không được vượt quá 100 ký tự.");
            }

            string sqlKiemTra = "SELECT COUNT(1) FROM dbo.PhongChieu WHERE MaRap = @MaRap AND TenPhong = @TenPhong AND MaPhong <> @MaPhong;";
            string sqlUpdate = @"
                UPDATE dbo.PhongChieu
                SET MaRap = @MaRap,
                    TenPhong = @TenPhong,
                    DinhDang = @DinhDang,
                    TrangThai = @TrangThai
                WHERE MaPhong = @MaPhong;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                ketNoi.Open();

                using (SqlCommand lenhCheck = new SqlCommand(sqlKiemTra, ketNoi))
                {
                    lenhCheck.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    lenhCheck.Parameters.Add("@TenPhong", SqlDbType.NVarChar, 100).Value = tenPhong.Trim();
                    lenhCheck.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;

                    int tonTai = Convert.ToInt32(lenhCheck.ExecuteScalar());
                    if (tonTai > 0)
                    {
                        return (false, $"Tên phòng '{tenPhong.Trim()}' đã tồn tại trong cụm rạp đã chọn.");
                    }
                }

                using (SqlCommand lenhUpdate = new SqlCommand(sqlUpdate, ketNoi))
                {
                    lenhUpdate.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;
                    lenhUpdate.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    lenhUpdate.Parameters.Add("@TenPhong", SqlDbType.NVarChar, 100).Value = tenPhong.Trim();
                    lenhUpdate.Parameters.Add("@DinhDang", SqlDbType.NVarChar, 50).Value = dinhDang.Trim();
                    lenhUpdate.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThai.Trim();

                    int soDong = lenhUpdate.ExecuteNonQuery();
                    if (soDong > 0)
                    {
                        return (true, "Cập nhật thông tin phòng chiếu thành công!");
                    }
                    else
                    {
                        return (false, "Không tìm thấy phòng chiếu để cập nhật.");
                    }
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi cập nhật phòng chiếu:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Chuyển đổi trạng thái hoạt động của phòng chiếu (không xóa vật lý).
        /// </summary>
        public static (bool thanhCong, string thongBao) DoiTrangThaiPhong(int maPhong, string trangThaiMoi)
        {
            if (maPhong <= 0)
            {
                return (false, "Mã phòng không hợp lệ.");
            }

            string sql = @"
                UPDATE dbo.PhongChieu
                SET TrangThai = @TrangThai
                WHERE MaPhong = @MaPhong;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);
                lenh.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThaiMoi.Trim();

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();
                if (soDong > 0)
                {
                    return (true, $"Đã cập nhật trạng thái phòng chiếu sang '{trangThaiMoi.Trim()}' thành công!");
                }
                else
                {
                    return (false, "Không tìm thấy phòng chiếu để cập nhật trạng thái.");
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi đổi trạng thái phòng chiếu:\n" + ex.Message);
            }
        }
    }
}
