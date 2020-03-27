       
    $DHCPServers = Get-DhcpServerInDC
   
 

    foreach ($DhcpSrv in $DHCPServers)
    {
        $Scopes =  Get-DhcpServerv4Scope -ComputerName $DHCPSrv | Select-Object Scopeid 
            foreach ($Scp in $Scopes)
                {
                       $DnsSettings = Get-DhcpServerv4OptionValue -ComputerName $DHCPSrv.DnsName -ScopeId $Scp.ScopeID| Where-Object {$_.OptionID -eq "6"} | Select-Object -ExpandProperty Value

                       foreach ($Dns in $DnsSettings)
                        {
                            $ourObject = [PSCustomObject]@{

                            DNSSettings = $Dns
                            Server = $DHCPSrv.DnsName
                            ScopeId = $Scp.ScopeId
                            
                                                    } 

                            $ourObject | Export-Csv -Append -NoTypeInformation -NoClobber -Path C:\temp\ss.csv
                                                }

                       
                       
                }
        
    }