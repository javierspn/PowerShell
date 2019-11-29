#Located on C:\Users\a-fpena\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1
cd "O:\1. Delivery teams\A21 - Aker BP\Software\Scripts\CustomModules"
$ModtoImport = Get-ChildItem | Where-Object {$_.Extension -like ".psm1"}
foreach ($Mod in $ModtoImport)
    {
        Import-Module $Mod.FullName
    }


$env:PSModulePath = $env:PSModulePath + ";O:\1. Delivery teams\A21 - Aker BP\Software\Scripts\CustomModules"

Import-Module VMware.PowerCLI
Import-Module NTFSSecurity
Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1"