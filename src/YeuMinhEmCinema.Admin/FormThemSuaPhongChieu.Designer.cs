namespace YeuMinhEmCinema.Admin
{
    partial class FormThemSuaPhongChieu
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
            pnlHeader = new Panel();
            lblTieuDeForm = new Label();
            lblRap = new Label();
            cboRap = new ComboBox();
            lblTenPhong = new Label();
            txtTenPhong = new TextBox();
            lblDinhDang = new Label();
            cboDinhDang = new ComboBox();
            lblTrangThai = new Label();
            cboTrangThai = new ComboBox();
            btnLuu = new Button();
            btnHuy = new Button();
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
            lblTieuDeForm.Size = new Size(207, 20);
            lblTieuDeForm.TabIndex = 0;
            lblTieuDeForm.Text = "🎬 THÊM PHÒNG CHIẾU MỚI";
            // 
            // lblRap
            // 
            lblRap.AutoSize = true;
            lblRap.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblRap.ForeColor = Color.FromArgb(51, 65, 85);
            lblRap.Location = new Point(20, 68);
            lblRap.Name = "lblRap";
            lblRap.Size = new Size(130, 15);
            lblRap.TabIndex = 1;
            lblRap.Text = "THUỘC CỤM RẠP (*):";
            // 
            // cboRap
            // 
            cboRap.DropDownStyle = ComboBoxStyle.DropDownList;
            cboRap.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboRap.FormattingEnabled = true;
            cboRap.Location = new Point(20, 88);
            cboRap.Name = "cboRap";
            cboRap.Size = new Size(440, 25);
            cboRap.TabIndex = 2;
            // 
            // lblTenPhong
            // 
            lblTenPhong.AutoSize = true;
            lblTenPhong.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTenPhong.ForeColor = Color.FromArgb(51, 65, 85);
            lblTenPhong.Location = new Point(20, 126);
            lblTenPhong.Name = "lblTenPhong";
            lblTenPhong.Size = new Size(139, 15);
            lblTenPhong.TabIndex = 3;
            lblTenPhong.Text = "TÊN PHÒNG CHIẾU (*):";
            // 
            // txtTenPhong
            // 
            txtTenPhong.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtTenPhong.Location = new Point(20, 146);
            txtTenPhong.MaxLength = 100;
            txtTenPhong.Name = "txtTenPhong";
            txtTenPhong.PlaceholderText = "Ví dụ: Phòng 01, Cinema 2...";
            txtTenPhong.Size = new Size(440, 25);
            txtTenPhong.TabIndex = 4;
            // 
            // lblDinhDang
            // 
            lblDinhDang.AutoSize = true;
            lblDinhDang.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblDinhDang.ForeColor = Color.FromArgb(51, 65, 85);
            lblDinhDang.Location = new Point(20, 184);
            lblDinhDang.Name = "lblDinhDang";
            lblDinhDang.Size = new Size(125, 15);
            lblDinhDang.TabIndex = 5;
            lblDinhDang.Text = "ĐỊNH DẠNG CHIẾU:";
            // 
            // cboDinhDang
            // 
            cboDinhDang.DropDownStyle = ComboBoxStyle.DropDownList;
            cboDinhDang.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboDinhDang.FormattingEnabled = true;
            cboDinhDang.Items.AddRange(new object[] { "2D Digital", "2D Dolby Atmos", "2D Standard", "3D RealD", "IMAX Laser", "4DX", "ScreenX", "Gold Class" });
            cboDinhDang.Location = new Point(20, 204);
            cboDinhDang.Name = "cboDinhDang";
            cboDinhDang.Size = new Size(440, 25);
            cboDinhDang.TabIndex = 6;
            // 
            // lblTrangThai
            // 
            lblTrangThai.AutoSize = true;
            lblTrangThai.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrangThai.ForeColor = Color.FromArgb(51, 65, 85);
            lblTrangThai.Location = new Point(20, 242);
            lblTrangThai.Name = "lblTrangThai";
            lblTrangThai.Size = new Size(83, 15);
            lblTrangThai.TabIndex = 7;
            lblTrangThai.Text = "TRẠNG THÁI:";
            // 
            // cboTrangThai
            // 
            cboTrangThai.DropDownStyle = ComboBoxStyle.DropDownList;
            cboTrangThai.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboTrangThai.FormattingEnabled = true;
            cboTrangThai.Items.AddRange(new object[] { "Đang hoạt động", "Ngừng hoạt động" });
            cboTrangThai.Location = new Point(20, 262);
            cboTrangThai.Name = "cboTrangThai";
            cboTrangThai.Size = new Size(440, 25);
            cboTrangThai.TabIndex = 8;
            // 
            // btnLuu
            // 
            btnLuu.BackColor = Color.FromArgb(211, 47, 47);
            btnLuu.Cursor = Cursors.Hand;
            btnLuu.FlatAppearance.BorderSize = 0;
            btnLuu.FlatStyle = FlatStyle.Flat;
            btnLuu.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnLuu.ForeColor = Color.White;
            btnLuu.Location = new Point(230, 310);
            btnLuu.Name = "btnLuu";
            btnLuu.Size = new Size(130, 36);
            btnLuu.TabIndex = 9;
            btnLuu.Text = "Lưu phòng";
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
            btnHuy.Location = new Point(370, 310);
            btnHuy.Name = "btnHuy";
            btnHuy.Size = new Size(90, 36);
            btnHuy.TabIndex = 10;
            btnHuy.Text = "Hủy bỏ";
            btnHuy.UseVisualStyleBackColor = false;
            btnHuy.Click += btnHuy_Click;
            // 
            // FormThemSuaPhongChieu
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.White;
            ClientSize = new Size(480, 365);
            Controls.Add(btnHuy);
            Controls.Add(btnLuu);
            Controls.Add(cboTrangThai);
            Controls.Add(lblTrangThai);
            Controls.Add(cboDinhDang);
            Controls.Add(lblDinhDang);
            Controls.Add(txtTenPhong);
            Controls.Add(lblTenPhong);
            Controls.Add(cboRap);
            Controls.Add(lblRap);
            Controls.Add(pnlHeader);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "FormThemSuaPhongChieu";
            StartPosition = FormStartPosition.CenterParent;
            Text = "Quản lý Phòng chiếu";
            pnlHeader.ResumeLayout(false);
            pnlHeader.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel pnlHeader;
        private Label lblTieuDeForm;
        private Label lblRap;
        private ComboBox cboRap;
        private Label lblTenPhong;
        private TextBox txtTenPhong;
        private Label lblDinhDang;
        private ComboBox cboDinhDang;
        private Label lblTrangThai;
        private ComboBox cboTrangThai;
        private Button btnLuu;
        private Button btnHuy;
    }
}
