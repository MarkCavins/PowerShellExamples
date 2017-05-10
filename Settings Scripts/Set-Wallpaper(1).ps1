<#
Script Name:	Set-Wallpaper.ps1
Created By: 	Victor Cruz - vcruz@mobileiron.com
Date: 		Dec 2016

.VERSION HISTORY
1.0		Dec 2016	Original Build

DESCRIPTION

    PowerShell script to change the Desktop Wallpaper

.USAGE

    Shell Syntax

 	Set-Wallpaper [Path]

        Picture Examples
            .\Set-Wallpaper.ps1 C:/wallpapers/companylogo.jpg
            .\Set-Wallpaper.ps1 \\network-drive\companylogo.jpg
            #>

#----------------------------------------------------------------------------------------------------------------
#   Supporting Functions   #
#---------------------------

#Validate Win10 Version
#Function retuns TRUE if is Windows 10 and Release is 1607 or greater
Function GValidateWindowsVersion{
$OSver = Get-ItemProperty -Path "HKLM:\software\microsoft\windows nt\currentversion"
$WinMajorVer = $OSver.CurrentMajorVersionNumber
$RelID = $OSver.ReleaseID

if ($WinMajorVer -lt 10){
  write-warning "This version of windows is not supported."
  return $false
}
elseif ($RelID -lt 1607){
  write-warning "This release of windows 10 is not supported."
  return $false
  }
  else {
    return $true
    }
}
#Validate if is Domain Joined
#Function retuns TRUE if domain joined
Function Get-DomainInfo{
(Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
}

Function Set-Wallpaper ($Path){

    #check if file exists

    if(Test-Path -Path $Path -PathType Leaf){

    #Set the wallpaper
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $Path
    Write-Output "$LogTime - Wallpaper changed"}

    else{
    Write-Output "$LogTime - Invalid file selected."}
    }
#Launch the Script
$LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
$validwin = ValidateWindowsVersion

if($args[0] -eq $NULL){
    Write-Output "$LogTime - Argument not set."
}
    elseif (Get-DomainInfo -eq $true){
        Write-Output "$LogTime - This PC belongs to a Domain, a GPO policy could overwrite this script"
        }
    elseif( $validwin -eq $false){
        Write-Output "$LogTime - This version of Windows is not supported by MobileIron Bridge"
    }
else{
    Set-Wallpaper $args[0]
    Write-Output "$LogTime"
    Out-File "%temp%\Set-Background.log" -Append
}
