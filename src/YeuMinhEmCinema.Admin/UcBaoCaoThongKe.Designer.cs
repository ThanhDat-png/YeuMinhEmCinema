namespace YeuMinhEmCinema.Admin
{
    partial class UcBaoCaoThongKe
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
            btnInBaoCao = new Button();
            btnXuatExcel = new Button();
            btnXemBaoCao = new Button();
            cboLoaiBaoCao = new ComboBox();
            lblLoaiBaoCao = new Label();
            dtpDenNgay = new DateTimePicker();
            lblDenNgay = new Label();
            dtpTuNgay = new DateTimePicker();
            lblTuNgay = new Label();
            tblKpi = new TableLayoutPanel();
            pnlKpi1 = new Panel();
            lblKpi1Value = new Label();
            lblKpi1Title = new Label();
            pnlKpi2 = new Panel();
            lblKpi2Value = new Label();
            lblKpi2Title = new Label();
            pnlKpi3 = new Panel();
            lblKpi3Value = new Label();
            lblKpi3Title = new Label();
            pnlKpi4 = new Panel();
            lblKpi4Value = new Label();
            lblKpi4Title = new Label();
            pnlGrid = new Panel();
            dgvBaoCao = new DataGridView();
            pnlBanner.SuspendLayout();
            pnlToolbar.SuspendLayout();
            tblKpi.SuspendLayout();
            pnlKpi1.SuspendLayout();
            pnlKpi2.SuspendLayout();
            pnlKpi3.SuspendLayout();
            pnlKpi4.SuspendLayout();
            pnlGrid.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvBaoCao).BeginInit();
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
            lblTieuDe.Text = "📈 BÁO CÁO DOANH THU VÀ THỐNG KÊ";
            // 
            // pnlToolbar
            // 
            pnlToolbar.BackColor = Color.White;
            pnlToolbar.BorderStyle = BorderStyle.FixedSingle;
            pnlToolbar.Controls.Add(btnInBaoCao);
            pnlToolbar.Controls.Add(btnXuatExcel);
            pnlToolbar.Controls.Add(btnXemBaoCao);
            pnlToolbar.Controls.Add(cboLoaiBaoCao);
            pnlToolbar.Controls.Add(lblLoaiBaoCao);
            pnlToolbar.Controls.Add(dtpDenNgay);
            pnlToolbar.Controls.Add(lblDenNgay);
            pnlToolbar.Controls.Add(dtpTuNgay);
            pnlToolbar.Controls.Add(lblTuNgay);
            pnlToolbar.Dock = DockStyle.Top;
            pnlToolbar.Location = new Point(15, 63);
            pnlToolbar.Name = "pnlToolbar";
            pnlToolbar.Padding = new Padding(10);
            pnlToolbar.Size = new Size(950, 68);
            pnlToolbar.TabIndex = 1;
            // 
            // btnInBaoCao
            // 
            btnInBaoCao.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnInBaoCao.BackColor = Color.FromArgb(71, 85, 105);
            btnInBaoCao.FlatAppearance.BorderSize = 0;
            btnInBaoCao.FlatStyle = FlatStyle.Flat;
            btnInBaoCao.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnInBaoCao.ForeColor = Color.White;
            btnInBaoCao.Location = new Point(830, 20);
            btnInBaoCao.Name = "btnInBaoCao";
            btnInBaoCao.Size = new Size(105, 32);
            btnInBaoCao.TabIndex = 8;
            btnInBaoCao.Text = "🖨️ In báo cáo";
            btnInBaoCao.UseVisualStyleBackColor = false;
            btnInBaoCao.Click += BtnChuaTrienKhai_Click;
            // 
            // btnXuatExcel
            // 
            btnXuatExcel.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnXuatExcel.BackColor = Color.FromArgb(16, 185, 129);
            btnXuatExcel.FlatAppearance.BorderSize = 0;
            btnXuatExcel.FlatStyle = FlatStyle.Flat;
            btnXuatExcel.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnXuatExcel.ForeColor = Color.White;
            btnXuatExcel.Location = new Point(715, 20);
            btnXuatExcel.Name = "btnXuatExcel";
            btnXuatExcel.Size = new Size(110, 32);
            btnXuatExcel.TabIndex = 7;
            btnXuatExcel.Text = "📊 Xuất Excel";
            btnXuatExcel.UseVisualStyleBackColor = false;
            btnXuatExcel.Click += BtnChuaTrienKhai_Click;
            // 
            // btnXemBaoCao
            // 
            btnXemBaoCao.BackColor = Color.FromArgb(211, 47, 47);
            btnXemBaoCao.FlatAppearance.BorderSize = 0;
            btnXemBaoCao.FlatStyle = FlatStyle.Flat;
            btnXemBaoCao.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnXemBaoCao.ForeColor = Color.White;
            btnXemBaoCao.Location = new Point(570, 20);
            btnXemBaoCao.Name = "btnXemBaoCao";
            btnXemBaoCao.Size = new Size(100, 32);
            btnXemBaoCao.TabIndex = 6;
            btnXemBaoCao.Text = "Xem báo cáo";
            btnXemBaoCao.UseVisualStyleBackColor = false;
            btnXemBaoCao.Click += btnXemBaoCao_Click;
            // 
            // cboLoaiBaoCao
            // 
            cboLoaiBaoCao.DropDownStyle = ComboBoxStyle.DropDownList;
            cboLoaiBaoCao.FormattingEnabled = true;
            cboLoaiBaoCao.Items.AddRange(new object[] { "Doanh thu theo phim", "Doanh thu theo ngày", "Doanh thu theo cụm rạp", "Doanh số F&B và Combo" });
            cboLoaiBaoCao.Location = new Point(310, 25);
            cboLoaiBaoCao.Name = "cboLoaiBaoCao";
            cboLoaiBaoCao.Size = new Size(230, 23);
            cboLoaiBaoCao.TabIndex = 5;
            // 
            // lblLoaiBaoCao
            // 
            lblLoaiBaoCao.AutoSize = true;
            lblLoaiBaoCao.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblLoaiBaoCao.ForeColor = Color.FromArgb(71, 85, 105);
            lblLoaiBaoCao.Location = new Point(310, 8);
            lblLoaiBaoCao.Name = "lblLoaiBaoCao";
            lblLoaiBaoCao.Size = new Size(89, 13);
            lblLoaiBaoCao.TabIndex = 4;
            lblLoaiBaoCao.Text = "LOẠI BÁO CÁO:";
            // 
            // dtpDenNgay
            // 
            dtpDenNgay.CustomFormat = "dd/MM/yyyy";
            dtpDenNgay.Format = DateTimePickerFormat.Custom;
            dtpDenNgay.Location = new Point(160, 25);
            dtpDenNgay.Name = "dtpDenNgay";
            dtpDenNgay.Size = new Size(130, 23);
            dtpDenNgay.TabIndex = 3;
            // 
            // lblDenNgay
            // 
            lblDenNgay.AutoSize = true;
            lblDenNgay.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblDenNgay.ForeColor = Color.FromArgb(71, 85, 105);
            lblDenNgay.Location = new Point(160, 8);
            lblDenNgay.Name = "lblDenNgay";
            lblDenNgay.Size = new Size(64, 13);
            lblDenNgay.TabIndex = 2;
            lblDenNgay.Text = "ĐẾN NGÀY:";
            // 
            // dtpTuNgay
            // 
            dtpTuNgay.CustomFormat = "dd/MM/yyyy";
            dtpTuNgay.Format = DateTimePickerFormat.Custom;
            dtpTuNgay.Location = new Point(12, 25);
            dtpTuNgay.Name = "dtpTuNgay";
            dtpTuNgay.Size = new Size(130, 23);
            dtpTuNgay.TabIndex = 1;
            // 
            // lblTuNgay
            // 
            lblTuNgay.AutoSize = true;
            lblTuNgay.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTuNgay.ForeColor = Color.FromArgb(71, 85, 105);
            lblTuNgay.Location = new Point(12, 8);
            lblTuNgay.Name = "lblTuNgay";
            lblTuNgay.Size = new Size(57, 13);
            lblTuNgay.TabIndex = 0;
            lblTuNgay.Text = "TỪ NGÀY:";
            // 
            // tblKpi
            // 
            tblKpi.ColumnCount = 4;
            tblKpi.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 25F));
            tblKpi.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 25F));
            tblKpi.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 25F));
            tblKpi.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 25F));
            tblKpi.Controls.Add(pnlKpi1, 0, 0);
            tblKpi.Controls.Add(pnlKpi2, 1, 0);
            tblKpi.Controls.Add(pnlKpi3, 2, 0);
            tblKpi.Controls.Add(pnlKpi4, 3, 0);
            tblKpi.Dock = DockStyle.Top;
            tblKpi.Location = new Point(15, 131);
            tblKpi.Name = "tblKpi";
            tblKpi.Padding = new Padding(0, 8, 0, 8);
            tblKpi.RowCount = 1;
            tblKpi.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblKpi.Size = new Size(950, 85);
            tblKpi.TabIndex = 2;
            // 
            // pnlKpi1
            // 
            pnlKpi1.BackColor = Color.White;
            pnlKpi1.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi1.Controls.Add(lblKpi1Value);
            pnlKpi1.Controls.Add(lblKpi1Title);
            pnlKpi1.Dock = DockStyle.Fill;
            pnlKpi1.Location = new Point(3, 11);
            pnlKpi1.Margin = new Padding(3, 3, 8, 3);
            pnlKpi1.Name = "pnlKpi1";
            pnlKpi1.Size = new Size(226, 63);
            pnlKpi1.TabIndex = 0;
            // 
            // lblKpi1Value
            // 
            lblKpi1Value.AutoSize = true;
            lblKpi1Value.Font = new Font("Segoe UI", 12.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi1Value.ForeColor = Color.FromArgb(211, 47, 47);
            lblKpi1Value.Location = new Point(12, 28);
            lblKpi1Value.Name = "lblKpi1Value";
            lblKpi1Value.Size = new Size(136, 23);
            lblKpi1Value.TabIndex = 1;
            lblKpi1Value.Text = "248.500.000 đ";
            // 
            // lblKpi1Title
            // 
            lblKpi1Title.AutoSize = true;
            lblKpi1Title.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi1Title.ForeColor = Color.Gray;
            lblKpi1Title.Location = new Point(12, 10);
            lblKpi1Title.Name = "lblKpi1Title";
            lblKpi1Title.Size = new Size(131, 13);
            lblKpi1Title.TabIndex = 0;
            lblKpi1Title.Text = "TỔNG DOANH THU KỲ NÀY";
            // 
            // pnlKpi2
            // 
            pnlKpi2.BackColor = Color.White;
            pnlKpi2.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi2.Controls.Add(lblKpi2Value);
            pnlKpi2.Controls.Add(lblKpi2Title);
            pnlKpi2.Dock = DockStyle.Fill;
            pnlKpi2.Location = new Point(240, 11);
            pnlKpi2.Margin = new Padding(3, 3, 8, 3);
            pnlKpi2.Name = "pnlKpi2";
            pnlKpi2.Size = new Size(226, 63);
            pnlKpi2.TabIndex = 1;
            // 
            // lblKpi2Value
            // 
            lblKpi2Value.AutoSize = true;
            lblKpi2Value.Font = new Font("Segoe UI", 12.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi2Value.ForeColor = Color.FromArgb(24, 24, 27);
            lblKpi2Value.Location = new Point(12, 28);
            lblKpi2Value.Name = "lblKpi2Value";
            lblKpi2Value.Size = new Size(84, 23);
            lblKpi2Value.TabIndex = 1;
            lblKpi2Value.Text = "2.840 vé";
            // 
            // lblKpi2Title
            // 
            lblKpi2Title.AutoSize = true;
            lblKpi2Title.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi2Title.ForeColor = Color.Gray;
            lblKpi2Title.Location = new Point(12, 10);
            lblKpi2Title.Name = "lblKpi2Title";
            lblKpi2Title.Size = new Size(88, 13);
            lblKpi2Title.TabIndex = 0;
            lblKpi2Title.Text = "TỔNG VÉ ĐÃ BÁN";
            // 
            // pnlKpi3
            // 
            pnlKpi3.BackColor = Color.White;
            pnlKpi3.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi3.Controls.Add(lblKpi3Value);
            pnlKpi3.Controls.Add(lblKpi3Title);
            pnlKpi3.Dock = DockStyle.Fill;
            pnlKpi3.Location = new Point(477, 11);
            pnlKpi3.Margin = new Padding(3, 3, 8, 3);
            pnlKpi3.Name = "pnlKpi3";
            pnlKpi3.Size = new Size(226, 63);
            pnlKpi3.TabIndex = 2;
            // 
            // lblKpi3Value
            // 
            lblKpi3Value.AutoSize = true;
            lblKpi3Value.Font = new Font("Segoe UI", 12.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi3Value.ForeColor = Color.FromArgb(24, 24, 27);
            lblKpi3Value.Location = new Point(12, 28);
            lblKpi3Value.Name = "lblKpi3Value";
            lblKpi3Value.Size = new Size(116, 23);
            lblKpi3Value.TabIndex = 1;
            lblKpi3Value.Text = "68.200.000 đ";
            // 
            // lblKpi3Title
            // 
            lblKpi3Title.AutoSize = true;
            lblKpi3Title.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi3Title.ForeColor = Color.Gray;
            lblKpi3Title.Location = new Point(12, 10);
            lblKpi3Title.Name = "lblKpi3Title";
            lblKpi3Title.Size = new Size(102, 13);
            lblKpi3Title.TabIndex = 0;
            lblKpi3Title.Text = "DOANH THU F&&B";
            // 
            // pnlKpi4
            // 
            pnlKpi4.BackColor = Color.White;
            pnlKpi4.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi4.Controls.Add(lblKpi4Value);
            pnlKpi4.Controls.Add(lblKpi4Title);
            pnlKpi4.Dock = DockStyle.Fill;
            pnlKpi4.Location = new Point(714, 11);
            pnlKpi4.Name = "pnlKpi4";
            pnlKpi4.Size = new Size(233, 63);
            pnlKpi4.TabIndex = 3;
            // 
            // lblKpi4Value
            // 
            lblKpi4Value.AutoSize = true;
            lblKpi4Value.Font = new Font("Segoe UI", 12.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi4Value.ForeColor = Color.FromArgb(16, 185, 129);
            lblKpi4Value.Location = new Point(12, 28);
            lblKpi4Value.Name = "lblKpi4Value";
            lblKpi4Value.Size = new Size(95, 23);
            lblKpi4Value.TabIndex = 1;
            lblKpi4Value.Text = "142 suất";
            // 
            // lblKpi4Title
            // 
            lblKpi4Title.AutoSize = true;
            lblKpi4Title.Font = new Font("Segoe UI", 8.25F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi4Title.ForeColor = Color.Gray;
            lblKpi4Title.Location = new Point(12, 10);
            lblKpi4Title.Name = "lblKpi4Title";
            lblKpi4Title.Size = new Size(130, 13);
            lblKpi4Title.TabIndex = 0;
            lblKpi4Title.Text = "TỔNG SUẤT CHIẾU PHÒNG";
            // 
            // pnlGrid
            // 
            pnlGrid.BackColor = Color.White;
            pnlGrid.BorderStyle = BorderStyle.FixedSingle;
            pnlGrid.Controls.Add(dgvBaoCao);
            pnlGrid.Dock = DockStyle.Fill;
            pnlGrid.Location = new Point(15, 216);
            pnlGrid.Name = "pnlGrid";
            pnlGrid.Padding = new Padding(12);
            pnlGrid.Size = new Size(950, 369);
            pnlGrid.TabIndex = 3;
            // 
            // dgvBaoCao
            // 
            dgvBaoCao.AllowUserToAddRows = false;
            dgvBaoCao.AllowUserToDeleteRows = false;
            dgvBaoCao.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvBaoCao.BackgroundColor = Color.White;
            dgvBaoCao.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvBaoCao.Dock = DockStyle.Fill;
            dgvBaoCao.Location = new Point(12, 12);
            dgvBaoCao.Name = "dgvBaoCao";
            dgvBaoCao.ReadOnly = true;
            dgvBaoCao.RowHeadersVisible = false;
            dgvBaoCao.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvBaoCao.Size = new Size(924, 343);
            dgvBaoCao.TabIndex = 0;
            // 
            // UcBaoCaoThongKe
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(pnlGrid);
            Controls.Add(tblKpi);
            Controls.Add(pnlToolbar);
            Controls.Add(pnlBanner);
            Name = "UcBaoCaoThongKe";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            pnlToolbar.ResumeLayout(false);
            pnlToolbar.PerformLayout();
            tblKpi.ResumeLayout(false);
            pnlKpi1.ResumeLayout(false);
            pnlKpi1.PerformLayout();
            pnlKpi2.ResumeLayout(false);
            pnlKpi2.PerformLayout();
            pnlKpi3.ResumeLayout(false);
            pnlKpi3.PerformLayout();
            pnlKpi4.ResumeLayout(false);
            pnlKpi4.PerformLayout();
            pnlGrid.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvBaoCao).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private Panel pnlToolbar;
        private Label lblTuNgay;
        private DateTimePicker dtpTuNgay;
        private Label lblDenNgay;
        private DateTimePicker dtpDenNgay;
        private Label lblLoaiBaoCao;
        private ComboBox cboLoaiBaoCao;
        private Button btnXemBaoCao;
        private Button btnXuatExcel;
        private Button btnInBaoCao;
        private TableLayoutPanel tblKpi;
        private Panel pnlKpi1;
        private Label lblKpi1Title;
        private Label lblKpi1Value;
        private Panel pnlKpi2;
        private Label lblKpi2Title;
        private Label lblKpi2Value;
        private Panel pnlKpi3;
        private Label lblKpi3Title;
        private Label lblKpi3Value;
        private Panel pnlKpi4;
        private Label lblKpi4Title;
        private Label lblKpi4Value;
        private Panel pnlGrid;
        private DataGridView dgvBaoCao;
    }
}
