using System.Data;
namespace YeuMinhEmCinema.Admin;
public partial class UcGiaVeVaFnb : UserControl
{
    private readonly DataGridView _gia=LichChieuUi.Bang(),_fnb=LichChieuUi.Bang(),_tp=LichChieuUi.Bang();
    private readonly ComboBox _loai=LichChieuUi.Combo(),_ttGia=LichChieuUi.Combo(180),_nhom=LichChieuUi.Combo(160),_ttFnb=LichChieuUi.Combo(160);
    private readonly TextBox _timGia=new(){Width=220,MaxLength=200,PlaceholderText="Loại ghế / định dạng"},_timFnb=new(){Width=220,MaxLength=200,PlaceholderText="Mã hoặc tên sản phẩm"};
    private readonly Label _soGia=new(){AutoSize=true,Padding=new Padding(6)},_soFnb=new(){AutoSize=true,Padding=new Padding(6)};
    public UcGiaVeVaFnb()
    {
        InitializeComponent();Dock=DockStyle.Fill;Font=new Font("Segoe UI",10F);BackColor=Color.White;
        var tabs=new TabControl{Dock=DockStyle.Fill};var g=new TabPage("Giá vé");var f=new TabPage("Sản phẩm & combo");tabs.TabPages.AddRange(new[]{g,f});Controls.Add(tabs);
        _ttGia.Items.AddRange(new object[]{"Tất cả trạng thái","Đang bật","Ngừng áp dụng"});_ttGia.SelectedIndex=0;
        _ttFnb.Items.AddRange(new object[]{"Tất cả trạng thái","Bật bán","Ngừng bán"});_ttFnb.SelectedIndex=0;
        _nhom.Items.AddRange(new object[]{"Tất cả nhóm","Bắp","Nước","Đồ ăn","Combo"});_nhom.SelectedIndex=0;
        var ag=new FlowLayoutPanel{AutoSize=true,Dock=DockStyle.Fill,WrapContents=true};
        ag.Controls.AddRange(new Control[]{LichChieuUi.Nhom("Loại ghế",_loai),LichChieuUi.Nhom("Trạng thái",_ttGia),LichChieuUi.Nhom("Tìm kiếm",_timGia)});
        ag.Controls.Add(LichChieuUi.Nut("Lọc",(_,_)=>TaiGia()));ag.Controls.Add(LichChieuUi.Nut("Làm mới",(_,_)=>Nap()));
        ag.Controls.Add(LichChieuUi.Nut("+ Thêm giá",(_,_)=>SuaGia(null),true));ag.Controls.Add(LichChieuUi.Nut("Sửa giá / bật tắt",(_,_)=>{var row=Chon(_gia);if(row==null){MessageBox.Show("Chọn một dòng giá để sửa.");return;}SuaGia(row);}));
        ag.Controls.Add(LichChieuUi.Nut("Tra giá theo ngày",(_,_)=>{using var form=new FormTraGiaVe();form.ShowDialog(FindForm());}));
        ag.Controls.Add(LichChieuUi.Nut("Xuất CSV",(_,_)=>GiaVeFnbUi.Xuat(_gia,FindForm()!,"GiaVe")));
        var lg=Khung(ag,_gia,_soGia);g.Controls.Add(lg);
        lg.Controls.Add(GiaVeFnbUi.GhiChu("Giá cho mỗi mã ghế. Ngày thường: T2–T5; cuối tuần: T6–CN. Hai mốc ngày được tính gồm cả ngày đầu/cuối. Chưa cấu hình ngày lễ riêng."),0,0);
        var af=new FlowLayoutPanel{AutoSize=true,Dock=DockStyle.Fill,WrapContents=true};
        af.Controls.AddRange(new Control[]{LichChieuUi.Nhom("Nhóm",_nhom),LichChieuUi.Nhom("Trạng thái cấu hình",_ttFnb),LichChieuUi.Nhom("Tìm kiếm",_timFnb)});
        af.Controls.Add(LichChieuUi.Nut("Lọc",(_,_)=>TaiFnb()));af.Controls.Add(LichChieuUi.Nut("Làm mới",(_,_)=>Nap()));
        af.Controls.Add(LichChieuUi.Nut("+ Thêm món / combo",(_,_)=>SuaFnb(null),true));af.Controls.Add(LichChieuUi.Nut("Sửa / bật tắt bán",(_,_)=>{var row=Chon(_fnb);if(row==null){MessageBox.Show("Chọn sản phẩm để sửa.");return;}SuaFnb(row);}));
        af.Controls.Add(LichChieuUi.Nut("Xuất CSV",(_,_)=>GiaVeFnbUi.Xuat(_fnb,FindForm()!,"MenuFnb")));
        var split=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=3};split.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));
        split.RowStyles.Add(new RowStyle(SizeType.Percent,65));split.RowStyles.Add(new RowStyle(SizeType.AutoSize));split.RowStyles.Add(new RowStyle(SizeType.Percent,35));
        split.Controls.Add(_fnb,0,0);split.Controls.Add(GiaVeFnbUi.GhiChu("Thành phần combo đang chọn (sản phẩm lẻ không có thành phần):"),0,1);split.Controls.Add(_tp,0,2);
        var lf=Khung(af,split,_soFnb);f.Controls.Add(lf);lf.Controls.Add(GiaVeFnbUi.GhiChu("Combo không lồng combo. Ngừng bán món lẻ có thể làm combo liên quan chưa bán được. Module này chưa quản lý tồn kho."),0,0);
        _fnb.SelectionChanged+=(_,_)=>TaiThanhPhan();_gia.CellDoubleClick+=(_,e)=>{if(e.RowIndex>=0)SuaGia(Chon(_gia));};
        _fnb.CellDoubleClick+=(_,e)=>{if(e.RowIndex>=0)SuaFnb(Chon(_fnb));};
        _timGia.KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Enter){e.SuppressKeyPress=true;TaiGia();}};
        _timFnb.KeyDown+=(_,e)=>{if(e.KeyCode==Keys.Enter){e.SuppressKeyPress=true;TaiFnb();}};
        Load+=(_,_)=>Nap();
    }
    private static TableLayoutPanel Khung(Control bar,Control grid,Control count)
    {
        var p=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=4,Padding=new Padding(10)};
        p.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));p.RowStyles.Add(new RowStyle(SizeType.AutoSize));p.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        p.RowStyles.Add(new RowStyle(SizeType.Percent,100));p.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        p.Controls.Add(bar,0,1);p.Controls.Add(grid,0,2);p.Controls.Add(count,0,3);return p;
    }
    private static DataRow? Chon(DataGridView g)=>(g.CurrentRow?.DataBoundItem as DataRowView)?.Row;
    private void Nap()
    {
        try{LichChieuUi.Gan(_loai,GiaVeFnbDAL.LoaiGhe(),"MaLoai","TenLoai","Tất cả loại ghế");_ttGia.SelectedIndex=0;_ttFnb.SelectedIndex=0;_nhom.SelectedIndex=0;_timGia.Clear();_timFnb.Clear();TaiGia();TaiFnb();}
        catch(Exception ex){GiaVeFnbUi.Loi(ex,FindForm()!);}
    }
    private void TaiGia()
    {
        try{var dt=GiaVeFnbDAL.GiaVe(_timGia.Text,LichChieuUi.Ma(_loai),_ttGia.SelectedIndex==0?null:_ttGia.SelectedIndex==1);
            AdminUi.BindTable(_gia,dt);GiaVeFnbUi.DinhDang(_gia);_soGia.Text=$"{dt.Rows.Count} dòng giá. Chọn Sửa giá để thay đổi hoặc ngừng áp dụng; không xóa giá.";}
        catch(Exception ex){_gia.DataSource=null;GiaVeFnbUi.Loi(ex,FindForm()!);}
    }
    private void TaiFnb()
    {
        try{var dt=GiaVeFnbDAL.Fnb(_timFnb.Text,_nhom.SelectedIndex==0?null:_nhom.Text,_ttFnb.SelectedIndex==0?null:_ttFnb.SelectedIndex==1);
            AdminUi.BindTable(_fnb,dt);GiaVeFnbUi.DinhDang(_fnb);_soFnb.Text=$"{dt.Rows.Count} sản phẩm. Có thể bán = bật bán và thành phần combo hợp lệ.";TaiThanhPhan();}
        catch(Exception ex){_fnb.DataSource=null;_tp.DataSource=null;GiaVeFnbUi.Loi(ex,FindForm()!);}
    }
    private void TaiThanhPhan()
    {
        var row=Chon(_fnb);if(row==null||row["Nhom"].ToString()!="Combo"){_tp.DataSource=null;return;}
        try{AdminUi.BindTable(_tp,GiaVeFnbDAL.ThanhPhan(Convert.ToInt32(row["MaSanPham"])));GiaVeFnbUi.DinhDang(_tp);}
        catch(Exception ex){_tp.DataSource=null;GiaVeFnbUi.Loi(ex,FindForm()!);}
    }
    private void SuaGia(DataRow? row){using var f=new FormGiaVe(row);if(f.ShowDialog(FindForm())==DialogResult.OK)TaiGia();}
    private void SuaFnb(DataRow? row){using var f=new FormFnb(row);if(f.ShowDialog(FindForm())==DialogResult.OK)TaiFnb();}
}
