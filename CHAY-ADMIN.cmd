@echo off
cd /d "%~dp0"
dotnet run --project "src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj"
if errorlevel 1 pause
