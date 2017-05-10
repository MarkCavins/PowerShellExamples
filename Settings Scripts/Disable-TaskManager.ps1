#requires -version 4
<#
.SYNOPSIS
  Disables the Task Manager from the user

.DESCRIPTION
  This script will disable or enable task manager on the device

.PARAMETER DeviceAction
  The action to be executed on the device

.INPUTS
  Enable - Enables Task Manager
  Disable - Disable Task Manager

.OUTPUTS
  <None>

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  1-2-2017
  Purpose/Change: Initial script development

.EXAMPLE
  Set the Device Name to USERID
  C:\temp\Disable-TaskManager.ps1 -DeviceAction (Enable or Disable)

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
        if ( Test-Path -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" ){
            Set-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'DisableTaskMgr' -Value '1' | Out-Null
            
        }
        else{
            New-Item -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System"
            New-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'DisableTaskMgr' -PropertyType DWORD -Value '1' | Out-Null
            
        }
    }
}
Function Enable-Control {
    param ( [String] $SID = "")

    process {
        if ( Test-Path -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" ){
            Set-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'DisableTaskMgr' -Value '0' | Out-Null
            
        }
        else{
            New-Item -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System"
            New-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'DisableTaskMgr' -PropertyType DWORD -Value '' | Out-Null
            
        }
    }
}
Switch ($DeviceAction) {
    Disable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-Control -SID $_.SID.Value } }
    Enable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Enable-Control -SID $_.SID.Value } }
}