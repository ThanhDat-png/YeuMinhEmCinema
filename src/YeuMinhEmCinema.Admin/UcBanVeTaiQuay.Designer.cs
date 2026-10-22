namespace YeuMinhEmCinema.Admin
{
    partial class UcBanVeTaiQuay
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
            splMain = new SplitContainer();
            pnlLeft = new Panel();
            grpFnb = new GroupBox();
            chkNuoc = new CheckBox();
            chkComboCouple = new CheckBox();
            chkComboSolo = new CheckBox();
            grpChonGhe = new GroupBox();
            flpGheNgoi = new FlowLayoutPanel();
            lblManHinh = new Label();
            grpChonSuat = new GroupBox();
            cboSuatChieu = new ComboBox();
            lblSuat = new Label();
            cboChonPhim = new ComboBox();
            lblPhim = new Label();
            pnlRight = new Panel();
            btnLamMoi = new Button();
            btnThanhToan = new Button();
            pnlDivider = new Panel();
            lblTongTienSo = new Label();
            lblTongTien = new Label();
            txtTomTatHoaDon = new TextBox();
            lblTomTatTieuDe = new Label();
            pnlBanner.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splMain).BeginInit();
            splMain.Panel1.SuspendLayout();
            splMain.Panel2.SuspendLayout();
            splMain.SuspendLayout();
            pnlLeft.SuspendLayout();
            grpFnb.SuspendLayout();
            grpChonGhe.SuspendLayout();
            grpChonSuat.SuspendLayout();
            pnlRight.SuspendLayout();
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
            lblTieuDe.Text = "🛒 BÁN VÉ TẠI QUẦY (BOX OFFICE POS)";
            // 
            // splMain
            // 
            splMain.Dock = DockStyle.Fill;
            splMain.Location = new Point(15, 63);
            splMain.Name = "splMain";
            // 
            // splMain.Panel1
            // 
            splMain.Panel1.Controls.Add(pnlLeft);
            splMain.Panel1.Padding = new Padding(0, 10, 8, 0);
            // 
            // splMain.Panel2
            // 
            splMain.Panel2.Controls.Add(pnlRight);
            splMain.Panel2.Padding = new Padding(8, 10, 0, 0);
            splMain.Size = new Size(950, 522);
            splMain.SplitterDistance = 620;
            splMain.TabIndex = 1;
            // 
            // pnlLeft
            // 
            pnlLeft.AutoScroll = true;
            pnlLeft.BackColor = Color.White;
            pnlLeft.BorderStyle = BorderStyle.FixedSingle;
            pnlLeft.Controls.Add(grpFnb);
            pnlLeft.Controls.Add(grpChonGhe);
            pnlLeft.Controls.Add(grpChonSuat);
            pnlLeft.Dock = DockStyle.Fill;
            pnlLeft.Location = new Point(0, 10);
            pnlLeft.Name = "pnlLeft";
            pnlLeft.Padding = new Padding(12);
            pnlLeft.Size = new Size(612, 512);
            pnlLeft.TabIndex = 0;
            // 
            // grpFnb
            // 
            grpFnb.Controls.Add(chkNuoc);
            grpFnb.Controls.Add(chkComboCouple);
            grpFnb.Controls.Add(chkComboSolo);
            grpFnb.Dock = DockStyle.Top;
            grpFnb.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            grpFnb.ForeColor = Color.FromArgb(24, 24, 27);
            grpFnb.Location = new Point(12, 342);
            grpFnb.Name = "grpFnb";
            grpFnb.Padding = new Padding(10);
            grpFnb.Size = new Size(586, 75);
            grpFnb.TabIndex = 2;
            grpFnb.TabStop = false;
            grpFnb.Text = "BƯỚC 3: CHỌN BẮP NƯỚC KÈM THEO";
            // 
            // chkNuoc
            // 
            chkNuoc.AutoSize = true;
            chkNuoc.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkNuoc.Location = new Point(400, 32);
            chkNuoc.Name = "chkNuoc";
            chkNuoc.Size = new Size(157, 19);
            chkNuoc.TabIndex = 2;
            chkNuoc.Text = "Coca Lớn (+35.000 đ)";
            chkNuoc.UseVisualStyleBackColor = true;
            chkNuoc.CheckedChanged += CapNhatGia_CheckedChanged;
            // 
            // chkComboCouple
            // 
            chkComboCouple.AutoSize = true;
            chkComboCouple.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkComboCouple.Location = new Point(200, 32);
            chkComboCouple.Name = "chkComboCouple";
            chkComboCouple.Size = new Size(183, 19);
            chkComboCouple.TabIndex = 1;
            chkComboCouple.Text = "Combo Couple (+109.000 đ)";
            chkComboCouple.UseVisualStyleBackColor = true;
            chkComboCouple.CheckedChanged += CapNhatGia_CheckedChanged;
            // 
            // chkComboSolo
            // 
            chkComboSolo.AutoSize = true;
            chkComboSolo.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkComboSolo.Location = new Point(20, 32);
            chkComboSolo.Name = "chkComboSolo";
            chkComboSolo.Size = new Size(164, 19);
            chkComboSolo.TabIndex = 0;
            chkComboSolo.Text = "Combo Solo (+79.000 đ)";
            chkComboSolo.UseVisualStyleBackColor = true;
            chkComboSolo.CheckedChanged += CapNhatGia_CheckedChanged;
            // 
            // grpChonGhe
            // 
            grpChonGhe.Controls.Add(flpGheNgoi);
            grpChonGhe.Controls.Add(lblManHinh);
            grpChonGhe.Dock = DockStyle.Top;
            grpChonGhe.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            grpChonGhe.ForeColor = Color.FromArgb(24, 24, 27);
            grpChonGhe.Location = new Point(12, 102);
            grpChonGhe.Name = "grpChonGhe";
            grpChonGhe.Padding = new Padding(10);
            grpChonGhe.Size = new Size(586, 240);
            grpChonGhe.TabIndex = 1;
            grpChonGhe.TabStop = false;
            grpChonGhe.Text = "BƯỚC 2: CHỌN GHẾ NGỒI";
            // 
            // flpGheNgoi
            // 
            flpGheNgoi.Dock = DockStyle.Fill;
            flpGheNgoi.Location = new Point(10, 53);
            flpGheNgoi.Name = "flpGheNgoi";
            flpGheNgoi.Size = new Size(566, 177);
            flpGheNgoi.TabIndex = 1;
            // 
            // lblManHinh
            // 
            lblManHinh.BackColor = Color.FromArgb(226, 232, 240);
            lblManHinh.Dock = DockStyle.Top;
            lblManHinh.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblManHinh.ForeColor = Color.FromArgb(71, 85, 105);
            lblManHinh.Location = new Point(10, 28);
            lblManHinh.Name = "lblManHinh";
            lblManHinh.Size = new Size(566, 25);
            lblManHinh.TabIndex = 0;
            lblManHinh.Text = "━━━━ MÀN HÌNH ━━━━";
            lblManHinh.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // grpChonSuat
            // 
            grpChonSuat.Controls.Add(cboSuatChieu);
            grpChonSuat.Controls.Add(lblSuat);
            grpChonSuat.Controls.Add(cboChonPhim);
            grpChonSuat.Controls.Add(lblPhim);
            grpChonSuat.Dock = DockStyle.Top;
            grpChonSuat.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            grpChonSuat.ForeColor = Color.FromArgb(24, 24, 27);
            grpChonSuat.Location = new Point(12, 12);
            grpChonSuat.Name = "grpChonSuat";
            grpChonSuat.Padding = new Padding(10);
            grpChonSuat.Size = new Size(586, 90);
            grpChonSuat.TabIndex = 0;
            grpChonSuat.TabStop = false;
            grpChonSuat.Text = "BƯỚC 1: CHỌN PHIM VÀ SUẤT CHIẾU";
            // 
            // cboSuatChieu
            // 
            cboSuatChieu.DropDownStyle = ComboBoxStyle.DropDownList;
            cboSuatChieu.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            cboSuatChieu.FormattingEnabled = true;
            cboSuatChieu.Items.AddRange(new object[] { "19:30 - Phòng 01 (2D Digital)", "20:00 - Phòng 03 (IMAX Laser)", "21:15 - Phòng 02 (3D RealD)", "22:45 - Phòng 01 (2D Digital)" });
            cboSuatChieu.Location = new Point(310, 48);
            cboSuatChieu.Name = "cboSuatChieu";
            cboSuatChieu.Size = new Size(250, 23);
            cboSuatChieu.TabIndex = 3;
            cboSuatChieu.SelectedIndexChanged += cboSuatChieu_SelectedIndexChanged;
            // 
            // lblSuat
            // 
            lblSuat.AutoSize = true;
            lblSuat.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblSuat.ForeColor = Color.Gray;
            lblSuat.Location = new Point(310, 30);
            lblSuat.Name = "lblSuat";
            lblSuat.Size = new Size(76, 13);
            lblSuat.TabIndex = 2;
            lblSuat.Text = "SUẤT CHIẾU:";
            // 
            // cboChonPhim
            // 
            cboChonPhim.DropDownStyle = ComboBoxStyle.DropDownList;
            cboChonPhim.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            cboChonPhim.FormattingEnabled = true;
            cboChonPhim.Items.AddRange(new object[] { "Đào, Phở và Piano", "Mai", "Lật Mặt 7: Một Điều Ước", "Kung Fu Panda 4", "Dune: Hành Tinh Cát 2" });
            cboChonPhim.Location = new Point(15, 48);
            cboChonPhim.Name = "cboChonPhim";
            cboChonPhim.Size = new Size(275, 23);
            cboChonPhim.TabIndex = 1;
            cboChonPhim.SelectedIndexChanged += cboChonPhim_SelectedIndexChanged;
            // 
            // lblPhim
            // 
            lblPhim.AutoSize = true;
            lblPhim.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblPhim.ForeColor = Color.Gray;
            lblPhim.Location = new Point(15, 30);
            lblPhim.Name = "lblPhim";
            lblPhim.Size = new Size(72, 13);
            lblPhim.TabIndex = 0;
            lblPhim.Text = "PHIM CHIẾU:";
            // 
            // pnlRight
            // 
            pnlRight.BackColor = Color.White;
            pnlRight.BorderStyle = BorderStyle.FixedSingle;
            pnlRight.Controls.Add(btnLamMoi);
            pnlRight.Controls.Add(btnThanhToan);
            pnlRight.Controls.Add(pnlDivider);
            pnlRight.Controls.Add(lblTongTienSo);
            pnlRight.Controls.Add(lblTongTien);
            pnlRight.Controls.Add(txtTomTatHoaDon);
            pnlRight.Controls.Add(lblTomTatTieuDe);
            pnlRight.Dock = DockStyle.Fill;
            pnlRight.Location = new Point(8, 10);
            pnlRight.Name = "pnlRight";
            pnlRight.Padding = new Padding(15);
            pnlRight.Size = new Size(318, 512);
            pnlRight.TabIndex = 0;
            // 
            // btnLamMoi
            // 
            btnLamMoi.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnLamMoi.BackColor = Color.FromArgb(148, 163, 184);
            btnLamMoi.FlatAppearance.BorderSize = 0;
            btnLamMoi.FlatStyle = FlatStyle.Flat;
            btnLamMoi.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnLamMoi.ForeColor = Color.White;
            btnLamMoi.Location = new Point(15, 462);
            btnLamMoi.Name = "btnLamMoi";
            btnLamMoi.Size = new Size(286, 35);
            btnLamMoi.TabIndex = 6;
            btnLamMoi.Text = "🔄 Làm mới đơn";
            btnLamMoi.UseVisualStyleBackColor = false;
            btnLamMoi.Click += btnLamMoi_Click;
            // 
            // btnThanhToan
            // 
            btnThanhToan.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnThanhToan.BackColor = Color.FromArgb(211, 47, 47);
            btnThanhToan.FlatAppearance.BorderSize = 0;
            btnThanhToan.FlatStyle = FlatStyle.Flat;
            btnThanhToan.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            btnThanhToan.ForeColor = Color.White;
            btnThanhToan.Location = new Point(15, 412);
            btnThanhToan.Name = "btnThanhToan";
            btnThanhToan.Size = new Size(286, 44);
            btnThanhToan.TabIndex = 5;
            btnThanhToan.Text = "💵 THANH TOÁN & IN VÉ";
            btnThanhToan.UseVisualStyleBackColor = false;
            btnThanhToan.Click += btnThanhToan_Click;
            // 
            // pnlDivider
            // 
            pnlDivider.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            pnlDivider.BackColor = Color.FromArgb(226, 232, 240);
            pnlDivider.Location = new Point(15, 335);
            pnlDivider.Name = "pnlDivider";
            pnlDivider.Size = new Size(286, 2);
            pnlDivider.TabIndex = 4;
            // 
            // lblTongTienSo
            // 
            lblTongTienSo.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            lblTongTienSo.Font = new Font("Segoe UI", 14F, FontStyle.Bold, GraphicsUnit.Point);
            lblTongTienSo.ForeColor = Color.FromArgb(211, 47, 47);
            lblTongTienSo.Location = new Point(115, 355);
            lblTongTienSo.Name = "lblTongTienSo";
            lblTongTienSo.Size = new Size(186, 30);
            lblTongTienSo.TabIndex = 3;
            lblTongTienSo.Text = "180.000 đ";
            lblTongTienSo.TextAlign = ContentAlignment.MiddleRight;
            // 
            // lblTongTien
            // 
            lblTongTien.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            lblTongTien.AutoSize = true;
            lblTongTien.Font = new Font("Segoe UI", 11F, FontStyle.Bold, GraphicsUnit.Point);
            lblTongTien.ForeColor = Color.FromArgb(24, 24, 27);
            lblTongTien.Location = new Point(15, 360);
            lblTongTien.Name = "lblTongTien";
            lblTongTien.Size = new Size(95, 20);
            lblTongTien.TabIndex = 2;
            lblTongTien.Text = "TỔNG CỘNG:";
            // 
            // txtTomTatHoaDon
            // 
            txtTomTatHoaDon.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            txtTomTatHoaDon.BackColor = Color.FromArgb(248, 250, 252);
            txtTomTatHoaDon.Font = new Font("Consolas", 9F, FontStyle.Regular, GraphicsUnit.Point);
            txtTomTatHoaDon.Location = new Point(15, 45);
            txtTomTatHoaDon.Multiline = true;
            txtTomTatHoaDon.Name = "txtTomTatHoaDon";
            txtTomTatHoaDon.ReadOnly = true;
            txtTomTatHoaDon.ScrollBars = ScrollBars.Vertical;
            txtTomTatHoaDon.Size = new Size(286, 275);
            txtTomTatHoaDon.TabIndex = 1;
            // 
            // lblTomTatTieuDe
            // 
            lblTomTatTieuDe.AutoSize = true;
            lblTomTatTieuDe.Font = new Font("Segoe UI", 11F, FontStyle.Bold, GraphicsUnit.Point);
            lblTomTatTieuDe.ForeColor = Color.FromArgb(24, 24, 27);
            lblTomTatTieuDe.Location = new Point(15, 15);
            lblTomTatTieuDe.Name = "lblTomTatTieuDe";
            lblTomTatTieuDe.Size = new Size(184, 20);
            lblTomTatTieuDe.TabIndex = 0;
            lblTomTatTieuDe.Text = "🧾 HÓA ĐƠN TẠM TÍNH";
            // 
            // UcBanVeTaiQuay
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(splMain);
            Controls.Add(pnlBanner);
            Name = "UcBanVeTaiQuay";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            splMain.Panel1.ResumeLayout(false);
            splMain.Panel2.ResumeLayout(false);
            splMain.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)splMain).EndInit();
            splMain.ResumeLayout(false);
            pnlLeft.ResumeLayout(false);
            grpFnb.ResumeLayout(false);
            grpFnb.PerformLayout();
            grpChonGhe.ResumeLayout(false);
            grpChonSuat.ResumeLayout(false);
            grpChonSuat.PerformLayout();
            pnlRight.ResumeLayout(false);
            pnlRight.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private SplitContainer splMain;
        private Panel pnlLeft;
        private GroupBox grpChonSuat;
        private Label lblPhim;
        private ComboBox cboChonPhim;
        private Label lblSuat;
        private ComboBox cboSuatChieu;
        private GroupBox grpChonGhe;
        private Label lblManHinh;
        private FlowLayoutPanel flpGheNgoi;
        private GroupBox grpFnb;
        private CheckBox chkComboSolo;
        private CheckBox chkComboCouple;
        private CheckBox chkNuoc;
        private Panel pnlRight;
        private Label lblTomTatTieuDe;
        private TextBox txtTomTatHoaDon;
        private Label lblTongTien;
        private Label lblTongTienSo;
        private Panel pnlDivider;
        private Button btnThanhToan;
        private Button btnLamMoi;
    }
}
