$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot
dotnet build .\YeuMinhEmCinema.slnx
if ($LASTEXITCODE -ne 0) { throw "Build chưa thành công. Kiểm tra lỗi phía trên." }
dotnet run --project .\src\YeuMinhEmCinema.Admin\YeuMinhEmCinema.Admin.csproj
