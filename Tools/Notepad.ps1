Function Set-NewAcls
{
    
    param (
        [Parameter(Mandatory = $true)][System.String]$Path,
        [Parameter(Mandatory = $true)][System.String]$Grp,
        [Parameter(Mandatory = $False)][System.String]$Depth = 3,
        [Parameter(Mandatory = $False)][System.String]$LogPath = "C:\temp"

            
    )


    $LogEnding = (Get-Date -Format HHmmss.ddMMyyyy) + ".txt"
    $LogBegginning = "acls.log."
    $LogName = $LogBegginning + $LogEnding
    $LogFullPath = $LogPath + "\" + $LogName
    $Message1 = "ACL for group $Grp previously existing; applied new ACL Settings"
    $Message2 = "ACL for group $Grp applied"

    $Iterations = ("\*" * $Depth) + "\"
    $PathToCheck = $Path + $Iterations

    Write-Host $PathToCheck

    $FoldersToChange = Get-ChildItem $PathToCheck -Directory | Select-Object FullName

    Write-Host $FoldersToChange

    foreach ($f in $FoldersToChange) {
        $Acl = Get-Acl -Path $f.FullName 

        $TryGroup = $Acl | Select-Object -ExpandProperty Access | Where-Object { $_.IdentityReference -eq $Grp }

        if ($TryGroup) {
            Write-Host $Message1, $f.FullName
            $AclArgs = $Grp, "Modify", "ContainerInherit, ObjectInherit", "None", "Allow"
            $AclRule = New-Object System.Security.AccessControl.FileSystemAccessRule $AclArgs
            $Acl.SetAccessRule($AclRule)
            $Acl | Set-Acl $f.FullName
            $Message1 + ";" + $f.FullName | Out-File -FilePath $LogFullPath -Append -NoClobber 
        
        }
        Else {
        
            Write-Host $Message2, $f.FullName
            $AclArgs = $Grp, "Modify", "ContainerInherit, ObjectInherit", "None", "Allow"
            $AclRule = New-Object System.Security.AccessControl.FileSystemAccessRule $AclArgs
            $Acl.SetAccessRule($AclRule)
            $Acl | Set-Acl $f.FullName 
            $Message2 + ";" + $f.FullName | Out-File -FilePath $LogFullPath -Append -NoClobber 
        }


    }
}

Measure-Command { Set-NewAcls -Path "\\A21-P1-filc01\petektest\Wells_P_Test" -Grp "PERTRA\RG-S-Well-Wells_Norway-M" }

<#
$Path = "\\A21-P1-filc01\petek\Well\Wells_P_Test2"
$Depth = 3
$Grp = "PERTRA\RG-S-Well-Wells_Norway-M"
#>