#requires -version 4
<#
.SYNOPSIS
  Disables Cortona

.DESCRIPTION
  This script will set Cortonal to enable or Disable on the device

.PARAMETER DeviceAction
  This will tell the script what to do 

.INPUTS
  Device Action takes two imputs
  Enable - Enables Cortana
  Disable - Disables Cortana

.OUTPUTS
  

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  1-2-2017
  Purpose/Change: Initial script development

.EXAMPLE
  Set the Device Name to USERID
  C:\temp\Disable-Cortana.ps1 -DeviceAction (Enable or Disable) 

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

# Disable Cortana:
Param(
	[String] $DeviceAction = ""
	)

Function Disable-Cortana {
	process {
		if ( Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'){
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value '0' | Out-Null
		}
		else {
			New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' | Out-Null
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' | Out-Null
		}
	}
}

Function Enable-Cortana {
	process {
		Try {
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value '1' | Out-Null
		}
		Catch {
    		Write-Output  "Error: $($_.Exception)"  
      		Break
    	}
	}
}

Switch ($DeviceAction ) {
    Enable { Enable-Cortana }
    Disable { Disable-Cortana }
}