$report = @()
# $clusterName = "MyCluster" 
$clusterName = "PRD-CLUSTER" 

foreach($cluster in Get-Cluster -Name $clusterName){
    $esx = $cluster | Get-VMHost    
    $ds = Get-Datastore -VMHost $esx | where {$_.Type -eq "VMFS" -and $_.Extensiondata.Summary.MultipleHostAccess}
        
    $row = "" | Select VCname,DCname,Clustername,"Total Physical Memory (MB)",
                "Configured Memory MB","Available Memroy (MB)",
                "Total CPU (Mhz)","Configured CPU (Mhz)",
                "Available CPU (Mhz)","Total Disk Space (MB)",
                "Configured Disk Space (MB)","Available Disk Space (MB)"
    $row.VCname = $cluster.Uid.Split(':@')[1]
    $row.DCname = (Get-Datacenter -Cluster $cluster).Name
    $row.Clustername = $cluster.Name
    $row."Total Physical Memory (MB)" = ($esx | Measure-Object -Property MemoryTotalMB -Sum).Sum
    $row."Configured Memory MB" = ($esx | Measure-Object -Property MemoryUsageMB -Sum).Sum
    $row."Available Memroy (MB)" = ($esx | Measure-Object -InputObject {$_.MemoryTotalMB - $_.MemoryUsageMB} -Sum).Sum
    $row."Total CPU (Mhz)" = ($esx | Measure-Object -Property CpuTotalMhz -Sum).Sum
    $row."Configured CPU (Mhz)" = ($esx | Measure-Object -Property CpuUsageMhz -Sum).Sum
    $row."Available CPU (Mhz)" = ($esx | Measure-Object -InputObject {$_.CpuTotalMhz - $_.CpuUsageMhz} -Sum).Sum
    $row."Total Disk Space (MB)" = ($ds | where {$_.Type -eq "VMFS"} | Measure-Object -Property CapacityMB -Sum).Sum
    $row."Configured Disk Space (MB)" = ($ds | Measure-Object -InputObject {$_.CapacityMB - $_.FreeSpaceMB} -Sum).Sum
    $row."Available Disk Space (MB)" = ($ds | Measure-Object -Property FreeSpaceMB -Sum).Sum
    $report += $row
} 
$report | Export-Csv "C:\TEMP\Cluster-Report.csv" -NoTypeInformation -UseCulture