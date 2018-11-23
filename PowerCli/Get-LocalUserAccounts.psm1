Function Get-EsxHostAccounts {
    
    param (
        [Parameter(Mandatory = $True)][System.String]$HostsFile,
        [Parameter(Mandatory = $True)][System.String]$Localuser,
        [Parameter(Mandatory = $True)][System.String]$LocalPassword,
        [Parameter(Mandatory = $True)][System.String]$OutFolder,
        [Parameter(Mandatory = $True)][System.String]$OutCSVName
                
    )

    $ESXHosts = Get-Content $HostsFile

    ForEach ($ESXi in $ESXHosts) {
    
        Connect-VIServer -Server "$ESXi" -User $Localuser -Password $LocalPassword
        Get-VMHostAccount -Server "$ESXi" | Select-Object Server, Name, Description | Export-Csv -Path $OutFolder\$OutCSVName -Append -NoTypeInformation
        Disconnect-VIServer -Server "$ESXi" -Confirm:$false 
      }


}


