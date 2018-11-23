Function Get-ESXiHostNics {
    
    param (
        [Parameter(Mandatory = $False)][System.String]$FilePath = "c:\temp",
        [Parameter(Mandatory = $False)][System.String]$FileName = "esxihost_nics_report.csv",
        [Parameter(Mandatory = $True)][System.String]$ESXHost
    )
 
    $vSwitchData = Get-VirtualSwitch -VMHost $ESXHost | Select-Object vmhost, Name, Nic

    ForEach ($vSwitch in $vSwitchData) {
 
        If ($vSwitch.Nic -ne $null) {
           
            ForEach ($NicCard in $vSwitch.Nic) {
                
                Get-VMHostNetworkAdapter -VMHost $ESXHost | Where-Object {$_.DeviceName -eq $NicCard} | 
                    Select-Object VMHost, Name, DhcpEnabled, IP, SubnetMask, DeviceName, MAC, @{N = "vSwitch"; E = {$vSwitch.Name}} |
                    Export-Csv -Path $FilePath\$FileName -NoTypeInformation -Append

            }
        }
    }
}
