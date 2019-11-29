<# 
.NAME
    Set-OU
.SYNOPSIS
    Moves the computer object in AD to the proper OU depending on the operating system:
    
    Server 2008 = "OU=Windows 2008,OU=PertraServere,DC=Pertra,DC=locale"
    Server 2012 = "OU=Windows 2012,OU=PertraServere,DC=Pertra,DC=locale"
    Server 2016 = "OU=Windows 2016,OU=PertraServere,DC=Pertra,DC=locale"
    Server 2019 = "OU=Windows 2019,OU=PertraServere,DC=Pertra,DC=locale"

    Nothing is done if the computer object is on the proper OU.

    The OU can be set manually with the following format: "OU=Servers,DC=contoso,DC=locale"

.PARAMETER $Computer
    Computer object's name to be moved.

.PARAMETER $OU
    Optional. OU where the computer object will be placed if specified. If not, default OUs (see above) will be used.
.EXAMPLE
    Set-OU -Computer SERVER1 -OU "OU=Servers,DC=contoso,DC=locale"
.EXAMPLE
    Set-OU -Computer SERVER1 
    
#>
function Set-OU
{

    Param
    (

        [Parameter(Mandatory = $True,Position=1)][string][Alias("C")]$Computer,
        [Parameter(Mandatory = $False,Position=2)][string][Alias("O")]$OU

    )


$ADCData = Get-ADComputer -LDAPFilter "(name=*$Computer*)" -Properties * | Select-Object OperatingSystem, DistinguishedName
$ADOs = ($ADCData.OperatingSystem) -replace '\D+(\d+)\D+','$1'

$AdOu2k8 = "OU=Windows 2008,OU=PertraServere,DC=Pertra,DC=locale"
$AdOu2k12 = "OU=Windows 2012,OU=PertraServere,DC=Pertra,DC=locale"
$AdOu2k16 = "OU=Windows 2016,OU=PertraServere,DC=Pertra,DC=locale"
$AdOu2k19 = "OU=Windows 2019,OU=PertraServere,DC=Pertra,DC=locale"

if ($OU) {

                  Get-ADComputer $Computer | Move-ADObject -TargetPath $OU
                  Write-Host "$Computer object moved to $OU"
                }
Else
                {

                    $OuLocated = ($ADCData.DistinguishedName -split "," | Select-String -SimpleMatch "Windows") -replace "[^0-9]" , ''

                    if ($OuLocated -like $ADOs) 
                        {
                            Write-Host "$Computer object is already located on the proper OU"
                        }

                    elseif ($ADOs -like "2008") 
                        {
                            Get-ADComputer $Computer | Move-ADObject -TargetPath $AdOu2k8
                            Write-Host "$Computer object moved to $AdOu2k8"
                        }

                    elseif ($ADOs -like "2012") 
                        {
                            Get-ADComputer $Computer | Move-ADObject -TargetPath $AdOu2k12
                            Write-Host "$Computer object moved to $AdOu2k12"
                        }

                    elseif ($ADOs -like "2016") 
                        {
                            Get-ADComputer $Computer | Move-ADObject -TargetPath $AdOu2k16
                            Write-Host "$Computer object moved to $AdOu2k16"
                        }

                    elseif ($ADOs -like "2019") 
                        {
                            Get-ADComputer $Computer | Move-ADObject -TargetPath $AdOu2k19
                            Write-Host "$Computer object moved to $AdOu2k19"
                        }
                    else
                        {
                            Write-Host "Unable to locate the OS/OU"
                        }
    }
}