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
        [ValidateSet(“BigFix”,”Symantec”,"Qualys")]$Software,
        [Parameter(Mandatory = $True,Position=1)][string][Alias("P")]$Computers,
        [Parameter(Mandatory = $False,Position=2)][string][Alias("N")]
        [ValidateSet($True,$False)]$NoReboot=$True

    )

    $BigFixPkg = "\\a21-p1-mgm026\shared$\Software\BigFix\"
    $BFInstall = Get-ChildItem -Path $BigFixPkg *auto* | Get-Random | Select-Object FullName
    $SymantecPkg = "\\a21-p1-mgm026\shared$\Software\Symantec\SymantecClientServers14"
    $QualysPkg = "\\a21-p1-mgm026\shared$\Software\Qualys"

    
    foreach ($C in $Computers)
    {
        $CSession = New-PSSession -ComputerName $C 
                
        switch ($Software) {
            "BigFix" { 
                        $BigFixFld = Get-Random
                        Write-Host "BigFix  installation on $C"
                        $InstallFolder = "$ENV:SystemDrive\$BigFixFld"
                                                
                        
                        Copy-Item -ToSession $CSession -Path $BFInstall.FullName -Destination $InstallFolder -Recurse -Container
                        Invoke-command -Session $CSession -ScriptBlock {param ($BfXarg) & "$using:InstallFolder\setup.exe" $BfXarg} -ArgumentList "/S /v/qn"
                        Start-Sleep -Seconds 120
                        Invoke-Command -Session $CSession -ScriptBlock {Remove-Item -Path "$using:InstallFolder" -Recurse -Force}
                        Remove-PSSession -Session $CSession
                        Write-Host "BigFix installed on $C. Check the BigFix console"

                                                             

                     }

            "Symantec" { 
                            $SymFld = Get-Random
                            Write-Host "Symantec installation on $C"
                            $InstallFolder = "$ENV:SystemDrive\$SymFld"
                            Copy-Item -ToSession $CSession -Path $SymantecPkg -Destination $InstallFolder -Recurse -Container
                            Invoke-command -Session $CSession -ScriptBlock {param ($SymXarg) & "$using:InstallFolder\setup.exe" $SymXarg} -ArgumentList "/S /v/qn"
                            Start-Sleep -Seconds 300
                            Invoke-Command -Session $CSession -ScriptBlock {Remove-Item -Path "$using:InstallFolder" -Recurse -Force}
                            Remove-PSSession -Session $CSession
                            
                            if ($NoReboot -eq $False) {
                                                        Restart-Computer -ComputerName $C -Force
                                                        $RdpUp = Test-NetConnection -ComputerName $C -Port 3389 | Select-Object TcptestSucceeded
                                                        While ($RdpUp.TestSucceeded -eq $False) 
                                                            { 
                                                                Write-Host "Waiting for server $C to became available"
                                                                Start-Sleep -seconds 10; 
                                                                $RdpUp = Test-NetConnection -ComputerName $C -Port 3389 | Select-Object TcptestSucceeded                            
                                                             }

                                                     }
                            
                             Write-Host "Symantec installed on $C. Check the Symantec console"
                                                                                
                     }

           "Qualys" { 
                        $QualysFld = Get-Random
                        Write-Host "Qualys agent  installation on $C"
                        $InstallFolder = "$ENV:SystemDrive\$QualysFld"
                                                
                        
                        Copy-Item -ToSession $CSession -Path $QualysPkg -Destination $InstallFolder -Recurse -Container
                        #$QBlock = {param ($QlXarg) & "$using:InstallFolder\QualysCloudAgent.exe" $QlXarg}
                        $QBlock = { cd $using:InstallFolder; .\Install-Qualys.ps1}
                        Invoke-command -Session $CSession -ScriptBlock $QBlock
                        Start-Sleep -Seconds 60
                        Invoke-Command -Session $CSession -ScriptBlock {Remove-Item -Path "$using:InstallFolder" -Recurse -Force}
                        Remove-PSSession -Session $CSession
                        Write-Host "Qualys agent installed on $C. Check the BigFix console"

                                                             

                     }

            Default {}
        }
    }


}