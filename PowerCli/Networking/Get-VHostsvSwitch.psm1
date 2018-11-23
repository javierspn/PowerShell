Function Get-VHostsvSwitchs {
    
    param (
                [Parameter(Mandatory = $True)][System.String]$SourceHost,
                [Parameter(Mandatory = $False)][System.String]$FilePath="c:\temp",
                [Parameter(Mandatory = $False)][System.String]$FileName="esxi_vswitch_export.csv"
    )
    
    Get-VirtualSwitch -VMHost $SourceHost | 
        Get-VirtualPortGroup | Select-Object @{N = "HostName"; E = {$SourceHost}}, Name, VirtualSwitchName, VirtualSwitch, VLanId | 
        Sort-Object -Property VirtualSwitchName, VLanId |
        Export-Csv -Path C:\temp\$FileName -Append -NoTypeInformation

    
}