namespace YeuMinhEmCinema.Admin
{
    partial class UcRapPhongChieu
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
            components = new System.ComponentModel.Container();
            pnlBanner = new Panel();
            lblDbStatus = new Label();
            lblTieuDe = new Label();
            splContainer = new SplitContainer();
            pnlLeft = new Panel();
            pnlLeftButtons = new TableLayoutPanel();
            btnThemRap = new Button();
            btnThemPhong = new Button();
            btnSuaRapPhong = new Button();
            btnDoiTrangThai = new Button();
            trvRapPhong = new TreeView();
            cmsRapPhong = new ContextMenuStrip(components);
            tsmThemPhong = new ToolStripMenuItem();
            tsmSua = new ToolStripMenuItem();
            tsmDoiTrangThai = new ToolStripMenuItem();
            tsmTaoSoDo = new ToolStripMenuItem();
            toolStripSeparator1 = new ToolStripSeparator();
            tsmLamMoi = new ToolStripMenuItem();
            lblDanhSachRap = new Label();
            pnlRight = new Panel();
            pnlSeatMapContainer = new Panel();
            flpGhe = new FlowLayoutPanel();
            lblScreen = new Label();
            pnlSeatControlBar = new Panel();
            flpSeatActions = new FlowLayoutPanel();
            lblGheDangChon = new Label();
            cboDoiLoaiGhe = new ComboBox();
            btnDoiLoaiGhe = new Button();
            btnDoiTrangThaiGhe = new Button();
            pnlChuThich = new Panel();
            lblChuThich = new Label();
            pnlThongTinPhong = new Panel();
            flpPhongButtons = new FlowLayoutPanel();
            btnTaoSoDoGhe = new Button();
            btnSuaPhong = new Button();
            btnDoiTrangThaiPhong = new Button();
            lblThongTinPhong = new Label();
            cmsGhe = new ContextMenuStrip(components);
            tsmGheThuong = new ToolStripMenuItem();
            tsmGheVip = new ToolStripMenuItem();
            tsmGheSweetbox = new ToolStripMenuItem();
            toolStripSeparator2 = new ToolStripSeparator();
            tsmDanhDauHong = new ToolStripMenuItem();
            tsmDanhDauHoatDong = new ToolStripMenuItem();
            pnlBanner.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splContainer).BeginInit();
            splContainer.Panel1.SuspendLayout();
            splContainer.Panel2.SuspendLayout();
            splContainer.SuspendLayout();
            pnlLeft.SuspendLayout();
            pnlLeftButtons.SuspendLayout();
            cmsRapPhong.SuspendLayout();
            pnlRight.SuspendLayout();
            pnlSeatMapContainer.SuspendLayout();
            pnlSeatControlBar.SuspendLayout();
            flpSeatActions.SuspendLayout();
            pnlChuThich.SuspendLayout();
            pnlThongTinPhong.SuspendLayout();
            flpPhongButtons.SuspendLayout();
            cmsGhe.SuspendLayout();
            SuspendLayout();
            // 
            // pnlBanner
            // 
            pnlBanner.BackColor = Color.FromArgb(240, 253, 244);
            pnlBanner.BorderStyle = BorderStyle.FixedSingle;
            pnlBanner.Controls.Add(lblDbStatus);
            pnlBanner.Controls.Add(lblTieuDe);
            pnlBanner.Dock = DockStyle.Top;
            pnlBanner.Location = new Point(15, 15);
            pnlBanner.Name = "pnlBanner";
            pnlBanner.Size = new Size(950, 48);
            pnlBanner.TabIndex = 0;
            // 
            // lblDbStatus
            // 
            lblDbStatus.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            lblDbStatus.AutoSize = true;
            lblDbStatus.BackColor = Color.FromArgb(22, 163, 74);
            lblDbStatus.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblDbStatus.ForeColor = Color.White;
            lblDbStatus.Location = new Point(640, 14);
            lblDbStatus.Name = "lblDbStatus";
            lblDbStatus.Padding = new Padding(6, 2, 6, 2);
            lblDbStatus.Size = new Size(295, 19);
            lblDbStatus.TabIndex = 1;
            lblDbStatus.Text = "🟢 ĐÃ KẾT NỐI DATABASE THẬT (SQL SERVER)";
            // 
            // lblTieuDe
            // 
            lblTieuDe.AutoSize = true;
            lblTieuDe.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTieuDe.ForeColor = Color.FromArgb(22, 101, 52);
            lblTieuDe.Location = new Point(12, 13);
            lblTieuDe.Name = "lblTieuDe";
            lblTieuDe.Size = new Size(346, 20);
            lblTieuDe.TabIndex = 0;
            lblTieuDe.Text = "🏛️ QUẢN LÝ CỤM RẠP - PHÒNG CHIẾU - GHẾ";
            // 
            // splContainer
            // 
            splContainer.Dock = DockStyle.Fill;
            splContainer.Location = new Point(15, 63);
            splContainer.Name = "splContainer";
            // 
            // splContainer.Panel1
            // 
            splContainer.Panel1.Controls.Add(pnlLeft);
            splContainer.Panel1.Padding = new Padding(0, 10, 8, 0);
            // 
            // splContainer.Panel2
            // 
            splContainer.Panel2.Controls.Add(pnlRight);
            splContainer.Panel2.Padding = new Padding(8, 10, 0, 0);
            splContainer.Size = new Size(950, 522);
            splContainer.SplitterDistance = 310;
            splContainer.TabIndex = 1;
            // 
            // pnlLeft
            // 
            pnlLeft.BackColor = Color.White;
            pnlLeft.BorderStyle = BorderStyle.FixedSingle;
            pnlLeft.Controls.Add(pnlLeftButtons);
            pnlLeft.Controls.Add(trvRapPhong);
            pnlLeft.Controls.Add(lblDanhSachRap);
            pnlLeft.Dock = DockStyle.Fill;
            pnlLeft.Location = new Point(0, 10);
            pnlLeft.Name = "pnlLeft";
            pnlLeft.Padding = new Padding(12);
            pnlLeft.Size = new Size(302, 512);
            pnlLeft.TabIndex = 0;
            // 
            // pnlLeftButtons
            // 
            pnlLeftButtons.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            pnlLeftButtons.ColumnCount = 2;
            pnlLeftButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            pnlLeftButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            pnlLeftButtons.Controls.Add(btnThemRap, 0, 0);
            pnlLeftButtons.Controls.Add(btnThemPhong, 1, 0);
            pnlLeftButtons.Controls.Add(btnSuaRapPhong, 0, 1);
            pnlLeftButtons.Controls.Add(btnDoiTrangThai, 1, 1);
            pnlLeftButtons.Location = new Point(12, 436);
            pnlLeftButtons.Name = "pnlLeftButtons";
            pnlLeftButtons.RowCount = 2;
            pnlLeftButtons.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            pnlLeftButtons.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            pnlLeftButtons.Size = new Size(276, 64);
            pnlLeftButtons.TabIndex = 2;
            // 
            // btnThemRap
            // 
            btnThemRap.BackColor = Color.FromArgb(211, 47, 47);
            btnThemRap.Cursor = Cursors.Hand;
            btnThemRap.Dock = DockStyle.Fill;
            btnThemRap.FlatAppearance.BorderSize = 0;
            btnThemRap.FlatStyle = FlatStyle.Flat;
            btnThemRap.Font = new Font("Segoe UI", 8.5F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemRap.ForeColor = Color.White;
            btnThemRap.Location = new Point(2, 2);
            btnThemRap.Margin = new Padding(2);
            btnThemRap.Name = "btnThemRap";
            btnThemRap.Size = new Size(134, 28);
            btnThemRap.TabIndex = 0;
            btnThemRap.Text = "+ Thêm rạp";
            btnThemRap.UseVisualStyleBackColor = false;
            btnThemRap.Click += btnThemRap_Click;
            // 
            // btnThemPhong
            // 
            btnThemPhong.BackColor = Color.FromArgb(71, 85, 105);
            btnThemPhong.Cursor = Cursors.Hand;
            btnThemPhong.Dock = DockStyle.Fill;
            btnThemPhong.FlatAppearance.BorderSize = 0;
            btnThemPhong.FlatStyle = FlatStyle.Flat;
            btnThemPhong.Font = new Font("Segoe UI", 8.5F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemPhong.ForeColor = Color.White;
            btnThemPhong.Location = new Point(140, 2);
            btnThemPhong.Margin = new Padding(2);
            btnThemPhong.Name = "btnThemPhong";
            btnThemPhong.Size = new Size(134, 28);
            btnThemPhong.TabIndex = 1;
            btnThemPhong.Text = "+ Thêm phòng";
            btnThemPhong.UseVisualStyleBackColor = false;
            btnThemPhong.Click += btnThemPhong_Click;
            // 
            // btnSuaRapPhong
            // 
            btnSuaRapPhong.BackColor = Color.FromArgb(241, 245, 249);
            btnSuaRapPhong.Cursor = Cursors.Hand;
            btnSuaRapPhong.Dock = DockStyle.Fill;
            btnSuaRapPhong.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnSuaRapPhong.FlatStyle = FlatStyle.Flat;
            btnSuaRapPhong.Font = new Font("Segoe UI", 8.5F, FontStyle.Regular, GraphicsUnit.Point);
            btnSuaRapPhong.ForeColor = Color.FromArgb(51, 65, 85);
            btnSuaRapPhong.Location = new Point(2, 34);
            btnSuaRapPhong.Margin = new Padding(2);
            btnSuaRapPhong.Name = "btnSuaRapPhong";
            btnSuaRapPhong.Size = new Size(134, 28);
            btnSuaRapPhong.TabIndex = 2;
            btnSuaRapPhong.Text = "✏️ Sửa mục chọn";
            btnSuaRapPhong.UseVisualStyleBackColor = false;
            btnSuaRapPhong.Click += btnSuaRapPhong_Click;
            // 
            // btnDoiTrangThai
            // 
            btnDoiTrangThai.BackColor = Color.FromArgb(241, 245, 249);
            btnDoiTrangThai.Cursor = Cursors.Hand;
            btnDoiTrangThai.Dock = DockStyle.Fill;
            btnDoiTrangThai.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnDoiTrangThai.FlatStyle = FlatStyle.Flat;
            btnDoiTrangThai.Font = new Font("Segoe UI", 8.5F, FontStyle.Regular, GraphicsUnit.Point);
            btnDoiTrangThai.ForeColor = Color.FromArgb(51, 65, 85);
            btnDoiTrangThai.Location = new Point(140, 34);
            btnDoiTrangThai.Margin = new Padding(2);
            btnDoiTrangThai.Name = "btnDoiTrangThai";
            btnDoiTrangThai.Size = new Size(134, 28);
            btnDoiTrangThai.TabIndex = 3;
            btnDoiTrangThai.Text = "🔄 Trạng thái";
            btnDoiTrangThai.UseVisualStyleBackColor = false;
            btnDoiTrangThai.Click += btnDoiTrangThai_Click;
            // 
            // trvRapPhong
            // 
            trvRapPhong.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            trvRapPhong.ContextMenuStrip = cmsRapPhong;
            trvRapPhong.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            trvRapPhong.FullRowSelect = true;
            trvRapPhong.HideSelection = false;
            trvRapPhong.ItemHeight = 26;
            trvRapPhong.Location = new Point(12, 38);
            trvRapPhong.Name = "trvRapPhong";
            trvRapPhong.Size = new Size(276, 392);
            trvRapPhong.TabIndex = 1;
            trvRapPhong.AfterSelect += trvRapPhong_AfterSelect;
            trvRapPhong.NodeMouseClick += trvRapPhong_NodeMouseClick;
            // 
            // cmsRapPhong
            // 
            cmsRapPhong.Items.AddRange(new ToolStripItem[] { tsmThemPhong, tsmSua, tsmDoiTrangThai, tsmTaoSoDo, toolStripSeparator1, tsmLamMoi });
            cmsRapPhong.Name = "cmsRapPhong";
            cmsRapPhong.Size = new Size(213, 120);
            // 
            // tsmThemPhong
            // 
            tsmThemPhong.Name = "tsmThemPhong";
            tsmThemPhong.Size = new Size(212, 22);
            tsmThemPhong.Text = "➕ Thêm phòng chiếu";
            tsmThemPhong.Click += tsmThemPhong_Click;
            // 
            // tsmSua
            // 
            tsmSua.Name = "tsmSua";
            tsmSua.Size = new Size(212, 22);
            tsmSua.Text = "✏️ Sửa thông tin";
            tsmSua.Click += tsmSua_Click;
            // 
            // tsmDoiTrangThai
            // 
            tsmDoiTrangThai.Name = "tsmDoiTrangThai";
            tsmDoiTrangThai.Size = new Size(212, 22);
            tsmDoiTrangThai.Text = "🔄 Đổi trạng thái hoạt động";
            tsmDoiTrangThai.Click += tsmDoiTrangThai_Click;
            // 
            // tsmTaoSoDo
            // 
            tsmTaoSoDo.Name = "tsmTaoSoDo";
            tsmTaoSoDo.Size = new Size(212, 22);
            tsmTaoSoDo.Text = "🪑 Tạo sơ đồ ghế...";
            tsmTaoSoDo.Click += tsmTaoSoDo_Click;
            // 
            // toolStripSeparator1
            // 
            toolStripSeparator1.Name = "toolStripSeparator1";
            toolStripSeparator1.Size = new Size(209, 6);
            // 
            // tsmLamMoi
            // 
            tsmLamMoi.Name = "tsmLamMoi";
            tsmLamMoi.Size = new Size(212, 22);
            tsmLamMoi.Text = "🔄 Tải lại dữ liệu";
            tsmLamMoi.Click += tsmLamMoi_Click;
            // 
            // lblDanhSachRap
            // 
            lblDanhSachRap.AutoSize = true;
            lblDanhSachRap.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            lblDanhSachRap.ForeColor = Color.FromArgb(24, 24, 27);
            lblDanhSachRap.Location = new Point(12, 12);
            lblDanhSachRap.Name = "lblDanhSachRap";
            lblDanhSachRap.Size = new Size(198, 19);
            lblDanhSachRap.TabIndex = 0;
            lblDanhSachRap.Text = "HỆ THỐNG CỤM RẠP & PHÒNG";
            // 
            // pnlRight
            // 
            pnlRight.BackColor = Color.White;
            pnlRight.BorderStyle = BorderStyle.FixedSingle;
            pnlRight.Controls.Add(pnlSeatMapContainer);
            pnlRight.Controls.Add(pnlSeatControlBar);
            pnlRight.Controls.Add(pnlChuThich);
            pnlRight.Controls.Add(pnlThongTinPhong);
            pnlRight.Dock = DockStyle.Fill;
            pnlRight.Location = new Point(8, 10);
            pnlRight.Name = "pnlRight";
            pnlRight.Padding = new Padding(12);
            pnlRight.Size = new Size(628, 512);
            pnlRight.TabIndex = 0;
            // 
            // pnlSeatMapContainer
            // 
            pnlSeatMapContainer.AutoScroll = true;
            pnlSeatMapContainer.BackColor = Color.FromArgb(248, 250, 252);
            pnlSeatMapContainer.BorderStyle = BorderStyle.FixedSingle;
            pnlSeatMapContainer.Controls.Add(flpGhe);
            pnlSeatMapContainer.Controls.Add(lblScreen);
            pnlSeatMapContainer.Dock = DockStyle.Fill;
            pnlSeatMapContainer.Location = new Point(12, 107);
            pnlSeatMapContainer.Name = "pnlSeatMapContainer";
            pnlSeatMapContainer.Padding = new Padding(15);
            pnlSeatMapContainer.Size = new Size(602, 348);
            pnlSeatMapContainer.TabIndex = 2;
            // 
            // flpGhe
            // 
            flpGhe.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            flpGhe.AutoScroll = true;
            flpGhe.Location = new Point(15, 60);
            flpGhe.Name = "flpGhe";
            flpGhe.Size = new Size(570, 270);
            flpGhe.TabIndex = 1;
            // 
            // lblScreen
            // 
            lblScreen.BackColor = Color.FromArgb(203, 213, 225);
            lblScreen.Dock = DockStyle.Top;
            lblScreen.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblScreen.ForeColor = Color.FromArgb(71, 85, 105);
            lblScreen.Location = new Point(15, 15);
            lblScreen.Name = "lblScreen";
            lblScreen.Size = new Size(570, 30);
            lblScreen.TabIndex = 0;
            lblScreen.Text = "━━━━ MÀN HÌNH CHIẾU ━━━━";
            lblScreen.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // pnlSeatControlBar
            // 
            pnlSeatControlBar.BackColor = Color.FromArgb(241, 245, 249);
            pnlSeatControlBar.BorderStyle = BorderStyle.FixedSingle;
            pnlSeatControlBar.Controls.Add(flpSeatActions);
            pnlSeatControlBar.Dock = DockStyle.Top;
            pnlSeatControlBar.Location = new Point(12, 65);
            pnlSeatControlBar.Name = "pnlSeatControlBar";
            pnlSeatControlBar.Padding = new Padding(4);
            pnlSeatControlBar.Size = new Size(602, 42);
            pnlSeatControlBar.TabIndex = 1;
            // 
            // flpSeatActions
            // 
            flpSeatActions.Controls.Add(lblGheDangChon);
            flpSeatActions.Controls.Add(cboDoiLoaiGhe);
            flpSeatActions.Controls.Add(btnDoiLoaiGhe);
            flpSeatActions.Controls.Add(btnDoiTrangThaiGhe);
            flpSeatActions.Dock = DockStyle.Fill;
            flpSeatActions.Location = new Point(4, 4);
            flpSeatActions.Name = "flpSeatActions";
            flpSeatActions.Size = new Size(592, 32);
            flpSeatActions.TabIndex = 0;
            // 
            // lblGheDangChon
            // 
            lblGheDangChon.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblGheDangChon.ForeColor = Color.FromArgb(15, 23, 42);
            lblGheDangChon.Location = new Point(3, 4);
            lblGheDangChon.Margin = new Padding(3, 4, 3, 0);
            lblGheDangChon.Name = "lblGheDangChon";
            lblGheDangChon.Size = new Size(200, 24);
            lblGheDangChon.TabIndex = 0;
            lblGheDangChon.Text = "Ghế đang chọn: [Chưa chọn]";
            // 
            // cboDoiLoaiGhe
            // 
            cboDoiLoaiGhe.DropDownStyle = ComboBoxStyle.DropDownList;
            cboDoiLoaiGhe.Font = new Font("Segoe UI", 8.5F, FontStyle.Regular, GraphicsUnit.Point);
            cboDoiLoaiGhe.FormattingEnabled = true;
            cboDoiLoaiGhe.Location = new Point(209, 3);
            cboDoiLoaiGhe.Name = "cboDoiLoaiGhe";
            cboDoiLoaiGhe.Size = new Size(130, 21);
            cboDoiLoaiGhe.TabIndex = 1;
            // 
            // btnDoiLoaiGhe
            // 
            btnDoiLoaiGhe.BackColor = Color.FromArgb(71, 85, 105);
            btnDoiLoaiGhe.Cursor = Cursors.Hand;
            btnDoiLoaiGhe.FlatAppearance.BorderSize = 0;
            btnDoiLoaiGhe.FlatStyle = FlatStyle.Flat;
            btnDoiLoaiGhe.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            btnDoiLoaiGhe.ForeColor = Color.White;
            btnDoiLoaiGhe.Location = new Point(345, 2);
            btnDoiLoaiGhe.Margin = new Padding(3, 2, 3, 2);
            btnDoiLoaiGhe.Name = "btnDoiLoaiGhe";
            btnDoiLoaiGhe.Size = new Size(90, 24);
            btnDoiLoaiGhe.TabIndex = 2;
            btnDoiLoaiGhe.Text = "Đổi loại ghế";
            btnDoiLoaiGhe.UseVisualStyleBackColor = false;
            btnDoiLoaiGhe.Click += btnDoiLoaiGhe_Click;
            // 
            // btnDoiTrangThaiGhe
            // 
            btnDoiTrangThaiGhe.BackColor = Color.FromArgb(185, 28, 28);
            btnDoiTrangThaiGhe.Cursor = Cursors.Hand;
            btnDoiTrangThaiGhe.FlatAppearance.BorderSize = 0;
            btnDoiTrangThaiGhe.FlatStyle = FlatStyle.Flat;
            btnDoiTrangThaiGhe.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            btnDoiTrangThaiGhe.ForeColor = Color.White;
            btnDoiTrangThaiGhe.Location = new Point(441, 2);
            btnDoiTrangThaiGhe.Margin = new Padding(3, 2, 3, 2);
            btnDoiTrangThaiGhe.Name = "btnDoiTrangThaiGhe";
            btnDoiTrangThaiGhe.Size = new Size(140, 24);
            btnDoiTrangThaiGhe.TabIndex = 3;
            btnDoiTrangThaiGhe.Text = "⛔ Đổi Hỏng/Hoạt động";
            btnDoiTrangThaiGhe.UseVisualStyleBackColor = false;
            btnDoiTrangThaiGhe.Click += btnDoiTrangThaiGhe_Click;
            // 
            // pnlChuThich
            // 
            pnlChuThich.Controls.Add(lblChuThich);
            pnlChuThich.Dock = DockStyle.Bottom;
            pnlChuThich.Location = new Point(12, 455);
            pnlChuThich.Name = "pnlChuThich";
            pnlChuThich.Size = new Size(602, 43);
            pnlChuThich.TabIndex = 3;
            // 
            // lblChuThich
            // 
            lblChuThich.Dock = DockStyle.Fill;
            lblChuThich.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            lblChuThich.ForeColor = Color.FromArgb(71, 85, 105);
            lblChuThich.Location = new Point(0, 0);
            lblChuThich.Name = "lblChuThich";
            lblChuThich.Size = new Size(602, 43);
            lblChuThich.TabIndex = 0;
            lblChuThich.Text = "Chú thích màu sắc: 🟩 Ghế thường | 🟧 Ghế VIP | 🟪 Ghế Sweetbox | ⬛ Hỏng/Ngừng sử dụng\n(Bấm chọn ghế hoặc bấm chuột phải vào ghế để đổi nhanh loại hoặc đổi trạng thái)";
            lblChuThich.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // pnlThongTinPhong
            // 
            pnlThongTinPhong.Controls.Add(flpPhongButtons);
            pnlThongTinPhong.Controls.Add(lblThongTinPhong);
            pnlThongTinPhong.Dock = DockStyle.Top;
            pnlThongTinPhong.Location = new Point(12, 12);
            pnlThongTinPhong.Name = "pnlThongTinPhong";
            pnlThongTinPhong.Size = new Size(602, 53);
            pnlThongTinPhong.TabIndex = 0;
            // 
            // flpPhongButtons
            // 
            flpPhongButtons.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            flpPhongButtons.Controls.Add(btnTaoSoDoGhe);
            flpPhongButtons.Controls.Add(btnSuaPhong);
            flpPhongButtons.Controls.Add(btnDoiTrangThaiPhong);
            flpPhongButtons.FlowDirection = FlowDirection.RightToLeft;
            flpPhongButtons.Location = new Point(262, 5);
            flpPhongButtons.Name = "flpPhongButtons";
            flpPhongButtons.Size = new Size(340, 42);
            flpPhongButtons.TabIndex = 1;
            // 
            // btnTaoSoDoGhe
            // 
            btnTaoSoDoGhe.BackColor = Color.FromArgb(211, 47, 47);
            btnTaoSoDoGhe.Cursor = Cursors.Hand;
            btnTaoSoDoGhe.FlatAppearance.BorderSize = 0;
            btnTaoSoDoGhe.FlatStyle = FlatStyle.Flat;
            btnTaoSoDoGhe.Font = new Font("Segoe UI", 8.5F, FontStyle.Bold, GraphicsUnit.Point);
            btnTaoSoDoGhe.ForeColor = Color.White;
            btnTaoSoDoGhe.Location = new Point(216, 2);
            btnTaoSoDoGhe.Margin = new Padding(2);
            btnTaoSoDoGhe.Name = "btnTaoSoDoGhe";
            btnTaoSoDoGhe.Size = new Size(122, 34);
            btnTaoSoDoGhe.TabIndex = 0;
            btnTaoSoDoGhe.Text = "🪑 Tạo sơ đồ ghế";
            btnTaoSoDoGhe.UseVisualStyleBackColor = false;
            btnTaoSoDoGhe.Click += btnTaoSoDoGhe_Click;
            // 
            // btnSuaPhong
            // 
            btnSuaPhong.BackColor = Color.FromArgb(71, 85, 105);
            btnSuaPhong.Cursor = Cursors.Hand;
            btnSuaPhong.FlatAppearance.BorderSize = 0;
            btnSuaPhong.FlatStyle = FlatStyle.Flat;
            btnSuaPhong.Font = new Font("Segoe UI", 8.5F, FontStyle.Bold, GraphicsUnit.Point);
            btnSuaPhong.ForeColor = Color.White;
            btnSuaPhong.Location = new Point(114, 2);
            btnSuaPhong.Margin = new Padding(2);
            btnSuaPhong.Name = "btnSuaPhong";
            btnSuaPhong.Size = new Size(98, 34);
            btnSuaPhong.TabIndex = 1;
            btnSuaPhong.Text = "✏️ Sửa phòng";
            btnSuaPhong.UseVisualStyleBackColor = false;
            btnSuaPhong.Click += btnSuaPhong_Click;
            // 
            // btnDoiTrangThaiPhong
            // 
            btnDoiTrangThaiPhong.BackColor = Color.FromArgb(241, 245, 249);
            btnDoiTrangThaiPhong.Cursor = Cursors.Hand;
            btnDoiTrangThaiPhong.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnDoiTrangThaiPhong.FlatStyle = FlatStyle.Flat;
            btnDoiTrangThaiPhong.Font = new Font("Segoe UI", 8F, FontStyle.Regular, GraphicsUnit.Point);
            btnDoiTrangThaiPhong.ForeColor = Color.FromArgb(51, 65, 85);
            btnDoiTrangThaiPhong.Location = new Point(22, 2);
            btnDoiTrangThaiPhong.Margin = new Padding(2);
            btnDoiTrangThaiPhong.Name = "btnDoiTrangThaiPhong";
            btnDoiTrangThaiPhong.Size = new Size(88, 34);
            btnDoiTrangThaiPhong.TabIndex = 2;
            btnDoiTrangThaiPhong.Text = "🔄 Trạng thái";
            btnDoiTrangThaiPhong.UseVisualStyleBackColor = false;
            btnDoiTrangThaiPhong.Click += btnDoiTrangThaiPhong_Click;
            // 
            // lblThongTinPhong
            // 
            lblThongTinPhong.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            lblThongTinPhong.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            lblThongTinPhong.ForeColor = Color.FromArgb(24, 24, 27);
            lblThongTinPhong.Location = new Point(3, 4);
            lblThongTinPhong.Name = "lblThongTinPhong";
            lblThongTinPhong.Size = new Size(253, 43);
            lblThongTinPhong.TabIndex = 0;
            lblThongTinPhong.Text = "SƠ ĐỒ GHẾ: Đang tải dữ liệu...";
            // 
            // cmsGhe
            // 
            cmsGhe.Items.AddRange(new ToolStripItem[] { tsmGheThuong, tsmGheVip, tsmGheSweetbox, toolStripSeparator2, tsmDanhDauHong, tsmDanhDauHoatDong });
            cmsGhe.Name = "cmsGhe";
            cmsGhe.Size = new Size(270, 120);
            // 
            // tsmGheThuong
            // 
            tsmGheThuong.Name = "tsmGheThuong";
            tsmGheThuong.Size = new Size(269, 22);
            tsmGheThuong.Text = "🟩 Đổi sang: Ghế thường";
            tsmGheThuong.Click += tsmGheThuong_Click;
            // 
            // tsmGheVip
            // 
            tsmGheVip.Name = "tsmGheVip";
            tsmGheVip.Size = new Size(269, 22);
            tsmGheVip.Text = "🟧 Đổi sang: Ghế VIP";
            tsmGheVip.Click += tsmGheVip_Click;
            // 
            // tsmGheSweetbox
            // 
            tsmGheSweetbox.Name = "tsmGheSweetbox";
            tsmGheSweetbox.Size = new Size(269, 22);
            tsmGheSweetbox.Text = "🟪 Đổi sang: Ghế Sweetbox";
            tsmGheSweetbox.Click += tsmGheSweetbox_Click;
            // 
            // toolStripSeparator2
            // 
            toolStripSeparator2.Name = "toolStripSeparator2";
            toolStripSeparator2.Size = new Size(266, 6);
            // 
            // tsmDanhDauHong
            // 
            tsmDanhDauHong.Name = "tsmDanhDauHong";
            tsmDanhDauHong.Size = new Size(269, 22);
            tsmDanhDauHong.Text = "⛔ Đánh dấu: Hỏng / Ngừng sử dụng";
            tsmDanhDauHong.Click += tsmDanhDauHong_Click;
            // 
            // tsmDanhDauHoatDong
            // 
            tsmDanhDauHoatDong.Name = "tsmDanhDauHoatDong";
            tsmDanhDauHoatDong.Size = new Size(269, 22);
            tsmDanhDauHoatDong.Text = "✅ Đánh dấu: Hoạt động bình thường";
            tsmDanhDauHoatDong.Click += tsmDanhDauHoatDong_Click;
            // 
            // UcRapPhongChieu
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(240, 242, 245);
            Controls.Add(splContainer);
            Controls.Add(pnlBanner);
            Name = "UcRapPhongChieu";
            Padding = new Padding(15);
            Size = new Size(980, 600);
            pnlBanner.ResumeLayout(false);
            pnlBanner.PerformLayout();
            splContainer.Panel1.ResumeLayout(false);
            splContainer.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splContainer).EndInit();
            splContainer.ResumeLayout(false);
            pnlLeft.ResumeLayout(false);
            pnlLeft.PerformLayout();
            pnlLeftButtons.ResumeLayout(false);
            cmsRapPhong.ResumeLayout(false);
            pnlRight.ResumeLayout(false);
            pnlSeatMapContainer.ResumeLayout(false);
            pnlSeatControlBar.ResumeLayout(false);
            flpSeatActions.ResumeLayout(false);
            pnlChuThich.ResumeLayout(false);
            pnlThongTinPhong.ResumeLayout(false);
            flpPhongButtons.ResumeLayout(false);
            cmsGhe.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlBanner;
        private Label lblDbStatus;
        private Label lblTieuDe;
        private SplitContainer splContainer;
        private Panel pnlLeft;
        private Label lblDanhSachRap;
        private TreeView trvRapPhong;
        private TableLayoutPanel pnlLeftButtons;
        private Button btnThemRap;
        private Button btnThemPhong;
        private Button btnSuaRapPhong;
        private Button btnDoiTrangThai;
        private Panel pnlRight;
        private Panel pnlThongTinPhong;
        private Label lblThongTinPhong;
        private FlowLayoutPanel flpPhongButtons;
        private Button btnTaoSoDoGhe;
        private Button btnSuaPhong;
        private Button btnDoiTrangThaiPhong;
        private Panel pnlSeatControlBar;
        private FlowLayoutPanel flpSeatActions;
        private Label lblGheDangChon;
        private ComboBox cboDoiLoaiGhe;
        private Button btnDoiLoaiGhe;
        private Button btnDoiTrangThaiGhe;
        private Panel pnlSeatMapContainer;
        private Label lblScreen;
        private FlowLayoutPanel flpGhe;
        private Panel pnlChuThich;
        private Label lblChuThich;
        private ContextMenuStrip cmsRapPhong;
        private ToolStripMenuItem tsmThemPhong;
        private ToolStripMenuItem tsmSua;
        private ToolStripMenuItem tsmDoiTrangThai;
        private ToolStripMenuItem tsmTaoSoDo;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripMenuItem tsmLamMoi;
        private ContextMenuStrip cmsGhe;
        private ToolStripMenuItem tsmGheThuong;
        private ToolStripMenuItem tsmGheVip;
        private ToolStripMenuItem tsmGheSweetbox;
        private ToolStripSeparator toolStripSeparator2;
        private ToolStripMenuItem tsmDanhDauHong;
        private ToolStripMenuItem tsmDanhDauHoatDong;
    }
}
