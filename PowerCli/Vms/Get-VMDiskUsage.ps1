$Report = @()

Get-VM -Name Olivov | ForEach-Object {
    $ReportRow = "" | Select-Object VMName, DiskCapacity, DiskFreespace
    $ReportRow.VMName = $_.Name
    $ReportRow.DiskCapacity = $_.Guest.Disks | Measure-Object CapacityGB -Sum | Select-Object -ExpandProperty Sum
    $ReportRow.DiskFreespace = $ReportRow.DiskCapacity - ($_.Guest.Disks | Measure-Object FreeSpaceGB -Sum | Select-Object -ExpandProperty Sum)
    $Report += $ReportRow
}

$Report