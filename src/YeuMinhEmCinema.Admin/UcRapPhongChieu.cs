using System.Data;

namespace YeuMinhEmCinema.Admin
{
    public partial class UcRapPhongChieu : UserControl
    {
        // Lưu thông tin mục đang chọn trên TreeView
        private class NodeInfo
        {
            public string Loai { get; set; } = ""; // "RAP" hoặc "PHONG"
            public int Ma { get; set; }
            public string Ten { get; set; } = "";
            public string TrangThai { get; set; } = "";
            public int MaRap { get; set; }
            public string TenRap { get; set; } = "";
            public string DinhDang { get; set; } = "";
            public int SucChua { get; set; }
        }

        // Lưu thông tin ghế đang được chọn trên sơ đồ
        private class GheInfo
        {
            public int MaGhe { get; set; }
            public int MaPhong { get; set; }
            public string HangGhe { get; set; } = "";
            public int SoGhe { get; set; }
            public int MaLoaiGhe { get; set; }
            public string TenLoaiGhe { get; set; } = "";
            public string TrangThai { get; set; } = "";
            public Button? NutGhe { get; set; }
        }

        private NodeInfo? _nodeDangChon;
        private GheInfo? _gheDangChon;
        private DataTable? _bangLoaiGhe;

        public UcRapPhongChieu()
        {
            InitializeComponent();

            NapDanhSachLoaiGheVaoCombo();
            NapCayRapVaPhong();
        }

