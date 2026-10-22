using System.Data;
namespace YeuMinhEmCinema.Admin;

public class FormSuatChieuBase : Form
{
    private readonly int? _ma;
    private readonly DataRow? _row;
    private readonly ComboBox _phim=LichChieuUi.Combo(470),_rap=LichChieuUi.Combo(470),_phong=LichChieuUi.Combo(470);
    private readonly DateTimePicker _gio=new(){Width=260,Format=DateTimePickerFormat.Custom,CustomFormat="dd/MM/yyyy HH:mm"};
    private readonly NumericUpDown _don=new(){Width=100,Minimum=0,Maximum=120,Value=15};
    private readonly Label _duKien=new(){AutoSize=true,MaximumSize=new Size(480,0),Padding=new Padding(4,10,4,10)};
    private readonly Button _luu;
    private bool _loading,_busy;
    public int MaDaLuu{get;private set;}
    protected FormSuatChieuBase(int? ma,DataRow? row)
    {
        _ma=ma;_row=row;Text=ma.HasValue?$"Sửa suất chiếu {ma}":"Thêm suất chiếu";
        Font=new Font("Segoe UI",10F);AutoScaleMode=AutoScaleMode.Font;ClientSize=new Size(550,620);
        MinimumSize=new Size(550,490);StartPosition=FormStartPosition.CenterParent;MaximizeBox=false;
        var shell=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=2,Padding=new Padding(12)};
        shell.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));shell.RowStyles.Add(new RowStyle(SizeType.Percent,100));shell.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        var body=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoScroll=true,FlowDirection=FlowDirection.TopDown,WrapContents=false};
        body.Controls.AddRange(new Control[]{LichChieuUi.Nhom("Phim",_phim),LichChieuUi.Nhom("Rạp",_rap),LichChieuUi.Nhom("Phòng có ghế hoạt động",_phong),
            LichChieuUi.Nhom("Bắt đầu",_gio),LichChieuUi.Nhom("Dọn phòng (phút)",_don),_duKien});
        var actions=new FlowLayoutPanel{AutoSize=true,Dock=DockStyle.Fill,WrapContents=true};
        actions.Controls.Add(LichChieuUi.Nut("Xem lịch phòng",(_,_)=>XemLich()));
        _luu=LichChieuUi.Nut("Lưu",(_,_)=>Luu(),true);_luu.Enabled=false;
        var dong=LichChieuUi.Nut("Đóng",(_,_)=>{DialogResult=DialogResult.Cancel;Close();});dong.DialogResult=DialogResult.Cancel;
        actions.Controls.AddRange(new Control[]{_luu,dong});shell.Controls.Add(body,0,0);shell.Controls.Add(actions,0,1);Controls.Add(shell);
        AcceptButton=_luu;CancelButton=dong;
        _rap.SelectedIndexChanged+=(_,_)=>{if(!_loading)NapPhong();};
        _phong.SelectedIndexChanged+=(_,_)=>KhaDung();_phim.SelectedIndexChanged+=(_,_)=>{DuKien();KhaDung();};
        _gio.ValueChanged+=(_,_)=>DuKien();_don.ValueChanged+=(_,_)=>DuKien();
        Load+=(_,_)=>Nap();
    }
    private void Nap()
    {
        _loading=true;
        try
        {
            LichChieuUi.Gan(_phim,SuatChieuDAL.LayPhim(true),"MaPhim","TenPhim","— Chọn phim —");
            LichChieuUi.Gan(_rap,SuatChieuDAL.LayRap(true),"MaRap","TenRap","— Chọn rạp —");
            _gio.Value=DateTime.Today.AddDays(1).AddHours(18);
            if(_row!=null)
            {
                _phim.SelectedValue=Convert.ToInt32(_row["MaPhim"]);_rap.SelectedValue=Convert.ToInt32(_row["MaRap"]);
                NapPhong();_phong.SelectedValue=Convert.ToInt32(_row["MaPhong"]);
                _gio.Value=Convert.ToDateTime(_row["GioBatDau"]);_don.Value=Convert.ToDecimal(_row["PhutDonPhong"]);
                if(!LichChieuUi.Ma(_phim).HasValue||!LichChieuUi.Ma(_phong).HasValue)
                    MessageBox.Show(this,"Phim hoặc phòng cũ không còn đủ điều kiện. Vui lòng chọn lại; chưa có thay đổi nào được lưu.","Kiểm tra lịch");
            }
            else NapPhong();
        }
        catch(Exception ex){LichChieuUi.Loi(ex,this);}
        finally{_loading=false;DuKien();KhaDung();}
    }
    private void NapPhong()
    {
        try
        {
            var rap=LichChieuUi.Ma(_rap);
            if(!rap.HasValue){_phong.DataSource=null;KhaDung();return;}
            LichChieuUi.Gan(_phong,SuatChieuDAL.LayPhong(rap,true),"MaPhong","TenPhong","— Chọn phòng —");KhaDung();
        }
        catch(Exception ex){_phong.DataSource=null;KhaDung();LichChieuUi.Loi(ex,this);}
    }
    private DateTime Gio()=>new(_gio.Value.Year,_gio.Value.Month,_gio.Value.Day,_gio.Value.Hour,_gio.Value.Minute,0);
    private void KhaDung(){_luu.Enabled=!_busy&&!_loading&&LichChieuUi.Ma(_phim).HasValue&&LichChieuUi.Ma(_phong).HasValue;}
    private void DuKien()
    {
        if(_phim.SelectedItem is not DataRowView rv||rv.Row["ThoiLuong"]==DBNull.Value){_duKien.Text="Chọn phim để xem thời lượng và giờ kết thúc.";return;}
        int phut=Convert.ToInt32(rv.Row["ThoiLuong"]);var kt=Gio().AddMinutes(phut);
        _duKien.Text=$"Thời lượng: {phut} phút | Khởi chiếu: {Convert.ToDateTime(rv.Row["NgayKhoiChieu"]):dd/MM/yyyy}\n"+
            $"Kết thúc dự kiến: {kt:dd/MM/yyyy HH:mm}\nPhòng sẵn sàng: {kt.AddMinutes((int)_don.Value):dd/MM/yyyy HH:mm}";
    }
    private void XemLich()
    {
        var p=LichChieuUi.Ma(_phong);if(!p.HasValue){MessageBox.Show(this,"Chọn phòng trước.");return;}
        using var f=new FormLichPhongTrongNgay(p.Value,_phong.Text,Gio().Date);f.ShowDialog(this);
    }
    private void Luu()
    {
        if(_busy)return;var phim=LichChieuUi.Ma(_phim);var phong=LichChieuUi.Ma(_phong);
        if(!phim.HasValue||!phong.HasValue){MessageBox.Show(this,"Chọn phim và phòng.");return;}
        if(Gio()<=DateTime.Now){MessageBox.Show(this,"Giờ bắt đầu phải ở tương lai.");return;}
        _busy=true;KhaDung();UseWaitCursor=true;
        try
        {
            if(_ma.HasValue){SuatChieuDAL.Sua(_ma.Value,phim.Value,phong.Value,Gio(),(int)_don.Value);MaDaLuu=_ma.Value;}
            else MaDaLuu=SuatChieuDAL.Them(phim.Value,phong.Value,Gio(),(int)_don.Value);
            MessageBox.Show(this,$"Đã lưu suất chiếu {MaDaLuu}.","Thành công");DialogResult=DialogResult.OK;Close();
        }
        catch(Exception ex){LichChieuUi.Loi(ex,this);}
        finally{_busy=false;UseWaitCursor=false;KhaDung();}
    }
}
