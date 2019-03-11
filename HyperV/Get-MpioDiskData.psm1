Function Get-MpioDiskData {

$Drives = Get-WmiObject -Namespace root\wmi -Class mpio_disk_info
$MDisks = @()
$Pdisks = get-disk | select Number, operationalstatus, numberofpartitions, @{Name="TotalSize"; Expression={[Math]::Round($_.size/1GB)}}


foreach ($Disks in $Drives)
    {
    $Disks = $Disks.DriveInfo
    
    foreach ($Disk in $Disks)
        {
            $DiskName = $Disk.Name -replace "[^0-9]"
            $MpioDisk = $Disk |  Select-Object Name, NUmberPaths, SerialNumber, @{Name="Number"; Expression={$DiskName}}
            $MDisks +=  $MpioDisk
        }
        
    }

Join-Object -LeftObject $MDisks -RightObject $Pdisks -On Number 

}


