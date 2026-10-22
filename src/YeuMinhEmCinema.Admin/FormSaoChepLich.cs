using System.Data;
namespace YeuMinhEmCinema.Admin;
public sealed class FormSaoChepLich : Form
{
    private readonly DateTimePicker _nguon=LichChieuUi.Ngay(),_dich=LichChieuUi.Ngay();
    private readonly ComboBox _rap=LichChieuUi.Combo(250),_phong=LichChieuUi.Combo(190);
    private readonly DataGridView _bang=LichChieuUi.Bang();
    private readonly Label _note=new(){AutoSize=true,Padding=new Padding(8)};
    private readonly Button _luu;
    private string? _chuKy;
    private bool _loading,_busy;
    public FormSaoChepLich()
    {
        Text="Sao chép lịch chiếu";Font=new Font("Segoe UI",10F);AutoScaleMode=AutoScaleMode.Font;
        ClientSize=new Size(1080,580);MinimumSize=new Size(780,440);StartPosition=FormStartPosition.CenterParent;
        var layout=new TableLayoutPanel{Dock=DockStyle.Fill,ColumnCount=1,RowCount=4,Padding=new Padding(10)};
        layout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent,100));layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));layout.RowStyles.Add(new RowStyle(SizeType.Percent,100));layout.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        var bar=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoSize=true,WrapContents=true};
        bar.Controls.AddRange(new Control[]{LichChieuUi.Nhom("Ngày nguồn",_nguon),LichChieuUi.Nhom("Ngày đích",_dich),
            LichChieuUi.Nhom("Rạp",_rap),LichChieuUi.Nhom("Phòng",_phong)});
        var actions=new FlowLayoutPanel{Dock=DockStyle.Fill,AutoSize=true,WrapContents=true};
        actions.Controls.Add(LichChieuUi.Nut("Xem trước và kiểm tra",(_,_)=>Xem()));
        _luu=LichChieuUi.Nut("Xác nhận sao chép",(_,_)=>Luu(),true);_luu.Enabled=false;actions.Controls.Add(_luu);
        layout.Controls.Add(bar,0,0);layout.Controls.Add(actions,0,1);layout.Controls.Add(_bang,0,2);layout.Controls.Add(_note,0,3);Controls.Add(layout);
        _nguon.Value=DateTime.Today.AddDays(1);_dich.Value=DateTime.Today.AddDays(2);
        _nguon.ValueChanged+=(_,_)=>HuyXem();_dich.ValueChanged+=(_,_)=>HuyXem();
        _phong.SelectedIndexChanged+=(_,_)=>HuyXem();
        _rap.SelectedIndexChanged+=(_,_)=>{if(!_loading)NapPhong();HuyXem();};
        Load+=(_,_)=>{_loading=true;try{LichChieuUi.Gan(_rap,SuatChieuDAL.LayRap(),"MaRap","TenRap","Tất cả rạp");NapPhong();}
            catch(Exception ex){LichChieuUi.Loi(ex,this);}finally{_loading=false;}};
    }
    private void HuyXem(){_chuKy=null;_luu.Enabled=false;_bang.DataSource=null;_note.Text="Xem trước để kiểm tra toàn bộ lịch tại ngày đích. Suất mới ở trạng thái Mở bán.";}
    private void NapPhong()
    {
        try{LichChieuUi.Gan(_phong,SuatChieuDAL.LayPhong(LichChieuUi.Ma(_rap)),"MaPhong","TenPhong","Tất cả phòng");}
        catch(Exception ex){_phong.DataSource=null;LichChieuUi.Loi(ex,this);}
    }
    private void Xem()
    {
        HuyXem();if(_busy)return;_busy=true;UseWaitCursor=true;
        try
        {
            var dt=SuatChieuDAL.SaoChep(_nguon.Value,_dich.Value,LichChieuUi.Ma(_rap),LichChieuUi.Ma(_phong),true);
            _bang.DataSource=dt;LichChieuUi.DinhDang(_bang);
            if(dt.Rows.Count>0){_chuKy=dt.Rows[0]["ChuKy"].ToString();_luu.Enabled=true;}
            _note.Text=$"{dt.Rows.Count} suất dự kiến ngày {_dich.Value:dd/MM/yyyy}. Ghi cả nhóm hoặc không ghi suất nào.";
        }
        catch(Exception ex){LichChieuUi.Loi(ex,this);}
        finally{_busy=false;UseWaitCursor=false;}
    }
    private void Luu()
    {
        if(_busy||string.IsNullOrEmpty(_chuKy))return;
        if(MessageBox.Show(this,$"Tạo {_bang.Rows.Count} suất ngày {_dich.Value:dd/MM/yyyy} như bảng xem trước?","Xác nhận sao chép",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question)!=DialogResult.Yes)return;
        _busy=true;_luu.Enabled=false;UseWaitCursor=true;
        try
        {
            var dt=SuatChieuDAL.SaoChep(_nguon.Value,_dich.Value,LichChieuUi.Ma(_rap),LichChieuUi.Ma(_phong),false,_chuKy);
            MessageBox.Show(this,$"Đã tạo {dt.Rows[0]["SoSuatDaTao"]} suất chiếu.");DialogResult=DialogResult.OK;Close();
        }
        catch(Exception ex){HuyXem();LichChieuUi.Loi(ex,this);}
        finally{_busy=false;UseWaitCursor=false;}
    }
}
