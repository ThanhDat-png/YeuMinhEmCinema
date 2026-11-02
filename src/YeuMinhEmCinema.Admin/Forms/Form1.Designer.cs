namespace YeuMinhEmCinema.Admin
{
    partial class Form1
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
            DataGridViewCellStyle dataGridViewCellStyle1 = new DataGridViewCellStyle();
            DataGridViewCellStyle dataGridViewCellStyle2 = new DataGridViewCellStyle();
            pnlSidebar = new Panel();
            flpNav = new FlowLayoutPanel();
            btnNavTongQuan = new Button();
            btnNavQuanLyPhim = new Button();
            btnNavRapPhong = new Button();
            btnNavLichChieu = new Button();
            btnNavGiaVeFnb = new Button();
            btnNavDonDatVe = new Button();
            btnNavBanVe = new Button();
            btnNavKiemTraVe = new Button();
            btnNavKhachHang = new Button();
            btnNavNhanVien = new Button();
            btnNavBaoCao = new Button();
            pnlBrand = new Panel();
            lblBrandSubtitle = new Label();
            lblBrandTitle = new Label();
            pnlHeader = new Panel();
            pnlUser = new Panel();
            lblUserRole = new Label();
            lblUserName = new Label();
            lblScreenTitle = new Label();
            pnlContent = new Panel();
            pnlQuanLyPhim = new Panel();
            pnlGridContainer = new Panel();
            dgvPhim = new DataGridView();
            pnlPhimDetail = new Panel();
            lblChiTietPhim = new Label();
            lblPhimDetailTitle = new Label();
            pnlChucNang = new FlowLayoutPanel();
            pnlTimKiemGroup = new Panel();
            pnlLocGroup = new Panel();
            pnlNutTimGroup = new Panel();
            pnlTacVuPhimGroup = new Panel();
            btnNgungChieu = new Button();
            btnSuaPhim = new Button();
            btnThemPhim = new Button();
            btnLamMoiPhim = new Button();
            btnTimKiemPhim = new Button();
            cboLocTrangThai = new ComboBox();
            lblLocTrangThai = new Label();
            txtTimKiemPhim = new TextBox();
            lblTimKiemPhim = new Label();
            pnlDatabaseBanner = new Panel();
            lblDbStatus = new Label();
            lblPhimBannerTitle = new Label();
            pnlSidebar.SuspendLayout();
            flpNav.SuspendLayout();
            pnlBrand.SuspendLayout();
            pnlHeader.SuspendLayout();
            pnlUser.SuspendLayout();
            pnlContent.SuspendLayout();
            pnlQuanLyPhim.SuspendLayout();
            pnlGridContainer.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvPhim).BeginInit();
            pnlPhimDetail.SuspendLayout();
            pnlChucNang.SuspendLayout();
            pnlTimKiemGroup.SuspendLayout();
            pnlLocGroup.SuspendLayout();
            pnlNutTimGroup.SuspendLayout();
            pnlTacVuPhimGroup.SuspendLayout();
            pnlDatabaseBanner.SuspendLayout();
            SuspendLayout();
            // 
            // pnlSidebar
            // 
            pnlSidebar.BackColor = Color.FromArgb(20, 20, 26);
            pnlSidebar.Controls.Add(flpNav);
            pnlSidebar.Controls.Add(pnlBrand);
            pnlSidebar.Dock = DockStyle.Left;
            pnlSidebar.Location = new Point(0, 0);
            pnlSidebar.Name = "pnlSidebar";
            pnlSidebar.Size = new Size(230, 768);
            pnlSidebar.TabIndex = 0;
            // 
            // flpNav
            // 
            flpNav.AutoScroll = true;
            flpNav.Controls.Add(btnNavTongQuan);
            flpNav.Controls.Add(btnNavQuanLyPhim);
            flpNav.Controls.Add(btnNavRapPhong);
            flpNav.Controls.Add(btnNavLichChieu);
            flpNav.Controls.Add(btnNavGiaVeFnb);
            flpNav.Controls.Add(btnNavDonDatVe);
            flpNav.Controls.Add(btnNavBanVe);
            flpNav.Controls.Add(btnNavKiemTraVe);
            flpNav.Controls.Add(btnNavKhachHang);
            flpNav.Controls.Add(btnNavNhanVien);
            flpNav.Controls.Add(btnNavBaoCao);
            flpNav.Dock = DockStyle.Fill;
            flpNav.Location = new Point(0, 75);
            flpNav.Name = "flpNav";
            flpNav.Padding = new Padding(8, 10, 8, 10);
            flpNav.Size = new Size(230, 693);
            flpNav.TabIndex = 1;
            // 
            // btnNavTongQuan
            // 
            btnNavTongQuan.Cursor = Cursors.Hand;
            btnNavTongQuan.FlatAppearance.BorderSize = 0;
            btnNavTongQuan.FlatStyle = FlatStyle.Flat;
            btnNavTongQuan.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavTongQuan.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavTongQuan.Location = new Point(11, 13);
            btnNavTongQuan.Margin = new Padding(3, 3, 3, 4);
            btnNavTongQuan.Name = "btnNavTongQuan";
            btnNavTongQuan.Size = new Size(205, 42);
            btnNavTongQuan.TabIndex = 0;
            btnNavTongQuan.Text = "📊   Tổng quan";
            btnNavTongQuan.TextAlign = ContentAlignment.MiddleLeft;
            btnNavTongQuan.UseVisualStyleBackColor = true;
            btnNavTongQuan.Click += btnNavTongQuan_Click;
            // 
            // btnNavQuanLyPhim
            // 
            btnNavQuanLyPhim.BackColor = Color.FromArgb(211, 47, 47);
            btnNavQuanLyPhim.Cursor = Cursors.Hand;
            btnNavQuanLyPhim.FlatAppearance.BorderSize = 0;
            btnNavQuanLyPhim.FlatStyle = FlatStyle.Flat;
            btnNavQuanLyPhim.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            btnNavQuanLyPhim.ForeColor = Color.White;
            btnNavQuanLyPhim.Location = new Point(11, 62);
            btnNavQuanLyPhim.Margin = new Padding(3, 3, 3, 4);
            btnNavQuanLyPhim.Name = "btnNavQuanLyPhim";
            btnNavQuanLyPhim.Size = new Size(205, 42);
            btnNavQuanLyPhim.TabIndex = 1;
            btnNavQuanLyPhim.Text = "🎬   Quản lý phim";
            btnNavQuanLyPhim.TextAlign = ContentAlignment.MiddleLeft;
            btnNavQuanLyPhim.UseVisualStyleBackColor = false;
            btnNavQuanLyPhim.Click += btnNavQuanLyPhim_Click;
            // 
            // btnNavRapPhong
            // 
            btnNavRapPhong.Cursor = Cursors.Hand;
            btnNavRapPhong.FlatAppearance.BorderSize = 0;
            btnNavRapPhong.FlatStyle = FlatStyle.Flat;
            btnNavRapPhong.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavRapPhong.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavRapPhong.Location = new Point(11, 111);
            btnNavRapPhong.Margin = new Padding(3, 3, 3, 4);
            btnNavRapPhong.Name = "btnNavRapPhong";
            btnNavRapPhong.Size = new Size(205, 42);
            btnNavRapPhong.TabIndex = 2;
            btnNavRapPhong.Text = "🏛️   Rạp & Phòng chiếu";
            btnNavRapPhong.TextAlign = ContentAlignment.MiddleLeft;
            btnNavRapPhong.UseVisualStyleBackColor = true;
            btnNavRapPhong.Click += btnNavRapPhong_Click;
            // 
            // btnNavLichChieu
            // 
            btnNavLichChieu.Cursor = Cursors.Hand;
            btnNavLichChieu.FlatAppearance.BorderSize = 0;
            btnNavLichChieu.FlatStyle = FlatStyle.Flat;
            btnNavLichChieu.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavLichChieu.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavLichChieu.Location = new Point(11, 160);
            btnNavLichChieu.Margin = new Padding(3, 3, 3, 4);
            btnNavLichChieu.Name = "btnNavLichChieu";
            btnNavLichChieu.Size = new Size(205, 42);
            btnNavLichChieu.TabIndex = 3;
            btnNavLichChieu.Text = "📅   Lịch chiếu";
            btnNavLichChieu.TextAlign = ContentAlignment.MiddleLeft;
            btnNavLichChieu.UseVisualStyleBackColor = true;
            btnNavLichChieu.Click += btnNavLichChieu_Click;
            // 
            // btnNavGiaVeFnb
            // 
            btnNavGiaVeFnb.Cursor = Cursors.Hand;
            btnNavGiaVeFnb.FlatAppearance.BorderSize = 0;
            btnNavGiaVeFnb.FlatStyle = FlatStyle.Flat;
            btnNavGiaVeFnb.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavGiaVeFnb.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavGiaVeFnb.Location = new Point(11, 209);
            btnNavGiaVeFnb.Margin = new Padding(3, 3, 3, 4);
            btnNavGiaVeFnb.Name = "btnNavGiaVeFnb";
            btnNavGiaVeFnb.Size = new Size(205, 42);
            btnNavGiaVeFnb.TabIndex = 4;
            btnNavGiaVeFnb.Text = "🍿   Giá vé & F&&B";
            btnNavGiaVeFnb.TextAlign = ContentAlignment.MiddleLeft;
            btnNavGiaVeFnb.UseVisualStyleBackColor = true;
            btnNavGiaVeFnb.Click += btnNavGiaVeFnb_Click;
            // 
            // btnNavDonDatVe
            // 
            btnNavDonDatVe.Cursor = Cursors.Hand;
            btnNavDonDatVe.FlatAppearance.BorderSize = 0;
            btnNavDonDatVe.FlatStyle = FlatStyle.Flat;
            btnNavDonDatVe.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavDonDatVe.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavDonDatVe.Location = new Point(11, 258);
            btnNavDonDatVe.Margin = new Padding(3, 3, 3, 4);
            btnNavDonDatVe.Name = "btnNavDonDatVe";
            btnNavDonDatVe.Size = new Size(205, 42);
            btnNavDonDatVe.TabIndex = 5;
            btnNavDonDatVe.Text = "📑   Đơn đặt vé";
            btnNavDonDatVe.TextAlign = ContentAlignment.MiddleLeft;
            btnNavDonDatVe.UseVisualStyleBackColor = true;
            btnNavDonDatVe.Click += btnNavDonDatVe_Click;
            // 
            // btnNavBanVe
            // 
            btnNavBanVe.Cursor = Cursors.Hand;
            btnNavBanVe.FlatAppearance.BorderSize = 0;
            btnNavBanVe.FlatStyle = FlatStyle.Flat;
            btnNavBanVe.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavBanVe.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavBanVe.Location = new Point(11, 307);
            btnNavBanVe.Margin = new Padding(3, 3, 3, 4);
            btnNavBanVe.Name = "btnNavBanVe";
            btnNavBanVe.Size = new Size(205, 42);
            btnNavBanVe.TabIndex = 6;
            btnNavBanVe.Text = "🛒   Bán vé tại quầy";
            btnNavBanVe.TextAlign = ContentAlignment.MiddleLeft;
            btnNavBanVe.UseVisualStyleBackColor = true;
            btnNavBanVe.Click += btnNavBanVe_Click;
            // 
            // btnNavKiemTraVe
            // 
            btnNavKiemTraVe.Cursor = Cursors.Hand;
            btnNavKiemTraVe.FlatAppearance.BorderSize = 0;
            btnNavKiemTraVe.FlatStyle = FlatStyle.Flat;
            btnNavKiemTraVe.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavKiemTraVe.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavKiemTraVe.Location = new Point(11, 356);
            btnNavKiemTraVe.Margin = new Padding(3, 3, 3, 4);
            btnNavKiemTraVe.Name = "btnNavKiemTraVe";
            btnNavKiemTraVe.Size = new Size(205, 42);
            btnNavKiemTraVe.TabIndex = 7;
            btnNavKiemTraVe.Text = "🔍   Kiểm tra vé";
            btnNavKiemTraVe.TextAlign = ContentAlignment.MiddleLeft;
            btnNavKiemTraVe.UseVisualStyleBackColor = true;
            btnNavKiemTraVe.Click += btnNavKiemTraVe_Click;
            // 
            // btnNavKhachHang
            // 
            btnNavKhachHang.Cursor = Cursors.Hand;
            btnNavKhachHang.FlatAppearance.BorderSize = 0;
            btnNavKhachHang.FlatStyle = FlatStyle.Flat;
            btnNavKhachHang.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavKhachHang.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavKhachHang.Location = new Point(11, 405);
            btnNavKhachHang.Margin = new Padding(3, 3, 3, 4);
            btnNavKhachHang.Name = "btnNavKhachHang";
            btnNavKhachHang.Size = new Size(205, 42);
            btnNavKhachHang.TabIndex = 8;
            btnNavKhachHang.Text = "👥   Khách hàng";
            btnNavKhachHang.TextAlign = ContentAlignment.MiddleLeft;
            btnNavKhachHang.UseVisualStyleBackColor = true;
            btnNavKhachHang.Click += btnNavKhachHang_Click;
            // 
            // btnNavNhanVien
            // 
            btnNavNhanVien.Cursor = Cursors.Hand;
            btnNavNhanVien.FlatAppearance.BorderSize = 0;
            btnNavNhanVien.FlatStyle = FlatStyle.Flat;
            btnNavNhanVien.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavNhanVien.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavNhanVien.Location = new Point(11, 454);
            btnNavNhanVien.Margin = new Padding(3, 3, 3, 4);
            btnNavNhanVien.Name = "btnNavNhanVien";
            btnNavNhanVien.Size = new Size(205, 42);
            btnNavNhanVien.TabIndex = 9;
            btnNavNhanVien.Text = "👤   Nhân viên & Quyền";
            btnNavNhanVien.TextAlign = ContentAlignment.MiddleLeft;
            btnNavNhanVien.UseVisualStyleBackColor = true;
            btnNavNhanVien.Click += btnNavNhanVien_Click;
            // 
            // btnNavBaoCao
            // 
            btnNavBaoCao.Cursor = Cursors.Hand;
            btnNavBaoCao.FlatAppearance.BorderSize = 0;
            btnNavBaoCao.FlatStyle = FlatStyle.Flat;
            btnNavBaoCao.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            btnNavBaoCao.ForeColor = Color.FromArgb(203, 213, 225);
            btnNavBaoCao.Location = new Point(11, 503);
            btnNavBaoCao.Margin = new Padding(3, 3, 3, 4);
            btnNavBaoCao.Name = "btnNavBaoCao";
            btnNavBaoCao.Size = new Size(205, 42);
            btnNavBaoCao.TabIndex = 10;
            btnNavBaoCao.Text = "📈   Báo cáo & Thống kê";
            btnNavBaoCao.TextAlign = ContentAlignment.MiddleLeft;
            btnNavBaoCao.UseVisualStyleBackColor = true;
            btnNavBaoCao.Click += btnNavBaoCao_Click;
            // 
            // pnlBrand
            // 
            pnlBrand.BackColor = Color.FromArgb(15, 15, 20);
            pnlBrand.Controls.Add(lblBrandSubtitle);
            pnlBrand.Controls.Add(lblBrandTitle);
            pnlBrand.Dock = DockStyle.Top;
            pnlBrand.Location = new Point(0, 0);
            pnlBrand.Name = "pnlBrand";
            pnlBrand.Padding = new Padding(15, 12, 15, 12);
            pnlBrand.Size = new Size(230, 75);
            pnlBrand.TabIndex = 0;
            // 
            // lblBrandSubtitle
            // 
            lblBrandSubtitle.AutoSize = true;
            lblBrandSubtitle.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblBrandSubtitle.ForeColor = Color.FromArgb(211, 47, 47);
            lblBrandSubtitle.Location = new Point(16, 44);
            lblBrandSubtitle.Name = "lblBrandSubtitle";
            lblBrandSubtitle.Size = new Size(137, 13);
            lblBrandSubtitle.TabIndex = 1;
            lblBrandSubtitle.Text = "ADMIN CONTROL PANEL";
            // 
            // lblBrandTitle
            // 
            lblBrandTitle.AutoSize = true;
            lblBrandTitle.Font = new Font("Segoe UI", 12.5F, FontStyle.Bold, GraphicsUnit.Point);
            lblBrandTitle.ForeColor = Color.White;
            lblBrandTitle.Location = new Point(14, 18);
            lblBrandTitle.Name = "lblBrandTitle";
            lblBrandTitle.Size = new Size(177, 23);
            lblBrandTitle.TabIndex = 0;
            lblBrandTitle.Text = "🎬 YÊU MÌNH EM";
            // 
            // pnlHeader
            // 
            pnlHeader.BackColor = Color.White;
            pnlHeader.BorderStyle = BorderStyle.FixedSingle;
            pnlHeader.Controls.Add(pnlUser);
            pnlHeader.Controls.Add(lblScreenTitle);
            pnlHeader.Dock = DockStyle.Top;
            pnlHeader.Location = new Point(230, 0);
            pnlHeader.Name = "pnlHeader";
            pnlHeader.Padding = new Padding(20, 10, 20, 10);
            pnlHeader.Size = new Size(1050, 60);
            pnlHeader.TabIndex = 1;
            // 
            // pnlUser
            // 
            pnlUser.Controls.Add(lblUserRole);
            pnlUser.Controls.Add(lblUserName);
            pnlUser.Dock = DockStyle.Right;
            pnlUser.Location = new Point(818, 10);
            pnlUser.Name = "pnlUser";
            pnlUser.Size = new Size(210, 38);
            pnlUser.TabIndex = 1;
            // 
            // lblUserRole
            // 
            lblUserRole.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            lblUserRole.Font = new Font("Segoe UI", 8F, FontStyle.Regular, GraphicsUnit.Point);
            lblUserRole.ForeColor = Color.FromArgb(16, 185, 129);
            lblUserRole.Location = new Point(10, 20);
            lblUserRole.Name = "lblUserRole";
            lblUserRole.Size = new Size(195, 15);
            lblUserRole.TabIndex = 1;
            lblUserRole.Text = "🟢 Quản trị viên (Super Admin)";
            lblUserRole.TextAlign = ContentAlignment.MiddleRight;
            // 
            // lblUserName
            // 
            lblUserName.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            lblUserName.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblUserName.ForeColor = Color.FromArgb(24, 24, 27);
            lblUserName.Location = new Point(10, 2);
            lblUserName.Name = "lblUserName";
            lblUserName.Size = new Size(195, 18);
            lblUserName.TabIndex = 0;
            lblUserName.Text = "Admin YeuMinhEm";
            lblUserName.TextAlign = ContentAlignment.MiddleRight;
            // 
            // lblScreenTitle
            // 
            lblScreenTitle.AutoSize = true;
            lblScreenTitle.Font = new Font("Segoe UI", 12.75F, FontStyle.Bold, GraphicsUnit.Point);
            lblScreenTitle.ForeColor = Color.FromArgb(24, 24, 27);
            lblScreenTitle.Location = new Point(20, 17);
            lblScreenTitle.Name = "lblScreenTitle";
            lblScreenTitle.Size = new Size(393, 23);
            lblScreenTitle.TabIndex = 0;
            lblScreenTitle.Text = "🎬 QUẢN LÝ PHIM (KẾT NỐI DATABASE THẬT)";
            // 
            // pnlContent
            // 
            pnlContent.BackColor = Color.FromArgb(240, 242, 245);
            pnlContent.Controls.Add(pnlQuanLyPhim);
            pnlContent.Dock = DockStyle.Fill;
            pnlContent.Location = new Point(230, 60);
            pnlContent.Name = "pnlContent";
            pnlContent.Size = new Size(1050, 708);
            pnlContent.TabIndex = 2;
            // 
            // pnlQuanLyPhim
            // 
            pnlQuanLyPhim.Controls.Add(pnlGridContainer);
            pnlQuanLyPhim.Controls.Add(pnlPhimDetail);
            pnlQuanLyPhim.Controls.Add(pnlChucNang);
            pnlQuanLyPhim.Controls.Add(pnlDatabaseBanner);
            pnlQuanLyPhim.Dock = DockStyle.Fill;
            pnlQuanLyPhim.Location = new Point(0, 0);
            pnlQuanLyPhim.Name = "pnlQuanLyPhim";
            pnlQuanLyPhim.Padding = new Padding(15);
            pnlQuanLyPhim.Size = new Size(1050, 708);
            pnlQuanLyPhim.TabIndex = 0;
            // 
            // pnlGridContainer
            // 
            pnlGridContainer.BackColor = Color.White;
            pnlGridContainer.BorderStyle = BorderStyle.FixedSingle;
            pnlGridContainer.Controls.Add(dgvPhim);
            pnlGridContainer.Dock = DockStyle.Fill;
            pnlGridContainer.Location = new Point(15, 125);
            pnlGridContainer.Name = "pnlGridContainer";
            pnlGridContainer.Padding = new Padding(12);
            pnlGridContainer.Size = new Size(1020, 448);
            pnlGridContainer.TabIndex = 2;
            // 
            // dgvPhim
            // 
            dgvPhim.AllowUserToAddRows = false;
            dgvPhim.AllowUserToDeleteRows = false;
            dgvPhim.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvPhim.BackgroundColor = Color.White;
            dgvPhim.BorderStyle = BorderStyle.None;
            dgvPhim.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle1.Alignment = DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = Color.FromArgb(241, 245, 249);
            dataGridViewCellStyle1.Font = new Font("Segoe UI", 9.75F, FontStyle.Bold, GraphicsUnit.Point);
            dataGridViewCellStyle1.ForeColor = Color.FromArgb(15, 23, 42);
            dataGridViewCellStyle1.SelectionBackColor = Color.FromArgb(241, 245, 249);
            dataGridViewCellStyle1.SelectionForeColor = Color.FromArgb(15, 23, 42);
            dataGridViewCellStyle1.WrapMode = DataGridViewTriState.True;
            dgvPhim.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            dgvPhim.ColumnHeadersHeight = 36;
            dgvPhim.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dataGridViewCellStyle2.Alignment = DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = Color.White;
            dataGridViewCellStyle2.Font = new Font("Segoe UI", 9.5F, FontStyle.Regular, GraphicsUnit.Point);
            dataGridViewCellStyle2.ForeColor = Color.FromArgb(30, 41, 59);
            dataGridViewCellStyle2.SelectionBackColor = Color.FromArgb(254, 226, 226);
            dataGridViewCellStyle2.SelectionForeColor = Color.FromArgb(153, 27, 27);
            dataGridViewCellStyle2.WrapMode = DataGridViewTriState.False;
            dgvPhim.DefaultCellStyle = dataGridViewCellStyle2;
            dgvPhim.Dock = DockStyle.Fill;
            dgvPhim.EnableHeadersVisualStyles = false;
            dgvPhim.GridColor = Color.FromArgb(226, 232, 240);
            dgvPhim.Location = new Point(12, 12);
            dgvPhim.MultiSelect = false;
            dgvPhim.Name = "dgvPhim";
            dgvPhim.ReadOnly = true;
            dgvPhim.RowHeadersVisible = false;
            dgvPhim.RowTemplate.Height = 32;
            dgvPhim.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvPhim.Size = new Size(994, 422);
            dgvPhim.TabIndex = 0;
            dgvPhim.CellContentClick += dataGridView1_CellContentClick;
            dgvPhim.SelectionChanged += dgvPhim_SelectionChanged;
            // 
            // pnlPhimDetail
            // 
            pnlPhimDetail.BackColor = Color.White;
            pnlPhimDetail.BorderStyle = BorderStyle.FixedSingle;
            pnlPhimDetail.Controls.Add(lblChiTietPhim);
            pnlPhimDetail.Controls.Add(lblPhimDetailTitle);
            pnlPhimDetail.Dock = DockStyle.Bottom;
            pnlPhimDetail.Location = new Point(15, 573);
            pnlPhimDetail.Name = "pnlPhimDetail";
            pnlPhimDetail.Padding = new Padding(12);
            pnlPhimDetail.Size = new Size(1020, 120);
            pnlPhimDetail.TabIndex = 3;
            // 
            // lblChiTietPhim
            // 
            lblChiTietPhim.Dock = DockStyle.Fill;
            lblChiTietPhim.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular, GraphicsUnit.Point);
            lblChiTietPhim.ForeColor = Color.FromArgb(51, 65, 85);
            lblChiTietPhim.Location = new Point(12, 35);
            lblChiTietPhim.Name = "lblChiTietPhim";
            lblChiTietPhim.Size = new Size(994, 71);
            lblChiTietPhim.TabIndex = 1;
            lblChiTietPhim.Text = "Chọn một bộ phim trong danh sách phía trên để xem mô tả chi tiết, link trailer và poster...";
            // 
            // lblPhimDetailTitle
            // 
            lblPhimDetailTitle.Dock = DockStyle.Top;
            lblPhimDetailTitle.Font = new Font("Segoe UI", 10F, FontStyle.Bold, GraphicsUnit.Point);
            lblPhimDetailTitle.ForeColor = Color.FromArgb(24, 24, 27);
            lblPhimDetailTitle.Location = new Point(12, 12);
            lblPhimDetailTitle.Name = "lblPhimDetailTitle";
            lblPhimDetailTitle.Size = new Size(994, 23);
            lblPhimDetailTitle.TabIndex = 0;
            lblPhimDetailTitle.Text = "THÔNG TIN CHI TIẾT VÀ MÔ TẢ PHIM ĐANG CHỌN";
            // 
            // 
            // pnlChucNang
            // 
            pnlChucNang.AutoSize = true;
            pnlChucNang.AutoSizeMode = AutoSizeMode.GrowAndShrink;
            pnlChucNang.BackColor = Color.White;
            pnlChucNang.BorderStyle = BorderStyle.FixedSingle;
            pnlChucNang.Controls.Add(pnlTimKiemGroup);
            pnlChucNang.Controls.Add(pnlLocGroup);
            pnlChucNang.Controls.Add(pnlNutTimGroup);
            pnlChucNang.Controls.Add(pnlTacVuPhimGroup);
            pnlChucNang.Dock = DockStyle.Top;
            pnlChucNang.FlowDirection = FlowDirection.LeftToRight;
            pnlChucNang.Location = new Point(15, 63);
            pnlChucNang.Name = "pnlChucNang";
            pnlChucNang.Padding = new Padding(6);
            pnlChucNang.Size = new Size(1020, 58);
            pnlChucNang.TabIndex = 1;
            pnlChucNang.WrapContents = true;
            // 
            // pnlTimKiemGroup
            // 
            pnlTimKiemGroup.Controls.Add(lblTimKiemPhim);
            pnlTimKiemGroup.Controls.Add(txtTimKiemPhim);
            pnlTimKiemGroup.Location = new Point(9, 9);
            pnlTimKiemGroup.Margin = new Padding(3, 3, 8, 3);
            pnlTimKiemGroup.Name = "pnlTimKiemGroup";
            pnlTimKiemGroup.Size = new Size(250, 48);
            pnlTimKiemGroup.TabIndex = 0;
            // 
            // lblTimKiemPhim
            // 
            lblTimKiemPhim.AutoSize = true;
            lblTimKiemPhim.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblTimKiemPhim.ForeColor = Color.FromArgb(71, 85, 105);
            lblTimKiemPhim.Location = new Point(0, 2);
            lblTimKiemPhim.Name = "lblTimKiemPhim";
            lblTimKiemPhim.Size = new Size(116, 13);
            lblTimKiemPhim.TabIndex = 0;
            lblTimKiemPhim.Text = "TÌM KIẾM TÊN PHIM:";
            // 
            // txtTimKiemPhim
            // 
            txtTimKiemPhim.Location = new Point(0, 18);
            txtTimKiemPhim.Name = "txtTimKiemPhim";
            txtTimKiemPhim.PlaceholderText = "Nhập tên phim cần tìm...";
            txtTimKiemPhim.Size = new Size(245, 23);
            txtTimKiemPhim.TabIndex = 1;
            txtTimKiemPhim.KeyDown += txtTimKiemPhim_KeyDown;
            // 
            // pnlLocGroup
            // 
            pnlLocGroup.Controls.Add(lblLocTrangThai);
            pnlLocGroup.Controls.Add(cboLocTrangThai);
            pnlLocGroup.Location = new Point(270, 9);
            pnlLocGroup.Margin = new Padding(3, 3, 8, 3);
            pnlLocGroup.Name = "pnlLocGroup";
            pnlLocGroup.Size = new Size(160, 48);
            pnlLocGroup.TabIndex = 1;
            // 
            // lblLocTrangThai
            // 
            lblLocTrangThai.AutoSize = true;
            lblLocTrangThai.Font = new Font("Segoe UI", 8.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblLocTrangThai.ForeColor = Color.FromArgb(71, 85, 105);
            lblLocTrangThai.Location = new Point(0, 2);
            lblLocTrangThai.Name = "lblLocTrangThai";
            lblLocTrangThai.Size = new Size(76, 13);
            lblLocTrangThai.TabIndex = 0;
            lblLocTrangThai.Text = "TRẠNG THÁI:";
            // 
            // cboLocTrangThai
            // 
            cboLocTrangThai.DropDownStyle = ComboBoxStyle.DropDownList;
            cboLocTrangThai.FormattingEnabled = true;
            cboLocTrangThai.Items.AddRange(new object[] { "Tất cả trạng thái", "Đang chiếu", "Sắp chiếu", "Ngừng chiếu" });
            cboLocTrangThai.Location = new Point(0, 18);
            cboLocTrangThai.Name = "cboLocTrangThai";
            cboLocTrangThai.Size = new Size(155, 23);
            cboLocTrangThai.TabIndex = 1;
            cboLocTrangThai.SelectedIndexChanged += cboLocTrangThai_SelectedIndexChanged;
            // 
            // pnlNutTimGroup
            // 
            pnlNutTimGroup.Controls.Add(btnTimKiemPhim);
            pnlNutTimGroup.Controls.Add(btnLamMoiPhim);
            pnlNutTimGroup.Location = new Point(441, 9);
            pnlNutTimGroup.Margin = new Padding(3, 3, 12, 3);
            pnlNutTimGroup.Name = "pnlNutTimGroup";
            pnlNutTimGroup.Size = new Size(175, 48);
            pnlNutTimGroup.TabIndex = 2;
            // 
            // btnTimKiemPhim
            // 
            btnTimKiemPhim.BackColor = Color.FromArgb(15, 23, 42);
            btnTimKiemPhim.Cursor = Cursors.Hand;
            btnTimKiemPhim.FlatAppearance.BorderSize = 0;
            btnTimKiemPhim.FlatStyle = FlatStyle.Flat;
            btnTimKiemPhim.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnTimKiemPhim.ForeColor = Color.White;
            btnTimKiemPhim.Location = new Point(0, 15);
            btnTimKiemPhim.Name = "btnTimKiemPhim";
            btnTimKiemPhim.Size = new Size(80, 28);
            btnTimKiemPhim.TabIndex = 0;
            btnTimKiemPhim.Text = "Tìm kiếm";
            btnTimKiemPhim.UseVisualStyleBackColor = false;
            btnTimKiemPhim.Click += btnTimKiemPhim_Click;
            // 
            // btnLamMoiPhim
            // 
            btnLamMoiPhim.BackColor = Color.FromArgb(241, 245, 249);
            btnLamMoiPhim.Cursor = Cursors.Hand;
            btnLamMoiPhim.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);
            btnLamMoiPhim.FlatStyle = FlatStyle.Flat;
            btnLamMoiPhim.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point);
            btnLamMoiPhim.ForeColor = Color.FromArgb(71, 85, 105);
            btnLamMoiPhim.Location = new Point(88, 15);
            btnLamMoiPhim.Name = "btnLamMoiPhim";
            btnLamMoiPhim.Size = new Size(82, 28);
            btnLamMoiPhim.TabIndex = 1;
            btnLamMoiPhim.Text = "🔄 Làm mới";
            btnLamMoiPhim.UseVisualStyleBackColor = false;
            btnLamMoiPhim.Click += btnLamMoiPhim_Click;
            // 
            // pnlTacVuPhimGroup
            // 
            pnlTacVuPhimGroup.Controls.Add(btnThemPhim);
            pnlTacVuPhimGroup.Controls.Add(btnSuaPhim);
            pnlTacVuPhimGroup.Controls.Add(btnNgungChieu);
            pnlTacVuPhimGroup.Location = new Point(631, 9);
            pnlTacVuPhimGroup.Margin = new Padding(3, 3, 3, 3);
            pnlTacVuPhimGroup.Name = "pnlTacVuPhimGroup";
            pnlTacVuPhimGroup.Size = new Size(345, 48);
            pnlTacVuPhimGroup.TabIndex = 3;
            // 
            // btnThemPhim
            // 
            btnThemPhim.BackColor = Color.FromArgb(211, 47, 47);
            btnThemPhim.Cursor = Cursors.Hand;
            btnThemPhim.FlatAppearance.BorderSize = 0;
            btnThemPhim.FlatStyle = FlatStyle.Flat;
            btnThemPhim.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnThemPhim.ForeColor = Color.White;
            btnThemPhim.Location = new Point(0, 14);
            btnThemPhim.Name = "btnThemPhim";
            btnThemPhim.Size = new Size(118, 30);
            btnThemPhim.TabIndex = 0;
            btnThemPhim.Text = "+ Thêm phim mới";
            btnThemPhim.UseVisualStyleBackColor = false;
            btnThemPhim.Click += btnThemPhim_Click;
            // 
            // btnSuaPhim
            // 
            btnSuaPhim.BackColor = Color.FromArgb(71, 85, 105);
            btnSuaPhim.Cursor = Cursors.Hand;
            btnSuaPhim.FlatAppearance.BorderSize = 0;
            btnSuaPhim.FlatStyle = FlatStyle.Flat;
            btnSuaPhim.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnSuaPhim.ForeColor = Color.White;
            btnSuaPhim.Location = new Point(124, 14);
            btnSuaPhim.Name = "btnSuaPhim";
            btnSuaPhim.Size = new Size(100, 30);
            btnSuaPhim.TabIndex = 1;
            btnSuaPhim.Text = "✏️ Sửa phim";
            btnSuaPhim.UseVisualStyleBackColor = false;
            btnSuaPhim.Click += btnSuaPhim_Click;
            // 
            // btnNgungChieu
            // 
            btnNgungChieu.BackColor = Color.FromArgb(185, 28, 28);
            btnNgungChieu.Cursor = Cursors.Hand;
            btnNgungChieu.FlatAppearance.BorderSize = 0;
            btnNgungChieu.FlatStyle = FlatStyle.Flat;
            btnNgungChieu.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            btnNgungChieu.ForeColor = Color.White;
            btnNgungChieu.Location = new Point(230, 14);
            btnNgungChieu.Name = "btnNgungChieu";
            btnNgungChieu.Size = new Size(110, 30);
            btnNgungChieu.TabIndex = 2;
            btnNgungChieu.Text = "⛔ Ngừng chiếu";
            btnNgungChieu.UseVisualStyleBackColor = false;
            btnNgungChieu.Click += btnNgungChieu_Click;
            // 
            // pnlDatabaseBanner
            // 
            pnlDatabaseBanner.BackColor = Color.FromArgb(240, 253, 244);
            pnlDatabaseBanner.BorderStyle = BorderStyle.FixedSingle;
            var filmBannerLayout = new TableLayoutPanel
            {
                Name = "pnlPhimBannerLayout", Dock = DockStyle.Fill,
                ColumnCount = 2, RowCount = 1, Padding = new Padding(10, 0, 10, 0)
            };
            filmBannerLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            filmBannerLayout.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            filmBannerLayout.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            filmBannerLayout.Controls.Add(lblPhimBannerTitle, 0, 0);
            filmBannerLayout.Controls.Add(lblDbStatus, 1, 0);
            pnlDatabaseBanner.Controls.Add(filmBannerLayout);
            pnlDatabaseBanner.Dock = DockStyle.Top;
            pnlDatabaseBanner.Location = new Point(15, 15);
            pnlDatabaseBanner.Name = "pnlDatabaseBanner";
            pnlDatabaseBanner.Size = new Size(1020, 48);
            pnlDatabaseBanner.TabIndex = 0;
            // 
            // lblDbStatus
            // 
            lblDbStatus.Anchor = AnchorStyles.Right;
            lblDbStatus.Margin = new Padding(10, 0, 0, 0);
            lblDbStatus.AutoSize = true;
            lblDbStatus.BackColor = Color.FromArgb(16, 185, 129);
            lblDbStatus.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point);
            lblDbStatus.ForeColor = Color.White;
            lblDbStatus.Location = new Point(610, 14);
            lblDbStatus.Padding = new Padding(6, 2, 6, 2);
            lblDbStatus.Name = "lblDbStatus";
            lblDbStatus.Size = new Size(393, 19);
            lblDbStatus.TabIndex = 1;
            lblDbStatus.Text = "Dữ liệu SQL Server";
            // 
            // lblPhimBannerTitle
            // 
            lblPhimBannerTitle.AutoSize = false;
            lblPhimBannerTitle.AutoEllipsis = true;
            lblPhimBannerTitle.Dock = DockStyle.Fill;
            lblPhimBannerTitle.TextAlign = ContentAlignment.MiddleLeft;
            lblPhimBannerTitle.Margin = Padding.Empty;
            lblPhimBannerTitle.Font = new Font("Segoe UI", 11.25F, FontStyle.Bold, GraphicsUnit.Point);
            lblPhimBannerTitle.ForeColor = Color.FromArgb(22, 101, 52);
            lblPhimBannerTitle.Location = new Point(12, 13);
            lblPhimBannerTitle.Name = "lblPhimBannerTitle";
            lblPhimBannerTitle.Size = new Size(318, 20);
            lblPhimBannerTitle.TabIndex = 0;
            lblPhimBannerTitle.Text = "🎬 DANH SÁCH PHIM ĐANG ĐƯỢC QUẢN LÝ";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1280, 768);
            Controls.Add(pnlContent);
            Controls.Add(pnlHeader);
            Controls.Add(pnlSidebar);
            MinimumSize = new Size(1024, 640);
            Name = "Form1";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "Yêu Mình Em Cinema - Hệ Thống Quản Trị Rạp Phim (Admin)";
            pnlSidebar.ResumeLayout(false);
            flpNav.ResumeLayout(false);
            pnlBrand.ResumeLayout(false);
            pnlBrand.PerformLayout();
            pnlHeader.ResumeLayout(false);
            pnlHeader.PerformLayout();
            pnlUser.ResumeLayout(false);
            pnlContent.ResumeLayout(false);
            pnlQuanLyPhim.ResumeLayout(false);
            pnlGridContainer.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvPhim).EndInit();
            pnlPhimDetail.ResumeLayout(false);
            pnlTimKiemGroup.ResumeLayout(false);
            pnlTimKiemGroup.PerformLayout();
            pnlLocGroup.ResumeLayout(false);
            pnlLocGroup.PerformLayout();
            pnlNutTimGroup.ResumeLayout(false);
            pnlTacVuPhimGroup.ResumeLayout(false);
            pnlChucNang.ResumeLayout(false);
            pnlDatabaseBanner.ResumeLayout(false);
            pnlDatabaseBanner.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlSidebar;
        private Panel pnlBrand;
        private Label lblBrandTitle;
        private Label lblBrandSubtitle;
        private FlowLayoutPanel flpNav;
        private Button btnNavTongQuan;
        private Button btnNavQuanLyPhim;
        private Button btnNavRapPhong;
        private Button btnNavLichChieu;
        private Button btnNavGiaVeFnb;
        private Button btnNavDonDatVe;
        private Button btnNavBanVe;
        private Button btnNavKiemTraVe;
        private Button btnNavKhachHang;
        private Button btnNavNhanVien;
        private Button btnNavBaoCao;
        private Panel pnlHeader;
        private Label lblScreenTitle;
        private Panel pnlUser;
        private Label lblUserName;
        private Label lblUserRole;
        private Panel pnlContent;
        private Panel pnlQuanLyPhim;
        private Panel pnlDatabaseBanner;
        private Label lblPhimBannerTitle;
        private Label lblDbStatus;
        private FlowLayoutPanel pnlChucNang;
        private Panel pnlTimKiemGroup;
        private Panel pnlLocGroup;
        private Panel pnlNutTimGroup;
        private Panel pnlTacVuPhimGroup;
        private Label lblTimKiemPhim;
        private TextBox txtTimKiemPhim;
        private Label lblLocTrangThai;
        private ComboBox cboLocTrangThai;
        private Button btnTimKiemPhim;
        private Button btnLamMoiPhim;
        private Button btnThemPhim;
        private Button btnSuaPhim;
        private Button btnNgungChieu;
        private Panel pnlGridContainer;
        private DataGridView dgvPhim;
        private Panel pnlPhimDetail;
        private Label lblPhimDetailTitle;
        private Label lblChiTietPhim;
    }
}
