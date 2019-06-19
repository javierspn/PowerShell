Function Get-Greeting {

    param (
            [Parameter(Mandatory = $true)][System.String]$Location
          )

    Set-Location $Location

    $W1 = Get-Content .\insult-word-1.txt | Get-Random
    $W2 = Get-Content .\insult-word-2.txt | Get-Random
    $W3 = Get-Content .\insult-word-3.txt | Get-Random
    $W4 = Get-Content .\insult-word-4.txt | Get-Random
    $W5 = Get-Content .\insult-word-5.txt | Get-Random


    $Hour = (Get-Date).Hour

    If ($Hour -lt 12) { $Greeting = "Good morning" }

    ElseIf ($Hour -gt 16) { $Greeting = "Good evening" }

    Else { $Greeting = "Good afternoon" }

    Write-Host "$Greeting you $W1 $W2 of $W3 $W4 $W5"
}


