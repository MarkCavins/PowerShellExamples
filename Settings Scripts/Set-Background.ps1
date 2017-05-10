#requires -version 4
<#
.SYNOPSIS
  Set Device name

.DESCRIPTION
  This script will set the device name and generate and HTML output with completion status or any errors experienced during execution.

.PARAMETER DeviceName
  The name to be assigned to the enrolled device (Core 9.2 and below please set the name of the devie at the Execution line below.)

.INPUTS
  $USERID$, $DEVICEID$, or any System variables that can bs used in a SCEP confiugration (Core 9.3 and up)

.OUTPUTS
  Script Status in html format

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  12-29-2016
  Purpose/Change: Initial script development

.EXAMPLE
  Set the Device Name to USERID
  C:\temp\Set-DeviceName.ps1 -DeviceName $USERID$

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

param(
    [String] $PathToFile = "",
    [String] $WPStyle = "4")
# Set up additional registry drives:
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null


#Disable changing home page setting
Function Set-WallPaper {
    param ( [String] $Image = "",
            [String] $Style = "",
            [String] $SID = "")

    process {
        
        Set-ItemProperty -Path "HKU:\$($SID)\Control Panel\Desktop" -Name Wallpaper -Value $Image
        rundll32.exe user32.dll, UpdatePerUserSystemParameters

    }
}

$EnabledUser = Get-localUser | where {$_.Enabled -eq $true}

Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Set-WallPaper -SID $_.SID.Value -Image $PathToFile -Style $WPStyle }