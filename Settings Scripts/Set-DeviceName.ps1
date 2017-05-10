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

Param (
  [String] $DeviceName = ""
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here
$name = (Get-Item env:\Computername).Value
$filepath = (Get-ChildItem env:\userprofile).value
#### HTML Output Formatting #######

#-----------------------------------------------------------[Functions]------------------------------------------------------------


Function Set-Name {
  Param ([cmdletbinding()]
    [string]$NewName = "")
  Process {
    Try {
      $ThisComputer = Get-WMIObject Win32_ComputerSystem | Select-Object -ExpandProperty name
          
       Rename-Computer -NewName $NewName -Restart -ErrorAction Stop
        $a = "<style>"
        $a = $a + "BODY{background-color:Lavender ;}"
        $a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
        $a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
        $a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
        $a = $a + "</style>"
        ConvertTo-Html -Head $a  -title "Device Name CHange on $name" -Body "<h1>Name: $name</h1> <h1>New Device Name: $NewName </h1>" >  "$filepath\$name.html" 
      
    }
    Catch {
      ConvertTo-Html -Body "Error: $($_.Exception)" >> "$filepath\$name.html"
      Break
    }
  }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Script Execution goes here
Set-Name -NewName $DeviceName
Get-Content "$filepath\$name.html"