namespace YeuMinhEmCinema.Admin
{
    partial class UcNhanVienPhanQuyen
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
            dgvNhanVien = new DataGridView();
            pnlToolbar = new Panel();
            btnThemNV = new Button();
            txtTimKiem = new TextBox();
            lblTimKiem = new Label();
            pnlRight = new Panel();
            btnLuuQuyen = new Button();
            grpQuyenChiTiet = new GroupBox();
            chkQuyenHeThong = new CheckBox();
            chkQuyenBaoCao = new CheckBox();
            chkQuyenSoatVe = new CheckBox();
            chkQuyenBanVe = new CheckBox();
            chkQuyenPhim = new CheckBox();
            grpVaiTro = new GroupBox();
            rdoSoatVe = new RadioButton();
            rdoBanVe = new RadioButton();
            rdoQuanLyRap = new RadioButton();
            rdoAdmin = new RadioButton();
            lblNhanVienDangChon = new Label();
            lblPhanQuyenTieuDe = new Label();
            pnlBanner.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splMain).BeginInit();
            splMain.Panel1.SuspendLayout();
            splMain.Panel2.SuspendLayout();
            splMain.SuspendLayout();
            pnlLeft.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvNhanVien).BeginInit();
            pnlToolbar.SuspendLayout();
            pnlRight.SuspendLayout();
            grpQuyenChiTiet.SuspendLayout();
            grpVaiTro.SuspendLayout();
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
            lblTieuDe.Size = new Size(301, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "👤 QUẢN LÝ NHÂN VIÊN VÀ PHÂN QUYỀN";
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
            splMain.SplitterDistance = 580;
            splMain.TabIndex = 1;
            // 
            // pnlLeft
            // 
            pnlLeft.BackColor = Color.White;
            pnlLeft.BorderStyle = BorderStyle.FixedSingle;
            pnlLeft.Controls.Add(dgvNhanVien);
            pnlLeft.Controls.Add(pnlToolbar);
            pnlLeft.Dock = DockStyle.Fill;
            pnlLeft.Location = new Point(0, 10);
            pnlLeft.Name = "pnlLeft";
            pnlLeft.Padding = new Padding(12);
            pnlLeft.Size = new Size(572, 512);
            pnlLeft.TabIndex = 0;
            // 
            // dgvNhanVien
            // 
            dgvNhanVien.AllowUserToAddRows = false;
            dgvNhanVien.AllowUserToDeleteRows = false;
            dgvNhanVien.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvNhanVien.BackgroundColor = Color.White;
            dgvNhanVien.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvNhanVien.Dock = DockStyle.Fill;
            dgvNhanVien.Location = new Point(12, 67);
            dgvNhanVien.Name = "dgvNhanVien";
            dgvNhanVien.ReadOnly = true;
            dgvNhanVien.RowHeadersVisible = false;
            dgvNhanVien.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvNhanVien.Size = new Size(546, 431);
            dgvNhanVien.TabIndex = 1;
            dgvNhanVien.SelectionChanged += dgvNhanVien_SelectionChanged;
            // 
            // pnlToolbar
            // 
            pnlToolbar.Controls.Add(btnThemNV);
            pnlToolbar.Controls.Add(txtTimKiem);
            pnlToolbar.Controls.Add(lblTimKiem);
            pnlToolbar.Dock = DockStyle.Top;
            pnlToolbar.Location = new Point(12, 12);
            pnlToolbar.Name = "pnlToolbar";
            pnlToolbar.Size = new Size(546, 55);
            pnlToolbar.TabIndex = 0;
            // 
            // btnThemNV
            // 
            btnThemNV.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnThemNV.BackColor = Color.FromArgb(211, 47, 47);
            btnThemNV.FlatAppearance.BorderSize = 0;
            btnThemNV.FlatStyle = FlatStyle.Flat;
            btnThemNV.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemNV.ForeColor = Color.White;
            btnThemNV.Location = new Point(410, 16);
            btnThemNV.Name = "btnThemNV";
            btnThemNV.Size = new Size(130, 30);
            btnThemNV.TabIndex = 2;
            btnThemNV.Text = "+ Thêm nhân viên";
            btnThemNV.UseVisualStyleBackColor = false;
            btnThemNV.Click += BtnChuaTrienKhai_Click;
            // 
            // txtTimKiem
            // 
            txtTimKiem.Location = new Point(3, 21);
            txtTimKiem.Name = "txtTimKiem";
            txtTimKiem.PlaceholderText = "Tìm theo tên, email, chức vụ...";
            txtTimKiem.Size = new Size(260, 23);
            txtTimKiem.TabIndex = 1;
            // 
            // lblTimKiem
            // 
            lblTimKiem.AutoSize = true;
            lblTimKiem.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTimKiem.ForeColor = Color.FromArgb(71, 85, 105);
            lblTimKiem.Location = new Point(3, 5);
            lblTimKiem.Name = "lblTimKiem";
            lblTimKiem.Size = new Size(125, 13);
            lblTimKiem.TabIndex = 0;
            lblTimKiem.Text = "TÌM KIẾM NHÂN VIÊN:";
            // 
            // pnlRight
            // 
            pnlRight.BackColor = Color.White;
            pnlRight.BorderStyle = BorderStyle.FixedSingle;
            pnlRight.Controls.Add(btnLuuQuyen);
            pnlRight.Controls.Add(grpQuyenChiTiet);
            pnlRight.Controls.Add(grpVaiTro);
            pnlRight.Controls.Add(lblNhanVienDangChon);
            pnlRight.Controls.Add(lblPhanQuyenTieuDe);
            pnlRight.Dock = DockStyle.Fill;
            pnlRight.Location = new Point(8, 10);
            pnlRight.Name = "pnlRight";
            pnlRight.Padding = new Padding(15);
            pnlRight.Size = new Size(358, 512);
            pnlRight.TabIndex = 0;
            // 
            // btnLuuQuyen
            // 
            btnLuuQuyen.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnLuuQuyen.BackColor = Color.FromArgb(15, 23, 42);
            btnLuuQuyen.FlatAppearance.BorderSize = 0;
            btnLuuQuyen.FlatStyle = FlatStyle.Flat;
            btnLuuQuyen.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            btnLuuQuyen.ForeColor = Color.White;
            btnLuuQuyen.Location = new Point(15, 458);
            btnLuuQuyen.Name = "btnLuuQuyen";
            btnLuuQuyen.Size = new Size(326, 38);
            btnLuuQuyen.TabIndex = 4;
            btnLuuQuyen.Text = "💾 CẬP NHẬT QUYỀN HẠN";
            btnLuuQuyen.UseVisualStyleBackColor = false;
            btnLuuQuyen.Click += btnLuuQuyen_Click;
            // 
            // grpQuyenChiTiet
            // 
            grpQuyenChiTiet.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            grpQuyenChiTiet.Controls.Add(chkQuyenHeThong);
            grpQuyenChiTiet.Controls.Add(chkQuyenBaoCao);
            grpQuyenChiTiet.Controls.Add(chkQuyenSoatVe);
            grpQuyenChiTiet.Controls.Add(chkQuyenBanVe);
            grpQuyenChiTiet.Controls.Add(chkQuyenPhim);
            grpQuyenChiTiet.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            grpQuyenChiTiet.ForeColor = Color.FromArgb(24, 24, 27);
            grpQuyenChiTiet.Location = new Point(15, 235);
            grpQuyenChiTiet.Name = "grpQuyenChiTiet";
            grpQuyenChiTiet.Padding = new Padding(12);
            grpQuyenChiTiet.Size = new Size(326, 205);
            grpQuyenChiTiet.TabIndex = 3;
            grpQuyenChiTiet.TabStop = false;
            grpQuyenChiTiet.Text = "QUYỀN TRUY CẬP CHI TIẾT";
            // 
            // chkQuyenHeThong
            // 
            chkQuyenHeThong.AutoSize = true;
            chkQuyenHeThong.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkQuyenHeThong.Location = new Point(15, 165);
            chkQuyenHeThong.Name = "chkQuyenHeThong";
            chkQuyenHeThong.Size = new Size(224, 19);
            chkQuyenHeThong.TabIndex = 4;
            chkQuyenHeThong.Text = "Quản lý nhân viên & cấu hình hệ thống";
            chkQuyenHeThong.UseVisualStyleBackColor = true;
            // 
            // chkQuyenBaoCao
            // 
            chkQuyenBaoCao.AutoSize = true;
            chkQuyenBaoCao.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkQuyenBaoCao.Location = new Point(15, 130);
            chkQuyenBaoCao.Name = "chkQuyenBaoCao";
            chkQuyenBaoCao.Size = new Size(223, 19);
            chkQuyenBaoCao.TabIndex = 3;
            chkQuyenBaoCao.Text = "Xem báo cáo thống kê & xuất file Excel";
            chkQuyenBaoCao.UseVisualStyleBackColor = true;
            // 
            // chkQuyenSoatVe
            // 
            chkQuyenSoatVe.AutoSize = true;
            chkQuyenSoatVe.Checked = true;
            chkQuyenSoatVe.CheckState = CheckState.Checked;
            chkQuyenSoatVe.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkQuyenSoatVe.Location = new Point(15, 95);
            chkQuyenSoatVe.Name = "chkQuyenSoatVe";
            chkQuyenSoatVe.Size = new Size(203, 19);
            chkQuyenSoatVe.TabIndex = 2;
            chkQuyenSoatVe.Text = "Soát vé & kiểm tra mã QR vào rạp";
            chkQuyenSoatVe.UseVisualStyleBackColor = true;
            // 
            // chkQuyenBanVe
            // 
            chkQuyenBanVe.AutoSize = true;
            chkQuyenBanVe.Checked = true;
            chkQuyenBanVe.CheckState = CheckState.Checked;
            chkQuyenBanVe.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkQuyenBanVe.Location = new Point(15, 60);
            chkQuyenBanVe.Name = "chkQuyenBanVe";
            chkQuyenBanVe.Size = new Size(210, 19);
            chkQuyenBanVe.TabIndex = 1;
            chkQuyenBanVe.Text = "Bán vé tại quầy POS & in bill bắp nước";
            chkQuyenBanVe.UseVisualStyleBackColor = true;
            // 
            // chkQuyenPhim
            // 
            chkQuyenPhim.AutoSize = true;
            chkQuyenPhim.Checked = true;
            chkQuyenPhim.CheckState = CheckState.Checked;
            chkQuyenPhim.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            chkQuyenPhim.Location = new Point(15, 25);
            chkQuyenPhim.Name = "chkQuyenPhim";
            chkQuyenPhim.Size = new Size(216, 19);
            chkQuyenPhim.TabIndex = 0;
            chkQuyenPhim.Text = "Quản lý phim & lập lịch chiếu phòng";
            chkQuyenPhim.UseVisualStyleBackColor = true;
            // 
            // grpVaiTro
            // 
            grpVaiTro.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            grpVaiTro.Controls.Add(rdoSoatVe);
            grpVaiTro.Controls.Add(rdoBanVe);
            grpVaiTro.Controls.Add(rdoQuanLyRap);
            grpVaiTro.Controls.Add(rdoAdmin);
            grpVaiTro.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            grpVaiTro.ForeColor = Color.FromArgb(24, 24, 27);
            grpVaiTro.Location = new Point(15, 80);
            grpVaiTro.Name = "grpVaiTro";
            grpVaiTro.Padding = new Padding(12);
            grpVaiTro.Size = new Size(326, 145);
            grpVaiTro.TabIndex = 2;
            grpVaiTro.TabStop = false;
            grpVaiTro.Text = "VAI TRÒ CHÍNH (ROLE)";
            // 
            // rdoSoatVe
            // 
            rdoSoatVe.AutoSize = true;
            rdoSoatVe.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            rdoSoatVe.Location = new Point(15, 110);
            rdoSoatVe.Name = "rdoSoatVe";
            rdoSoatVe.Size = new Size(130, 19);
            rdoSoatVe.TabIndex = 3;
            rdoSoatVe.Text = "Nhân viên soát vé";
            rdoSoatVe.UseVisualStyleBackColor = true;
            // 
            // rdoBanVe
            // 
            rdoBanVe.AutoSize = true;
            rdoBanVe.Checked = true;
            rdoBanVe.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            rdoBanVe.Location = new Point(15, 82);
            rdoBanVe.Name = "rdoBanVe";
            rdoBanVe.Size = new Size(157, 19);
            rdoBanVe.TabIndex = 2;
            rdoBanVe.TabStop = true;
            rdoBanVe.Text = "Nhân viên bán vé quầy";
            rdoBanVe.UseVisualStyleBackColor = true;
            // 
            // rdoQuanLyRap
            // 
            rdoQuanLyRap.AutoSize = true;
            rdoQuanLyRap.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            rdoQuanLyRap.Location = new Point(15, 54);
            rdoQuanLyRap.Name = "rdoQuanLyRap";
            rdoQuanLyRap.Size = new Size(111, 19);
            rdoQuanLyRap.TabIndex = 1;
            rdoQuanLyRap.Text = "Quản lý cụm rạp";
            rdoQuanLyRap.UseVisualStyleBackColor = true;
            // 
            // rdoAdmin
            // 
            rdoAdmin.AutoSize = true;
            rdoAdmin.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            rdoAdmin.Location = new Point(15, 26);
            rdoAdmin.Name = "rdoAdmin";
            rdoAdmin.Size = new Size(174, 19);
            rdoAdmin.TabIndex = 0;
            rdoAdmin.Text = "Quản trị viên (Super Admin)";
            rdoAdmin.UseVisualStyleBackColor = true;
            // 
            // lblNhanVienDangChon
            // 
            lblNhanVienDangChon.AutoSize = true;
            lblNhanVienDangChon.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblNhanVienDangChon.ForeColor = Color.FromArgb(211, 47, 47);
            lblNhanVienDangChon.Location = new Point(15, 45);
            lblNhanVienDangChon.Name = "lblNhanVienDangChon";
            lblNhanVienDangChon.Size = new Size(250, 17);
            lblNhanVienDangChon.TabIndex = 1;
            lblNhanVienDangChon.Text = "Đang chọn: NV001 - Nguyễn Văn Hưng";
            // 
            // lblPhanQuyenTieuDe
            // 
            lblPhanQuyenTieuDe.AutoSize = true;
            lblPhanQuyenTieuDe.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblPhanQuyenTieuDe.ForeColor = Color.FromArgb(24, 24, 27);
            lblPhanQuyenTieuDe.Location = new Point(15, 15);
            lblPhanQuyenTieuDe.Name = "lblPhanQuyenTieuDe";
            lblPhanQuyenTieuDe.Size = new Size(182, 20);
            lblPhanQuyenTieuDe.TabIndex = 0;
            lblPhanQuyenTieuDe.Text = "PHÂN QUYỀN HỆ THỐNG";
            // 
            // UcNhanVienPhanQuyen
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(splMain);
            Controls.Add(pnlBanner);
            Name = "UcNhanVienPhanQuyen";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            splMain.Panel1.ResumeLayout(false);
            splMain.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splMain).EndInit();
            splMain.ResumeLayout(false);
            pnlLeft.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvNhanVien).EndInit();
            pnlToolbar.ResumeLayout(false);
            pnlToolbar.PerformLayout();
            pnlRight.ResumeLayout(false);
            pnlRight.PerformLayout();
            grpQuyenChiTiet.ResumeLayout(false);
            grpQuyenChiTiet.PerformLayout();
            grpVaiTro.ResumeLayout(false);
            grpVaiTro.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private SplitContainer splMain;
        private Panel pnlLeft;
        private Panel pnlToolbar;
        private Label lblTimKiem;
        private TextBox txtTimKiem;
        private Button btnThemNV;
        private DataGridView dgvNhanVien;
        private Panel pnlRight;
        private Label lblPhanQuyenTieuDe;
        private Label lblNhanVienDangChon;
        private GroupBox grpVaiTro;
        private RadioButton rdoAdmin;
        private RadioButton rdoQuanLyRap;
        private RadioButton rdoBanVe;
        private RadioButton rdoSoatVe;
        private GroupBox grpQuyenChiTiet;
        private CheckBox chkQuyenPhim;
        private CheckBox chkQuyenBanVe;
        private CheckBox chkQuyenSoatVe;
        private CheckBox chkQuyenBaoCao;
        private CheckBox chkQuyenHeThong;
        private Button btnLuuQuyen;
    }
}
