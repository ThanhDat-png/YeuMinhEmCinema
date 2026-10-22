namespace YeuMinhEmCinema.Admin
{
    partial class UcKiemTraVe
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        private void InitializeComponent()
        {
            pnlBanner = new Panel();
            lblCanhBao = new Label();
            lblTieuDe = new Label();
            pnlInput = new Panel();
            btnQuetCamera = new Button();
            btnKiemTra = new Button();
            txtMaVe = new TextBox();
            lblMaVe = new Label();
            pnlKetQua = new Panel();
            btnXacNhanVaoRap = new Button();
            lblChiTietVe = new Label();
            lblTrangThaiVe = new Label();
            lblKetQuaTieuDe = new Label();
            pnlBanner.SuspendLayout();
            pnlInput.SuspendLayout();
            pnlKetQua.SuspendLayout();
            SuspendLayout();
            // 
            // pnlBanner
            // 
            pnlBanner.BackColor = Color.FromArgb(254, 242, 242);
            pnlBanner.BorderStyle = BorderStyle.FixedSingle;
            pnlBanner.Controls.Add(lblCanhBao);
            pnlBanner.Controls.Add(lblTieuDe);
            pnlBanner.Dock = DockStyle.Top;
            pnlBanner.Location = new Point(15, 15);
            pnlBanner.Name = "pnlBanner";
            pnlBanner.Size = new Size(950, 48);
            pnlBanner.TabIndex = 0;
            // 
            // lblCanhBao
            // 
            lblCanhBao.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            lblCanhBao.AutoSize = true;
            lblCanhBao.BackColor = Color.FromArgb(239, 68, 68);
            lblCanhBao.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblCanhBao.ForeColor = Color.White;
            lblCanhBao.Location = new Point(620, 15);
            lblCanhBao.Padding = new Padding(6, 2, 6, 2);
            lblCanhBao.Name = "lblCanhBao";
            lblCanhBao.Size = new Size(310, 19);
            lblCanhBao.TabIndex = 1;
            lblCanhBao.Text = "⚠️ Dữ liệu minh họa — chưa kết nối cơ sở dữ liệu";
            // 
            // lblTieuDe
            // 
            lblTieuDe.AutoSize = true;
            lblTieuDe.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTieuDe.ForeColor = Color.FromArgb(153, 27, 27);
            lblTieuDe.Location = new Point(12, 13);
            lblTieuDe.Name = "lblTieuDe";
            lblTieuDe.Size = new Size(295, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "🔍 KIỂM TRA VÉ VÀ SOÁT VÉ VÀO PHÒNG";
            // 
            // pnlInput
            // 
            pnlInput.BackColor = Color.White;
            pnlInput.BorderStyle = BorderStyle.FixedSingle;
            pnlInput.Controls.Add(btnQuetCamera);
            pnlInput.Controls.Add(btnKiemTra);
            pnlInput.Controls.Add(txtMaVe);
            pnlInput.Controls.Add(lblMaVe);
            pnlInput.Dock = DockStyle.Top;
            pnlInput.Location = new Point(15, 63);
            pnlInput.Name = "pnlInput";
            pnlInput.Padding = new Padding(15);
            pnlInput.Size = new Size(950, 75);
            pnlInput.TabIndex = 1;
            // 
            // btnQuetCamera
            // 
            btnQuetCamera.BackColor = Color.FromArgb(71, 85, 105);
            btnQuetCamera.FlatAppearance.BorderSize = 0;
            btnQuetCamera.FlatStyle = FlatStyle.Flat;
            btnQuetCamera.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnQuetCamera.ForeColor = Color.White;
            btnQuetCamera.Location = new Point(620, 26);
            btnQuetCamera.Name = "btnQuetCamera";
            btnQuetCamera.Size = new Size(130, 32);
            btnQuetCamera.TabIndex = 3;
            btnQuetCamera.Text = "📷 Quét mã QR";
            btnQuetCamera.UseVisualStyleBackColor = false;
            btnQuetCamera.Click += BtnChuaTrienKhai_Click;
            // 
            // btnKiemTra
            // 
            btnKiemTra.BackColor = Color.FromArgb(211, 47, 47);
            btnKiemTra.FlatAppearance.BorderSize = 0;
            btnKiemTra.FlatStyle = FlatStyle.Flat;
            btnKiemTra.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnKiemTra.ForeColor = Color.White;
            btnKiemTra.Location = new Point(480, 26);
            btnKiemTra.Name = "btnKiemTra";
            btnKiemTra.Size = new Size(130, 32);
            btnKiemTra.TabIndex = 2;
            btnKiemTra.Text = "🔍 Kiểm tra vé";
            btnKiemTra.UseVisualStyleBackColor = false;
            btnKiemTra.Click += btnKiemTra_Click;
            // 
            // txtMaVe
            // 
            txtMaVe.Font = new Font("Segoe UI", 11F, FontStyle.Regular, GraphicsUnit.Point);
            txtMaVe.Location = new Point(15, 29);
            txtMaVe.Name = "txtMaVe";
            txtMaVe.PlaceholderText = "Nhập mã vé, ví dụ: VE-1029...";
            txtMaVe.Size = new Size(450, 27);
            txtMaVe.TabIndex = 1;
            // 
            // lblMaVe
            // 
            lblMaVe.AutoSize = true;
            lblMaVe.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblMaVe.ForeColor = Color.FromArgb(71, 85, 105);
            lblMaVe.Location = new Point(15, 10);
            lblMaVe.Name = "lblMaVe";
            lblMaVe.Size = new Size(210, 15);
            lblMaVe.TabIndex = 0;
            lblMaVe.Text = "NHẬP MÃ VÉ HOẶC MÃ VẠCH CHECK-IN:";
            // 
            // pnlKetQua
            // 
            pnlKetQua.BackColor = Color.White;
            pnlKetQua.BorderStyle = BorderStyle.FixedSingle;
            pnlKetQua.Controls.Add(btnXacNhanVaoRap);
            pnlKetQua.Controls.Add(lblChiTietVe);
            pnlKetQua.Controls.Add(lblTrangThaiVe);
            pnlKetQua.Controls.Add(lblKetQuaTieuDe);
            pnlKetQua.Dock = DockStyle.Fill;
            pnlKetQua.Location = new Point(15, 138);
            pnlKetQua.Margin = new Padding(0, 10, 0, 0);
            pnlKetQua.Name = "pnlKetQua";
            pnlKetQua.Padding = new Padding(20);
            pnlKetQua.Size = new Size(950, 447);
            pnlKetQua.TabIndex = 2;
            // 
            // btnXacNhanVaoRap
            // 
            btnXacNhanVaoRap.BackColor = Color.FromArgb(16, 185, 129);
            btnXacNhanVaoRap.FlatAppearance.BorderSize = 0;
            btnXacNhanVaoRap.FlatStyle = FlatStyle.Flat;
            btnXacNhanVaoRap.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            btnXacNhanVaoRap.ForeColor = Color.White;
            btnXacNhanVaoRap.Location = new Point(20, 370);
            btnXacNhanVaoRap.Name = "btnXacNhanVaoRap";
            btnXacNhanVaoRap.Size = new Size(300, 45);
            btnXacNhanVaoRap.TabIndex = 3;
            btnXacNhanVaoRap.Text = "✅ XÁC NHẬN SOÁT VÉ VÀO PHÒNG";
            btnXacNhanVaoRap.UseVisualStyleBackColor = false;
            btnXacNhanVaoRap.Click += BtnChuaTrienKhai_Click;
            // 
            // lblChiTietVe
            // 
            lblChiTietVe.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            lblChiTietVe.BackColor = Color.FromArgb(248, 250, 252);
            lblChiTietVe.BorderStyle = BorderStyle.FixedSingle;
            lblChiTietVe.Font = new Font("Segoe UI", 10.5F, FontStyle.Regular, GraphicsUnit.Point);
            lblChiTietVe.ForeColor = Color.FromArgb(30, 41, 59);
            lblChiTietVe.Location = new Point(20, 115);
            lblChiTietVe.Name = "lblChiTietVe";
            lblChiTietVe.Padding = new Padding(15);
            lblChiTietVe.Size = new Size(908, 235);
            lblChiTietVe.TabIndex = 2;
            lblChiTietVe.Text = "• Mã vé: VE-1029-A\r\n• Phim: Đào, Phở và Piano (Giới hạn: T13)\r\n• Suất chiếu: 19:30 - Thứ Sáu, 21/10/2026\r\n• Cụm rạp: YeuMinhEm Landmark 81\r\n• Phòng chiếu: Phòng 01 (2D Digital)\r\n• Vị trí ghế: C5 (Ghế VIP)\r\n• Khách hàng: Trần Minh Quân (SĐT: 0901234567)\r\n• Combo kèm theo: Combo Solo (1 Bắp + 1 Nước)";
            // 
            // lblTrangThaiVe
            // 
            lblTrangThaiVe.AutoSize = true;
            lblTrangThaiVe.BackColor = Color.FromArgb(16, 185, 129);
            lblTrangThaiVe.Font = new Font("Segoe UI", 12F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrangThaiVe.ForeColor = Color.White;
            lblTrangThaiVe.Location = new Point(20, 65);
            lblTrangThaiVe.Name = "lblTrangThaiVe";
            lblTrangThaiVe.Padding = new Padding(12, 6, 12, 6);
            lblTrangThaiVe.Size = new Size(307, 33);
            lblTrangThaiVe.TabIndex = 1;
            lblTrangThaiVe.Text = "✔ VÉ HỢP LỆ — ĐỦ ĐIỀU KIỆN VÀO RẠP";
            // 
            // lblKetQuaTieuDe
            // 
            lblKetQuaTieuDe.AutoSize = true;
            lblKetQuaTieuDe.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblKetQuaTieuDe.ForeColor = Color.FromArgb(24, 24, 27);
            lblKetQuaTieuDe.Location = new Point(20, 20);
            lblKetQuaTieuDe.Name = "lblKetQuaTieuDe";
            lblKetQuaTieuDe.Size = new Size(207, 20);
            lblKetQuaTieuDe.TabIndex = 0;
            lblKetQuaTieuDe.Text = "THÔNG TIN CHI TIẾT TẤM VÉ";
            // 
            // UcKiemTraVe
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(pnlKetQua);
            Controls.Add(pnlInput);
            Controls.Add(pnlBanner);
            Name = "UcKiemTraVe";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            pnlInput.ResumeLayout(false);
            pnlInput.PerformLayout();
            pnlKetQua.ResumeLayout(false);
            pnlKetQua.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private Panel pnlInput;
        private Label lblMaVe;
        private TextBox txtMaVe;
        private Button btnKiemTra;
        private Button btnQuetCamera;
        private Panel pnlKetQua;
        private Label lblKetQuaTieuDe;
        private Label lblTrangThaiVe;
        private Label lblChiTietVe;
        private Button btnXacNhanVaoRap;
    }
}
