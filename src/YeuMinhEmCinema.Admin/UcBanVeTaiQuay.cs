using System.Text;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcBanVeTaiQuay : UserControl
    {
        private readonly List<string> _danhSachGheChon = new();
        private const int GIA_VE_THUONG = 90000;

        public UcBanVeTaiQuay()
        {
            InitializeComponent();
            cboChonPhim.SelectedIndex = 0;
            cboSuatChieu.SelectedIndex = 0;
            KhoiTaoSoDoGhe();
            CapNhatHoaDon();
        }

        private void KhoiTaoSoDoGhe()
        {
            flpGheNgoi.SuspendLayout();
            flpGheNgoi.Controls.Clear();
            _danhSachGheChon.Clear();

            char[] hangGhe = { 'A', 'B', 'C', 'D' };
            int soGheMoiHang = 8;

            foreach (char hang in hangGhe)
            {
                for (int i = 1; i <= soGheMoiHang; i++)
                {
                    string maGhe = $"{hang}{i}";
                    Button btn = new Button
                    {
                        Text = maGhe,
                        Width = 55,
                        Height = 35,
                        Margin = new Padding(3),
                        FlatStyle = FlatStyle.Flat,
                        Font = new Font("Segoe UI", 9F, FontStyle.Bold),
                        ForeColor = Color.FromArgb(71, 85, 105),
                        BackColor = Color.FromArgb(241, 245, 249)
                    };
                    btn.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);

                    // Giả lập ghế đã bán
                    if (maGhe == "B3" || maGhe == "B4")
                    {
                        btn.BackColor = Color.FromArgb(148, 163, 184);
                        btn.ForeColor = Color.White;
                        btn.Enabled = false;
                    }
                    else
                    {
                        btn.Click += (s, e) =>
                        {
                            if (_danhSachGheChon.Contains(maGhe))
                            {
                                _danhSachGheChon.Remove(maGhe);
                                btn.BackColor = Color.FromArgb(241, 245, 249);
                                btn.ForeColor = Color.FromArgb(71, 85, 105);
                            }
                            else
                            {
                                _danhSachGheChon.Add(maGhe);
                                btn.BackColor = Color.FromArgb(211, 47, 47); // Màu đỏ chọn
                                btn.ForeColor = Color.White;
                            }
                            CapNhatHoaDon();
                        };
                    }

                    flpGheNgoi.Controls.Add(btn);
                }
            }

            flpGheNgoi.ResumeLayout(true);
        }

        private void CapNhatHoaDon()
        {
            string tenPhim = cboChonPhim.SelectedItem?.ToString() ?? "";
            string suat = cboSuatChieu.SelectedItem?.ToString() ?? "";

            int tienVe = _danhSachGheChon.Count * GIA_VE_THUONG;
            int tienFnb = 0;

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("YEUMINHEM CINEMA - QUẦY VÉ");
            sb.AppendLine("───────────────────────────────");
            sb.AppendLine($"• Phim: {tenPhim}");
            sb.AppendLine($"• Suất: {suat}");
            sb.AppendLine($"• Ghế đã chọn ({_danhSachGheChon.Count}):");

            if (_danhSachGheChon.Count > 0)
            {
                sb.AppendLine($"  {string.Join(", ", _danhSachGheChon)}");
                sb.AppendLine($"  => Tiền vé: {tienVe:N0} đ");
            }
            else
            {
                sb.AppendLine("  (Chưa chọn ghế nào)");
            }

            sb.AppendLine();
            sb.AppendLine("• F&B kèm theo:");

            if (chkComboSolo.Checked)
            {
                tienFnb += 79000;
                sb.AppendLine("  + 1x Combo Solo (79.000 đ)");
            }
            if (chkComboCouple.Checked)
            {
                tienFnb += 109000;
                sb.AppendLine("  + 1x Combo Couple (109.000 đ)");
            }
            if (chkNuoc.Checked)
            {
                tienFnb += 35000;
                sb.AppendLine("  + 1x Coca Lớn (35.000 đ)");
            }
            if (!chkComboSolo.Checked && !chkComboCouple.Checked && !chkNuoc.Checked)
            {
                sb.AppendLine("  (Không có)");
            }

            int tongCong = tienVe + tienFnb;
            lblTongTienSo.Text = $"{tongCong:N0} đ";

            sb.AppendLine("───────────────────────────────");
            sb.AppendLine($"TỔNG TIỀN: {tongCong:N0} đ");
            sb.AppendLine("(Dữ liệu minh họa — chưa kết nối CSDL)");

            txtTomTatHoaDon.Text = sb.ToString();
        }

        private void cboChonPhim_SelectedIndexChanged(object sender, EventArgs e)
        {
            CapNhatHoaDon();
        }

        private void cboSuatChieu_SelectedIndexChanged(object sender, EventArgs e)
        {
            KhoiTaoSoDoGhe();
            CapNhatHoaDon();
        }

        private void CapNhatGia_CheckedChanged(object? sender, EventArgs e)
        {
            CapNhatHoaDon();
        }

        private void btnLamMoi_Click(object sender, EventArgs e)
        {
            chkComboSolo.Checked = false;
            chkComboCouple.Checked = false;
            chkNuoc.Checked = false;
            KhoiTaoSoDoGhe();
            CapNhatHoaDon();
        }

        private void btnThanhToan_Click(object sender, EventArgs e)
        {
            MessageBox.Show(
                "Chức năng bán vé và thanh toán tại quầy đang được phát triển.\n" +
                "(Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu và cổng thanh toán).",
                "Thông báo",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
    }
}
