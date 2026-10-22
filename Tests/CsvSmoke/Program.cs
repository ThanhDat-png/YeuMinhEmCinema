using System.Data;
using System.Text;
using Microsoft.VisualBasic.FileIO;
using YeuMinhEmCinema.Admin;
var path=Path.GetTempFileName();
try
{
    var dt=new DataTable();dt.Columns.Add("Tên, phim");dt.Columns.Add("Ghi chú");dt.Columns.Add("Thời gian",typeof(DateTime));
    string[] data={"Tiếng Việt", "Dòng, có dấu phẩy", "Chữ \"đẹp\"", "Hai\ndòng", "=1+1", "  @SUM(1)", "\t=1", "-2", "+3"};
    foreach(var s in data)dt.Rows.Add(s,DBNull.Value,new DateTime(2026,10,23,18,0,0));
    CsvUtility.Ghi(path,dt);
    var b=File.ReadAllBytes(path);
    if(b.Length<3||b[0]!=239||b[1]!=187||b[2]!=191)throw new Exception("Thiếu BOM");
    using var parser=new TextFieldParser(path,Encoding.UTF8){TextFieldType=FieldType.Delimited,HasFieldsEnclosedInQuotes=true,TrimWhiteSpace=false};
    parser.SetDelimiters(",");var header=parser.ReadFields()!;
    if(header.Length!=3||header[0]!="Tên, phim")throw new Exception("Sai header");
    foreach(var s in data)
    {
        var fields=parser.ReadFields()!;var trim=s.TrimStart();
        bool nguyHiem=(trim.Length>0&&"=+-@".Contains(trim[0]))||s.StartsWith('\t');
        if(fields.Length!=3||fields[0]!=(nguyHiem?"'"+s:s)||fields[1]!=""||fields[2]!="23/10/2026 18:00")
            throw new Exception("CSV không round-trip đúng: "+s);
    }
    if(!parser.EndOfData)throw new Exception("Dư dòng");
    Console.WriteLine("PASS: BOM, Unicode, comma, quotes, multiline, NULL, dates, formula escaping.");
}
finally{File.Delete(path);}
