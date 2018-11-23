Function Compress-7zip {
    
    param (
        [Parameter(Mandatory = $True)][System.String]$File,
        [Parameter(Mandatory = $False)][System.String][ValidateSet('Yes', 'No')]$DeleteInputFile = "No"
    )

    $7ZipPath=".\7zip\7za.exe"
    $Is7zipHere = Test-Path $7ZipPath
    If (!$Is7zipHere) {Write-Host "7zip executable or libraries not found"}
    
    if ($DeleteInputFile -eq "Yes") {$DeleteParam = "-sdel"}

    $ZipFilename = $File + ".zip"
    Write-Host $ZipFilename
    &"$7ZipPath" a -mx9 $ZipFilename $File $DeleteParam -y

}
