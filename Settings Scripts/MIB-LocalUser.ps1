#requires -version 4
<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None>

.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param(
    [string] $DeviceAction = "",
    [string] $User = "",
    [string] $fullName = "",
    [string] $Description = ""
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here


#-----------------------------------------------------------[Functions]------------------------------------------------------------




Function New-LocalAccount {
  [cmdletbinding()]
  Param (
    [string] $LocalName = "",
    [string] $Description = "",
    [string] $FullName = ""
      ) 
  # End of Parameters

  Process {
    Try {
      New-LocalUser -Name $LocalName -Description $Description -FullName $FullName -NoPassword
    }
    Catch {
      Write-Host  "Error: $($_.Exception)" 
      Break
    }
  }
}

function Disable-LocalAccount {
  [cmdletbinding()]
  Param (
    [string] $LocalName = "" 
  )
  
  Process {
    Try {
      Disable-LocalUser -Name $LocalName
      Write-Host  Write-Host "Acount has Been Disabled" 
    }
    Catch {
      Write-Host  "Error: $($_.Exception)"
      Break
    }
  }
}


Function Enable-LocalAccount{
  [cmdletbinding()]
  Param (
    [string] $LocalName = ""
  )
  
  Process {
    Try{ 
      Enable-LocalUser -Name $LocalName
      Write-Host  "Acount has Been Enabled"
    }
    Catch {
      Write-Host  "Error: $($_.Exception)"  
      Break
    }
  }
  End{
    If ($?) {
      Write-Host  "Completed Successfully."  
    }    
  }
}


Function Remove-LocalAccount{
  [cmdletbinding()]
  Param (
    [string] $LocalName = ""
  )
  
  Process {
    Try {
      Remove-LocalUser -Name $LocalName
      Write-Host  "Acount has Been Removed"  
    }
    Catch {
      Write-Host  "Error: $($_.Exception)"  
      Break
    }
  }
  End{
    If ($?) {
      Write-Host  "Completed Successfully."  
    }    
  }
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Script Execution goes here
#New-LocalAccount -LocalName $User -FullName "Static User" -Description "None"

Switch ($DeviceAction)
    {
        Create { New-LocalAccount -LocalName $User -FullName $FullName -Description $Description }
        Disable { Disable-LocalAccount -LocalName $User }
        Enable { Enable-LocalAccount -LocalName $User }
        Delete { Remove-LocalAccount -LocalName $User }
    }

# Invoke Expressons
