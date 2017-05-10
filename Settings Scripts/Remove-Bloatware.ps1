#requires -version 4
<#
.SYNOPSIS
  Removes Bloatware

.DESCRIPTION
  This script will all not system applications

.PARAMETER <None>

.INPUTS
 <None>

.OUTPUTS
  <None>

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  1-2-2017
  Purpose/Change: Initial script development

.EXAMPLE
  Set the Device Name to USERID
  C:\temp\Remove-Apps.ps1

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Function Remove-Apps {
  Process {
    Try {
        Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online -ErrorAction Continue
        Get-AppxPackage -AllUsers | Remove-AppxPackage -ErrorAction Continue
    }
    Catch {
        Write-Error -Message 
        continue
        }
}
}

Remove-Apps
