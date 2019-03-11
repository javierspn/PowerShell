Import-Module FailoverClusters

$cluster = Get-Cluster
$nodes = Get-ClusterNode
$vms = foreach ($node in $nodes) {
    Get-VM -ComputerName $node.Name
}

$csvs = @(Get-ChildItem C:\ClusterStorage -Directory)
$vmDirs = $csvs.ForEach({Get-ChildItem -Path $_.FullName -Directory})

$result = foreach ($vmDir in $vmDirs) {
    $vm = $null
    $sum = $vmDir | Get-ChildItem -Recurse -File | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
    if ($sum -ge 0) { $sum = [System.Math]::Ceiling(($sum/1GB)) }
    $vmName    = $vmDir.Name
    $vmDirName = $vmDir.Name
    $vm        = $vms.Where({$_.Name -eq $vmName}) | Select-Object -First 1
    $connected = if ($vm -eq $null) { 'Disconnected' } else { 'Connected' }
    
    $state = $null
    if ($vmName -match '^_.+$') {
        if ($vmName -match '^_(.+?)_.+$') {
            $state = $Matches[1]
        }
        $vmName = $vmName -replace '^_.+?_(.+)$', '$1'
    }
    if ($vmName -match '^.+?_V\d') {
        $vmName = $vmName -replace '^(.+?)_V\d$', '$1'
    }
    [pscustomobject]@{
        Name      = $vmName
        VM        = $vm
        VMState   = if ($vm -ne $null) { $vm.State } else { $null }
        Connected = $connected
        State     = $state
        FSItem    = $vmDir
        SizeGB    = $sum
        Volume    = $vmDir.Parent.Name
    }
}

#$result | Sort-Object Name, Connected, Volume, State | Select-Object -Property * -ExcludeProperty VM | ft -AutoSize


$css = @'
h1 {
    font-family: "Segoe UI",Arial,sans-serif;
    font-weight: 400;
}
table {
    font-size: 16px;
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    border-spacing: 0;
}
table, th, td {
    border-style: solid;
    border-color: #dddddd;
    border-width: 0px 1px;
}
th {
    background-color: #5bc0de;
}
.Connected {
    background-color: #5cb85c;
}
.Disconnected {
    background-color: #ffd500;
}
.OffDuplicate {
    background-color: #d9534f;
}
'@

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">')
[void]$sb.AppendLine('<html xmlns="http://www.w3.org/1999/xhtml">')
[void]$sb.AppendLine('<head>')
[void]$sb.AppendLine('<style>')
[void]$sb.AppendLine($css)
[void]$sb.AppendLine('</style>')
[void]$sb.AppendLine(('<title>VM Table for {0}</title>' -f $cluster.Name))
[void]$sb.AppendLine('</head><body>')
[void]$sb.AppendLine(('<h1>VM Table for {0}</h1>' -f $cluster.Name))
[void]$sb.AppendLine('<table>')
[void]$sb.AppendLine('<tr>')
[void]$sb.AppendLine('<th>Name</th>')
[void]$sb.AppendLine('<th>Connected to VM</th>')
[void]$sb.AppendLine('<th>VM State</th>')
[void]$sb.AppendLine('<th>FileSystem State</th>')
[void]$sb.AppendLine('<th>Directory Name</th>')
[void]$sb.AppendLine('<th>Size</th>')
[void]$sb.AppendLine('<th>Volume</th>')
[void]$sb.AppendLine('</tr>')

$serverGroups = ($result | Group-Object -Property Name | Sort-Object -Property Name)
foreach ($server in $serverGroups) {
    #$ARRAY | Sort-Object -Property @{Expression = {$_.PROP_A}; Ascending = $false}, PROP_B
    $sortedGroup = @($server.Group | Sort-Object -Property Connected, @{Expression = {$_.VMState}; Ascending = $true}, State, Volume)
    for ($i = 0; $i -lt $sortedGroup.Count; $i++) {
        $srv = $sortedGroup[$i]
        if ((![string]::IsNullOrEmpty($srv.VMState)) -and $srv.VMState -ne 'Running' -and $srv.Connected -eq 'Connected') {
            $class = 'OffDuplicate'
        }
        else {
            $class = $srv.Connected
        }

        [void]$sb.AppendLine(('<tr class="{0}">' -f $class))
        if ($i -eq 0) { [void]$sb.AppendLine(('    <td rowspan="{0}">{1}</td>' -f $sortedGroup.Count.ToString(), $server.Name)) }
        [void]$sb.AppendLine(('    <td>{0}</td>' -f $srv.Connected))
        [void]$sb.AppendLine(('    <td>{0}</td>' -f $srv.VMState))
        [void]$sb.AppendLine(('    <td>{0}</td>' -f $srv.State))
        [void]$sb.AppendLine(('    <td>{0}</td>' -f $srv.FSItem.Name))
        [void]$sb.AppendLine(('    <td>{0}GB</td>' -f $srv.SizeGB))
        [void]$sb.AppendLine(('    <td>{0}</td>' -f $srv.Volume))
        [void]$sb.AppendLine('</tr>')
        if ($i -eq $sortedGroup.Count-1) {
            [void]$sb.AppendLine(('<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>' -f $srv.Connected))
        }
    }
}
[void]$sb.AppendLine('</table>')
[void]$sb.AppendLine('</body></html>')

$sb.ToString() | Out-File ('C:\Scripts\VMReport_{0}.html' -f $cluster.Name) -Encoding utf8 -Force