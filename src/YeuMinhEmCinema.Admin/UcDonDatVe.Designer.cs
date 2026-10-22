namespace YeuMinhEmCinema.Admin
{
    partial class UcDonDatVe
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
            btnInLaiVe = new Button();
            btnChiTiet = new Button();
            btnLoc = new Button();
            cboTrangThai = new ComboBox();
            lblTrangThai = new Label();
            txtTimKiem = new TextBox();
            lblTimKiem = new Label();
            pnlGrid = new Panel();
            dgvDonHang = new DataGridView();
            pnlBanner.SuspendLayout();
            pnlToolbar.SuspendLayout();
            pnlGrid.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvDonHang).BeginInit();
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
            lblTieuDe.Size = new Size(276, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "📑 QUẢN LÝ ĐƠN ĐẶT VÉ VÀ HÓA ĐƠN";
            // 
            // pnlToolbar
            // 
            pnlToolbar.BackColor = Color.White;
            pnlToolbar.BorderStyle = BorderStyle.FixedSingle;
            pnlToolbar.Controls.Add(btnInLaiVe);
            pnlToolbar.Controls.Add(btnChiTiet);
            pnlToolbar.Controls.Add(btnLoc);
            pnlToolbar.Controls.Add(cboTrangThai);
            pnlToolbar.Controls.Add(lblTrangThai);
            pnlToolbar.Controls.Add(txtTimKiem);
            pnlToolbar.Controls.Add(lblTimKiem);
            pnlToolbar.Dock = DockStyle.Top;
            pnlToolbar.Location = new Point(15, 63);
            pnlToolbar.Name = "pnlToolbar";
            pnlToolbar.Padding = new Padding(10);
            pnlToolbar.Size = new Size(950, 65);
            pnlToolbar.TabIndex = 1;
            // 
            // btnInLaiVe
            // 
            btnInLaiVe.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnInLaiVe.BackColor = Color.FromArgb(71, 85, 105);
            btnInLaiVe.FlatAppearance.BorderSize = 0;
            btnInLaiVe.FlatStyle = FlatStyle.Flat;
            btnInLaiVe.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnInLaiVe.ForeColor = Color.White;
            btnInLaiVe.Location = new Point(830, 18);
            btnInLaiVe.Name = "btnInLaiVe";
            btnInLaiVe.Size = new Size(105, 30);
            btnInLaiVe.TabIndex = 6;
            btnInLaiVe.Text = "🖨️ In lại vé";
            btnInLaiVe.UseVisualStyleBackColor = false;
            btnInLaiVe.Click += BtnChuaTrienKhai_Click;
            // 
            // btnChiTiet
            // 
            btnChiTiet.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnChiTiet.BackColor = Color.FromArgb(211, 47, 47);
            btnChiTiet.FlatAppearance.BorderSize = 0;
            btnChiTiet.FlatStyle = FlatStyle.Flat;
            btnChiTiet.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnChiTiet.ForeColor = Color.White;
            btnChiTiet.Location = new Point(700, 18);
            btnChiTiet.Name = "btnChiTiet";
            btnChiTiet.Size = new Size(120, 30);
            btnChiTiet.TabIndex = 5;
            btnChiTiet.Text = "🔍 Xem chi tiết";
            btnChiTiet.UseVisualStyleBackColor = false;
            btnChiTiet.Click += btnChiTiet_Click;
            // 
            // btnLoc
            // 
            btnLoc.BackColor = Color.FromArgb(15, 23, 42);
            btnLoc.FlatAppearance.BorderSize = 0;
            btnLoc.FlatStyle = FlatStyle.Flat;
            btnLoc.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnLoc.ForeColor = Color.White;
            btnLoc.Location = new Point(480, 20);
            btnLoc.Name = "btnLoc";
            btnLoc.Size = new Size(80, 28);
            btnLoc.TabIndex = 4;
            btnLoc.Text = "Tìm kiếm";
            btnLoc.UseVisualStyleBackColor = false;
            btnLoc.Click += btnLoc_Click;
            // 
            // cboTrangThai
            // 
            cboTrangThai.DropDownStyle = ComboBoxStyle.DropDownList;
            cboTrangThai.FormattingEnabled = true;
            cboTrangThai.Items.AddRange(new object[] { "Tất cả trạng thái", "Đã thanh toán", "Đang giữ chỗ", "Đã hủy" });
            cboTrangThai.Location = new Point(275, 24);
            cboTrangThai.Name = "cboTrangThai";
            cboTrangThai.Size = new Size(185, 23);
            cboTrangThai.TabIndex = 3;
            // 
            // lblTrangThai
            // 
            lblTrangThai.AutoSize = true;
            lblTrangThai.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrangThai.ForeColor = Color.FromArgb(71, 85, 105);
            lblTrangThai.Location = new Point(275, 8);
            lblTrangThai.Name = "lblTrangThai";
            lblTrangThai.Size = new Size(76, 13);
            lblTrangThai.TabIndex = 2;
            lblTrangThai.Text = "TRẠNG THÁI:";
            // 
            // txtTimKiem
            // 
            txtTimKiem.Location = new Point(12, 24);
            txtTimKiem.Name = "txtTimKiem";
            txtTimKiem.PlaceholderText = "Nhập mã đơn hoặc SĐT...";
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
            lblTimKiem.Text = "TÌM KIẾM ĐƠN ĐẶT VÉ:";
            // 
            // pnlGrid
            // 
            pnlGrid.BackColor = Color.White;
            pnlGrid.BorderStyle = BorderStyle.FixedSingle;
            pnlGrid.Controls.Add(dgvDonHang);
            pnlGrid.Dock = DockStyle.Fill;
            pnlGrid.Location = new Point(15, 128);
            pnlGrid.Name = "pnlGrid";
            pnlGrid.Padding = new Padding(12);
            pnlGrid.Size = new Size(950, 457);
            pnlGrid.TabIndex = 2;
            // 
            // dgvDonHang
            // 
            dgvDonHang.AllowUserToAddRows = false;
            dgvDonHang.AllowUserToDeleteRows = false;
            dgvDonHang.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvDonHang.BackgroundColor = Color.White;
            dgvDonHang.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvDonHang.Dock = DockStyle.Fill;
            dgvDonHang.Location = new Point(12, 12);
            dgvDonHang.Name = "dgvDonHang";
            dgvDonHang.ReadOnly = true;
            dgvDonHang.RowHeadersVisible = false;
            dgvDonHang.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvDonHang.Size = new Size(924, 431);
            dgvDonHang.TabIndex = 0;
            // 
            // UcDonDatVe
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(pnlGrid);
            Controls.Add(pnlToolbar);
            Controls.Add(pnlBanner);
            Name = "UcDonDatVe";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            pnlToolbar.ResumeLayout(false);
            pnlToolbar.PerformLayout();
            pnlGrid.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvDonHang).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private Panel pnlToolbar;
        private Label lblTimKiem;
        private TextBox txtTimKiem;
        private Label lblTrangThai;
        private ComboBox cboTrangThai;
        private Button btnLoc;
        private Button btnChiTiet;
        private Button btnInLaiVe;
        private Panel pnlGrid;
        private DataGridView dgvDonHang;
    }
}
