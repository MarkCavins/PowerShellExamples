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
    [String] $DeviceAction = " ",
    [String] $PathToFile = ""
    )

# Set up additional registry drives:
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null -ErrorAction Continue

Function Enable-RestrictedApps {
    param ( [String] $SID = "",
            [String] $Applist = "")

    process {
        $Apps = Get-Content $Applist
        if ( Test-Path -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" ){
            if ( Test-Path -Path "HKU:\$($SID)\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun"){
                Set-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'RestrictRun' -Value '1' | Out-Null
                foreach ( $app in $Apps ){
                    New-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" -Name $app  -PropertyType String -Value $app | Out-Null
                }
            }
            else {
                New-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'RestrictRun' -PropertyType DWORD -Value '1' | Out-Null
                
                foreach ( $app in $Apps ){
                    New-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" -Name $app  -PropertyType String -Value $app | Out-Null
                }
            }   
        }
        else{
            New-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            New-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'RestrictRun' -PropertyType DWORD -Value '1' | Out-Null
            
            New-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun"
            foreach ( $app in $Apps ){
                New-ItemProperty -Path "HKU:\$($SID)\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" -Name $app  -PropertyType String -Value $app | Out-Null
            }
        }
    }
}
Function Disable-RestrictedApps {
    param ( [String] $SID = "")

    process {
        $Apps = Get-Content $Applist
        if ( Test-Path -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" ){
            Set-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'RestrictRun' -Value '0' | Out-Null  
            Remove-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun"
        }
        else{
            New-Item -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            New-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name 'RestrictRun' -PropertyType DWORD -Value '0' | Out-Null
        }
    }
}
Switch ($DeviceAction) {
    Disable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-RestrictedApps -SID $_.SID.Value } }
    Enable { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Enable-RestrictedApps -SID $_.SID.Value -Applist $PathToFile } }
}