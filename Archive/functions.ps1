#Validate Win10 Version
#Function retuns TRUE if is Windows 10 and Release is 1607 or greater

Function ValidateWindowsVersion{
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

#Validate Win10 ChassisType (Desktop,Tablet)
Function Get-Chassis{
$GetSystem = Get-WMIObject -class Win32_systemenclosure
$ChassisType = $GetSystem.chassistypes
Switch ($ChassisType)
    {
        "1" {"Chassis type is: $ChassisType - Other/VM"}
        "2" {"Chassis type is: $ChassisType - Unknown"}
        "3" {"Chassis type is: $ChassisType - Desktop"}
        "4" {"Chassis type is: $ChassisType - Low Profile Desktop"}
        "5" {"Chassis type is: $ChassisType - Pizza Box"}
        "6" {"Chassis type is: $ChassisType - Mini Tower"}
        "7" {"Chassis type is: $ChassisType - Tower"}
        "8" {"Chassis type is: $ChassisType - Portable"}
        "9" {"Chassis type is: $ChassisType - Laptop"}
        "10" {"Chassis type is: $ChassisType - Notebook"}
        "11" {"Chassis type is: $ChassisType - Handheld"}
        "12" {"Chassis type is: $ChassisType - Docking Station"}
        "13" {"Chassis type is: $ChassisType - All-in-One"}
        "14" {"Chassis type is: $ChassisType - Sub-Notebook"}
        "15" {"Chassis type is: $ChassisType - Space Saving"}
        "16" {"Chassis type is: $ChassisType - Lunch Box"}
        "17" {"Chassis type is: $ChassisType - Main System Chassis"}
        "18" {"Chassis type is: $ChassisType - Expansion Chassis"}
        "19" {"Chassis type is: $ChassisType - Sub-Chassis"}
        "20" {"Chassis type is: $ChassisType - Bus Expansion Chassis"}
        "21" {"Chassis type is: $ChassisType - Peripheral Chassis"}
        "22" {"Chassis type is: $ChassisType - Storage Chassis"}
        "23" {"Chassis type is: $ChassisType - Rack Mount Chassis"}
        "24" {"Chassis type is: $ChassisType - Sealed-Case PC"}
        Default {"Chassis type is: $ChassisType - Unknown"}
     }
}

$winout = ValidateWindowsVersion
$domainout = Get-DomainInfo
$chassisout = Get-Chassis
$LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"

write-output "$LogTime - Is Windows supported?: $a is domain joined? $b and $c" | Out-File 'C:\Temp\functionsps.log' -Append -Force
