﻿Get-View -ViewType VirtualMachine | Foreach-Object{
New-Object PSObject -Property @{
Name = $_.Name
Host = (Get-View $_.Summary.Runtime.Host).Name
Datastore = [system.String]::Join(",",($_.Storage.PerDatastoreUsage | Foreach-Object{Get-View $_.Datastore} | Foreach-Object{$_.Name}))
Size = (Get-VM $_.Name | Select-Object -Property ProvisionedSpaceGB).ProvisionedSpaceGB #($_.Storage.PerDatastoreUsage | Measure-Object -Property Committed -Sum).Sum
CPU = (Get-VM $_.Name | Select-Object -Property numCPU).NumCpu
Memory = (Get-VM $_.Name | Select-Object -Property MemoryMB).MemoryMB
Network = (Get-NetworkAdapter $_.Name | Select-Object -Property NetworkName).NetworkName
}
} | Export-Csv "C:\temp\VM-report.csv" -NoTypeInformation -UseCulture