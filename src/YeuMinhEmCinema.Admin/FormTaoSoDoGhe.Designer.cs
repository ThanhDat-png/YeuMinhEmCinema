namespace YeuMinhEmCinema.Admin
{
    partial class FormTaoSoDoGhe
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
            lblThongTinPhong = new Label();
            lblSoGheHienTai = new Label();
            lblSoHang = new Label();
            numSoHang = new NumericUpDown();
            lblGiaiThichHang = new Label();
            lblSoGheMoiHang = new Label();
            numSoGheMoiHang = new NumericUpDown();
            lblLoaiGheMacDinh = new Label();
            cboLoaiGheMacDinh = new ComboBox();
            pnlNote = new Panel();
            lblNote = new Label();
            btnTaoSoDo = new Button();
            btnDong = new Button();
            pnlHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)numSoHang).BeginInit();
            ((System.ComponentModel.ISupportInitialize)numSoGheMoiHang).BeginInit();
            pnlNote.SuspendLayout();
            SuspendLayout();
            // 
            // pnlHeader
            // 
            pnlHeader.BackColor = Color.FromArgb(20, 20, 26);
            pnlHeader.Controls.Add(lblTieuDeForm);
            pnlHeader.Dock = DockStyle.Top;
            pnlHeader.Location = new Point(0, 0);
            pnlHeader.Name = "pnlHeader";
            pnlHeader.Size = new Size(500, 50);
            pnlHeader.TabIndex = 0;
            // 
            // lblTieuDeForm
            // 
            lblTieuDeForm.AutoSize = true;
            lblTieuDeForm.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTieuDeForm.ForeColor = Color.White;
            lblTieuDeForm.Location = new Point(16, 15);
            lblTieuDeForm.Name = "lblTieuDeForm";
            lblTieuDeForm.Size = new Size(244, 20);
            lblTieuDeForm.TabIndex = 0;
            lblTieuDeForm.Text = "🪑 TẠO SƠ ĐỒ GHẾ PHÒNG CHIẾU";
            // 
            // lblThongTinPhong
            // 
            lblThongTinPhong.AutoSize = true;
            lblThongTinPhong.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            lblThongTinPhong.ForeColor = Color.FromArgb(15, 23, 42);
            lblThongTinPhong.Location = new Point(20, 65);
            lblThongTinPhong.Name = "lblThongTinPhong";
            lblThongTinPhong.Size = new Size(183, 19);
            lblThongTinPhong.TabIndex = 1;
            lblThongTinPhong.Text = "Phòng chiếu: Đang chọn...";
            // 
            // lblSoGheHienTai
            // 
            lblSoGheHienTai.AutoSize = true;
            lblSoGheHienTai.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblSoGheHienTai.ForeColor = Color.FromArgb(71, 85, 105);
            lblSoGheHienTai.Location = new Point(20, 88);
            lblSoGheHienTai.Name = "lblSoGheHienTai";
            lblSoGheHienTai.Size = new Size(137, 15);
            lblSoGheHienTai.TabIndex = 2;
            lblSoGheHienTai.Text = "Số ghế hiện có: 0 ghế";
            // 
            // lblSoHang
            // 
            lblSoHang.AutoSize = true;
            lblSoHang.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblSoHang.ForeColor = Color.FromArgb(51, 65, 85);
            lblSoHang.Location = new Point(20, 125);
            lblSoHang.Name = "lblSoHang";
            lblSoHang.Size = new Size(113, 15);
            lblSoHang.TabIndex = 3;
            lblSoHang.Text = "SỐ HÀNG GHẾ (1-26):";
            // 
            // numSoHang
            // 
            numSoHang.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            numSoHang.Location = new Point(20, 145);
            numSoHang.Maximum = new decimal(new int[] { 26, 0, 0, 0 });
            numSoHang.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            numSoHang.Name = "numSoHang";
            numSoHang.Size = new Size(140, 25);
            numSoHang.TabIndex = 4;
            numSoHang.Value = new decimal(new int[] { 6, 0, 0, 0 });
            numSoHang.ValueChanged += numSoHang_ValueChanged;
            // 
            // lblGiaiThichHang
            // 
            lblGiaiThichHang.AutoSize = true;
            lblGiaiThichHang.Font = new Font("Segoe UI", 8.25F, FontStyle.Italic, GraphicsUnit.Point);
            lblGiaiThichHang.ForeColor = Color.FromArgb(100, 116, 139);
            lblGiaiThichHang.Location = new Point(170, 152);
            lblGiaiThichHang.Name = "lblGiaiThichHang";
            lblGiaiThichHang.Size = new Size(130, 13);
            lblGiaiThichHang.TabIndex = 5;
            lblGiaiThichHang.Text = "(Tương ứng hàng A đến F)";
            // 
            // lblSoGheMoiHang
            // 
            lblSoGheMoiHang.AutoSize = true;
            lblSoGheMoiHang.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblSoGheMoiHang.ForeColor = Color.FromArgb(51, 65, 85);
            lblSoGheMoiHang.Location = new Point(20, 185);
            lblSoGheMoiHang.Name = "lblSoGheMoiHang";
            lblSoGheMoiHang.Size = new Size(157, 15);
            lblSoGheMoiHang.TabIndex = 6;
            lblSoGheMoiHang.Text = "SỐ GHẾ MỖI HÀNG (1-50):";
            // 
            // numSoGheMoiHang
            // 
            numSoGheMoiHang.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            numSoGheMoiHang.Location = new Point(20, 205);
            numSoGheMoiHang.Maximum = new decimal(new int[] { 50, 0, 0, 0 });
            numSoGheMoiHang.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            numSoGheMoiHang.Name = "numSoGheMoiHang";
            numSoGheMoiHang.Size = new Size(140, 25);
            numSoGheMoiHang.TabIndex = 7;
            numSoGheMoiHang.Value = new decimal(new int[] { 10, 0, 0, 0 });
            // 
            // lblLoaiGheMacDinh
            // 
            lblLoaiGheMacDinh.AutoSize = true;
            lblLoaiGheMacDinh.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblLoaiGheMacDinh.ForeColor = Color.FromArgb(51, 65, 85);
            lblLoaiGheMacDinh.Location = new Point(20, 245);
            lblLoaiGheMacDinh.Name = "lblLoaiGheMacDinh";
            lblLoaiGheMacDinh.Size = new Size(137, 15);
            lblLoaiGheMacDinh.TabIndex = 8;
            lblLoaiGheMacDinh.Text = "LOẠI GHẾ MẶC ĐỊNH:";
            // 
            // cboLoaiGheMacDinh
            // 
            cboLoaiGheMacDinh.DropDownStyle = ComboBoxStyle.DropDownList;
            cboLoaiGheMacDinh.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            cboLoaiGheMacDinh.FormattingEnabled = true;
            cboLoaiGheMacDinh.Location = new Point(20, 265);
            cboLoaiGheMacDinh.Name = "cboLoaiGheMacDinh";
            cboLoaiGheMacDinh.Size = new Size(460, 25);
            cboLoaiGheMacDinh.TabIndex = 9;
            // 
            // pnlNote
            // 
            pnlNote.BackColor = Color.FromArgb(239, 246, 255);
            pnlNote.BorderStyle = BorderStyle.FixedSingle;
            pnlNote.Controls.Add(lblNote);
            pnlNote.Location = new Point(20, 305);
            pnlNote.Name = "pnlNote";
            pnlNote.Padding = new Padding(10);
            pnlNote.Size = new Size(460, 65);
            pnlNote.TabIndex = 10;
            // 
            // lblNote
            // 
            lblNote.Dock = DockStyle.Fill;
            lblNote.Font = new Font("Segoe UI", 8.5F, FontStyle.Regular, GraphicsUnit.Point);
            lblNote.ForeColor = Color.FromArgb(30, 64, 175);
            lblNote.Location = new Point(10, 10);
            lblNote.Name = "lblNote";
            lblNote.Size = new Size(438, 43);
            lblNote.TabIndex = 0;
            lblNote.Text = "🛡️ Bảo toàn dữ liệu: Hệ thống sẽ tạo các ghế mới theo số hàng và số ghế. Nếu vị trí ghế đã tồn tại, hệ thống giữ nguyên vị trí cũ, TUYỆT ĐỐI KHÔNG xóa hoặc ghi đè.";
            // 
            // btnTaoSoDo
            // 
            btnTaoSoDo.BackColor = Color.FromArgb(211, 47, 47);
            btnTaoSoDo.Cursor = Cursors.Hand;
            btnTaoSoDo.FlatAppearance.BorderSize = 0;
            btnTaoSoDo.FlatStyle = FlatStyle.Flat;
            btnTaoSoDo.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnTaoSoDo.ForeColor = Color.White;
            btnTaoSoDo.Location = new Point(220, 385);
            btnTaoSoDo.Name = "btnTaoSoDo";
            btnTaoSoDo.Size = new Size(160, 36);
            btnTaoSoDo.TabIndex = 11;
            btnTaoSoDo.Text = "⚡ Tạo sơ đồ ghế";
            btnTaoSoDo.UseVisualStyleBackColor = false;
            btnTaoSoDo.Click += btnTaoSoDo_Click;
            // 
            // btnDong
            // 
            btnDong.BackColor = Color.FromArgb(241, 245, 249);
            btnDong.Cursor = Cursors.Hand;
            btnDong.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnDong.FlatStyle = FlatStyle.Flat;
            btnDong.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            btnDong.ForeColor = Color.FromArgb(71, 85, 105);
            btnDong.Location = new Point(390, 385);
            btnDong.Name = "btnDong";
            btnDong.Size = new Size(90, 36);
            btnDong.TabIndex = 12;
            btnDong.Text = "Đóng";
            btnDong.UseVisualStyleBackColor = false;
            btnDong.Click += btnDong_Click;
            // 
            // FormTaoSoDoGhe
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.White;
            ClientSize = new Size(500, 440);
            Controls.Add(btnDong);
            Controls.Add(btnTaoSoDo);
            Controls.Add(pnlNote);
            Controls.Add(cboLoaiGheMacDinh);
            Controls.Add(lblLoaiGheMacDinh);
            Controls.Add(numSoGheMoiHang);
            Controls.Add(lblSoGheMoiHang);
            Controls.Add(lblGiaiThichHang);
            Controls.Add(numSoHang);
            Controls.Add(lblSoHang);
            Controls.Add(lblSoGheHienTai);
            Controls.Add(lblThongTinPhong);
            Controls.Add(pnlHeader);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "FormTaoSoDoGhe";
            StartPosition = FormStartPosition.CenterParent;
            Text = "Tạo sơ đồ ghế";
            pnlHeader.ResumeLayout(false);
            pnlHeader.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)numSoHang).EndInit();
            ((System.ComponentModel.ISupportInitialize)numSoGheMoiHang).EndInit();
            pnlNote.ResumeLayout(false);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel pnlHeader;
        private Label lblTieuDeForm;
        private Label lblThongTinPhong;
        private Label lblSoGheHienTai;
        private Label lblSoHang;
        private NumericUpDown numSoHang;
        private Label lblGiaiThichHang;
        private Label lblSoGheMoiHang;
        private NumericUpDown numSoGheMoiHang;
        private Label lblLoaiGheMacDinh;
        private ComboBox cboLoaiGheMacDinh;
        private Panel pnlNote;
        private Label lblNote;
        private Button btnTaoSoDo;
        private Button btnDong;
    }
}
