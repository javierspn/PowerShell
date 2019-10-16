Function Get-CpuProcUsage {
    Param
    (
       
        [Parameter(Mandatory = $false, Position = 0)][Alias("N")]$NumberOfProcesses = 10
    )
        $IntDate = Get-Date -Format dd:mm:ss 
        $properties = @(
            @{Name = "Process Name"; Expression = { $_.name } },
            @{Name = "CPUPercentage"; Expression = { $_.PercentProcessorTime } },    
            @{Name = "Memory (MB)"; Expression = { [Math]::Round(($_.workingSetPrivate / 1mb), 2) } },
            @{ Name = 'Date'; Expression = { $IntDate } }
        )
        Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process | 
        Select-Object $properties | Sort-Object -Property CPUPercentage -Descending | Select-Object -First $NumberOfProcesses 
 
}