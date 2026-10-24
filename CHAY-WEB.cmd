@echo off
setlocal
cd /d "%~dp0"
echo Thu muc code dang chay: %CD%
echo Mo trinh duyet tai: http://localhost:5190
echo Nhan Ctrl+C de dung web.
dotnet run --project "%~dp0src\YeuMinhEmCinema.Web\YeuMinhEmCinema.Web.csproj" -- --urls "http://localhost:5190"
pause
