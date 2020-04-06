# Run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Set-Location $PSScriptRoot

#Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
#Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
[Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" ) > $null

$smo
[System.Collections.ArrayList]$mdfsToCopy = [System.Collections.ArrayList]@()
[System.Collections.ArrayList]$dbsToDettach = [System.Collections.ArrayList]@()

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

ForEach ($database in $smo.Databases)
{
    try
    {
        Write-Host "Processing database:" $database.Name
        if(!$database.IsSystemObject)
        {
            $dbPath = [IO.Path]::Combine($database.PrimaryFilePath, $database.Name)
            $dbPath +=".mdf"
            $mdfsToCopy.Add($dbPath)
            Write-Host "Adding:" $dbPath            
        }
        else
        {        
            Write-Host "Skipping: " $database.Name
		}
    } 
    catch [Exception]
    {
        Write-Host "Failed." -ForegroundColor Red
        echo $_.Exception|format-list -force
        return
    }
}

ForEach ($db in $dbsToDettach)
{
    Write-Host "Dettaching:" $db
    $smo.KillAllProcesses($db)            
    $smo.DetachDatabase($db, $true)
}
        
# Stopping the server so files aren't locked on copy
Write-Host "Stopping SQL service: " $smo.ServiceName
Stop-Service -Name $smo.ServiceName -Force

# Move to F:\
$sqlFolderOnF = "F:\Environment\MSSQL\"
if (!(Test-Path $sqlFolderOnF))
{
    New-Item -Path $sqlFolderOnF -ItemType Directory
    Write-Host "Created:"$sqlFolderOnF
}

ForEach ($mdf in $mdfsToCopy)
{
    Write-Host "Copy" $mdf "to" $sqlFolderOnF
    Copy-Item -Path $mdf -Destination $sqlFolderOnF -Force
}

Write-Host "Done." -ForegroundColor Green