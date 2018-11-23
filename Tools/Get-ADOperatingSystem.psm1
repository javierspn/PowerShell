Function Get-ADOperatingSystem {
     param (
            [Parameter(Mandatory = $true)][System.String]$LoadFile
            )
    $ServersList = Get-Content $LoadFile

    foreach ($Srv in $ServersList) {
    
        Try {
            Get-ADComputer -Identity $Srv -Properties *  | 
                Select-Object Name, OperatingSystem | Export-Csv -Path C:\TEMP\results.csv -NoTypeInformation -Append

        }
        Catch {
            "$Srv Does not Exist on AD" 
        }
     
    }
}