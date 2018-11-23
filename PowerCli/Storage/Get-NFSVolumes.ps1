get-vmhost | 
New-Datastore -NFS -Name <datastorename> -Path /<path to nfs mount point> -nfshost <hostname or IPaddress>

$cluster = "Cluster_Ibercom"
$DataStores = Get-Datastore -Entity (Get-VMHost -Location $cluster) | 
    where {$_.Type -eq "NFS"} |
    Sort-Object -Unique |
    Select @{N = "Cluster"; E = {$cluster.Name}}, Name, RemoteHost, RemotePath

    foreach ($nf in $DataStores)
    {
        Write-Host $nf.Name, $nf.remotehost, $nf.remotepath
        New-Datastore -nfs -name $nf.Name -Path $nf.RemotePath -NfsHost $nf.RemoteHost -VMHost "212.166.73.78"
    }