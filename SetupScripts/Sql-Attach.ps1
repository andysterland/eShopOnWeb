# Run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Set-Location $PSScriptRoot

#Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
#Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
[Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" ) > $null

$smo

try
{
# By defailt SMO will use the current user account to login 
    $smo = New-Object Microsoft.SqlServer.Management.Smo.Server
}
catch [Exception]
{
    Write-Host "Failed." -ForegroundColor Red
    echo $_.Exception|format-list -force
    return
}

# Get files to attach

[System.Collections.ArrayList]$dbsToAttach = [System.Collections.ArrayList]@()
# Hack: Hardcoded location!
$sqlFolderOnF = "F:\Environment\MSSQL\"

if (!(Test-Path $sqlFolderOnF))
{
    Write-Host "No SQL files, quitting...:"
    Return
}

$mdfFiles = Get-ChildItem $sqlFolderOnF -Filter "*.mdf" 
ForEach ($mdf in $mdfFiles)
{
    $dbName = [System.IO.Path]::GetFileNameWithoutExtension($mdf)   
    $path = [IO.Path]::Combine($sqlFolderOnF, $mdf)
    $filestructure = New-Object System.Collections.Specialized.StringCollection
    $filestructure.Add($path)
    Write-Host "Path:" $path "DB:" $dbName
    $smo.AttachDatabase($dbName, $path)
}
