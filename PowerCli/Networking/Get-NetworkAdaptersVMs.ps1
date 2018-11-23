get-vm | Get-NetworkAdapter | Select-Object @{N="VM";E={$_.Parent.Name}}, @{N="Version";E={$_.Parent.Version}},@{N="Guest";E={$_.Parent.Guest}}, name,type | Export-Csv -Path C:\temp\vms_mm_net_adapters.csv -NoTypeInformation

