<#
.Synopsis
   Gets a list of folders with Inheritance disabled (from a given folder). Any subfolder at any level will be included.
.DESCRIPTION
   Gets a list of folders with Inheritance disabled (from a given folder). Any subfolder at any level will be included.
   It uses Get-Acl to get each folder's Acl settings, validating AreAccessRulesProtected property. When AreAccessRulesProtected = $True, 
   Inheritance is disabled.
   Generates a txt file for all folders with AreAccessRulesProtected = $True and an error file (if applicable) on the same path.
.EXAMPLE
   Get-AclInheritance -Folder c:\Temp -OutFolder c:\User\JohnDoe\Desktop
.INPUTS
   Folder to be checked for its subfolder's Acls and Folder where the output files will be created.
.OUTPUTS
   List of folders: acls.<day><month><year>.<hour><minute><second>.txt
   Errors file : acls.<day><month><year>.<hour><minute><second>.err.txt
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-ACLInheritance {
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true, Position = 0)][Alias("F")]$Folder,

        # Param2 help description
        [Parameter(Mandatory = $true, Position = 1)][Alias("O")]$OutFolder

    )

    $Date = Get-Date -Format ddMMyyyy.HHmmss
    $FileName = $OutFolder + "\" + "acls." + $Date + ".txt"
    $FileNameErr = $OutFolder + "\" + "acls." + $Date + ".err.txt"
    $FileNameExcp = $OutFolder + "\" + "acls." + $Date + ".excp.txt"

    Try { $Folders = [System.IO.Directory]::EnumerateDirectories($Folder, '*.*', 'AllDirectories') } catch { $_ | Out-File -Append -NoClobber -FilePath $FileNameExcp }


    try {
        foreach ($F in $Folders) {
            $PathExists = Test-Path $F

            If ($PathExists) {
                $Acls = Get-Acl $F

                If ($Acls.AreAccessRulesProtected -eq $True) {
                    Write-Host $F
                    $F | Out-File -Append -NoClobber -FilePath $FileName 
                }
            }
            Else {
                $F | Out-File -Append -NoClobber -FilePath $FileNameErr
            }
        }

    }

    catch {
        $_.Exception.Message | Out-File -Append -NoClobber -FilePath $FileNameExcp
    }
}