Function Get-ClusterNodeData {

 Param(
        [Parameter(Mandatory=$True)][String]$ClusterName,
        [Parameter(Mandatory=$False)][String]$FilePath=$env:TEMP

    )

$ClusterNodes = Get-Cluster -Name $ClusterName | Get-ClusterNode | Select Name

$DateFormat = Get-Date -Format ddMMyyyy
$FileNameAdapters = $FilePath+"\"+$ClusterName+$DateFormat+".netadapters.csv"
$FileNameTeams = $FilePath+"\"+$ClusterName+$DateFormat+".netteams.csv"
$FileNameIPs = $FilePath+"\"+$ClusterName+$DateFormat+".netips.csv"


foreach ($Node in $ClusterNodes)
    {
        Invoke-Command -ComputerName $Node.Name -ScriptBlock {Get-NetAdapter | Where-Object {$_.virtual -ne "True"}} |      
        Select-Object Name, MacAddress, PSComputerName | Export-Csv -Path $FileNameAdapters -Append -NoClobber -NoTypeInformation

        Invoke-Command -ComputerName $Node.Name -ScriptBlock {Get-NetLbfoTeam} | 
        Select-Object TeamNics, tm, lba, Members, LoadBalancingAlgorithm,TeamingMode, PSComputerName | 
        Export-Csv -Path $FileNameTeams -Append -NoClobber -NoTypeInformation

        Invoke-Command -ComputerName $Node.Name -ScriptBlock {`
                                                                Get-NetIPAddress | 
                                                                Where-Object {$_.IPv4Address -notlike "169.*" -and $_.InterfaceAlias -notlike "Loop*" -and $_.IPv6Address -eq $Null}
                                                              } |
        Select-Object interfacealias, ipv4*, PSComputerName |
        Export-Csv -Path $FileNameIPs -Append -NoClobber -NoTypeInformation

   }
}
