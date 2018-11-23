$DataStores = Get-Datastore | ?{$_.Name -like "EQ*"} 


foreach ($DS in $DataStores)
        {

        $DSName = $Ds.Name
        get-datastore $DS.name | get-vm | select name, @{Name="DS"; E = {$DSname}}, usedspacegb
      
        }


#Get-VIEvent -Entity $PoweredOffvms
#$Sample = "Centreon_Sonda_Ibercom_V3"
#Get-VIEvent -Entity $Sample -MaxSamples 1 | select createdtime,fullformattedmessage,@{Name="VMName"; E = {$Sample}} 

