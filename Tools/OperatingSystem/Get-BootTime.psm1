<# 
.NAME
    Get-BootTime
.SYNOPSIS
    Gets the bootup time for all AD Computers.
    Generates a file with servers' names and last bootup time and a file for servers that do not reply to a Test-Connection test.

#>
function Get-BootTime {

    Param
    (
        [Parameter(Mandatory = $False)][string]$FilesPath
    )
    #Function Logic:

    $Cpath = $FilesPath
    $DateFormat = Get-Date -Format ddMMyyyy.HHmmss
    $UpCFullname = $Cpath + "\" + "lastbootupservers." + $DateFormat + ".csv"
    $DownCFullname = $Cpath + "\" + "offlineservers." + $DateFormat + ".txt"


    $SrvUp = @()
    $SrvUpInfo = @()
    $SrvDwn = @()

    $Srvs = Get-ADComputer -Filter * -Properties * | Where-Object {$_.Enabled -eq $True -and $_.DNSHostname -notlike "*clu*" -and $_.CN -notlike "$env:COMPUTERNAME" } 

    foreach ($c in $Srvs) {
        $SName = $c.DNSHostname
        $IsAlive = Test-Connection -ComputerName $SName -Count 1 -Quiet

        If ($IsAlive -eq $true) { Write-Host "$SName is alive"; $SrvUp += $SName }
        else { 
            Write-Host "$SName is offline"
            $SrvDwn += $SName 
        }
             
    }

    foreach ($Sup in $SrvUp) {
        #Write-Host "$Sup+yeah"
        $SrvBoot = Invoke-Command -ComputerName $Sup -ScriptBlock {Get-CimInstance -ClassName win32_operatingsystem} |  Select-Object csname, lastbootuptime
        $SrvUpInfo += $SrvBoot
    }

    $SrvUpInfo |Sort-Object -Property cname | Export-Csv -Path $UpCFullname -NoClobber -NoTypeInformation
    $SrvDwn | Sort-Object | Get-Unique | Out-File -FilePath $DownCFullname -NoClobber

    Write-Host "Offline or non-WinRM enabled servers report stored on $DownCFullname" -ForegroundColor Red
    Write-Host "Online or servers report stored on $DownCFullname" -ForegroundColor Green

}