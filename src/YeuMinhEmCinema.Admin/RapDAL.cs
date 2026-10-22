using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin
{
    /// <summary>
    /// Lớp truy xuất dữ liệu (Data Access Layer - DAL) cho bảng dbo.Rap.
    /// Tách biệt hoàn toàn các câu lệnh SQL liên quan đến Cụm rạp.
    /// </summary>
    public static class RapDAL
    {
        /// <summary>
        /// Lấy danh sách cụm rạp, có hỗ trợ tìm kiếm theo tên và lọc theo trạng thái.
        /// Đồng thời đếm số lượng phòng chiếu và tổng sức chứa của từng rạp.
        /// </summary>
        public static DataTable LayDanhSachRap(string? tuKhoa = null, string? trangThai = null)
        {
            DataTable bangRap = new DataTable();

            string sql = @"
                SELECT 
                    r.MaRap,
                    r.TenRap,
                    r.DiaChi,
                    r.TrangThai,
                    COUNT(DISTINCT p.MaPhong) AS SoLuongPhong,
                    ISNULL(COUNT(g.MaGhe), 0) AS TongSucChua
                FROM dbo.Rap r
                LEFT JOIN dbo.PhongChieu p ON r.MaRap = p.MaRap
                LEFT JOIN dbo.Ghe g ON p.MaPhong = g.MaPhong
                WHERE 1 = 1";

            if (!string.IsNullOrWhiteSpace(tuKhoa))
            {
                sql += " AND (r.TenRap LIKE @TuKhoa OR r.DiaChi LIKE @TuKhoa)";
            }

            if (!string.IsNullOrWhiteSpace(trangThai) && trangThai != "Tất cả")
            {
                sql += " AND r.TrangThai = @TrangThai";
            }

            sql += @"
                GROUP BY r.MaRap, r.TenRap, r.DiaChi, r.TrangThai
                ORDER BY r.MaRap ASC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);

            if (!string.IsNullOrWhiteSpace(tuKhoa))
            {
                lenh.Parameters.Add("@TuKhoa", SqlDbType.NVarChar, 200).Value = "%" + tuKhoa.Trim() + "%";
            }

            if (!string.IsNullOrWhiteSpace(trangThai) && trangThai != "Tất cả")
            {
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThai.Trim();
            }

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangRap);

            return bangRap;
        }

        /// <summary>
        /// Lấy thông tin chi tiết một cụm rạp theo mã rạp.
        /// </summary>
        public static DataRow? LayRapTheoMa(int maRap)
        {
            if (maRap <= 0) return null;

            string sql = @"
                SELECT MaRap, TenRap, DiaChi, TrangThai
                FROM dbo.Rap
                WHERE MaRap = @MaRap;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            DataTable bang = new DataTable();
            boDoc.Fill(bang);

            return bang.Rows.Count > 0 ? bang.Rows[0] : null;
        }

        /// <summary>
        /// Thêm cụm rạp mới vào hệ thống.
        /// </summary>
        public static (bool thanhCong, string thongBao, int maRapMoi) ThemRap(
            string tenRap,
            string? diaChi,
            string trangThai)
        {
            if (string.IsNullOrWhiteSpace(tenRap))
            {
                return (false, "Tên rạp không được để trống.", 0);
            }
            if (tenRap.Trim().Length > 200)
            {
                return (false, "Tên rạp không được vượt quá 200 ký tự.", 0);
            }
            if (!string.IsNullOrWhiteSpace(diaChi) && diaChi.Trim().Length > 500)
            {
                return (false, "Địa chỉ rạp không được vượt quá 500 ký tự.", 0);
            }
            if (string.IsNullOrWhiteSpace(trangThai))
            {
                trangThai = "Đang hoạt động";
            }

            // Kiểm tra trùng tên rạp
            string sqlKiemTra = "SELECT COUNT(1) FROM dbo.Rap WHERE TenRap = @TenRap;";
            string sqlInsert = @"
                INSERT INTO dbo.Rap (TenRap, DiaChi, TrangThai)
                VALUES (@TenRap, @DiaChi, @TrangThai);
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                ketNoi.Open();

                using (SqlCommand lenhCheck = new SqlCommand(sqlKiemTra, ketNoi))
                {
                    lenhCheck.Parameters.Add("@TenRap", SqlDbType.NVarChar, 200).Value = tenRap.Trim();
                    int tonTai = Convert.ToInt32(lenhCheck.ExecuteScalar());
                    if (tonTai > 0)
                    {
                        return (false, $"Tên cụm rạp '{tenRap.Trim()}' đã tồn tại trong hệ thống.", 0);
                    }
                }

                using (SqlCommand lenhInsert = new SqlCommand(sqlInsert, ketNoi))
                {
                    lenhInsert.Parameters.Add("@TenRap", SqlDbType.NVarChar, 200).Value = tenRap.Trim();
                    lenhInsert.Parameters.Add("@DiaChi", SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrWhiteSpace(diaChi) ? DBNull.Value : diaChi.Trim();
                    lenhInsert.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThai.Trim();

                    int maMoi = Convert.ToInt32(lenhInsert.ExecuteScalar());
                    return (true, "Thêm cụm rạp mới thành công!", maMoi);
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi thêm rạp:\n" + ex.Message, 0);
            }
        }

        /// <summary>
        /// Cập nhật thông tin cụm rạp hiện có.
        /// </summary>
        public static (bool thanhCong, string thongBao) CapNhatRap(
            int maRap,
            string tenRap,
            string? diaChi,
            string trangThai)
        {
            if (maRap <= 0)
            {
                return (false, "Mã rạp không hợp lệ.");
            }
            if (string.IsNullOrWhiteSpace(tenRap))
            {
                return (false, "Tên rạp không được để trống.");
            }
            if (tenRap.Trim().Length > 200)
            {
                return (false, "Tên rạp không được vượt quá 200 ký tự.");
            }
            if (!string.IsNullOrWhiteSpace(diaChi) && diaChi.Trim().Length > 500)
            {
                return (false, "Địa chỉ rạp không được vượt quá 500 ký tự.");
            }

            string sqlKiemTra = "SELECT COUNT(1) FROM dbo.Rap WHERE TenRap = @TenRap AND MaRap <> @MaRap;";
            string sqlUpdate = @"
                UPDATE dbo.Rap
                SET TenRap = @TenRap,
                    DiaChi = @DiaChi,
                    TrangThai = @TrangThai
                WHERE MaRap = @MaRap;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                ketNoi.Open();

                using (SqlCommand lenhCheck = new SqlCommand(sqlKiemTra, ketNoi))
                {
                    lenhCheck.Parameters.Add("@TenRap", SqlDbType.NVarChar, 200).Value = tenRap.Trim();
                    lenhCheck.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    int tonTai = Convert.ToInt32(lenhCheck.ExecuteScalar());
                    if (tonTai > 0)
                    {
                        return (false, $"Tên cụm rạp '{tenRap.Trim()}' đã được dùng cho rạp khác.");
                    }
                }

                using (SqlCommand lenhUpdate = new SqlCommand(sqlUpdate, ketNoi))
                {
                    lenhUpdate.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                    lenhUpdate.Parameters.Add("@TenRap", SqlDbType.NVarChar, 200).Value = tenRap.Trim();
                    lenhUpdate.Parameters.Add("@DiaChi", SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrWhiteSpace(diaChi) ? DBNull.Value : diaChi.Trim();
                    lenhUpdate.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThai.Trim();

                    int soDong = lenhUpdate.ExecuteNonQuery();
                    if (soDong > 0)
                    {
                        return (true, "Cập nhật thông tin cụm rạp thành công!");
                    }
                    else
                    {
                        return (false, "Không tìm thấy cụm rạp để cập nhật.");
                    }
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi cập nhật rạp:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Thay đổi trạng thái hoạt động của rạp (chuyển đổi trạng thái, không xóa vật lý).
        /// </summary>
        public static (bool thanhCong, string thongBao) DoiTrangThaiRap(int maRap, string trangThaiMoi)
        {
            if (maRap <= 0)
            {
                return (false, "Mã rạp không hợp lệ.");
            }

            string sql = @"
                UPDATE dbo.Rap
                SET TrangThai = @TrangThai
                WHERE MaRap = @MaRap;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);
                lenh.Parameters.Add("@MaRap", SqlDbType.Int).Value = maRap;
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThaiMoi.Trim();

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();
                if (soDong > 0)
                {
                    return (true, $"Đã cập nhật trạng thái rạp sang '{trangThaiMoi.Trim()}' thành công!");
                }
                else
                {
                    return (false, "Không tìm thấy cụm rạp để cập nhật trạng thái.");
                }
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi đổi trạng thái rạp:\n" + ex.Message);
            }
        }
    }
}
