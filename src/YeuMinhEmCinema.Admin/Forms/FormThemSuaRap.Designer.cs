namespace YeuMinhEmCinema.Admin
{
    partial class FormThemSuaRap
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

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            lblTieuDeForm = new Label();
            lblTenRap = new Label();
            txtTenRap = new TextBox();
            lblDiaChi = new Label();
            txtDiaChi = new TextBox();
            lblTrangThai = new Label();
            cboTrangThai = new ComboBox();
            btnLuu = new Button();
            btnHuy = new Button();
            pnlHeader = new Panel();
            pnlHeader.SuspendLayout();
            SuspendLayout();
            // 
            // pnlHeader
            // 
            pnlHeader.BackColor = Color.FromArgb(20, 20, 26);
            pnlHeader.Controls.Add(lblTieuDeForm);
            pnlHeader.Dock = DockStyle.Top;
            pnlHeader.Location = new Point(0, 0);
            pnlHeader.Name = "pnlHeader";
            pnlHeader.Size = new Size(480, 50);
            pnlHeader.TabIndex = 0;
            // 
            // lblTieuDeForm
            // 
            lblTieuDeForm.AutoSize = true;
            lblTieuDeForm.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTieuDeForm.ForeColor = Color.White;
            lblTieuDeForm.Location = new Point(16, 15);
            lblTieuDeForm.Name = "lblTieuDeForm";
            lblTieuDeForm.Size = new Size(185, 20);
            lblTieuDeForm.TabIndex = 0;
            lblTieuDeForm.Text = "🏛️ THÊM CỤM RẠP MỚI";
            // 
            // lblTenRap
            // 
            lblTenRap.AutoSize = true;
            lblTenRap.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTenRap.ForeColor = Color.FromArgb(51, 65, 85);
            lblTenRap.Location = new Point(20, 68);
            lblTenRap.Name = "lblTenRap";
            lblTenRap.Size = new Size(111, 15);
            lblTenRap.TabIndex = 1;
            lblTenRap.Text = "TÊN CỤM RẠP (*):";
            // 
            // txtTenRap
            // 
            txtTenRap.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtTenRap.Location = new Point(20, 88);
            txtTenRap.MaxLength = 200;
            txtTenRap.Name = "txtTenRap";
            txtTenRap.PlaceholderText = "Ví dụ: Cụm rạp YeuMinhEm Landmark 81...";
            txtTenRap.Size = new Size(440, 25);
            txtTenRap.TabIndex = 2;
            // 
            // lblDiaChi
            // 
            lblDiaChi.AutoSize = true;
            lblDiaChi.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblDiaChi.ForeColor = Color.FromArgb(51, 65, 85);
            lblDiaChi.Location = new Point(20, 126);
            lblDiaChi.Name = "lblDiaChi";
            lblDiaChi.Size = new Size(84, 15);
            lblDiaChi.TabIndex = 3;
            lblDiaChi.Text = "ĐỊA CHỈ RẠP:";
            // 
            // txtDiaChi
            // 
            txtDiaChi.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtDiaChi.Location = new Point(20, 146);
            txtDiaChi.MaxLength = 500;
            txtDiaChi.Multiline = true;
            txtDiaChi.Name = "txtDiaChi";
            txtDiaChi.PlaceholderText = "Nhập địa chỉ chi tiết cụm rạp...";
            txtDiaChi.ScrollBars = ScrollBars.Vertical;
            txtDiaChi.Size = new Size(440, 60);
            txtDiaChi.TabIndex = 4;
            // 
            // lblTrangThai
            // 
            lblTrangThai.AutoSize = true;
            lblTrangThai.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrangThai.ForeColor = Color.FromArgb(51, 65, 85);
            lblTrangThai.Location = new Point(20, 218);
            lblTrangThai.Name = "lblTrangThai";
            lblTrangThai.Size = new Size(83, 15);
            lblTrangThai.TabIndex = 5;
            lblTrangThai.Text = "TRẠNG THÁI:";
            // 
            // cboTrangThai
            // 
            cboTrangThai.DropDownStyle = ComboBoxStyle.DropDownList;
            cboTrangThai.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboTrangThai.FormattingEnabled = true;
            cboTrangThai.Items.AddRange(new object[] { "Đang hoạt động", "Ngừng hoạt động" });
            cboTrangThai.Location = new Point(20, 238);
            cboTrangThai.Name = "cboTrangThai";
            cboTrangThai.Size = new Size(440, 25);
            cboTrangThai.TabIndex = 6;
            // 
            // btnLuu
            // 
            btnLuu.BackColor = Color.FromArgb(211, 47, 47);
            btnLuu.Cursor = Cursors.Hand;
            btnLuu.FlatAppearance.BorderSize = 0;
            btnLuu.FlatStyle = FlatStyle.Flat;
            btnLuu.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnLuu.ForeColor = Color.White;
            btnLuu.Location = new Point(250, 285);
            btnLuu.Name = "btnLuu";
            btnLuu.Size = new Size(110, 36);
            btnLuu.TabIndex = 7;
            btnLuu.Text = "Lưu cụm rạp";
            btnLuu.UseVisualStyleBackColor = false;
            btnLuu.Click += btnLuu_Click;
            // 
            // btnHuy
            // 
            btnHuy.BackColor = Color.FromArgb(241, 245, 249);
            btnHuy.Cursor = Cursors.Hand;
            btnHuy.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnHuy.FlatStyle = FlatStyle.Flat;
            btnHuy.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            btnHuy.ForeColor = Color.FromArgb(71, 85, 105);
            btnHuy.Location = new Point(370, 285);
            btnHuy.Name = "btnHuy";
            btnHuy.Size = new Size(90, 36);
            btnHuy.TabIndex = 8;
            btnHuy.Text = "Hủy bỏ";
            btnHuy.UseVisualStyleBackColor = false;
            btnHuy.Click += btnHuy_Click;
            // 
            // FormThemSuaRap
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.White;
            ClientSize = new Size(480, 340);
            Controls.Add(btnHuy);
            Controls.Add(btnLuu);
            Controls.Add(cboTrangThai);
            Controls.Add(lblTrangThai);
            Controls.Add(txtDiaChi);
            Controls.Add(lblDiaChi);
            Controls.Add(txtTenRap);
            Controls.Add(lblTenRap);
            Controls.Add(pnlHeader);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "FormThemSuaRap";
            StartPosition = FormStartPosition.CenterParent;
            Text = "Quản lý Cụm rạp";
            pnlHeader.ResumeLayout(false);
            pnlHeader.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel pnlHeader;
        private Label lblTieuDeForm;
        private Label lblTenRap;
        private TextBox txtTenRap;
        private Label lblDiaChi;
        private TextBox txtDiaChi;
        private Label lblTrangThai;
        private ComboBox cboTrangThai;
        private Button btnLuu;
        private Button btnHuy;
    }
}