        private void NapDanhSachLoaiGheVaoCombo()
        {
            try
            {
                _bangLoaiGhe = GheDAL.LayDanhSachLoaiGhe();
                cboDoiLoaiGhe.DataSource = _bangLoaiGhe;
                cboDoiLoaiGhe.DisplayMember = "TenLoai";
                cboDoiLoaiGhe.ValueMember = "MaLoai";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không tải được danh mục loại ghế:\n" + ex.Message, "Lỗi nạp dữ liệu", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Nạp toàn bộ cây dữ liệu Cụm rạp và Phòng chiếu từ database SQL Server.
        /// Sức chứa của từng phòng được tính toán động từ danh sách ghế.
        /// </summary>
        public void NapCayRapVaPhong(int? maPhongCanChon = null)
        {
            trvRapPhong.BeginUpdate();
            trvRapPhong.Nodes.Clear();

            TreeNode? nodeCanChon = null;

            try
            {
                DataTable dtRap = RapDAL.LayDanhSachRap();
                DataTable dtPhong = PhongChieuDAL.LayDanhSachTatCaPhong();

                foreach (DataRow rowRap in dtRap.Rows)
                {
                    int maRap = Convert.ToInt32(rowRap["MaRap"]);
                    string tenRap = rowRap["TenRap"]?.ToString() ?? "";
                    string trangThaiRap = rowRap["TrangThai"]?.ToString() ?? "Đang hoạt động";

                    TreeNode nodeRap = new TreeNode($"📍 {tenRap} [{trangThaiRap}]")
                    {
                        Tag = new NodeInfo
                        {
                            Loai = "RAP",
                            Ma = maRap,
                            Ten = tenRap,
                            TrangThai = trangThaiRap
                        }
                    };

                    if (trangThaiRap != "Đang hoạt động")
                    {
                        nodeRap.ForeColor = Color.FromArgb(148, 163, 184); // Màu xám cho rạp ngừng hoạt động
                    }

                    // Tìm các phòng chiếu thuộc cụm rạp này
                    DataRow[] danhSachPhong = dtPhong.Select($"MaRap = {maRap}");
                    foreach (DataRow rowPhong in danhSachPhong)
                    {
                        int maPhong = Convert.ToInt32(rowPhong["MaPhong"]);
                        string tenPhong = rowPhong["TenPhong"]?.ToString() ?? "";
                        string dinhDang = rowPhong["DinhDang"]?.ToString() ?? "2D";
                        string trangThaiPhong = rowPhong["TrangThai"]?.ToString() ?? "Đang hoạt động";
                        int sucChua = Convert.ToInt32(rowPhong["SucChua"]);

                        TreeNode nodePhong = new TreeNode($"🎬 {tenPhong} ({dinhDang} - {sucChua} ghế)")
                        {
                            Tag = new NodeInfo
                            {
                                Loai = "PHONG",
                                Ma = maPhong,
                                Ten = tenPhong,
                                TrangThai = trangThaiPhong,
                                MaRap = maRap,
                                TenRap = tenRap,
                                DinhDang = dinhDang,
                                SucChua = sucChua
                            }
                        };

                        if (trangThaiPhong != "Đang hoạt động")
                        {
                            nodePhong.ForeColor = Color.FromArgb(148, 163, 184);
                        }

                        if (maPhongCanChon.HasValue && maPhong == maPhongCanChon.Value)
                        {
                            nodeCanChon = nodePhong;
                        }
                        else if (nodeCanChon == null)
                        {
                            nodeCanChon = nodePhong;
                        }

                        nodeRap.Nodes.Add(nodePhong);
                    }

                    trvRapPhong.Nodes.Add(nodeRap);
                }

                trvRapPhong.ExpandAll();

                // Tự động chọn phòng đầu tiên hoặc phòng vừa cập nhật
                if (nodeCanChon != null)
                {
                    trvRapPhong.SelectedNode = nodeCanChon;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Lỗi kết nối cơ sở dữ liệu khi tải danh sách Rạp và Phòng chiếu:\n" + ex.Message,
                    "Lỗi nạp dữ liệu",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
            finally
            {
                trvRapPhong.EndUpdate();
            }
        }

        /// <summary>
        /// Vẽ sơ đồ ghế đúng với số lượng và trạng thái ghế thực tế của phòng chiếu đang chọn.
        /// TUYỆT ĐỐI KHÔNG hiển thị ghế đã bán vì trạng thái bán vé thuộc từng suất chiếu cụ thể.
        /// </summary>
        private void VeSoDoGhe(int maPhong, string tenPhong, string dinhDang, string tenRap, string trangThaiPhong)
        {
            _gheDangChon = null;
            lblGheDangChon.Text = "Ghế đang chọn: [Chưa chọn]";
            btnDoiLoaiGhe.Enabled = false;
            btnDoiTrangThaiGhe.Enabled = false;

            flpGhe.SuspendLayout();
            while (flpGhe.Controls.Count > 0)
                flpGhe.Controls[0].Dispose();
            flpGhe.FlowDirection = FlowDirection.TopDown;
            flpGhe.WrapContents = false;
            flpGhe.AutoScrollPosition = Point.Empty;

            try
            {
                DataTable dtGhe = GheDAL.LayDanhSachGheTheoPhong(maPhong);
                int tongSoGhe = dtGhe.Rows.Count;
                int soGheHoatDong = 0;
                int soGheHong = 0;

                foreach (DataRow r in dtGhe.Rows)
                {
                    string tt = r["TrangThai"]?.ToString() ?? "Hoạt động";
                    if (tt == "Hoạt động") soGheHoatDong++;
                    else soGheHong++;
                }

                lblThongTinPhong.Text =
                    $"🎬 {tenPhong} ({dinhDang}) — {tenRap} [{trangThaiPhong}]\n" +
                    $"• Sức chứa: {tongSoGhe} ghế ({soGheHoatDong} hoạt động, {soGheHong} hỏng/ngừng)";

                if (tongSoGhe == 0)
                {
                    Label lblTrong = new Label
                    {
                        Text = "Phòng chiếu này hiện chưa có ghế nào trong sơ đồ.\n\nBấm nút [🪑 Tạo sơ đồ ghế] ở góc trên bên phải để tạo tự động.",
                        Font = new Font("Segoe UI", 10F, FontStyle.Italic),
                        ForeColor = Color.FromArgb(100, 116, 139),
                        TextAlign = ContentAlignment.MiddleCenter,
                        Size = new Size(500, 100),
                        Margin = new Padding(20)
                    };
                    flpGhe.Controls.Add(lblTrong);
                    flpGhe.ResumeLayout(true);
                    return;
                }

                // Gom nhóm các ghế theo từng Hàng ghế (A, B, C...)
                var danhSachHang = dtGhe.AsEnumerable()
                    .GroupBy(r => r.Field<string>("HangGhe")?.Trim() ?? "")
                    .OrderBy(g => g.Key.Length)
                    .ThenBy(g => g.Key);

                foreach (var nhomHang in danhSachHang)
                {
                    string tenHang = nhomHang.Key;

                    // Mỗi hàng là một panel không ngắt dòng. Hàng rộng dùng thanh cuộn ngang.
                    FlowLayoutPanel hangGhe = new FlowLayoutPanel
                    {
                        AutoSize = true,
                        AutoSizeMode = AutoSizeMode.GrowAndShrink,
                        FlowDirection = FlowDirection.LeftToRight,
                        WrapContents = false,
                        Margin = new Padding(0, 0, 0, 6),
                        Padding = Padding.Empty
                    };
                    flpGhe.Controls.Add(hangGhe);

                    // Nhãn tên hàng ghế hiển thị ở đầu mỗi hàng
                    Label lblTenHang = new Label
                    {
                        Text = tenHang,
                        Width = 32,
                        Height = 36,
                        Font = new Font("Segoe UI", 9.5F, FontStyle.Bold),
                        ForeColor = Color.FromArgb(71, 85, 105),
                        TextAlign = ContentAlignment.MiddleCenter,
                        Margin = new Padding(2, 4, 4, 4)
                    };
                    hangGhe.Controls.Add(lblTenHang);

                    var danhSachGheTrongHang = nhomHang.OrderBy(r => r.Field<int>("SoGhe")).ToList();
                    for (int i = 0; i < danhSachGheTrongHang.Count; i++)
                    {
                        DataRow rowGhe = danhSachGheTrongHang[i];
                        int maGhe = Convert.ToInt32(rowGhe["MaGhe"]);
                        int soGhe = Convert.ToInt32(rowGhe["SoGhe"]);
                        int maLoaiGhe = Convert.ToInt32(rowGhe["MaLoaiGhe"]);
                        string tenLoaiGhe = rowGhe["TenLoaiGhe"]?.ToString() ?? "Ghế thường";
                        string trangThaiGhe = rowGhe["TrangThai"]?.ToString() ?? "Hoạt động";

                        GheInfo info = new GheInfo
                        {
                            MaGhe = maGhe,
                            MaPhong = maPhong,
                            HangGhe = tenHang,
                            SoGhe = soGhe,
                            MaLoaiGhe = maLoaiGhe,
                            TenLoaiGhe = tenLoaiGhe,
                            TrangThai = trangThaiGhe
                        };

                        Button btnGhe = new Button
                        {
                            Width = 48,
                            Height = 36,
                            Margin = new Padding(3),
                            FlatStyle = FlatStyle.Flat,
                            Font = new Font("Segoe UI", 8F, FontStyle.Bold),
                            ForeColor = Color.White,
                            Cursor = Cursors.Hand,
                            Tag = info,
                            ContextMenuStrip = cmsGhe
                        };
                        btnGhe.FlatAppearance.BorderSize = 1;
                        btnGhe.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);

                        info.NutGhe = btnGhe;
                        DinhDangMauSacGhe(btnGhe, info);

                        // Sự kiện khi click chọn ghế
                        btnGhe.Click += (s, e) =>
                        {
                            ChonGhe(info);
                        };

                        hangGhe.Controls.Add(btnGhe);

                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi tải sơ đồ ghế từ cơ sở dữ liệu:\n" + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                flpGhe.ResumeLayout(true);
            }
        }

        private void DinhDangMauSacGhe(Button btnGhe, GheInfo info)
        {
            if (info.TrangThai != "Hoạt động")
            {
                // Ghế hỏng / ngừng sử dụng
                btnGhe.Text = $"{info.HangGhe}{info.SoGhe}✖";
                btnGhe.BackColor = Color.FromArgb(71, 85, 105); // Xám đậm
                btnGhe.ForeColor = Color.FromArgb(254, 202, 202); // Đỏ nhạt
                btnGhe.FlatAppearance.BorderColor = Color.FromArgb(239, 68, 68);
            }
            else
            {
                btnGhe.Text = $"{info.HangGhe}{info.SoGhe}";
                btnGhe.ForeColor = Color.White;
                btnGhe.FlatAppearance.BorderColor = Color.FromArgb(203, 213, 225);

                if (info.TenLoaiGhe.Contains("VIP", StringComparison.OrdinalIgnoreCase))
                {
                    btnGhe.BackColor = Color.FromArgb(245, 158, 11); // Cam hổ phách
                }
                else if (info.TenLoaiGhe.Contains("Sweetbox", StringComparison.OrdinalIgnoreCase) ||
                         info.TenLoaiGhe.Contains("Đôi", StringComparison.OrdinalIgnoreCase))
                {
                    btnGhe.BackColor = Color.FromArgb(139, 92, 246); // Tím
                }
                else
                {
                    btnGhe.BackColor = Color.FromArgb(16, 185, 129); // Xanh lá
                }
            }
        }

        private void ChonGhe(GheInfo info)
        {
            // Bỏ highlight ghế trước đó
            if (_gheDangChon?.NutGhe != null && !_gheDangChon.NutGhe.IsDisposed)
            {
                _gheDangChon.NutGhe.FlatAppearance.BorderSize = 1;
                _gheDangChon.NutGhe.FlatAppearance.BorderColor =
                    _gheDangChon.TrangThai != "Hoạt động" ? Color.FromArgb(239, 68, 68) : Color.FromArgb(203, 213, 225);
            }

            _gheDangChon = info;

            // Highlight ghế đang chọn với viền nổi bật
            if (info.NutGhe != null && !info.NutGhe.IsDisposed)
            {
                info.NutGhe.FlatAppearance.BorderSize = 2;
                info.NutGhe.FlatAppearance.BorderColor = Color.FromArgb(37, 99, 235); // Xanh dương đậm
            }

            lblGheDangChon.Text = $"Ghế {info.HangGhe}{info.SoGhe} [{info.TenLoaiGhe}] ({info.TrangThai})";

            // Đồng bộ combobox chọn loại ghế
            if (_bangLoaiGhe != null)
            {
                cboDoiLoaiGhe.SelectedValue = info.MaLoaiGhe;
            }

            btnDoiLoaiGhe.Enabled = true;
            btnDoiTrangThaiGhe.Enabled = true;

            btnDoiTrangThaiGhe.Text = info.TrangThai == "Hoạt động"
                ? "⛔ Báo hỏng ghế"
                : "✅ Kích hoạt ghế";
        }

        #region XỬ LÝ SỰ KIỆN TREEVIEW

        private void trvRapPhong_AfterSelect(object sender, TreeViewEventArgs e)
        {
            if (e.Node?.Tag is not NodeInfo tag) return;

            _nodeDangChon = tag;

            if (tag.Loai == "PHONG")
            {
                btnTaoSoDoGhe.Enabled = true;
                btnSuaPhong.Enabled = true;
                btnDoiTrangThaiPhong.Enabled = true;

                btnDoiTrangThai.Text = tag.TrangThai == "Đang hoạt động" ? "🔄 Ngừng phòng" : "🔄 Mở phòng";
                btnDoiTrangThaiPhong.Text = tag.TrangThai == "Đang hoạt động" ? "⛔ Ngừng hoạt động" : "✅ Hoạt động lại";

                VeSoDoGhe(tag.Ma, tag.Ten, tag.DinhDang, tag.TenRap, tag.TrangThai);
            }
            else // RAP
            {
                btnTaoSoDoGhe.Enabled = false;
                btnSuaPhong.Enabled = false;
                btnDoiTrangThaiPhong.Enabled = false;

                btnDoiTrangThai.Text = tag.TrangThai == "Đang hoạt động" ? "🔄 Ngừng rạp" : "🔄 Mở rạp";

                lblThongTinPhong.Text =
                    $"🏛️ CỤM RẠP: {tag.Ten} [{tag.TrangThai}]\n" +
                    $"• Chọn một phòng chiếu trong cây danh mục bên trái để xem sơ đồ ghế.";

                flpGhe.SuspendLayout();
                while (flpGhe.Controls.Count > 0)
                flpGhe.Controls[0].Dispose();
            flpGhe.FlowDirection = FlowDirection.TopDown;
            flpGhe.WrapContents = false;
            flpGhe.AutoScrollPosition = Point.Empty;
                flpGhe.ResumeLayout(true);

                _gheDangChon = null;
                lblGheDangChon.Text = "Ghế đang chọn: [Chưa chọn]";
                btnDoiLoaiGhe.Enabled = false;
                btnDoiTrangThaiGhe.Enabled = false;
            }
        }

        private void trvRapPhong_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                trvRapPhong.SelectedNode = e.Node;
            }
        }

        #endregion

        #region THAO TÁC CỤM RẠP VÀ PHÒNG CHIẾU

        private void btnThemRap_Click(object sender, EventArgs e)
        {
            using FormThemSuaRap form = new FormThemSuaRap();
            if (form.ShowDialog(this) == DialogResult.OK)
            {
                NapCayRapVaPhong();
            }
        }

        private void btnThemPhong_Click(object sender, EventArgs e)
        {
            int maRapMacDinh = 0;
            if (_nodeDangChon != null)
            {
                maRapMacDinh = _nodeDangChon.Loai == "RAP" ? _nodeDangChon.Ma : _nodeDangChon.MaRap;
            }

            using FormThemSuaPhongChieu form = new FormThemSuaPhongChieu(maRapMacDinh);
            if (form.ShowDialog(this) == DialogResult.OK)
            {
                NapCayRapVaPhong();
            }
        }

        private void btnSuaRapPhong_Click(object sender, EventArgs e)
        {
            if (_nodeDangChon == null)
            {
                MessageBox.Show("Vui lòng chọn một cụm rạp hoặc phòng chiếu trong cây danh mục để sửa.", "Chưa chọn mục", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (_nodeDangChon.Loai == "RAP")
            {
                using FormThemSuaRap form = new FormThemSuaRap(_nodeDangChon.Ma);
                if (form.ShowDialog(this) == DialogResult.OK)
                {
                    NapCayRapVaPhong();
                }
            }
            else // PHONG
            {
                using FormThemSuaPhongChieu form = new FormThemSuaPhongChieu(_nodeDangChon.Ma, true);
                if (form.ShowDialog(this) == DialogResult.OK)
                {
                    NapCayRapVaPhong(_nodeDangChon.Ma);
                }
            }
        }

        private void btnDoiTrangThai_Click(object sender, EventArgs e)
        {
            if (_nodeDangChon == null)
            {
                MessageBox.Show("Vui lòng chọn cụm rạp hoặc phòng chiếu để đổi trạng thái.", "Chưa chọn mục", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string trangThaiMoi = _nodeDangChon.TrangThai == "Đang hoạt động" ? "Ngừng hoạt động" : "Đang hoạt động";

            if (_nodeDangChon.Loai == "RAP")
            {
                DialogResult xacNhan = MessageBox.Show(
                    $"Bạn có chắc chắn muốn chuyển trạng thái cụm rạp '{_nodeDangChon.Ten}' sang '{trangThaiMoi}'?\n\n(Hệ thống lưu giữ nguyên vẹn dữ liệu trong database, không xóa vật lý).",
                    "Xác nhận đổi trạng thái rạp",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (xacNhan == DialogResult.Yes)
                {
                    var (thanhCong, thongBao) = RapDAL.DoiTrangThaiRap(_nodeDangChon.Ma, trangThaiMoi);
                    if (thanhCong)
                    {
                        MessageBox.Show(thongBao, "Thông báo thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        NapCayRapVaPhong();
                    }
                    else
                    {
                        MessageBox.Show(thongBao, "Lỗi cập nhật", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            else // PHONG
            {
                DialogResult xacNhan = MessageBox.Show(
                    $"Bạn có chắc chắn muốn chuyển trạng thái phòng chiếu '{_nodeDangChon.Ten}' sang '{trangThaiMoi}'?\n\n(Hệ thống lưu giữ nguyên vẹn dữ liệu trong database, không xóa vật lý).",
                    "Xác nhận đổi trạng thái phòng",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (xacNhan == DialogResult.Yes)
                {
                    var (thanhCong, thongBao) = PhongChieuDAL.DoiTrangThaiPhong(_nodeDangChon.Ma, trangThaiMoi);
                    if (thanhCong)
                    {
                        MessageBox.Show(thongBao, "Thông báo thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        NapCayRapVaPhong(_nodeDangChon.Ma);
                    }
                    else
                    {
                        MessageBox.Show(thongBao, "Lỗi cập nhật", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void btnTaoSoDoGhe_Click(object sender, EventArgs e)
        {
            if (_nodeDangChon == null || _nodeDangChon.Loai != "PHONG")
            {
                MessageBox.Show("Vui lòng chọn một phòng chiếu để tạo sơ đồ ghế.", "Chưa chọn phòng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            using FormTaoSoDoGhe form = new FormTaoSoDoGhe(_nodeDangChon.Ma, _nodeDangChon.Ten, _nodeDangChon.TenRap);
            if (form.ShowDialog(this) == DialogResult.OK)
            {
                // Sau khi tạo xong, tải lại để cập nhật số ghế và vẽ lại sơ đồ
                NapCayRapVaPhong(_nodeDangChon.Ma);
            }
        }

        private void btnSuaPhong_Click(object sender, EventArgs e)
        {
            btnSuaRapPhong_Click(sender, e);
        }

        private void btnDoiTrangThaiPhong_Click(object sender, EventArgs e)
        {
            btnDoiTrangThai_Click(sender, e);
        }

        #endregion

        #region THAO TÁC ĐỔI LOẠI GHẾ VÀ TRẠNG THÁI GHẾ

        private void btnDoiLoaiGhe_Click(object sender, EventArgs e)
        {
            if (_gheDangChon == null)
            {
                MessageBox.Show("Vui lòng click chọn một ghế trên sơ đồ trước.", "Chưa chọn ghế", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (cboDoiLoaiGhe.SelectedValue == null) return;

            int maLoaiMoi = Convert.ToInt32(cboDoiLoaiGhe.SelectedValue);
            string tenLoaiMoi = cboDoiLoaiGhe.Text;

            var (thanhCong, thongBao) = GheDAL.CapNhatLoaiGhe(_gheDangChon.MaGhe, maLoaiMoi);
            if (thanhCong)
            {
                _gheDangChon.MaLoaiGhe = maLoaiMoi;
                _gheDangChon.TenLoaiGhe = tenLoaiMoi;

                if (_gheDangChon.NutGhe != null)
                {
                    DinhDangMauSacGhe(_gheDangChon.NutGhe, _gheDangChon);
                }

                ChonGhe(_gheDangChon);
                MessageBox.Show($"Đã đổi ghế {_gheDangChon.HangGhe}{_gheDangChon.SoGhe} sang '{tenLoaiMoi}'.", "Thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show(thongBao, "Lỗi cập nhật ghế", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnDoiTrangThaiGhe_Click(object sender, EventArgs e)
        {
            if (_gheDangChon == null)
            {
                MessageBox.Show("Vui lòng click chọn một ghế trên sơ đồ trước.", "Chưa chọn ghế", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string trangThaiMoi = _gheDangChon.TrangThai == "Hoạt động"
                ? "Hỏng/Ngừng sử dụng"
                : "Hoạt động";

            var (thanhCong, thongBao) = GheDAL.DoiTrangThaiGhe(_gheDangChon.MaGhe, trangThaiMoi);
            if (thanhCong)
            {
                _gheDangChon.TrangThai = trangThaiMoi;

                if (_gheDangChon.NutGhe != null)
                {
                    DinhDangMauSacGhe(_gheDangChon.NutGhe, _gheDangChon);
                }

                ChonGhe(_gheDangChon);

                // Cập nhật lại số liệu thống kê trên nhãn phòng
                if (_nodeDangChon != null && _nodeDangChon.Loai == "PHONG")
                {
                    VeSoDoGhe(_nodeDangChon.Ma, _nodeDangChon.Ten, _nodeDangChon.DinhDang, _nodeDangChon.TenRap, _nodeDangChon.TrangThai);
                }
            }
            else
            {
                MessageBox.Show(thongBao, "Lỗi cập nhật trạng thái ghế", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        #endregion

        #region MENU NGỮ CẢNH (CONTEXT MENU)

        private void tsmThemPhong_Click(object sender, EventArgs e) => btnThemPhong_Click(sender, e);
        private void tsmSua_Click(object sender, EventArgs e) => btnSuaRapPhong_Click(sender, e);
        private void tsmDoiTrangThai_Click(object sender, EventArgs e) => btnDoiTrangThai_Click(sender, e);
        private void tsmTaoSoDo_Click(object sender, EventArgs e) => btnTaoSoDoGhe_Click(sender, e);
        private void tsmLamMoi_Click(object sender, EventArgs e) => NapCayRapVaPhong(_nodeDangChon?.Ma);

        private void DoiLoaiGheTheoTen(string tenLoai)
        {
            if (_gheDangChon == null || _bangLoaiGhe == null) return;

            DataRow[] rows = _bangLoaiGhe.Select($"TenLoai = '{tenLoai.Replace("'", "''")}'");
            if (rows.Length > 0)
            {
                int maLoai = Convert.ToInt32(rows[0]["MaLoai"]);
                var (thanhCong, thongBao) = GheDAL.CapNhatLoaiGhe(_gheDangChon.MaGhe, maLoai);
                if (thanhCong)
                {
                    _gheDangChon.MaLoaiGhe = maLoai;
                    _gheDangChon.TenLoaiGhe = tenLoai;
                    if (_gheDangChon.NutGhe != null)
                    {
                        DinhDangMauSacGhe(_gheDangChon.NutGhe, _gheDangChon);
                    }
                    ChonGhe(_gheDangChon);
                }
                else
                {
                    MessageBox.Show(thongBao, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void tsmGheThuong_Click(object sender, EventArgs e) => DoiLoaiGheTheoTen("Ghế thường");
        private void tsmGheVip_Click(object sender, EventArgs e) => DoiLoaiGheTheoTen("Ghế VIP");
        private void tsmGheSweetbox_Click(object sender, EventArgs e) => DoiLoaiGheTheoTen("Ghế Sweetbox");

        private void tsmDanhDauHong_Click(object sender, EventArgs e)
        {
            if (_gheDangChon == null) return;
            var (thanhCong, thongBao) = GheDAL.DoiTrangThaiGhe(_gheDangChon.MaGhe, "Hỏng/Ngừng sử dụng");
            if (thanhCong)
            {
                _gheDangChon.TrangThai = "Hỏng/Ngừng sử dụng";
                if (_gheDangChon.NutGhe != null) DinhDangMauSacGhe(_gheDangChon.NutGhe, _gheDangChon);
                ChonGhe(_gheDangChon);
                if (_nodeDangChon != null && _nodeDangChon.Loai == "PHONG")
                {
                    VeSoDoGhe(_nodeDangChon.Ma, _nodeDangChon.Ten, _nodeDangChon.DinhDang, _nodeDangChon.TenRap, _nodeDangChon.TrangThai);
                }
            }
            else MessageBox.Show(thongBao, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void tsmDanhDauHoatDong_Click(object sender, EventArgs e)
        {
            if (_gheDangChon == null) return;
            var (thanhCong, thongBao) = GheDAL.DoiTrangThaiGhe(_gheDangChon.MaGhe, "Hoạt động");
            if (thanhCong)
            {
                _gheDangChon.TrangThai = "Hoạt động";
                if (_gheDangChon.NutGhe != null) DinhDangMauSacGhe(_gheDangChon.NutGhe, _gheDangChon);
                ChonGhe(_gheDangChon);
                if (_nodeDangChon != null && _nodeDangChon.Loai == "PHONG")
                {
                    VeSoDoGhe(_nodeDangChon.Ma, _nodeDangChon.Ten, _nodeDangChon.DinhDang, _nodeDangChon.TenRap, _nodeDangChon.TrangThai);
                }
            }
            else MessageBox.Show(thongBao, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        #endregion
    }
}
