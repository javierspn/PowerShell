$Computer = "c21-t1-app011"
#Get-ADComputer -LDAPFilter "(name=*$Computer*)" -Properties *

$ADCData = Get-ADComputer -LDAPFilter "(name=*$Computer*)" -Properties * | Select-Object OperatingSystem, DistinguishedName
$ADOs = ($ADCData.OperatingSystem) -replace '\D+(\d+)\D+','$1'
$ADdn = ($ADCData.DistinguishedName) -replace '\D+(\d+)\D+','$1'

#$Osystem = (Get-ADComputer -LDAPFilter "(name=*$Computer*)" -Properties * | Select-Object OperatingSystem) -replace '\D+(\d+)\D+','$1'
#$CDn = Get-ADComputer -LDAPFilter "(name=*$Computer*)" -Properties * | Select-Object DistinguishedName





if ($ADOs -like "2016") {$COs = "2016"}
elseif ($ADOs -like "2012") {$COs = "2012"}
elseif ($ADOs -like "2008") {$COs = "2008"}

Write-Host $COs
Write-Host $ADdn
($ADCData.DistinguishedName) -split ","

