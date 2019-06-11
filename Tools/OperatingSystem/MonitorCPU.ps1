$IntervalSeconds = 5
$MaxIntervals = 10
$IntCount = 0

while ($MaxIntervals -ne $IntCount ) 
    {
        
        $IntDate = Get-Date -Format dd:mm:ss 
        $properties = @(
        @{Name = "Process Name"; Expression = { $_.name } },
        @{Name = "CPUPercentage"; Expression = { $_.PercentProcessorTime } },    
        @{Name = "Memory (MB)"; Expression = { [Math]::Round(($_.workingSetPrivate / 1mb), 2) } },
        @{ Name = 'Date'; Expression = {$IntDate } }
    )
    Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process | 
    Select-Object $properties | Sort-Object -Property CPUPercentage -Descending | Select-Object -First 10 | 
    Export-Csv -Path C:\Temp\process.csv -Append -NoClobber -NoTypeInformation
 
    $IntCount = $IntCount + 1
 
    Start-Sleep $IntervalSeconds
    }
