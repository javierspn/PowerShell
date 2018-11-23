<#
.SYNOPSIS
   Get DataSTores Info for a Given Host, Cluster or list of Hosts on a Given file.
.DESCRIPTION
    Get DataSTores Info for a Given Host, Cluster or list of Hosts on a Given file.
    The load file must be provided as a pliant txt file with a single column 
    (one ESXi host name per column).
    The output information will be stored on a CSV file.
.NOTES
    File Name      : Get-AllDataStores.psm1
    Author         : Javier Santiago (javier.santiago@msn.com)
    Prerequisite   : PowerShell 3 or later, PowerCLI 6.5 or later. Previous Connection to
    the Vcenter server (using Connect-VIServer cmdlet)
    Copyright 2018 - Javier Santiago
.LINK
    Email: javier.santiago@msn.com
.EXAMPLE
    Get-AllDataStores -VMHost "MyHost" -OutFolder c:\temp -OutFile dts_report.csv
.EXAMPLE
    Get-AllDataStores -ClusterName "MyCluster" -OutFolder c:\temp -OutFile dts_report.csv
.EXAMPLE
    Get-AllDataStores -LoadFile "c:\temp\host_list.txt" -OutFolder c:\temp -OutFile dts_report.csv

#>
Function Get-AllDataStores {
    
    [CmdletBinding(DefaultParameterSetName = 'ByVMHost')]
    param (
        
        [Parameter(Mandatory = $False)]$OutFolder = "c:\temp",
        [Parameter(Mandatory = $False)]$OutFile = "esxihost_dts_report.csv",

        [Parameter(Mandatory = $True, ParameterSetName = 'ByVMHost')]$VMHost,
        [Parameter(Mandatory = $True, ParameterSetName = 'ByLoadFile')]$LoadFile,

        [Parameter(Mandatory = $True, ParameterSetName = 'ByCluster')]$ClusterName
        
    
    )

    If ($LoadFile) {
        $VMHost = Get-Content $LoadFile

        ForEach ($ESX in $VMHost) {
         
            Get-VMHost -Name $ESX | 
            Get-Datastore | Select-Object  @{N = "Host"; E = {$ESX}},
            Name, Type, Datacenter, 
            @{N = "RemoteHost"; E = {$_.RemoteHost -join ','}}, 
            RemotePath, FreespaceGB, CapacityGB |
            Export-Csv -Path $OutFolder\$OutFile -Append -NoTypeInformation
            
        }
    }

    elseif ($ClusterName) {
        $CLusterHosts = Get-Cluster -Name $ClusterName | Get-VMHost | Select-Object Name
        foreach ($ClusterESX in $CLusterHosts) {
            Get-VMHost -Name $ClusterESX.Name | 
            Get-Datastore | Select-Object  @{N = "Host"; E = {$ClusterESX.Name}},
            Name, Type, Datacenter, 
            @{N = "RemoteHost"; E = {$_.RemoteHost -join ','}}, 
            RemotePath, FreespaceGB, CapacityGB |
            Export-Csv -Path $OutFolder\$OutFile -Append -NoTypeInformation
        }
    }
    else {
            Get-VMHost -Name $VMHost |
            Get-Datastore | Select-Object  @{N = "Host"; E = {$VMHost}},
            Name, Type, Datacenter, 
            @{N = "RemoteHost"; E = {$_.RemoteHost -join ','}}, 
            RemotePath, FreespaceGB, CapacityGB |
            Export-Csv -Path $OutFolder\$OutFile -Append -NoTypeInformation
    }
}