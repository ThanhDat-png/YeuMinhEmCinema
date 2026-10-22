namespace YeuMinhEmCinema.Admin
{
    partial class UcLichChieu
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
            btnSaoChepLich = new Button();
            btnThemSuat = new Button();
            btnLoc = new Button();
            dtpNgayChieu = new DateTimePicker();
            lblNgayChieu = new Label();
            cboPhim = new ComboBox();
            lblPhim = new Label();
            cboRap = new ComboBox();
            lblRap = new Label();
            pnlGrid = new Panel();
            dgvLichChieu = new DataGridView();
            pnlBanner.SuspendLayout();
            pnlToolbar.SuspendLayout();
            pnlGrid.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvLichChieu).BeginInit();
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
            lblTieuDe.Size = new Size(297, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "📅 QUẢN LÝ LỊCH CHIẾU VÀ SUẤT CHIẾU";
            // 
            // pnlToolbar
            // 
            pnlToolbar.BackColor = Color.White;
            pnlToolbar.BorderStyle = BorderStyle.FixedSingle;
            pnlToolbar.Controls.Add(btnSaoChepLich);
            pnlToolbar.Controls.Add(btnThemSuat);
            pnlToolbar.Controls.Add(btnLoc);
            pnlToolbar.Controls.Add(dtpNgayChieu);
            pnlToolbar.Controls.Add(lblNgayChieu);
            pnlToolbar.Controls.Add(cboPhim);
            pnlToolbar.Controls.Add(lblPhim);
            pnlToolbar.Controls.Add(cboRap);
            pnlToolbar.Controls.Add(lblRap);
            pnlToolbar.Dock = DockStyle.Top;
            pnlToolbar.Location = new Point(15, 63);
            pnlToolbar.Name = "pnlToolbar";
            pnlToolbar.Padding = new Padding(10);
            pnlToolbar.Size = new Size(950, 68);
            pnlToolbar.TabIndex = 1;
            // 
            // btnSaoChepLich
            // 
            btnSaoChepLich.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnSaoChepLich.BackColor = Color.FromArgb(71, 85, 105);
            btnSaoChepLich.FlatAppearance.BorderSize = 0;
            btnSaoChepLich.FlatStyle = FlatStyle.Flat;
            btnSaoChepLich.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnSaoChepLich.ForeColor = Color.White;
            btnSaoChepLich.Location = new Point(680, 20);
            btnSaoChepLich.Name = "btnSaoChepLich";
            btnSaoChepLich.Size = new Size(115, 32);
            btnSaoChepLich.TabIndex = 8;
            btnSaoChepLich.Text = "Sao chép ngày";
            btnSaoChepLich.UseVisualStyleBackColor = false;
            btnSaoChepLich.Click += BtnChuaTrienKhai_Click;
            // 
            // btnThemSuat
            // 
            btnThemSuat.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnThemSuat.BackColor = Color.FromArgb(211, 47, 47);
            btnThemSuat.FlatAppearance.BorderSize = 0;
            btnThemSuat.FlatStyle = FlatStyle.Flat;
            btnThemSuat.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemSuat.ForeColor = Color.White;
            btnThemSuat.Location = new Point(805, 20);
            btnThemSuat.Name = "btnThemSuat";
            btnThemSuat.Size = new Size(130, 32);
            btnThemSuat.TabIndex = 7;
            btnThemSuat.Text = "+ Thêm suất chiếu";
            btnThemSuat.UseVisualStyleBackColor = false;
            btnThemSuat.Click += BtnChuaTrienKhai_Click;
            // 
            // btnLoc
            // 
            btnLoc.BackColor = Color.FromArgb(15, 23, 42);
            btnLoc.FlatAppearance.BorderSize = 0;
            btnLoc.FlatStyle = FlatStyle.Flat;
            btnLoc.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnLoc.ForeColor = Color.White;
            btnLoc.Location = new Point(560, 20);
            btnLoc.Name = "btnLoc";
            btnLoc.Size = new Size(80, 32);
            btnLoc.TabIndex = 6;
            btnLoc.Text = "Lọc suất";
            btnLoc.UseVisualStyleBackColor = false;
            btnLoc.Click += btnLoc_Click;
            // 
            // dtpNgayChieu
            // 
            dtpNgayChieu.CustomFormat = "dd/MM/yyyy";
            dtpNgayChieu.Format = DateTimePickerFormat.Custom;
            dtpNgayChieu.Location = new Point(415, 25);
            dtpNgayChieu.Name = "dtpNgayChieu";
            dtpNgayChieu.Size = new Size(130, 23);
            dtpNgayChieu.TabIndex = 5;
            // 
            // lblNgayChieu
            // 
            lblNgayChieu.AutoSize = true;
            lblNgayChieu.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblNgayChieu.ForeColor = Color.FromArgb(71, 85, 105);
            lblNgayChieu.Location = new Point(415, 8);
            lblNgayChieu.Name = "lblNgayChieu";
            lblNgayChieu.Size = new Size(77, 13);
            lblNgayChieu.TabIndex = 4;
            lblNgayChieu.Text = "NGÀY CHIẾU:";
            // 
            // cboPhim
            // 
            cboPhim.DropDownStyle = ComboBoxStyle.DropDownList;
            cboPhim.FormattingEnabled = true;
            cboPhim.Items.AddRange(new object[] { "Tất cả phim", "Đào, Phở và Piano", "Mai", "Lật Mặt 7: Một Điều Ước", "Kung Fu Panda 4", "Dune 2" });
            cboPhim.Location = new Point(205, 25);
            cboPhim.Name = "cboPhim";
            cboPhim.Size = new Size(195, 23);
            cboPhim.TabIndex = 3;
            // 
            // lblPhim
            // 
            lblPhim.AutoSize = true;
            lblPhim.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblPhim.ForeColor = Color.FromArgb(71, 85, 105);
            lblPhim.Location = new Point(205, 8);
            lblPhim.Name = "lblPhim";
            lblPhim.Size = new Size(72, 13);
            lblPhim.TabIndex = 2;
            lblPhim.Text = "CHỌN PHIM:";
            // 
            // cboRap
            // 
            cboRap.DropDownStyle = ComboBoxStyle.DropDownList;
            cboRap.FormattingEnabled = true;
            cboRap.Items.AddRange(new object[] { "Tất cả cụm rạp", "YeuMinhEm Landmark 81", "YeuMinhEm Vincom Đồng Khởi", "YeuMinhEm Thủ Đức" });
            cboRap.Location = new Point(12, 25);
            cboRap.Name = "cboRap";
            cboRap.Size = new Size(180, 23);
            cboRap.TabIndex = 1;
            // 
            // lblRap
            // 
            lblRap.AutoSize = true;
            lblRap.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblRap.ForeColor = Color.FromArgb(71, 85, 105);
            lblRap.Location = new Point(12, 8);
            lblRap.Name = "lblRap";
            lblRap.Size = new Size(67, 13);
            lblRap.TabIndex = 0;
            lblRap.Text = "CỤM RẠP:";
            // 
            // pnlGrid
            // 
            pnlGrid.BackColor = Color.White;
            pnlGrid.BorderStyle = BorderStyle.FixedSingle;
            pnlGrid.Controls.Add(dgvLichChieu);
            pnlGrid.Dock = DockStyle.Fill;
            pnlGrid.Location = new Point(15, 131);
            pnlGrid.Name = "pnlGrid";
            pnlGrid.Padding = new Padding(12);
            pnlGrid.Size = new Size(950, 454);
            pnlGrid.TabIndex = 2;
            // 
            // dgvLichChieu
            // 
            dgvLichChieu.AllowUserToAddRows = false;
            dgvLichChieu.AllowUserToDeleteRows = false;
            dgvLichChieu.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvLichChieu.BackgroundColor = Color.White;
            dgvLichChieu.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvLichChieu.Dock = DockStyle.Fill;
            dgvLichChieu.Location = new Point(12, 12);
            dgvLichChieu.Name = "dgvLichChieu";
            dgvLichChieu.ReadOnly = true;
            dgvLichChieu.RowHeadersVisible = false;
            dgvLichChieu.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvLichChieu.Size = new Size(924, 428);
            dgvLichChieu.TabIndex = 0;
            // 
            // UcLichChieu
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(pnlGrid);
            Controls.Add(pnlToolbar);
            Controls.Add(pnlBanner);
            Name = "UcLichChieu";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            pnlToolbar.ResumeLayout(false);
            pnlToolbar.PerformLayout();
            pnlGrid.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvLichChieu).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private Panel pnlToolbar;
        private Label lblRap;
        private ComboBox cboRap;
        private Label lblPhim;
        private ComboBox cboPhim;
        private Label lblNgayChieu;
        private DateTimePicker dtpNgayChieu;
        private Button btnLoc;
        private Button btnThemSuat;
        private Button btnSaoChepLich;
        private Panel pnlGrid;
        private DataGridView dgvLichChieu;
    }
}
