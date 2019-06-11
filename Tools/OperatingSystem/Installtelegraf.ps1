$Vmhosts = Import-Csv C:\temp\vmhosts.csv

foreach ($Hv in $Vmhosts) {
    <#
        $Copypath = "\\"+$Hv.Name+"\c$"
        Write-Host $Copypath
        Copy-Item "C:\Temp\telegraf\" -Destination $Copypath -Recurse -Force
        #>
    # Invoke-Command -ComputerName $HV.Name -ScriptBlock {& 'C:\Telegraf\telegraf.exe' --service install --config C:\telegraf\telegraf.conf}
    Invoke-Command -ComputerName $HV.Name -ScriptBlock { Restart-Service -Name telegraf }
}
