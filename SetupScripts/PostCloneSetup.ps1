# Instal dotnet ef (long term will be moved to image)
dotnet tool install --global dotnet-ef

# Setup Databases
pushd "F:\Workspace\eShopOnWeb\src\Web"
dotnet restore
dotnet tool restore
dotnet ef database update -c catalogcontext -p ../Infrastructure/Infrastructure.csproj -s Web.csproj
dotnet ef database update -c appidentitydbcontext -p ../Infrastructure/Infrastructure.csproj -s Web.csproj

popd

# Set mix mode auth + SA Account
Invoke-Sqlcmd -Query "EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2"
Write-Host "Updated auth mode"

Invoke-Sqlcmd -Query "ALTER LOGIN sa ENABLE"
Write-Host "Enabled SA Login"

# Shouldn't put this here for prod, but for ease of testing we have this here now
Invoke-Sqlcmd -Query "ALTER LOGIN sa WITH PASSWORD = 'Passw0rd.Secret'"
Write-Host "Set SA account password"

# Restart service to validate changes took
Stop-Service MSSQLServer
Start-Service MSSQLServer
Write-Host "Restarting SQL Server"

$authMode = Invoke-Sqlcmd -Query "SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly') WHEN 1 THEN 'Windows Authentication' WHEN 0 THEN 'Windows and SQL Server Authentication' END as [Authentication Mode]" -Database "master"            

Write-Host "Final auth-mode is:" $authMode.'Authentication Mode'
    
if ($authMode.'Authentication Mode' -ne "Windows and SQL Server Authentication")
{
    Write-Host "Failed to change auth mode" -ForegroundColor Red
}

$saAccount = Invoke-Sqlcmd -Query "SELECT name, is_disabled FROM sys.server_principals where name='sa'"                                                                                                                                                                                                                                

Write-Host "SA Account is_disabled is: " $saAccount.is_disabled

if ($saAccount.is_disabled -eq $true)
{
    Write-Host "Failed to enable SA Login" -ForegroundColor Red
}