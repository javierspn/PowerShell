function Add-RDMSession {

    Param
    (
        [Parameter(Mandatory = $True,Position=0)][string][Alias("C")]
        [ValidateSet("AkerEnergy","AkerBP")]
        $Customer,
        [Parameter(Mandatory = $True,Position=1)][string][Alias("N")]$ComputerName,
        [Parameter(Mandatory = $True,Position=2)][string][Alias("I")]$ComputerIP,
        [Parameter(Mandatory = $False,Position=3)][string][Alias("G")]$Computergroup,
        [Parameter(Mandatory = $False,Position=4)][string][Alias("D")]$Domain
        
    )


$A21Repo = Get-RDMRepository | Where-Object {$_.Name -like "*A21*"} 
$A37Repo = Get-RDMRepository | Where-Object {$_.Name -like "*A37*"} 
$DefaultRepo = Get-RDMRepository | Where-Object {$_.Name -like "*Default*"} 


    If ($Customer -like "AkerBP") 
        {
            Set-RDMCurrentRepository -ID $A21Repo.ID
            $Group = "A21 - Det norske oljeselskap ASA"
        }

    elseif ($Customer -like "AkerEnergy")
        {
            Set-RDMCurrentRepository -ID $A37Repo.ID
            $Group = "A37 - Aker Energy ASA"
        }

     else
        {
            Set-RDMCurrentRepository -ID $DefaultRepo.ID
            Set-RDMCurrentRepository -ID $A37Repo.ID
            $Group = "DPS"
        }

If ($Computergroup) {$Group = $Computergroup}

$RDMSession = New-RDMSession -Host $ComputerIP -Type "RDPConfigured" -Name $ComputerName -Group $Group

Set-RDMSession -Session $RDMSession -Refresh

Update-RDMUI

if ($Domain) {Set-RDMSessionDomain -ID $RDMSession.ID -Domain $Domain}



}