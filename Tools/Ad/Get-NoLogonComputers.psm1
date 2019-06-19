function Get-NoLogonComputers {
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]$DaysInactive,
        [Parameter(Mandatory = $true, Position = 1)]$OutFolder


    )
    
    $CurrentTime = (Get-Date).Adddays( - ($DaysInactive))
    $Date = Get-Date -Format ddMMyyyy.HHmmss
    $FileName = $OutFolder + "\" + "NoLogonComputers." + $Date + ".csv"

    Get-ADComputer -Filter { LastLogonTimeStamp -lt $CurrentTime } -Properties LastLogonTimeStamp |

    Select-Object Name, @{Name = "Stamp"; Expression = { [DateTime]::FromFileTime($_.lastLogonTimestamp) } } | 
    Export-Csv -Path $FileName -NoTypeInformation -NoClobber
    
}