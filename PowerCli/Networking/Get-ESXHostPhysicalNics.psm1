Function Get-ESXHostPhysicalNics {
       param (
                [Parameter(Mandatory = $False)][System.String]$FilePath="c:\temp",
                [Parameter(Mandatory = $False)][System.String]$FileName="esxi_nics_export.csv"
             )
    
        
            Get-VMHostNetworkAdapter | Select-Object | Where-Object {$_.DeviceName -notlike "*vmk*"} | 
            Select-Object VMHost, Name, DhcpEnabled, IP, SubnetMask, DeviceName, MAC |
            Export-Csv -Path $FilePath\$FileName -NoTypeInformation
        

}