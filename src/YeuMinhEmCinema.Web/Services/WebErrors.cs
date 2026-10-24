using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Data.SqlClient;

namespace YeuMinhEmCinema.Web.Services;

/// <summary>Ghi mã chẩn đoán an toàn, không ghi câu SQL, cookie, mật khẩu hay kết nối.</summary>
public class WebErrors : IExceptionFilter
{
    private readonly ILogger<WebErrors> logger;

    public WebErrors(ILogger<WebErrors> logger)
    {
        this.logger = logger;
    }

    public static string ThongBao(SqlException exception)
    {
        if (exception.Number is 2601 or 2627)
        {
            return "Tên đăng nhập hoặc email đã được sử dụng. Vui lòng kiểm tra lại.";
        }
        if (exception.Number >= 50000 && exception.Number < 51000)
        {
            return exception.Message;
        }
        return "Chưa xử lý được dữ liệu. Vui lòng thử lại sau.";
    }

    public void OnException(ExceptionContext context)
    {
        logger.LogError("Lỗi Web: {Loai}; mã SQL: {Ma}", context.Exception.GetType().Name,
            (context.Exception as SqlException)?.Number);
        context.Result = new ViewResult
        {
            ViewName = "~/Views/Home/Loi.cshtml",
            StatusCode = 503
        };
        context.ExceptionHandled = true;
    }
}
