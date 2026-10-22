namespace YeuMinhEmCinema.Admin
{
    partial class FormThemSuaPhim
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
            pnlNoiDung = new Panel();
            txtMoTa = new TextBox();
            lblMoTa = new Label();
            txtTrailer = new TextBox();
            lblTrailer = new Label();
            txtPoster = new TextBox();
            lblPoster = new Label();
            cboTrangThai = new ComboBox();
            lblTrangThai = new Label();
            cboGioiHanTuoi = new ComboBox();
            lblGioiHanTuoi = new Label();
            dtpNgayKhoiChieu = new DateTimePicker();
            lblNgayKhoiChieu = new Label();
            numThoiLuong = new NumericUpDown();
            lblThoiLuong = new Label();
            txtTenPhim = new TextBox();
            lblTenPhim = new Label();
            pnlFooter = new Panel();
            btnHuy = new Button();
            btnLuu = new Button();
            pnlHeader.SuspendLayout();
            pnlNoiDung.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)numThoiLuong).BeginInit();
            pnlFooter.SuspendLayout();
            SuspendLayout();
            // 
            // pnlHeader
            // 
            pnlHeader.BackColor = Color.FromArgb(20, 20, 28);
            pnlHeader.Controls.Add(lblTieuDeForm);
            pnlHeader.Dock = DockStyle.Top;
            pnlHeader.Location = new Point(0, 0);
            pnlHeader.Name = "pnlHeader";
            pnlHeader.Size = new Size(584, 55);
            pnlHeader.TabIndex = 0;
            // 
            // lblTieuDeForm
            // 
            lblTieuDeForm.AutoSize = true;
            lblTieuDeForm.Font = new Font("Segoe UI", 12F, FontStyle.Bold, GraphicsUnit.Point);
            lblTieuDeForm.ForeColor = Color.White;
            lblTieuDeForm.Location = new Point(20, 16);
            lblTieuDeForm.Name = "lblTieuDeForm";
            lblTieuDeForm.Size = new Size(130, 21);
            lblTieuDeForm.TabIndex = 0;
            lblTieuDeForm.Text = "Thêm phim mới";
            // 
            // pnlNoiDung
            // 
            pnlNoiDung.AutoScroll = true;
            pnlNoiDung.BackColor = Color.White;
            pnlNoiDung.Controls.Add(txtMoTa);
            pnlNoiDung.Controls.Add(lblMoTa);
            pnlNoiDung.Controls.Add(txtTrailer);
            pnlNoiDung.Controls.Add(lblTrailer);
            pnlNoiDung.Controls.Add(txtPoster);
            pnlNoiDung.Controls.Add(lblPoster);
            pnlNoiDung.Controls.Add(cboTrangThai);
            pnlNoiDung.Controls.Add(lblTrangThai);
            pnlNoiDung.Controls.Add(cboGioiHanTuoi);
            pnlNoiDung.Controls.Add(lblGioiHanTuoi);
            pnlNoiDung.Controls.Add(dtpNgayKhoiChieu);
            pnlNoiDung.Controls.Add(lblNgayKhoiChieu);
            pnlNoiDung.Controls.Add(numThoiLuong);
            pnlNoiDung.Controls.Add(lblThoiLuong);
            pnlNoiDung.Controls.Add(txtTenPhim);
            pnlNoiDung.Controls.Add(lblTenPhim);
            pnlNoiDung.Dock = DockStyle.Fill;
            pnlNoiDung.Location = new Point(0, 55);
            pnlNoiDung.Name = "pnlNoiDung";
            pnlNoiDung.Padding = new Padding(20);
            pnlNoiDung.Size = new Size(584, 465);
            pnlNoiDung.TabIndex = 1;
            // 
            // txtMoTa
            // 
            txtMoTa.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtMoTa.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtMoTa.Location = new Point(24, 340);
            txtMoTa.Multiline = true;
            txtMoTa.Name = "txtMoTa";
            txtMoTa.ScrollBars = ScrollBars.Vertical;
            txtMoTa.Size = new Size(535, 100);
            txtMoTa.TabIndex = 15;
            // 
            // lblMoTa
            // 
            lblMoTa.AutoSize = true;
            lblMoTa.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblMoTa.ForeColor = Color.FromArgb(64, 64, 64);
            lblMoTa.Location = new Point(24, 322);
            lblMoTa.Name = "lblMoTa";
            lblMoTa.Size = new Size(76, 15);
            lblMoTa.TabIndex = 14;
            lblMoTa.Text = "Mô tả phim:";
            // 
            // txtTrailer
            // 
            txtTrailer.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtTrailer.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtTrailer.Location = new Point(24, 280);
            txtTrailer.MaxLength = 500;
            txtTrailer.Name = "txtTrailer";
            txtTrailer.PlaceholderText = "https://youtube.com/watch?v=...";
            txtTrailer.Size = new Size(535, 25);
            txtTrailer.TabIndex = 13;
            // 
            // lblTrailer
            // 
            lblTrailer.AutoSize = true;
            lblTrailer.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrailer.ForeColor = Color.FromArgb(64, 64, 64);
            lblTrailer.Location = new Point(24, 262);
            lblTrailer.Name = "lblTrailer";
            lblTrailer.Size = new Size(130, 15);
            lblTrailer.TabIndex = 12;
            lblTrailer.Text = "Đường dẫn link Trailer:";
            // 
            // txtPoster
            // 
            txtPoster.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtPoster.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            txtPoster.Location = new Point(24, 222);
            txtPoster.MaxLength = 500;
            txtPoster.Name = "txtPoster";
            txtPoster.PlaceholderText = "https://... hoặc tên file ảnh poster";
            txtPoster.Size = new Size(535, 25);
            txtPoster.TabIndex = 11;
            // 
            // lblPoster
            // 
            lblPoster.AutoSize = true;
            lblPoster.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblPoster.ForeColor = Color.FromArgb(64, 64, 64);
            lblPoster.Location = new Point(24, 204);
            lblPoster.Name = "lblPoster";
            lblPoster.Size = new Size(136, 15);
            lblPoster.TabIndex = 10;
            lblPoster.Text = "Đường dẫn ảnh Poster:";
            // 
            // cboTrangThai
            // 
            cboTrangThai.DropDownStyle = ComboBoxStyle.DropDownList;
            cboTrangThai.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboTrangThai.FormattingEnabled = true;
            cboTrangThai.Items.AddRange(new object[] { "Sắp chiếu", "Đang chiếu", "Ngừng chiếu" });
            cboTrangThai.Location = new Point(310, 162);
            cboTrangThai.Name = "cboTrangThai";
            cboTrangThai.Size = new Size(249, 25);
            cboTrangThai.TabIndex = 9;
            // 
            // lblTrangThai
            // 
            lblTrangThai.AutoSize = true;
            lblTrangThai.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTrangThai.ForeColor = Color.FromArgb(64, 64, 64);
            lblTrangThai.Location = new Point(310, 144);
            lblTrangThai.Name = "lblTrangThai";
            lblTrangThai.Size = new Size(111, 15);
            lblTrangThai.TabIndex = 8;
            lblTrangThai.Text = "Trạng thái chiếu (*):";
            // 
            // cboGioiHanTuoi
            // 
            cboGioiHanTuoi.DropDownStyle = ComboBoxStyle.DropDownList;
            cboGioiHanTuoi.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboGioiHanTuoi.FormattingEnabled = true;
            cboGioiHanTuoi.Items.AddRange(new object[] { "P", "K", "T13", "T16", "T18", "C" });
            cboGioiHanTuoi.Location = new Point(24, 162);
            cboGioiHanTuoi.Name = "cboGioiHanTuoi";
            cboGioiHanTuoi.Size = new Size(249, 25);
            cboGioiHanTuoi.TabIndex = 7;
            // 
            // lblGioiHanTuoi
            // 
            lblGioiHanTuoi.AutoSize = true;
            lblGioiHanTuoi.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblGioiHanTuoi.ForeColor = Color.FromArgb(64, 64, 64);
            lblGioiHanTuoi.Location = new Point(24, 144);
            lblGioiHanTuoi.Name = "lblGioiHanTuoi";
            lblGioiHanTuoi.Size = new Size(99, 15);
            lblGioiHanTuoi.TabIndex = 6;
            lblGioiHanTuoi.Text = "Giới hạn tuổi (*):";
            // 
            // dtpNgayKhoiChieu
            // 
            dtpNgayKhoiChieu.CustomFormat = "dd/MM/yyyy";
            dtpNgayKhoiChieu.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            dtpNgayKhoiChieu.Format = DateTimePickerFormat.Custom;
            dtpNgayKhoiChieu.Location = new Point(310, 98);
            dtpNgayKhoiChieu.Name = "dtpNgayKhoiChieu";
            dtpNgayKhoiChieu.Size = new Size(249, 25);
            dtpNgayKhoiChieu.TabIndex = 5;
            // 
            // lblNgayKhoiChieu
            // 
            lblNgayKhoiChieu.AutoSize = true;
            lblNgayKhoiChieu.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblNgayKhoiChieu.ForeColor = Color.FromArgb(64, 64, 64);
            lblNgayKhoiChieu.Location = new Point(310, 80);
            lblNgayKhoiChieu.Name = "lblNgayKhoiChieu";
            lblNgayKhoiChieu.Size = new Size(116, 15);
            lblNgayKhoiChieu.TabIndex = 4;
            lblNgayKhoiChieu.Text = "Ngày khởi chiếu (*):";
            // 
            // numThoiLuong
            // 
            numThoiLuong.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            numThoiLuong.Location = new Point(24, 98);
            numThoiLuong.Maximum = new decimal(new int[] { 600, 0, 0, 0 });
            numThoiLuong.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            numThoiLuong.Name = "numThoiLuong";
            numThoiLuong.Size = new Size(249, 25);
            numThoiLuong.TabIndex = 3;
            numThoiLuong.Value = new decimal(new int[] { 120, 0, 0, 0 });
            // 
            // lblThoiLuong
            // 
            lblThoiLuong.AutoSize = true;
            lblThoiLuong.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblThoiLuong.ForeColor = Color.FromArgb(64, 64, 64);
            lblThoiLuong.Location = new Point(24, 80);
            lblThoiLuong.Name = "lblThoiLuong";
            lblThoiLuong.Size = new Size(130, 15);
            lblThoiLuong.TabIndex = 2;
            lblThoiLuong.Text = "Thời lượng (phút) (*):";
            // 
            // txtTenPhim
            // 
            txtTenPhim.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtTenPhim.Font = new Font("Segoe UI", 10F, FontStyle.Regular, GraphicsUnit.Point);
            txtTenPhim.Location = new Point(24, 42);
            txtTenPhim.MaxLength = 200;
            txtTenPhim.Name = "txtTenPhim";
            txtTenPhim.PlaceholderText = "Nhập tên phim...";
            txtTenPhim.Size = new Size(535, 25);
            txtTenPhim.TabIndex = 1;
            // 
            // lblTenPhim
            // 
            lblTenPhim.AutoSize = true;
            lblTenPhim.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblTenPhim.ForeColor = Color.FromArgb(64, 64, 64);
            lblTenPhim.Location = new Point(24, 24);
            lblTenPhim.Name = "lblTenPhim";
            lblTenPhim.Size = new Size(82, 15);
            lblTenPhim.TabIndex = 0;
            lblTenPhim.Text = "Tên phim (*):";
            // 
            // pnlFooter
            // 
            pnlFooter.BackColor = Color.FromArgb(240, 242, 245);
            pnlFooter.Controls.Add(btnHuy);
            pnlFooter.Controls.Add(btnLuu);
            pnlFooter.Dock = DockStyle.Bottom;
            pnlFooter.Location = new Point(0, 520);
            pnlFooter.Name = "pnlFooter";
            pnlFooter.Size = new Size(584, 60);
            pnlFooter.TabIndex = 2;
            // 
            // btnHuy
            // 
            btnHuy.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnHuy.BackColor = Color.FromArgb(120, 144, 156);
            btnHuy.Cursor = Cursors.Hand;
            btnHuy.FlatAppearance.BorderSize = 0;
            btnHuy.FlatStyle = FlatStyle.Flat;
            btnHuy.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnHuy.ForeColor = Color.White;
            btnHuy.Location = new Point(345, 12);
            btnHuy.Name = "btnHuy";
            btnHuy.Size = new Size(100, 36);
            btnHuy.TabIndex = 1;
            btnHuy.Text = "Hủy bỏ";
            btnHuy.UseVisualStyleBackColor = false;
            btnHuy.Click += btnHuy_Click;
            // 
            // btnLuu
            // 
            btnLuu.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnLuu.BackColor = Color.FromArgb(211, 47, 47);
            btnLuu.Cursor = Cursors.Hand;
            btnLuu.FlatAppearance.BorderSize = 0;
            btnLuu.FlatStyle = FlatStyle.Flat;
            btnLuu.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnLuu.ForeColor = Color.White;
            btnLuu.Location = new Point(455, 12);
            btnLuu.Name = "btnLuu";
            btnLuu.Size = new Size(115, 36);
            btnLuu.TabIndex = 0;
            btnLuu.Text = "Lưu phim";
            btnLuu.UseVisualStyleBackColor = false;
            btnLuu.Click += btnLuu_Click;
            // 
            // FormThemSuaPhim
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(584, 580);
            Controls.Add(pnlNoiDung);
            Controls.Add(pnlFooter);
            Controls.Add(pnlHeader);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "FormThemSuaPhim";
            StartPosition = FormStartPosition.CenterParent;
            Text = "Quản lý phim - YeuMinhEm Cinema";
            pnlHeader.ResumeLayout(false);
            pnlHeader.PerformLayout();
            pnlNoiDung.ResumeLayout(false);
            pnlNoiDung.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)numThoiLuong).EndInit();
            pnlFooter.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlHeader;
        private Label lblTieuDeForm;
        private Panel pnlNoiDung;
        private Label lblTenPhim;
        private TextBox txtTenPhim;
        private Label lblThoiLuong;
        private NumericUpDown numThoiLuong;
        private Label lblNgayKhoiChieu;
        private DateTimePicker dtpNgayKhoiChieu;
        private Label lblGioiHanTuoi;
        private ComboBox cboGioiHanTuoi;
        private Label lblTrangThai;
        private ComboBox cboTrangThai;
        private Label lblPoster;
        private TextBox txtPoster;
        private Label lblTrailer;
        private TextBox txtTrailer;
        private Label lblMoTa;
        private TextBox txtMoTa;
        private Panel pnlFooter;
        private Button btnHuy;
        private Button btnLuu;
    }
}
