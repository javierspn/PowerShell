$PoweredOffvms = Get-VM -server 10.34.133.43 | where {$_.PowerState -eq "PoweredOff"}


foreach ($VM in $PoweredOffvms)
        {

        $VmName = $VM.Name
        $Event = Get-VIEvent -Entity $VM -MaxSamples 1 | select createdtime,fullformattedmessage, @{Name="VMName"; E = {$vmName}} | Export-Csv -Path c:\temp\mm.csv -Append -NoTypeInformation
      

        }


#Get-VIEvent -Entity $PoweredOffvms
#$Sample = "Centreon_Sonda_Ibercom_V3"
#Get-VIEvent -Entity $Sample -MaxSamples 1 | select createdtime,fullformattedmessage,@{Name="VMName"; E = {$Sample}} 
quiero ver ese procedimiento
Melapela.