<#
.Synopsis
   Removes the Antivirus, BigFix client
.DESCRIPTION
    Removes all componentes needed for a server deocmmission
.EXAMPLE
   Get-AclInheritance -Folder c:\Temp -OutFolder c:\User\JohnDoe\Desktop
.INPUTS
   Full FQDN server's name
.OUTPUTS
  Not for the moment
.NOTES
For DNS: https://community.spiceworks.com/topic/2131661-searching-for-a-records-across-all-zones blablah

#>
function Remove-Server {

    Param
    (
        # Server's name (full FQDN).
        [Parameter(Mandatory = $true, Position = 0)][Alias("F")]$ComputerName

    )

    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $env:COMPUTERNAME
        $BFYes = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like “*IBM BigFix*” }
        if ($BFYes) { $BFYes.Uninstall() }
        $SEPYes = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like “*Symantec Endpoint Protection*” }
        if ($SEPYes) { $SEPYes.Uninstall() }
        Restart-Computer -Force -ErrorAction SilentlyContinue

    }

    Start-Sleep -Seconds 120

    $RDPUp = (Test-NetConnection $ComputerName -port 3389).TcpTestSucceeded
    If (!$RDPUp) {
        Start-Sleep -Seconds 30
        $RDPUp.Refresh()
    }
    Else {
        Write-Host "Server $ComputerName is online"
    }


}

Invoke-Command -ComputerName a21-p1-dom037 -Credential pertra\dadminfrasan -ScriptBlock { Get-DnsServerResourceRecord -zonename "pertra.locale" -Name "a21-t1-app020" }

$ADGroups = Get-ADGroup -Filter { name -like "*a21-t1-app020*" }

foreach ($ADGrp in $ADGroups) {
    Remove-ADGroup -Identity $ADGrp.Name -Confirm:$false
    
}




