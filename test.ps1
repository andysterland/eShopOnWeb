<#
.SYNOPSIS
Shows the Instances and the Port Numbers on a SQL Server

.DESCRIPTION
This function will show the Instances and the Port Numbers on a SQL Server using WMI

.PARAMETER Server
The Server Name

.EXAMPLE
Get-SQLInstancesPort Fade2Black

This will display the instances and the port numbers on the server Fade2Black
.NOTES
AUTHOR: Rob Sewell sqldbawithabeard.com
DATE: 22/04/2015
#>

function Get-SQLInstancesPort {

    param ([string]$Server)

    [system.reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")|Out-Null
    [system.reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")|Out-Null
    $mc = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $Server
    $Instances = $mc.ServerInstances

    foreach ($Instance in $Instances) {
        $port = @{Name = "Port"; Expression = {$_.ServerProtocols['Tcp'].IPAddresses['IPAll'].IPAddressProperties['TcpPort'].Value}}
        $Parent = @{Name = "Parent"; Expression = {$_.Parent.Name}}
        $TcpEnabled = @{Name = "TcpEnabled"; Expression = {$_.ServerProtocols['Tcp'].IsEnabled}}
        $Instance|Select $Parent, Name, $TcpEnabled, $Port

        if($Instance.ServerProtocols['Tcp'].IsEnabled -eq $false)
        {
            $Instance.ServerProtocols['Tcp'].IsEnabled =  $true
            $Instance.ServerProtocols['Tcp'].IPAddresses['IPAll'].IPAddressProperties[1].Value = "1433"
            $Instance.ServerProtocols['Tcp'].Alter()
            Write-Host Updated port
        }
    }
}

Get-SQLInstancesPort