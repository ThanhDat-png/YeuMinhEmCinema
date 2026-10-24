using Microsoft.AspNetCore.Identity;
using Microsoft.Data.SqlClient;
using System.Data;

namespace YeuMinhEmCinema.Admin
{
    // Thông tin giữ lại sau khi đăng nhập.
    // Không lưu mật khẩu hoặc chuỗi băm trong kết quả này.
    internal sealed class KetQuaDangNhap
    {
        public int MaTaiKhoan { get; init; }

        public string TenDangNhap { get; init; } = "";

        public IReadOnlyCollection<string> DanhSachQuyen { get; init; }
            = Array.Empty<string>();
    }

    internal static class TaiKhoanDAL
    {
        // Kiểm tra đã có Admin hay chưa.
        public static bool DaCoAdmin()
        {
            const string sql = """
                SELECT CASE WHEN EXISTS
                (
                    SELECT 1
                    FROM dbo.TaiKhoanVaiTro tv
                    INNER JOIN dbo.VaiTro v
                        ON v.MaVaiTro = tv.MaVaiTro
                    WHERE v.TenVaiTro = 'ADMIN'
                )
                THEN 1 ELSE 0 END;
                """;

            using var ketNoi =
                new SqlConnection(CauHinh.ChuoiKetNoi);

            using var lenh = new SqlCommand(sql, ketNoi);

            ketNoi.Open();

            return Convert.ToInt32(lenh.ExecuteScalar()) == 1;
        }

        // SQL chỉ cho tạo Admin đầu tiên một lần.
        public static int KhoiTaoAdmin(
            string tenDangNhap,
            string matKhau)
        {
            tenDangNhap = tenDangNhap.Trim();

            if (tenDangNhap.Length < 3 ||
                tenDangNhap.Length > 50)
            {
                throw new ArgumentException(
                    "Tên đăng nhập phải có từ 3 đến 50 ký tự.");
            }

            string matKhauHash =
                BaoMatMatKhau.TaoHash(matKhau);

            using var ketNoi =
                new SqlConnection(CauHinh.ChuoiKetNoi);

            using var lenh = new SqlCommand(
                "dbo.sp_YMC_KhoiTaoAdmin",
                ketNoi);

            lenh.CommandType = CommandType.StoredProcedure;

            lenh.Parameters.Add(
                "@TenDangNhap",
                SqlDbType.VarChar,
                50).Value = tenDangNhap;

            lenh.Parameters.Add(
                "@MatKhauHash",
                SqlDbType.VarChar,
                1000).Value = matKhauHash;

            ketNoi.Open();

            return Convert.ToInt32(lenh.ExecuteScalar());
        }

