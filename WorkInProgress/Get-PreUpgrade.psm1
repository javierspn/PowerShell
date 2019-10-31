<#
.SYNOPSIS
 Quick and dirty Function to export IP interface configuration, FQDN name and Windows Firewall rules.

.DESCRIPTION
 Exports IP interface configuration, FQDN name, Windows Firewall rules and free space from the local host to txt files to a given folder.
 For the firewall rules to be exported you must import and run this function within an elevated prompt.

.PARAMETER <Parameter_Name>
 $FolderPath is the path wher ethe files will be exported. If the parameter is not provided the default temporary user folder will be used.
.INPUTS
 None.
.OUTPUTS
 FQDN: <HOSTNAME>_fqdn_info.txt
 IP interfaces:<HOSTNAME>_interfaces_info.txt
 Firewall rules: <HOSTNAME>_firewall_rules.wfw
.NOTES
  Version:        1.0
  Author:         FJSP
  Creation Date:  10/01/2019
  Purpose/Change: Initial script development
  
.EXAMPLE
  Get-PreUpgradeInfo -Folderpath c:\temp on host sunset.contoso.com: three files are created in c:\temp, "sunset_fqdn_info.txt", "sunset__interfaces_info.txt" and "sunset__firewall_rules.wfw"
#>
Function Get-PreUpgradeInfo{
    
    [CmdletBinding()]
    
    Param(
            [Parameter(Mandatory=$False)][String]$FolderPath="$env:Temp"
        
         )

  
    $CheckElevation = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if ($CheckElevation -eq $False) {Write-Host "You must run the function on an elevated prompt for the Firewall rules to be exported. Please re-run this function on an elevated Powershell session"; Break}
    If (!$FolderPath) { New-Item -Path $FolderPath -ItemType directory -Name }
    




    #Get Domain and Hostname information
    $FqdnHostname = [System.Net.Dns]::GetHostByName("$env:computername").HostName
    
    #Write Domain and Hostname information
    $FqdnFilename = $env:computername+"_fqdn_info.txt"
    $FqdnHostname > $FolderPath\$FqdnFilename
      
    #Get Interface configuration

    $IfInfoFilename = $env:computername+"_interfaces_info.txt"
    $IfInfo = Get-WmiObject win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress} | Select-Object *
    
    #Write Interface configuration
    
    foreach ($If in $IfInfo) {$if >> $FolderPath\$IfInfoFilename}

    #Get Firewall configuration (requires elevation!).

    $FwRulesFileName = $env:computername+"_firewall_rules.wfw"
    Netsh Advfirewall export $FolderPath\$FwRulesFileName

    $DiskSpaceFileName = $env:computername+"_diskpace.txt"
    
    $FreeDiskSpace = Get-WmiObject Win32_LogicalDisk -Filter DriveType=3 | 
     Select-Object DeviceID, @{'Name'='Size'; 'Expression'={[math]::truncate($_.size / 1GB)}}, @{'Name'='Freespace'; 'Expression'={[math]::truncate($_.freespace / 1GB)}}
    $FreeDiskSpace | Select-Object DeviceID, Size, FreeSpace >  $FolderPath\$DiskSpaceFileName

    
}