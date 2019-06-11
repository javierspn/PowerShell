Function Super-Ping
{
    
    param (
            [Parameter(Mandatory = $true)][System.String]$ComputersFile,
            [Parameter(Mandatory = $False)][System.String]$FilePath="c:\temp\",
            [Parameter(Mandatory = $False)][System.String]$FileName="SuperPing"
            
            )


    
    $DateLog = Get-Date -Format ddmmyyyy.HHmm
    $CSVFileName = "$FileName.$DateLog.csv"
    $CSVpath = $Filepath

    $Computers = (get-content $ComputersFile) -notmatch "^\s*$"

    $Objects = foreach ($entry in $computers) 
        {
            $PingResult = Test-Connection -ComputerName $entry.Trim() -Quiet -Count 1 -ErrorAction SilentlyContinue
            $HostName = $entry
            $ObjectProps = @{
                                Ping = $PingResult
                                Hostname = $HostName
                            }
            New-Object psobject -Property $ObjectProps

        }
       $Objects | Export-Csv -Path $FilePath\$CSVFileName
}
