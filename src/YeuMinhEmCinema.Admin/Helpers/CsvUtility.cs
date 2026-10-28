using System.Data;
using System.Globalization;
using System.Text;

namespace YeuMinhEmCinema.Admin;

public static class CsvUtility
{
    public static string O(string? s)
    {
        s??="";
        var clean=s.TrimStart();
        if((clean.Length>0&&"=+-@".Contains(clean[0])) || s.StartsWith('\t') || s.StartsWith('\r') || s.StartsWith('\n'))
            s="'"+s;
        return "\""+s.Replace("\"","\"\"")+"\"";
    }
    public static void Ghi(string path,DataTable table)
    {
        using var writer=new StreamWriter(path,false,new UTF8Encoding(true));
        writer.WriteLine(string.Join(",",table.Columns.Cast<DataColumn>().Select(c=>O(c.ColumnName))));
        foreach(DataRow row in table.Rows)
            writer.WriteLine(string.Join(",",table.Columns.Cast<DataColumn>().Select(c=>O(
                row[c] is DateTime d?d.ToString("dd/MM/yyyy HH:mm",CultureInfo.InvariantCulture):Convert.ToString(row[c],CultureInfo.InvariantCulture)))));
    }
}
