$HostList = "C:\temp\serversmm.txt"
$ESXiArray = Get-Content $HostList

foreach ($ESX in $ESXiArray ) {
    Get-VHostsvSwitchs -SourceHost $ESX 
}