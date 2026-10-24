using System.Data;
namespace YeuMinhEmCinema.Admin;
internal sealed class FormFnb : Form
{
    private readonly DataRow? _row;
    private readonly TextBox _code=new(){Width=200,MaxLength=30,CharacterCasing=CharacterCasing.Upper},_ten=new(){Width=550,MaxLength=150},_size=new(){Width=300,MaxLength=50};
    private readonly ComboBox _nhom=LichChieuUi.Combo(200),_mon=LichChieuUi.Combo(440);
    private readonly NumericUpDown _gia=GiaVeFnbUi.Gia(),_sl=new(){Minimum=1,Maximum=99,Value=1,Width=80};
    private readonly CheckBox _ban=new(){Text="Bật bán",Checked=true,AutoSize=true};
    private readonly DataGridView _grid=LichChieuUi.Bang();
    private readonly DataTable _parts=new();
    private readonly FlowLayoutPanel _combo=new(){AutoSize=true,FlowDirection=FlowDirection.TopDown,WrapContents=false,Width=620};
    private readonly Button _luu;
    private bool _busy;
    public FormFnb(DataRow? row)
    {
        _row=row;Text=row==null?"Thêm sản phẩm / combo":"Sửa sản phẩm / combo";Font=new Font("Segoe UI",10F);AutoScaleMode=AutoScaleMode.Font;
        ClientSize=new Size(720,670);MinimumSize=new Size(700,500);StartPosition=FormStartPosition.CenterParent;
        var panel=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=2,Padding=new Padding(12)};
        panel.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));panel.RowStyles.Add(new RowStyle(SizeType.Percent,100));panel.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        var body=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoScroll=true,FlowDirection=FlowDirection.TopDown,WrapContents=false};
        body.Controls.AddRange(new Control[]{LichChieuUi.Nhom("Mã hàng (A–Z, 0–9, _ hoặc -)",_code),LichChieuUi.Nhom("Tên sản phẩm",_ten),
            LichChieuUi.Nhom("Nhóm",_nhom),LichChieuUi.Nhom("Kích cỡ / quy cách",_size),LichChieuUi.Nhom("Đơn giá bán (đồng)",_gia),_ban,_combo});
        _nhom.Items.AddRange(new object[]{"Bắp","Nước","Đồ ăn","Combo"});_nhom.SelectedIndex=0;
        _parts.Columns.Add("MaThanhPhan",typeof(int));_parts.Columns.Add("MaHang");_parts.Columns.Add("TenSanPham");_parts.Columns.Add("SoLuong",typeof(int));
        _grid.Dock=DockStyle.None;_grid.Size=new Size(620,160);AdminUi.BindTable(_grid,_parts);GiaVeFnbUi.DinhDang(_grid);
        var bar=new FlowLayoutPanel{AutoSize=true,WrapContents=true,Width=620};bar.Controls.AddRange(new Control[]{_mon,_sl});
        bar.Controls.Add(LichChieuUi.Nut("Thêm thành phần",(_,_)=>ThemMon()));
        bar.Controls.Add(LichChieuUi.Nut("Bỏ dòng chọn",(_,_)=>{if(_grid.CurrentRow?.DataBoundItem is DataRowView rv)rv.Row.Delete();}));
        _combo.Controls.AddRange(new Control[]{GiaVeFnbUi.GhiChu("Thành phần combo: chỉ chọn món lẻ đang bật bán. Số lượng 1–99. Giá combo nhập riêng, không tự cộng giá món."),bar,_grid});
        var actions=new FlowLayoutPanel{AutoSize=true,Dock=DockStyle.Fill};_luu=LichChieuUi.Nut("Lưu",(_,_)=>Luu(),true);actions.Controls.Add(_luu);
        var close=LichChieuUi.Nut("Đóng",(_,_)=>Close());close.DialogResult=DialogResult.Cancel;actions.Controls.Add(close);AcceptButton=_luu;CancelButton=close;
        panel.Controls.Add(body,0,0);panel.Controls.Add(actions,0,1);Controls.Add(panel);
        _nhom.SelectedIndexChanged+=(_,_)=>_combo.Visible=_nhom.Text=="Combo";_combo.Visible=false;
        Load+=(_,_)=>Nap();
    }
    private void Nap()
    {
        try{LichChieuUi.Gan(_mon,GiaVeFnbDAL.MonLe(),"MaSanPham","TenHienThi","— Chọn món —");
            if(_row!=null){_code.Text=_row["MaHang"].ToString();_ten.Text=_row["TenSanPham"].ToString();_nhom.SelectedItem=_row["Nhom"].ToString();
                _size.Text=_row["KichCo"].ToString();_gia.Value=Convert.ToDecimal(_row["DonGia"]);_ban.Checked=Convert.ToBoolean(_row["DangBan"]);
                foreach(DataRow p in GiaVeFnbDAL.ThanhPhan(Convert.ToInt32(_row["MaSanPham"])).Rows)
                    _parts.Rows.Add(p["MaThanhPhan"],p["MaHang"],p["TenSanPham"],p["SoLuong"]);}}
        catch(Exception ex){_luu.Enabled=false;GiaVeFnbUi.Loi(ex,this);}
    }
    private void ThemMon()
    {
        var ma=LichChieuUi.Ma(_mon);if(!ma.HasValue){MessageBox.Show(this,"Chọn món lẻ trước.");return;}
        foreach(DataRow row in _parts.Rows)
        {
            if(row.RowState==DataRowState.Deleted)continue;
            if(Convert.ToInt32(row["MaThanhPhan"])==ma.Value)
            {
                int n=Convert.ToInt32(row["SoLuong"])+(int)_sl.Value;
                if(n>99){MessageBox.Show(this,"Tổng số lượng mỗi thành phần tối đa 99.");return;}
                row["SoLuong"]=n;return;
            }
        }
        string text=_mon.Text;int idx=text.IndexOf(" — ",StringComparison.Ordinal);
        _parts.Rows.Add(ma.Value,idx>=0?text[..idx]:text,idx>=0?text[(idx+3)..]:text,(int)_sl.Value);
    }
    private void Luu()
    {
        if(_busy)return;
        string code=_code.Text.Trim();if(code.Length==0||code.Any(c=>!(c is >= 'A' and <= 'Z'||c is >= '0' and <= '9'||c is '_' or '-'))||string.IsNullOrWhiteSpace(_ten.Text))
        {MessageBox.Show(this,"Nhập mã hàng hợp lệ và tên sản phẩm.");return;}
        var parts=GiaVeFnbDAL.TaoThanhPhan();
        if(_nhom.Text=="Combo")foreach(DataRow row in _parts.Rows)
            if(row.RowState!=DataRowState.Deleted)parts.Rows.Add(row["MaThanhPhan"],row["SoLuong"]);
        if(_nhom.Text=="Combo"&&parts.Rows.Count==0){MessageBox.Show(this,"Thêm ít nhất một thành phần cho combo.");return;}
        if(_row!=null&&_row["Nhom"].ToString()=="Combo"&&_nhom.Text!="Combo"&&
            MessageBox.Show(this,"Đổi sang món lẻ sẽ bỏ cấu hình thành phần combo. Tiếp tục?","Xác nhận",MessageBoxButtons.YesNo)!=DialogResult.Yes)return;
        _busy=true;_luu.Enabled=false;
        try{GiaVeFnbDAL.LuuFnb(_row==null?null:Convert.ToInt32(_row["MaSanPham"]),code,_ten.Text,_nhom.Text,_size.Text,_gia.Value,_ban.Checked,parts,_row==null?null:(byte[])_row["PhienBan"]);
            DialogResult=DialogResult.OK;Close();}
        catch(Exception ex){GiaVeFnbUi.Loi(ex,this);}
        finally{_busy=false;_luu.Enabled=true;}
    }
}
