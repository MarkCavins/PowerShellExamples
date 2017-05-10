#requires -version 4
<#
.SYNOPSIS
  Disable Control Pannel

.DESCRIPTION
  This script will disable the control panel for every active user on the device

.PARAMETER DeviceAction
  This will determine if the Control Panel is enable or disabled

.INPUTS
  Enabel - Enables Control Panel
  Disable - Disables Control Panel

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  1-2-2017
  Purpose/Change: Initial script development

.EXAMPLE
  Set the Device Name to USERID
  C:\temp\Disable-ControlPanel.ps1 -DeviceAction (Enable or Disable)

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

param(
    [String] $DeviceAction = " "
    )

# Set up additional registry drives:
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null -ErrorAction Continue

Function Disable-Control {
    param ( [String] $SID = "")

    process {
        if ( Test-Path -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" ){
            Set-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'NoControlPanel' -Value '1' | Out-Null
        }
        else{
            New-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            New-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'NoControlPanel' -PropertyType DWORD -Value '1' | Out-Null
        }
    }
}
Function Enable-Control {
    param ( [String] $SID = "")

    process {
        if ( Test-Path -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" ){
            Set-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'NoControlPanel' -Value '0' | Out-Null
        }
        else{
            New-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            New-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'NoControlPanel' -PropertyType DWORD -Value '0' | Out-Null
        }
    }
}
Switch ($DeviceAction) {
    Disable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-Control -SID $_.SID.Value } }
    Enable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Enable-Control -SID $_.SID.Value } }
}