        // Trả về null nếu sai thông tin hoặc không được vào Admin.
        // Lỗi SQL/kết nối được chuyển lên form để xử lý.
        public static KetQuaDangNhap? DangNhap(
            string tenDangNhap,
            string matKhau)
        {
            tenDangNhap = tenDangNhap.Trim();

            if (tenDangNhap.Length == 0 ||
                tenDangNhap.Length > 50 ||
                string.IsNullOrEmpty(matKhau))
            {
                return null;
            }

            using var ketNoi =
                new SqlConnection(CauHinh.ChuoiKetNoi);

            ketNoi.Open();

            int maTaiKhoan;
            string tenTrongDatabase;
            string matKhauHash;
            byte[] phienBan;

            // 1. Lấy thông tin phục vụ xác thực.
            using (var lenh = new SqlCommand(
                "dbo.sp_YMC_LayThongTinDangNhap",
                ketNoi))
            {
                lenh.CommandType = CommandType.StoredProcedure;

                lenh.Parameters.Add(
                    "@TenDangNhap",
                    SqlDbType.VarChar,
                    50).Value = tenDangNhap;

                using var boDoc = lenh.ExecuteReader();

                if (!boDoc.Read())
                {
                    return null;
                }

                if (!(bool)boDoc["DangHoatDong"])
                {
                    return null;
                }

                maTaiKhoan = (int)boDoc["MaTaiKhoan"];

                tenTrongDatabase =
                    (string)boDoc["TenDangNhap"];

                matKhauHash =
                    (string)boDoc["MatKhauHash"];

                phienBan = (byte[])boDoc["PhienBan"];
            }

            // 2. Kiểm tra mật khẩu bằng PasswordHasher.
            var ketQua = BaoMatMatKhau.KiemTra(
                matKhauHash,
                matKhau);

            bool dungMatKhau =
                ketQua == PasswordVerificationResult.Success ||
                ketQua == PasswordVerificationResult.SuccessRehashNeeded;

            // 3. SQL kiểm tra khóa tài khoản và phiên bản dữ liệu.
            // Sai 5 lần sẽ khóa tạm theo quy tắc đã viết trong SQL.
            using (var lenh = new SqlCommand(
                "dbo.sp_YMC_GhiNhanDangNhap",
                ketNoi))
            {
                lenh.CommandType = CommandType.StoredProcedure;

                lenh.Parameters.Add(
                    "@MaTaiKhoan",
                    SqlDbType.Int).Value = maTaiKhoan;

                lenh.Parameters.Add(
                    "@ThanhCong",
                    SqlDbType.Bit).Value = dungMatKhau;

                lenh.Parameters.Add(
                    "@PhienBan",
                    SqlDbType.Binary,
                    8).Value = phienBan;

                lenh.ExecuteNonQuery();
            }

            if (!dungMatKhau)
            {
                return null;
            }

            // 4. Chỉ cho Admin hoặc nhân viên đang làm việc
            // có vai trò phù hợp vào ứng dụng quản trị.
            const string sqlKiemTraVaiTro = """
                SELECT CASE WHEN EXISTS
                (
                    SELECT 1
                    FROM dbo.TaiKhoanVaiTro tv
                    INNER JOIN dbo.VaiTro v
                        ON v.MaVaiTro = tv.MaVaiTro
                    WHERE tv.MaTaiKhoan = @MaTaiKhoan
                      AND v.DangHoatDong = 1
                      AND
                      (
                          v.TenVaiTro = 'ADMIN'
                          OR
                          (
                              v.TenVaiTro IN
                                  ('QUAN_LY', 'BAN_VE', 'SOAT_VE')
                              AND EXISTS
                              (
                                  SELECT 1
                                  FROM dbo.NhanVien nv
                                  WHERE nv.MaTaiKhoan = tv.MaTaiKhoan
                                    AND nv.DangLamViec = 1
                              )
                          )
                      )
                )
                THEN 1 ELSE 0 END;
                """;

            using (var lenh = new SqlCommand(
                sqlKiemTraVaiTro,
                ketNoi))
            {
                lenh.Parameters.Add(
                    "@MaTaiKhoan",
                    SqlDbType.Int).Value = maTaiKhoan;

                if (Convert.ToInt32(lenh.ExecuteScalar()) != 1)
                {
                    return null;
                }
            }

            // 5. Lấy các quyền đang có hiệu lực.
            var danhSachQuyen = new List<string>();

            using (var lenh = new SqlCommand(
                "dbo.sp_YMC_LayQuyenTaiKhoan",
                ketNoi))
            {
                lenh.CommandType = CommandType.StoredProcedure;

                lenh.Parameters.Add(
                    "@MaTaiKhoan",
                    SqlDbType.Int).Value = maTaiKhoan;

                using var boDoc = lenh.ExecuteReader();

                while (boDoc.Read())
                {
                    danhSachQuyen.Add(
                        (string)boDoc["MaQuyen"]);
                }
            }

            if (danhSachQuyen.Count == 0)
            {
                return null;
            }

            return new KetQuaDangNhap
            {
                MaTaiKhoan = maTaiKhoan,
                TenDangNhap = tenTrongDatabase,
                DanhSachQuyen = danhSachQuyen.AsReadOnly()
            };
        }
    }
}