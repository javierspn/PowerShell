Function Get-ClusterSharedVolumesInfo {

 Param(
        [Parameter(Mandatory=$True)][String]$ClusterName,
        [Parameter(Mandatory=$False)][String]$CSVPath=$env:TEMP,
        [Parameter(Mandatory=$False)][String]$CSVName=$ClusterName+".csvinfo.csv"

    )

$objs = @() 

$Csvs = Get-ClusterSharedVolume -Cluster $ClusterName

foreach ($csv in $Csvs)
    {
        $csvinfos = $csv | select -Property Name -ExpandProperty SharedVolumeInfo  
        foreach ( $csvinfo in $csvinfos )  
             {
                 $obj = New-Object PSObject -Property @{  
            Name        = $csv.Name  
            Path        = $csvinfo.FriendlyVolumeName  
            Size        = [math]::Round($csvinfo.Partition.Size/1GB)
            FreeSpace   = [math]::Round($csvinfo.Partition.FreeSpace/1GB)
            UsedSpace   = [math]::Round($csvinfo.Partition.UsedSpace/1GB)
            PercentFree = $csvinfo.Partition.PercentFree
                                                        }  
             }
    $objs += $obj 
    }

    $FilePath = $CSVPath+"\"+$CSVName

    $objs | Export-Csv -Path $FilePath -NoClobber -NoTypeInformation

}