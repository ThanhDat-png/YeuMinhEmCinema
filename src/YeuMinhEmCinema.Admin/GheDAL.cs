using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin
{
    /// <summary>
    /// Lớp truy xuất dữ liệu (Data Access Layer - DAL) cho bảng dbo.Ghe và dbo.LoaiGhe.
    /// Hỗ trợ tạo sơ đồ ghế theo lô với SqlTransaction, đổi loại ghế và đổi trạng thái ghế.
    /// </summary>
    public static class GheDAL
    {
        /// <summary>
        /// Lấy danh sách các loại ghế cấu hình trong hệ thống (Ghế thường, Ghế VIP, Ghế Sweetbox...).
        /// </summary>
        public static DataTable LayDanhSachLoaiGhe()
        {
            DataTable bangLoai = new DataTable();

            string sql = "SELECT MaLoai, TenLoai FROM dbo.LoaiGhe ORDER BY MaLoai ASC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangLoai);

            return bangLoai;
        }

        /// <summary>
        /// Lấy toàn bộ danh sách ghế của một phòng chiếu, sắp xếp theo hàng ghế và số ghế.
        /// </summary>
        public static DataTable LayDanhSachGheTheoPhong(int maPhong)
        {
            DataTable bangGhe = new DataTable();

            string sql = @"
                SELECT 
                    g.MaGhe,
                    g.MaPhong,
                    g.HangGhe,
                    g.SoGhe,
                    g.MaLoaiGhe,
                    lg.TenLoai AS TenLoaiGhe,
                    g.TrangThai
                FROM dbo.Ghe g
                INNER JOIN dbo.LoaiGhe lg ON g.MaLoaiGhe = lg.MaLoai
                WHERE g.MaPhong = @MaPhong
                ORDER BY LEN(g.HangGhe) ASC, g.HangGhe ASC, g.SoGhe ASC;";

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            using SqlCommand lenh = new SqlCommand(sql, ketNoi);
            lenh.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;

            using SqlDataAdapter boDoc = new SqlDataAdapter(lenh);
            boDoc.Fill(bangGhe);

            return bangGhe;
        }

        /// <summary>
        /// Đếm tổng số ghế hiện có của một phòng chiếu.
        /// </summary>
        public static int DemSoGheCuaPhong(int maPhong)
        {
            if (maPhong <= 0) return 0;

            string sql = "SELECT COUNT(*) FROM dbo.Ghe WHERE MaPhong = @MaPhong;";

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
        /// Tạo sơ đồ ghế theo số hàng và số ghế mỗi hàng sử dụng SqlTransaction.
        /// NGUYÊN TẮC: KHÔNG tự xóa hoặc ghi đè các ghế đã có sẵn trong phòng.
        /// Chỉ thêm các ghế mới chưa tồn tại, đảm bảo an toàn tuyệt đối cho dữ liệu.
        /// </summary>
        public static (bool thanhCong, string thongBao, int soGheDaTao, int soGheBoQua) TaoSoDoGhe(
            int maPhong,
            int soHang,
            int soGheMoiHang,
            int maLoaiGheMacDinh)
        {
            if (maPhong <= 0)
            {
                return (false, "Phòng chiếu không hợp lệ.", 0, 0);
            }
            if (soHang < 1 || soHang > 26)
            {
                return (false, "Số hàng ghế phải từ 1 đến 26 (tương ứng hàng A đến Z).", 0, 0);
            }
            if (soGheMoiHang < 1 || soGheMoiHang > 50)
            {
                return (false, "Số ghế mỗi hàng phải từ 1 đến 50 ghế.", 0, 0);
            }
            if (maLoaiGheMacDinh <= 0)
            {
                return (false, "Vui lòng chọn loại ghế mặc định hợp lệ.", 0, 0);
            }

            int soGheDaTao = 0;
            int soGheBoQua = 0;

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            ketNoi.Open();

            // Sử dụng SqlTransaction để đảm bảo tính toàn vẹn khi tạo hàng loạt ghế
            using SqlTransaction giaoDich = ketNoi.BeginTransaction();

            try
            {
                // 1. Tải danh sách vị trí ghế đã có trong phòng chiếu này để kiểm tra tránh trùng
                HashSet<string> danhSachGheHienCo = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                string sqlLayGheCu = "SELECT HangGhe, SoGhe FROM dbo.Ghe WHERE MaPhong = @MaPhong;";

                using (SqlCommand lenhLayGheCu = new SqlCommand(sqlLayGheCu, ketNoi, giaoDich))
                {
                    lenhLayGheCu.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;
                    using SqlDataReader reader = lenhLayGheCu.ExecuteReader();
                    while (reader.Read())
                    {
                        string hang = reader.GetString(0).Trim().ToUpper();
                        int so = reader.GetInt32(1);
                        danhSachGheHienCo.Add($"{hang}_{so}");
                    }
                }

                // 2. Chuẩn bị câu lệnh chèn ghế mới
                string sqlInsert = @"
                    INSERT INTO dbo.Ghe (MaPhong, HangGhe, SoGhe, MaLoaiGhe, TrangThai)
                    VALUES (@MaPhong, @HangGhe, @SoGhe, @MaLoaiGhe, N'Hoạt động');";

                using SqlCommand lenhInsert = new SqlCommand(sqlInsert, ketNoi, giaoDich);
                lenhInsert.Parameters.Add("@MaPhong", SqlDbType.Int).Value = maPhong;
                SqlParameter prmHang = lenhInsert.Parameters.Add("@HangGhe", SqlDbType.VarChar, 5);
                SqlParameter prmSo = lenhInsert.Parameters.Add("@SoGhe", SqlDbType.Int);
                lenhInsert.Parameters.Add("@MaLoaiGhe", SqlDbType.Int).Value = maLoaiGheMacDinh;

                // 3. Vòng lặp duyệt qua từng hàng và từng ghế
                for (int h = 1; h <= soHang; h++)
                {
                    string tenHang = ((char)('A' + h - 1)).ToString();

                    for (int s = 1; s <= soGheMoiHang; s++)
                    {
                        string maViTri = $"{tenHang}_{s}";

                        // Nếu ghế này đã tồn tại trong phòng, TUYỆT ĐỐI KHÔNG ghi đè, ghi nhận bỏ qua
                        if (danhSachGheHienCo.Contains(maViTri))
                        {
                            soGheBoQua++;
                            continue;
                        }

                        prmHang.Value = tenHang;
                        prmSo.Value = s;
                        lenhInsert.ExecuteNonQuery();

                        danhSachGheHienCo.Add(maViTri);
                        soGheDaTao++;
                    }
                }

                // Hoàn tất giao dịch nếu không có lỗi phát sinh
                giaoDich.Commit();

                string thongDiep = $"Tạo sơ đồ ghế thành công!\n• Đã thêm mới: {soGheDaTao} ghế.\n• Giữ nguyên (bỏ qua): {soGheBoQua} ghế đã tồn tại.";
                return (true, thongDiep, soGheDaTao, soGheBoQua);
            }
            catch (Exception ex)
            {
                // Rollback an toàn toàn bộ thao tác nếu xảy ra lỗi
                try
                {
                    giaoDich.Rollback();
                }
                catch
                {
                    // Bỏ qua lỗi rollback nếu kết nối bị đứt
                }

                return (false, "Lỗi khi tạo sơ đồ ghế (đã rollback dữ liệu):\n" + ex.Message, 0, 0);
            }
        }

        /// <summary>
        /// Cập nhật loại ghế (Ghế thường, VIP, Sweetbox...) cho một ghế cụ thể.
        /// </summary>
        public static (bool thanhCong, string thongBao) CapNhatLoaiGhe(int maGhe, int maLoaiGheMoi)
        {
            if (maGhe <= 0 || maLoaiGheMoi <= 0)
            {
                return (false, "Thông tin ghế hoặc loại ghế không hợp lệ.");
            }

            string sql = @"
                UPDATE dbo.Ghe
                SET MaLoaiGhe = @MaLoaiGhe
                WHERE MaGhe = @MaGhe;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);
                lenh.Parameters.Add("@MaGhe", SqlDbType.Int).Value = maGhe;
                lenh.Parameters.Add("@MaLoaiGhe", SqlDbType.Int).Value = maLoaiGheMoi;

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();
                return soDong > 0
                    ? (true, "Đã cập nhật loại ghế thành công!")
                    : (false, "Không tìm thấy ghế cần cập nhật.");
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi đổi loại ghế:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Đổi trạng thái ghế (ví dụ: 'Hoạt động' <-> 'Hỏng/Ngừng sử dụng').
        /// Không xóa vật lý ghế khỏi phòng chiếu.
        /// </summary>
        public static (bool thanhCong, string thongBao) DoiTrangThaiGhe(int maGhe, string trangThaiMoi)
        {
            if (maGhe <= 0)
            {
                return (false, "Mã ghế không hợp lệ.");
            }
            if (string.IsNullOrWhiteSpace(trangThaiMoi))
            {
                return (false, "Trạng thái ghế không được để trống.");
            }

            string sql = @"
                UPDATE dbo.Ghe
                SET TrangThai = @TrangThai
                WHERE MaGhe = @MaGhe;";

            try
            {
                using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
                using SqlCommand lenh = new SqlCommand(sql, ketNoi);
                lenh.Parameters.Add("@MaGhe", SqlDbType.Int).Value = maGhe;
                lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThaiMoi.Trim();

                ketNoi.Open();
                int soDong = lenh.ExecuteNonQuery();
                return soDong > 0
                    ? (true, $"Đã cập nhật trạng thái ghế sang '{trangThaiMoi.Trim()}' thành công!")
                    : (false, "Không tìm thấy ghế cần cập nhật.");
            }
            catch (Exception ex)
            {
                return (false, "Lỗi cơ sở dữ liệu khi đổi trạng thái ghế:\n" + ex.Message);
            }
        }

        /// <summary>
        /// Cập nhật loại ghế hoặc trạng thái cho nhiều ghế được chọn cùng lúc trong một SqlTransaction.
        /// </summary>
        public static (bool thanhCong, string thongBao) CapNhatNhieuGhe(
            List<int> danhSachMaGhe,
            int? maLoaiGheMoi,
            string? trangThaiMoi)
        {
            if (danhSachMaGhe == null || danhSachMaGhe.Count == 0)
            {
                return (false, "Chưa có ghế nào được chọn để cập nhật.");
            }

            if (!maLoaiGheMoi.HasValue && string.IsNullOrWhiteSpace(trangThaiMoi))
            {
                return (false, "Không có thông tin thay đổi nào được yêu cầu.");
            }

            using SqlConnection ketNoi = new SqlConnection(CauHinh.ChuoiKetNoi);
            ketNoi.Open();
            using SqlTransaction giaoDich = ketNoi.BeginTransaction();

            try
            {
                string sql = "UPDATE dbo.Ghe SET ";
                List<string> setClauses = new List<string>();

                if (maLoaiGheMoi.HasValue)
                {
                    setClauses.Add("MaLoaiGhe = @MaLoaiGhe");
                }
                if (!string.IsNullOrWhiteSpace(trangThaiMoi))
                {
                    setClauses.Add("TrangThai = @TrangThai");
                }

                sql += string.Join(", ", setClauses) + " WHERE MaGhe = @MaGhe;";

                using SqlCommand lenh = new SqlCommand(sql, ketNoi, giaoDich);
                SqlParameter prmMaGhe = lenh.Parameters.Add("@MaGhe", SqlDbType.Int);

                if (maLoaiGheMoi.HasValue)
                {
                    lenh.Parameters.Add("@MaLoaiGhe", SqlDbType.Int).Value = maLoaiGheMoi.Value;
                }
                if (!string.IsNullOrWhiteSpace(trangThaiMoi))
                {
                    lenh.Parameters.Add("@TrangThai", SqlDbType.NVarChar, 50).Value = trangThaiMoi.Trim();
                }

                int tongCapNhat = 0;
                foreach (int maGhe in danhSachMaGhe)
                {
                    prmMaGhe.Value = maGhe;
                    tongCapNhat += lenh.ExecuteNonQuery();
                }

                giaoDich.Commit();
                return (true, $"Đã cập nhật thành công {tongCapNhat} ghế.");
            }
            catch (Exception ex)
            {
                try { giaoDich.Rollback(); } catch { }
                return (false, "Lỗi khi cập nhật danh sách ghế:\n" + ex.Message);
            }
        }
    }
}
