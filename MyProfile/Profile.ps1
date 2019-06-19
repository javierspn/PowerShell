Import-Module "C:\Users\fjsantiago.SOPRA\Google Drive\Ps\Misc\Get-Greeting.psm1"
$TitleDate = get-date

# Elevated session
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (Test-Administrator) { $Elevated = "Elevated" }


Set-Location $Env:SystemDrive\temp
Clear-Host
Get-Greeting -Location "C:\Users\fjsantiago.SOPRA\Google Drive\Ps\Misc"


$MajorV = $PSVersionTable | Select-Object -ExpandProperty values | Select-Object major -First 1
$MinorV = $PSVersionTable | Select-Object -ExpandProperty values | Select-Object minor -First 1
$Version = "PS|" + $MajorV.Major.ToString() + "." + $MinorV.Minor.ToString()

function Prompt {
    #$Host.UI.RawUI.WindowTitle = (Get-Date -UFormat '%y/%m/%d %R').Tostring()
    $Host.UI.RawUI.WindowTitle = "Session started at " + $TitleDate.ToString() + " " + $Elevated

    Write-Host '[' -NoNewline
    Write-Host ($Version) -ForegroundColor Green -NoNewline
    Write-Host ']:> ' -NoNewline
    Write-Host (Split-Path (Get-Location) -Leaf) -NoNewline
    return "$ "
}