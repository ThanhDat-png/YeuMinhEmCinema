namespace YeuMinhEmCinema.Admin
{
    partial class UcTongQuan
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
            pnlChart = new Panel();
            lblChartDesc = new Label();
            lblChartTitle = new Label();
            pnlRecentOrders = new Panel();
            dgvDonHangGanDay = new DataGridView();
            lblOrdersTitle = new Label();
            pnlBanner.SuspendLayout();
            tblKpi.SuspendLayout();
            pnlKpi1.SuspendLayout();
            pnlKpi2.SuspendLayout();
            pnlKpi3.SuspendLayout();
            pnlKpi4.SuspendLayout();
            pnlChart.SuspendLayout();
            pnlRecentOrders.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvDonHangGanDay).BeginInit();
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
            lblTieuDe.Size = new Size(323, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "📊 BÁO CÁO TỔNG QUAN HOẠT ĐỘNG RẠP";
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
            tblKpi.Location = new Point(15, 63);
            tblKpi.Name = "tblKpi";
            tblKpi.Padding = new Padding(0, 10, 0, 10);
            tblKpi.RowCount = 1;
            tblKpi.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblKpi.Size = new Size(950, 100);
            tblKpi.TabIndex = 1;
            // 
            // pnlKpi1
            // 
            pnlKpi1.BackColor = Color.White;
            pnlKpi1.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi1.Controls.Add(lblKpi1Value);
            pnlKpi1.Controls.Add(lblKpi1Title);
            pnlKpi1.Dock = DockStyle.Fill;
            pnlKpi1.Location = new Point(3, 13);
            pnlKpi1.Margin = new Padding(3, 3, 8, 3);
            pnlKpi1.Name = "pnlKpi1";
            pnlKpi1.Size = new Size(226, 74);
            pnlKpi1.TabIndex = 0;
            // 
            // lblKpi1Value
            // 
            lblKpi1Value.AutoSize = true;
            lblKpi1Value.Font = new Font("Segoe UI", 14.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi1Value.ForeColor = Color.FromArgb(211, 47, 47);
            lblKpi1Value.Location = new Point(12, 34);
            lblKpi1Value.Name = "lblKpi1Value";
            lblKpi1Value.Size = new Size(137, 25);
            lblKpi1Value.TabIndex = 1;
            lblKpi1Value.Text = "48.500.000 đ";
            // 
            // lblKpi1Title
            // 
            lblKpi1Title.AutoSize = true;
            lblKpi1Title.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi1Title.ForeColor = Color.Gray;
            lblKpi1Title.Location = new Point(12, 12);
            lblKpi1Title.Name = "lblKpi1Title";
            lblKpi1Title.Size = new Size(111, 15);
            lblKpi1Title.TabIndex = 0;
            lblKpi1Title.Text = "DOANH THU HÔM NAY";
            // 
            // pnlKpi2
            // 
            pnlKpi2.BackColor = Color.White;
            pnlKpi2.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi2.Controls.Add(lblKpi2Value);
            pnlKpi2.Controls.Add(lblKpi2Title);
            pnlKpi2.Dock = DockStyle.Fill;
            pnlKpi2.Location = new Point(240, 13);
            pnlKpi2.Margin = new Padding(3, 3, 8, 3);
            pnlKpi2.Name = "pnlKpi2";
            pnlKpi2.Size = new Size(226, 74);
            pnlKpi2.TabIndex = 1;
            // 
            // lblKpi2Value
            // 
            lblKpi2Value.AutoSize = true;
            lblKpi2Value.Font = new Font("Segoe UI", 14.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi2Value.ForeColor = Color.FromArgb(24, 24, 27);
            lblKpi2Value.Location = new Point(12, 34);
            lblKpi2Value.Name = "lblKpi2Value";
            lblKpi2Value.Size = new Size(74, 25);
            lblKpi2Value.TabIndex = 1;
            lblKpi2Value.Text = "520 vé";
            // 
            // lblKpi2Title
            // 
            lblKpi2Title.AutoSize = true;
            lblKpi2Title.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi2Title.ForeColor = Color.Gray;
            lblKpi2Title.Location = new Point(12, 12);
            lblKpi2Title.Name = "lblKpi2Title";
            lblKpi2Title.Size = new Size(95, 15);
            lblKpi2Title.TabIndex = 0;
            lblKpi2Title.Text = "SỐ VÉ ĐÃ BÁN";
            // 
            // pnlKpi3
            // 
            pnlKpi3.BackColor = Color.White;
            pnlKpi3.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi3.Controls.Add(lblKpi3Value);
            pnlKpi3.Controls.Add(lblKpi3Title);
            pnlKpi3.Dock = DockStyle.Fill;
            pnlKpi3.Location = new Point(477, 13);
            pnlKpi3.Margin = new Padding(3, 3, 8, 3);
            pnlKpi3.Name = "pnlKpi3";
            pnlKpi3.Size = new Size(226, 74);
            pnlKpi3.TabIndex = 2;
            // 
            // lblKpi3Value
            // 
            lblKpi3Value.AutoSize = true;
            lblKpi3Value.Font = new Font("Segoe UI", 14.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi3Value.ForeColor = Color.FromArgb(24, 24, 27);
            lblKpi3Value.Location = new Point(12, 34);
            lblKpi3Value.Name = "lblKpi3Value";
            lblKpi3Value.Size = new Size(76, 25);
            lblKpi3Value.TabIndex = 1;
            lblKpi3Value.Text = "24 suất";
            // 
            // lblKpi3Title
            // 
            lblKpi3Title.AutoSize = true;
            lblKpi3Title.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi3Title.ForeColor = Color.Gray;
            lblKpi3Title.Location = new Point(12, 12);
            lblKpi3Title.Name = "lblKpi3Title";
            lblKpi3Title.Size = new Size(125, 15);
            lblKpi3Title.TabIndex = 0;
            lblKpi3Title.Text = "SUẤT CHIẾU HÔM NAY";
            // 
            // pnlKpi4
            // 
            pnlKpi4.BackColor = Color.White;
            pnlKpi4.BorderStyle = BorderStyle.FixedSingle;
            pnlKpi4.Controls.Add(lblKpi4Value);
            pnlKpi4.Controls.Add(lblKpi4Title);
            pnlKpi4.Dock = DockStyle.Fill;
            pnlKpi4.Location = new Point(714, 13);
            pnlKpi4.Name = "pnlKpi4";
            pnlKpi4.Size = new Size(233, 74);
            pnlKpi4.TabIndex = 3;
            // 
            // lblKpi4Value
            // 
            lblKpi4Value.AutoSize = true;
            lblKpi4Value.Font = new Font("Segoe UI", 14.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblKpi4Value.ForeColor = Color.FromArgb(16, 185, 129);
            lblKpi4Value.Location = new Point(12, 34);
            lblKpi4Value.Name = "lblKpi4Value";
            lblKpi4Value.Size = new Size(68, 25);
            lblKpi4Value.TabIndex = 1;
            lblKpi4Value.Text = "78.5 %";
            // 
            // lblKpi4Title
            // 
            lblKpi4Title.AutoSize = true;
            lblKpi4Title.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblKpi4Title.ForeColor = Color.Gray;
            lblKpi4Title.Location = new Point(12, 12);
            lblKpi4Title.Name = "lblKpi4Title";
            lblKpi4Title.Size = new Size(111, 15);
            lblKpi4Title.TabIndex = 0;
            lblKpi4Title.Text = "TỶ LỆ LẤP ĐẦY RẠP";
            // 
            // pnlChart
            // 
            pnlChart.BackColor = Color.White;
            pnlChart.BorderStyle = BorderStyle.FixedSingle;
            pnlChart.Controls.Add(lblChartDesc);
            pnlChart.Controls.Add(lblChartTitle);
            pnlChart.Dock = DockStyle.Top;
            pnlChart.Location = new Point(15, 163);
            pnlChart.Name = "pnlChart";
            pnlChart.Padding = new Padding(15);
            pnlChart.Size = new Size(950, 160);
            pnlChart.TabIndex = 2;
            // 
            // lblChartDesc
            // 
            lblChartDesc.AutoSize = true;
            lblChartDesc.Font = new Font("Segoe UI", 9.75F, FontStyle.Italic, GraphicsUnit.Point);
            lblChartDesc.ForeColor = Color.FromArgb(100, 116, 139);
            lblChartDesc.Location = new Point(18, 50);
            lblChartDesc.Name = "lblChartDesc";
            lblChartDesc.Size = new Size(620, 85);
            lblChartDesc.TabIndex = 1;
            lblChartDesc.Text = "• Thứ Hai:  █ 32.000.000 đ (340 vé)\r\n• Thứ Ba:   ██ 38.500.000 đ (410 vé)\r\n• Thứ Tư:    ███ 41.200.000 đ (445 vé)\r\n• Thứ Năm:   ███ 44.000.000 đ (480 vé)\r\n• Thứ Sáu:   ████ 48.500.000 đ (520 vé) [Hôm nay]";
            // 
            // lblChartTitle
            // 
            lblChartTitle.AutoSize = true;
            lblChartTitle.Font = new Font("Segoe UI", 10.5F, FontStyle.Bold, GraphicsUnit.Point);
            lblChartTitle.ForeColor = Color.FromArgb(24, 24, 27);
            lblChartTitle.Location = new Point(15, 15);
            lblChartTitle.Name = "lblChartTitle";
            lblChartTitle.Size = new Size(337, 19);
            lblChartTitle.TabIndex = 0;
            lblChartTitle.Text = "📈 BIỂU ĐỒ DOANH THU THEO NGÀY TRONG TUẦN";
            // 
            // pnlRecentOrders
            // 
            pnlRecentOrders.BackColor = Color.White;
            pnlRecentOrders.BorderStyle = BorderStyle.FixedSingle;
            pnlRecentOrders.Controls.Add(dgvDonHangGanDay);
            pnlRecentOrders.Controls.Add(lblOrdersTitle);
            pnlRecentOrders.Dock = DockStyle.Fill;
            pnlRecentOrders.Location = new Point(15, 323);
            pnlRecentOrders.Margin = new Padding(0, 10, 0, 0);
            pnlRecentOrders.Name = "pnlRecentOrders";
            pnlRecentOrders.Padding = new Padding(15);
            pnlRecentOrders.Size = new Size(950, 262);
            pnlRecentOrders.TabIndex = 3;
            // 
            // dgvDonHangGanDay
            // 
            dgvDonHangGanDay.AllowUserToAddRows = false;
            dgvDonHangGanDay.AllowUserToDeleteRows = false;
            dgvDonHangGanDay.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvDonHangGanDay.BackgroundColor = Color.White;
            dgvDonHangGanDay.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvDonHangGanDay.Dock = DockStyle.Fill;
            dgvDonHangGanDay.Location = new Point(15, 45);
            dgvDonHangGanDay.Name = "dgvDonHangGanDay";
            dgvDonHangGanDay.ReadOnly = true;
            dgvDonHangGanDay.RowHeadersVisible = false;
            dgvDonHangGanDay.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvDonHangGanDay.Size = new Size(918, 200);
            dgvDonHangGanDay.TabIndex = 1;
            // 
            // lblOrdersTitle
            // 
            lblOrdersTitle.Dock = DockStyle.Top;
            lblOrdersTitle.Font = new Font("Segoe UI", 10.5F, FontStyle.Bold, GraphicsUnit.Point);
            lblOrdersTitle.ForeColor = Color.FromArgb(24, 24, 27);
            lblOrdersTitle.Location = new Point(15, 15);
            lblOrdersTitle.Name = "lblOrdersTitle";
            lblOrdersTitle.Size = new Size(918, 30);
            lblOrdersTitle.TabIndex = 0;
            lblOrdersTitle.Text = "🧾 CÁC ĐƠN ĐẶT VÉ GẦN ĐÂY";
            // 
            // UcTongQuan
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(pnlRecentOrders);
            Controls.Add(pnlChart);
            Controls.Add(tblKpi);
            Controls.Add(pnlBanner);
            Name = "UcTongQuan";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            tblKpi.ResumeLayout(false);
            pnlKpi1.ResumeLayout(false);
            pnlKpi1.PerformLayout();
            pnlKpi2.ResumeLayout(false);
            pnlKpi2.PerformLayout();
            pnlKpi3.ResumeLayout(false);
            pnlKpi3.PerformLayout();
            pnlKpi4.ResumeLayout(false);
            pnlKpi4.PerformLayout();
            pnlChart.ResumeLayout(false);
            pnlChart.PerformLayout();
            pnlRecentOrders.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvDonHangGanDay).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblCanhBao;
        private Label lblTieuDe;
        private TableLayoutPanel tblKpi;
        private Panel pnlKpi1;
        private Label lblKpi1Value;
        private Label lblKpi1Title;
        private Panel pnlKpi2;
        private Label lblKpi2Value;
        private Label lblKpi2Title;
        private Panel pnlKpi3;
        private Label lblKpi3Value;
        private Label lblKpi3Title;
        private Panel pnlKpi4;
        private Label lblKpi4Value;
        private Label lblKpi4Title;
        private Panel pnlChart;
        private Label lblChartTitle;
        private Label lblChartDesc;
        private Panel pnlRecentOrders;
        private Label lblOrdersTitle;
        private DataGridView dgvDonHangGanDay;
    }
}
