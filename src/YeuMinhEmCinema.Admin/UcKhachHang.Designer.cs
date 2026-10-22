namespace YeuMinhEmCinema.Admin
{
    partial class UcKhachHang
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
            pnlToolbar = new Panel();
            btnThemKhachHang = new Button();
            btnTimKiem = new Button();
            cboHangThanhVien = new ComboBox();
            lblHang = new Label();
            txtTimKiem = new TextBox();
            lblTimKiem = new Label();
            splMain = new SplitContainer();
            dgvKhachHang = new DataGridView();
            pnlChiTiet = new Panel();
            lblChiTietKhach = new Label();
            lblChiTietTieuDe = new Label();
            pnlBanner.SuspendLayout();
            pnlToolbar.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splMain).BeginInit();
            splMain.Panel1.SuspendLayout();
            splMain.Panel2.SuspendLayout();
            splMain.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvKhachHang).BeginInit();
            pnlChiTiet.SuspendLayout();
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
            lblTieuDe.Size = new Size(309, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "👥 QUẢN LÝ KHÁCH HÀNG VÀ THÀNH VIÊN";
            // 
            // pnlToolbar
            // 
            pnlToolbar.BackColor = Color.White;
            pnlToolbar.BorderStyle = BorderStyle.FixedSingle;
            pnlToolbar.Controls.Add(btnThemKhachHang);
            pnlToolbar.Controls.Add(btnTimKiem);
            pnlToolbar.Controls.Add(cboHangThanhVien);
            pnlToolbar.Controls.Add(lblHang);
            pnlToolbar.Controls.Add(txtTimKiem);
            pnlToolbar.Controls.Add(lblTimKiem);
            pnlToolbar.Dock = DockStyle.Top;
            pnlToolbar.Location = new Point(15, 63);
            pnlToolbar.Name = "pnlToolbar";
            pnlToolbar.Padding = new Padding(10);
            pnlToolbar.Size = new Size(950, 65);
            pnlToolbar.TabIndex = 1;
            // 
            // btnThemKhachHang
            // 
            btnThemKhachHang.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnThemKhachHang.BackColor = Color.FromArgb(211, 47, 47);
            btnThemKhachHang.FlatAppearance.BorderSize = 0;
            btnThemKhachHang.FlatStyle = FlatStyle.Flat;
            btnThemKhachHang.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemKhachHang.ForeColor = Color.White;
            btnThemKhachHang.Location = new Point(790, 18);
            btnThemKhachHang.Name = "btnThemKhachHang";
            btnThemKhachHang.Size = new Size(145, 30);
            btnThemKhachHang.TabIndex = 5;
            btnThemKhachHang.Text = "+ Thêm khách hàng";
            btnThemKhachHang.UseVisualStyleBackColor = false;
            btnThemKhachHang.Click += BtnChuaTrienKhai_Click;
            // 
            // btnTimKiem
            // 
            btnTimKiem.BackColor = Color.FromArgb(15, 23, 42);
            btnTimKiem.FlatAppearance.BorderSize = 0;
            btnTimKiem.FlatStyle = FlatStyle.Flat;
            btnTimKiem.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnTimKiem.ForeColor = Color.White;
            btnTimKiem.Location = new Point(480, 20);
            btnTimKiem.Name = "btnTimKiem";
            btnTimKiem.Size = new Size(80, 28);
            btnTimKiem.TabIndex = 4;
            btnTimKiem.Text = "Tìm kiếm";
            btnTimKiem.UseVisualStyleBackColor = false;
            btnTimKiem.Click += btnTimKiem_Click;
            // 
            // cboHangThanhVien
            // 
            cboHangThanhVien.DropDownStyle = ComboBoxStyle.DropDownList;
            cboHangThanhVien.FormattingEnabled = true;
            cboHangThanhVien.Items.AddRange(new object[] { "Tất cả hạng", "Standard", "VIP Member", "Diamond Club" });
            cboHangThanhVien.Location = new Point(275, 24);
            cboHangThanhVien.Name = "cboHangThanhVien";
            cboHangThanhVien.Size = new Size(185, 23);
            cboHangThanhVien.TabIndex = 3;
            // 
            // lblHang
            // 
            lblHang.AutoSize = true;
            lblHang.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblHang.ForeColor = Color.FromArgb(71, 85, 105);
            lblHang.Location = new Point(275, 8);
            lblHang.Name = "lblHang";
            lblHang.Size = new Size(111, 13);
            lblHang.TabIndex = 2;
            lblHang.Text = "HẠNG THÀNH VIÊN:";
            // 
            // txtTimKiem
            // 
            txtTimKiem.Location = new Point(12, 24);
            txtTimKiem.Name = "txtTimKiem";
            txtTimKiem.PlaceholderText = "Nhập tên, SĐT hoặc Email...";
            txtTimKiem.Size = new Size(245, 23);
            txtTimKiem.TabIndex = 1;
            // 
            // lblTimKiem
            // 
            lblTimKiem.AutoSize = true;
            lblTimKiem.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTimKiem.ForeColor = Color.FromArgb(71, 85, 105);
            lblTimKiem.Location = new Point(12, 8);
            lblTimKiem.Name = "lblTimKiem";
            lblTimKiem.Size = new Size(130, 13);
            lblTimKiem.TabIndex = 0;
            lblTimKiem.Text = "TÌM KIẾM KHÁCH HÀNG:";
            // 
            // splMain
            // 
            splMain.Dock = DockStyle.Fill;
            splMain.Location = new Point(15, 128);
            splMain.Name = "splMain";
            splMain.Orientation = Orientation.Horizontal;
            // 
            // splMain.Panel1
            // 
            splMain.Panel1.Controls.Add(dgvKhachHang);
            splMain.Panel1.Padding = new Padding(0, 10, 0, 5);
            // 
            // splMain.Panel2
            // 
            splMain.Panel2.Controls.Add(pnlChiTiet);
            splMain.Panel2.Padding = new Padding(0, 5, 0, 0);
            splMain.Size = new Size(950, 457);
            splMain.SplitterDistance = 310;
            splMain.TabIndex = 2;
            // 
            // dgvKhachHang
            // 
            dgvKhachHang.AllowUserToAddRows = false;
            dgvKhachHang.AllowUserToDeleteRows = false;
            dgvKhachHang.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvKhachHang.BackgroundColor = Color.White;
            dgvKhachHang.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvKhachHang.Dock = DockStyle.Fill;
            dgvKhachHang.Location = new Point(0, 10);
            dgvKhachHang.Name = "dgvKhachHang";
            dgvKhachHang.ReadOnly = true;
            dgvKhachHang.RowHeadersVisible = false;
            dgvKhachHang.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvKhachHang.Size = new Size(950, 295);
            dgvKhachHang.TabIndex = 0;
            dgvKhachHang.SelectionChanged += dgvKhachHang_SelectionChanged;
            // 
            // pnlChiTiet
            // 
            pnlChiTiet.BackColor = Color.White;
            pnlChiTiet.BorderStyle = BorderStyle.FixedSingle;
            pnlChiTiet.Controls.Add(lblChiTietKhach);
            pnlChiTiet.Controls.Add(lblChiTietTieuDe);
            pnlChiTiet.Dock = DockStyle.Fill;
            pnlChiTiet.Location = new Point(0, 5);
            pnlChiTiet.Name = "pnlChiTiet";
            pnlChiTiet.Padding = new Padding(12);
            pnlChiTiet.Size = new Size(950, 138);
            pnlChiTiet.TabIndex = 0;
            // 
            // lblChiTietKhach
            // 
            lblChiTietKhach.Dock = DockStyle.Fill;
            lblChiTietKhach.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            lblChiTietKhach.ForeColor = Color.FromArgb(51, 65, 85);
            lblChiTietKhach.Location = new Point(12, 37);
            lblChiTietKhach.Name = "lblChiTietKhach";
            lblChiTietKhach.Size = new Size(924, 87);
            lblChiTietKhach.TabIndex = 1;
            lblChiTietKhach.Text = "Chọn một khách hàng để xem chi tiết lịch sử xem phim và ưu đãi...";
            // 
            // lblChiTietTieuDe
            // 
            lblChiTietTieuDe.Dock = DockStyle.Top;
            lblChiTietTieuDe.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            lblChiTietTieuDe.ForeColor = Color.FromArgb(24, 24, 27);
            lblChiTietTieuDe.Location = new Point(12, 12);
            lblChiTietTieuDe.Name = "lblChiTietTieuDe";
            lblChiTietTieuDe.Size = new Size(924, 25);
            lblChiTietTieuDe.TabIndex = 0;
            lblChiTietTieuDe.Text = "HỒ SƠ KHÁCH HÀNG & LỊCH SỬ XEM PHIM";
            // 
            // UcKhachHang
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(splMain);
            Controls.Add(pnlToolbar);
            Controls.Add(pnlBanner);
            Name = "UcKhachHang";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            pnlToolbar.ResumeLayout(false);
            pnlToolbar.PerformLayout();
            splMain.Panel1.ResumeLayout(false);
            splMain.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splMain).EndInit();
            splMain.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvKhachHang).EndInit();
            pnlChiTiet.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private Panel pnlToolbar;
        private Label lblTimKiem;
        private TextBox txtTimKiem;
        private Label lblHang;
        private ComboBox cboHangThanhVien;
        private Button btnTimKiem;
        private Button btnThemKhachHang;
        private SplitContainer splMain;
        private DataGridView dgvKhachHang;
        private Panel pnlChiTiet;
        private Label lblChiTietTieuDe;
        private Label lblChiTietKhach;
    }
}
