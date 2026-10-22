namespace YeuMinhEmCinema.Admin
{
    partial class UcGiaVeVaFnb
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
            tabMain = new TabControl();
            tabGiaVe = new TabPage();
            dgvGiaVe = new DataGridView();
            pnlToolbarVe = new Panel();
            btnCapNhatGiaVe = new Button();
            tabFnb = new TabPage();
            dgvFnb = new DataGridView();
            pnlToolbarFnb = new Panel();
            btnThemFnb = new Button();
            pnlBanner.SuspendLayout();
            tabMain.SuspendLayout();
            tabGiaVe.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvGiaVe).BeginInit();
            pnlToolbarVe.SuspendLayout();
            tabFnb.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvFnb).BeginInit();
            pnlToolbarFnb.SuspendLayout();
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
            lblTieuDe.Size = new Size(307, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "🍿 QUẢN LÝ BẢNG GIÁ VÉ VÀ MENU F&B";
            // 
            // tabMain
            // 
            tabMain.Controls.Add(tabGiaVe);
            tabMain.Controls.Add(tabFnb);
            tabMain.Dock = DockStyle.Fill;
            tabMain.Font = new Font("Segoe UI", 10F, FontStyle.Regular, GraphicsUnit.Point);
            tabMain.Location = new Point(15, 63);
            tabMain.Name = "tabMain";
            tabMain.SelectedIndex = 0;
            tabMain.Size = new Size(950, 522);
            tabMain.TabIndex = 1;
            // 
            // tabGiaVe
            // 
            tabGiaVe.Controls.Add(dgvGiaVe);
            tabGiaVe.Controls.Add(pnlToolbarVe);
            tabGiaVe.Location = new Point(4, 26);
            tabGiaVe.Name = "tabGiaVe";
            tabGiaVe.Padding = new Padding(10);
            tabGiaVe.Size = new Size(942, 492);
            tabGiaVe.TabIndex = 0;
            tabGiaVe.Text = "🎟️ Bảng giá vé rạp";
            tabGiaVe.UseVisualStyleBackColor = true;
            // 
            // dgvGiaVe
            // 
            dgvGiaVe.AllowUserToAddRows = false;
            dgvGiaVe.AllowUserToDeleteRows = false;
            dgvGiaVe.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvGiaVe.BackgroundColor = Color.White;
            dgvGiaVe.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvGiaVe.Dock = DockStyle.Fill;
            dgvGiaVe.Location = new Point(10, 55);
            dgvGiaVe.Name = "dgvGiaVe";
            dgvGiaVe.ReadOnly = true;
            dgvGiaVe.RowHeadersVisible = false;
            dgvGiaVe.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvGiaVe.Size = new Size(922, 427);
            dgvGiaVe.TabIndex = 1;
            // 
            // pnlToolbarVe
            // 
            pnlToolbarVe.Controls.Add(btnCapNhatGiaVe);
            pnlToolbarVe.Dock = DockStyle.Top;
            pnlToolbarVe.Location = new Point(10, 10);
            pnlToolbarVe.Name = "pnlToolbarVe";
            pnlToolbarVe.Size = new Size(922, 45);
            pnlToolbarVe.TabIndex = 0;
            // 
            // btnCapNhatGiaVe
            // 
            btnCapNhatGiaVe.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnCapNhatGiaVe.BackColor = Color.FromArgb(211, 47, 47);
            btnCapNhatGiaVe.FlatAppearance.BorderSize = 0;
            btnCapNhatGiaVe.FlatStyle = FlatStyle.Flat;
            btnCapNhatGiaVe.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnCapNhatGiaVe.ForeColor = Color.White;
            btnCapNhatGiaVe.Location = new Point(782, 5);
            btnCapNhatGiaVe.Name = "btnCapNhatGiaVe";
            btnCapNhatGiaVe.Size = new Size(135, 34);
            btnCapNhatGiaVe.TabIndex = 0;
            btnCapNhatGiaVe.Text = "+ Cập nhật giá vé";
            btnCapNhatGiaVe.UseVisualStyleBackColor = false;
            btnCapNhatGiaVe.Click += BtnChuaTrienKhai_Click;
            // 
            // tabFnb
            // 
            tabFnb.Controls.Add(dgvFnb);
            tabFnb.Controls.Add(pnlToolbarFnb);
            tabFnb.Location = new Point(4, 26);
            tabFnb.Name = "tabFnb";
            tabFnb.Padding = new Padding(10);
            tabFnb.Size = new Size(942, 492);
            tabFnb.TabIndex = 1;
            tabFnb.Text = "🍿 Menu Bắp, Nước & Combo F&B";
            tabFnb.UseVisualStyleBackColor = true;
            // 
            // dgvFnb
            // 
            dgvFnb.AllowUserToAddRows = false;
            dgvFnb.AllowUserToDeleteRows = false;
            dgvFnb.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvFnb.BackgroundColor = Color.White;
            dgvFnb.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvFnb.Dock = DockStyle.Fill;
            dgvFnb.Location = new Point(10, 55);
            dgvFnb.Name = "dgvFnb";
            dgvFnb.ReadOnly = true;
            dgvFnb.RowHeadersVisible = false;
            dgvFnb.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvFnb.Size = new Size(922, 427);
            dgvFnb.TabIndex = 1;
            // 
            // pnlToolbarFnb
            // 
            pnlToolbarFnb.Controls.Add(btnThemFnb);
            pnlToolbarFnb.Dock = DockStyle.Top;
            pnlToolbarFnb.Location = new Point(10, 10);
            pnlToolbarFnb.Name = "pnlToolbarFnb";
            pnlToolbarFnb.Size = new Size(922, 45);
            pnlToolbarFnb.TabIndex = 0;
            // 
            // btnThemFnb
            // 
            btnThemFnb.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnThemFnb.BackColor = Color.FromArgb(211, 47, 47);
            btnThemFnb.FlatAppearance.BorderSize = 0;
            btnThemFnb.FlatStyle = FlatStyle.Flat;
            btnThemFnb.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemFnb.ForeColor = Color.White;
            btnThemFnb.Location = new Point(782, 5);
            btnThemFnb.Name = "btnThemFnb";
            btnThemFnb.Size = new Size(135, 34);
            btnThemFnb.TabIndex = 0;
            btnThemFnb.Text = "+ Thêm sản phẩm";
            btnThemFnb.UseVisualStyleBackColor = false;
            btnThemFnb.Click += BtnChuaTrienKhai_Click;
            // 
            // UcGiaVeVaFnb
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(tabMain);
            Controls.Add(pnlBanner);
            Name = "UcGiaVeVaFnb";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            tabMain.ResumeLayout(false);
            tabGiaVe.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvGiaVe).EndInit();
            pnlToolbarVe.ResumeLayout(false);
            tabFnb.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvFnb).EndInit();
            pnlToolbarFnb.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private TabControl tabMain;
        private TabPage tabGiaVe;
        private DataGridView dgvGiaVe;
        private Panel pnlToolbarVe;
        private Button btnCapNhatGiaVe;
        private TabPage tabFnb;
        private DataGridView dgvFnb;
        private Panel pnlToolbarFnb;
        private Button btnThemFnb;
    }
}
