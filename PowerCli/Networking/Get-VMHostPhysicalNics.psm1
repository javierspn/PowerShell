Function Get-ESXiHostNics {
    
    [CmdletBinding(DefaultParameterSetName = 'ByVMHost')]
    param (
        
        [Parameter(Mandatory = $False)]$OutFolder = "c:\temp",
        [Parameter(Mandatory = $False)]$OutFile = "esxihost_nics_report.csv",
        [Parameter(Mandatory = $True, ParameterSetName = 'ByVMHost')]$VMHost,
      
        [Parameter(Mandatory = $True, ParameterSetName = 'ByLoadFile')]$LoadFile
    
    )
 

    If ($LoadFile) {$VMHost = Get-Content $LoadFile}

    ForEach ($ESX in $VMHost) {
        
        Write-Host $ESX
        Get-VMHostNetworkAdapter -VMHost $ESX | Select-Object VMHost, DeviceName, Mac |  Export-Csv -LiteralPath $OutFolder\$OutFile -Append -NoTypeInformation
    
    }

    

}
#Get-ESXiHostNics -LoadFile "C:\temp\ibercomhosts.txt"
Get-ESXiHostNics -OutFolder C:\temp -OutFile tusmuelas.csv -LoadFile C:\temp\ibercomhosts.txt
