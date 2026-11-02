using System.Data;
using Microsoft.Data.SqlClient;

namespace YeuMinhEmCinema.Web.Data;

/// <summary>Thực thi ADO.NET có tham số và giải phóng kết nối sau mỗi thao tác.</summary>
public class WebDb
{
    private readonly IConfiguration configuration;

    public WebDb(IConfiguration configuration)
    {
        this.configuration = configuration;
    }

    public SqlConnection Open()
    {
        var value = configuration.GetConnectionString("Cinema")
        ?? Environment.GetEnvironmentVariable("YMC_CONNECTION");
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new InvalidOperationException("Chưa cấu hình kết nối Cinema.");
        }
        var connection = new SqlConnection(value);
        try
        {
            connection.Open();
        }
        catch
        {
            connection.Dispose();
            throw;
        }
        return connection;
    }

    /// <summary>Chỉ nội dung SQL cố định trong DAL được truyền vào đây.</summary>
    public DataSet Read(string sql,
        bool procedure = false,
        params SqlParameter[] parameters)
    {
        using var connection = Open();
        using var command = new SqlCommand(sql, connection);
        if (procedure)
        {
            command.CommandType = CommandType.StoredProcedure;
        }
        command.Parameters.AddRange(parameters);
        using var adapter = new SqlDataAdapter(command);
        var result = new DataSet();
        adapter.Fill(result);
        return result;
    }

    public DataTable Table(string sql,
        bool procedure = false,
        params SqlParameter[] parameters)
    {
        var result = Read(sql, procedure, parameters);
        if (result.Tables.Count == 0)
        {
            return new DataTable();
        }
        return result.Tables[0];
    }

    /// <summary>Khai báo kiểu theo giá trị server, luôn truyền riêng khỏi chuỗi SQL.</summary>
    public static SqlParameter P(string name, object? value)
    {
        var type = value switch
        {
            int => SqlDbType.Int,
            long => SqlDbType.BigInt,
            bool => SqlDbType.Bit,
            Guid => SqlDbType.UniqueIdentifier,
            DateTime => SqlDbType.DateTime2,
            byte[] => SqlDbType.VarBinary,
            decimal => SqlDbType.Decimal,
            _ => SqlDbType.NVarChar
        };
        return new SqlParameter(name, type)
        {
            Value = value ?? DBNull.Value
        };
    }
}
