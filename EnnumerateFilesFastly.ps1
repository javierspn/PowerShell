###Cambia estas dos variables#####################################################################################################################
$UserName = "System"
$FPath = "C:\Users\fjsantiago.SOPRA"
##################################################################################################################################################

$AllFolders = Get-ChildItem -Path $FPath -Recurse -Directory

foreach ($Folder in $AllFolders) {
    $Acls = Get-Acl $Folder.FullName
    foreach ($Acl in $Acls) {
        $Acl.Access | Where-Object {$_.IdentityReference -like "*$UserName*"} | 
            Select-Object FileSystemRights, AccessControlType, IdentityReference, IsInherited, InheritanceFlags, PropagationFlags,
        @{Name = "Path"; Expression = {$Folder.Fullname}} |
            Export-Csv -Append -NoClobber -NoTypeInformation -Path c:\temp\aclsreport.csv
                 

    }                  
        
}


$Spath = "C:\Users\fjsantiago.SOPRA"
$UserName = "System"

Try {$Folders = [System.IO.Directory]::EnumerateDirectories($Spath, '*.*', 'AllDirectories')} catch {$_ | Out-File -FilePath C:\Temp\fileerrors.txt -Append -NoClobber}
$Folders | Out-File -FilePath C:\Temp\file.txt -Append -NoClobber

try {
    foreach ($f in $Folders) {
        $Acls = Get-Acl $f

        foreach ($Acl in $Acls) {
        $Acl.Access | Where-Object {$_.IdentityReference -like "*$UserName*"} | 
            Select-Object FileSystemRights, AccessControlType, IdentityReference, IsInherited, InheritanceFlags, PropagationFlags,
            @{Name = "Path"; Expression = {$Folder.Fullname}} |
            Export-Csv -Append -NoClobber -NoTypeInformation -Path c:\temp\aclsreport.csv
            }
        }
}

catch {
    $_.Exception.Message | Out-File -FilePath C:\Temp\fileerrors.txt -Append -NoClobber
}