# Download SQL Server installation media
$SqlServerIsoImageDownloadUri= "https://zippyapistorage.blob.core.windows.net/sql/en_sql_server_2019_developer_x64_dvd_e5ade34a.iso"
$downloadDirectory = "F:\downloads"
if (!(Test-Path $downloadDirectory)){
    New-Item -Path $downloadDirectory -ItemType Directory
    # Write-Host "$global:foldPath Folder Created Successfully"
}
$SqlServerIsoImagePath = $downloadDirectory + "\sql_server_2016_developer_x64_dvd.iso"
Invoke-WebRequest -URI $SqlServerIsoImageDownloadUri -OutFile $SqlServerIsoImagePath

#Installs SQL Server locally with standard settings for Developers/Testers.
# Install SQL from command line help - https://msdn.microsoft.com/en-us/library/ms144259.aspx
$sw = [Diagnostics.Stopwatch]::StartNew()
$currentUserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name;

#Mount the installation media, and change to the mounted Drive.
$mountVolume = Mount-DiskImage -ImagePath $SqlServerIsoImagePath -PassThru
$driveLetter = ($mountVolume | Get-Volume).DriveLetter
$drivePath = $driveLetter + ":"
push-location -path "$drivePath"

#Install SQL Server locally with our default settings. 
# Only the Sql Engine and LocalDB
# i.e. no Replication, FullText, Data Quality, PolyBase, R, AnalysisServices, Reporting Services, Integration service, Master Data Services, Books Online(BOL) or SDK are installed.
.\Setup.exe /q /ACTION=Install /FEATURES=SQLEngine, LocalDB /UpdateEnabled /UpdateSource=MU /X86=false /INSTANCENAME=MSSQLSERVER /INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server" /INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server" /SQLSVCINSTANTFILEINIT="True" /INSTANCEDIR="C:\Program Files\Microsoft SQL Server" /AGTSVCACCOUNT="NT Service\SQLSERVERAGENT" /AGTSVCSTARTUPTYPE="Manual" /SQLSVCSTARTUPTYPE="Automatic" /SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS" /SQLSVCACCOUNT="NT Service\MSSQLSERVER" /SECURITYMODE="SQL" /SAPWD="Passw0rd.Secret" /SQLSYSADMINACCOUNTS="$currentUserName" /IACCEPTSQLSERVERLICENSETERMS

#Dismount the installation media.
pop-location
Dismount-DiskImage -ImagePath $SqlServerIsoImagePath

#Install SQL Powershell module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name SqlServer -Force

#print Time taken to execute
$sw.Stop()
"Sql install script completed in {0:c}" -f $sw.Elapsed;