
    Import-Module "C:\Users\fjsantiago.SOPRA\Git\PowerShell\Tools\OperatingSystem\Get-CpuProcUsage.psm1"
    
    $Date = Get-Date -Format ddMMyyyy.HHmmss
    $OutFolder = "C:\Temp"
    $FileName = $OutFolder + "\" + "CPUProcUsage." + $Date + ".csv"
    $IntervalSeconds = 5
    $MaxIntervals = 10
    $IntCount = 0

    
    while ($MaxIntervals -ne $IntCount ) {
    
        Get-CpuProcUsage -NumberOfProcesses 10 | Export-Csv -Path $FileName -Append -NoClobber -NoTypeInformation
 
        $IntCount = $IntCount + 1
 
        Start-Sleep $IntervalSeconds
    }