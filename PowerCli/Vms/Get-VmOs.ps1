    $ViServers = "172.30.112.217","172.30.112.219","10.34.133.43", "10.34.7.248"



    ForEach ($ViSrv in $ViServers)
    {
    Get-VM -Server $ViSrv | Get-View -Property @("Name", "Config.GuestFullName", "Guest.GuestFullName") | 
        Select-Object -Property Name, @{N = "Configured OS"; E = {$_.Config.GuestFullName}}, @{N = "Running OS"; E = {$_.Guest.GuestFullName}} | 
        Export-Csv -Path C:\temp\informeOs.csv -Append -NoTypeInformation
    }

    