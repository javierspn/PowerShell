$Computers = Get-Content -Path <filepath>

foreach ($C in $Computers) {
        
    Get-ADComputer -Identity $C -Properties * | Select-oBject Name, LastLogonDate

}
