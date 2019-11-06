<# 
.NAME
    Add-Software
.SYNOPSIS
    Install Things
#>
function Add-Software{

    Param
    (
        [Parameter(Mandatory = $True,Position=0)][string][Alias("S")]
        [ValidateSet(“BigFix”,”Symantec”)]$Software,
        [Parameter(Mandatory = $True,Position=1)][string][Alias("P")]$Computers

    )

    $BigFixPkg = "\\a21-p1-mgm026\shared$\Software\BigFix\"
    $BFInstall = Get-ChildItem -Path $BigFixPkg *auto* | Get-Random | Select-Object FullName
    $SymantecPkg = "\\a21-p1-mgm026\shared$\Software\Symantec\SymantecClientServers14"

    
    foreach ($C in $Computers)
    {
        $CSession = New-PSSession -ComputerName $C 
                
        switch ($Software) {
            "BigFix" { 
                        $BigFixFld = Get-Random
                        Write-Host "BigFix  installation on $C"
                        $InstallFolder = "$ENV:SystemDrive\$BigFixFld"
                        Write-Host $InstallFolder
                        
                        #Copy-Item -ToSession $CSession -Path $BigFixPkg -Destination $InstallFolder -Recurse -Container
                        Copy-Item -ToSession $CSession -Path $BFInstall.FullName -Destination $InstallFolder -Recurse -Container
                        #Invoke-command -Session $CSession -ScriptBlock {param ($BfXarg) & "$using:InstallFolder\auto01\setup.exe" $BfXarg} -ArgumentList "/S /v/qn"
                        Invoke-command -Session $CSession -ScriptBlock {param ($BfXarg) & "$using:InstallFolder\setup.exe" $BfXarg} -ArgumentList "/S /v/qn"
                        Start-Sleep -Seconds 120
                        Invoke-Command -Session $CSession -ScriptBlock {Remove-Item -Path "$using:InstallFolder" -Recurse -Force}
                        Remove-PSSession -Session $CSession
                        Write-Host "BigFix installed on $C. Check the BigFix console"

                                                             

                     }

            "Symantec" { 
                            Write-Host "Symantec installation on $Computers"  
                     }

            Default {}
        }
    }


}