#requires -version 4
<#
.SYNOPSIS
  Creates Desktop Shortcuts

.DESCRIPTION
  This script will create desktop shortcuts for all users on the device

.PARAMETER
  Device Action - (APP or WEB) Determines which type of Shortcut to create
  SCName (Required) - Nme of the shortcut to be create
  Target (Required) - the .exe or web url path
  WorkingDir (Required App Only) - Working Dir of the applicaiton shortcut
  WinStyle - Refers to the style of the Shortcut 
  HotKey - Refers to the HotKeys used to execute the shortcut (CTRL + SHift + W)
  IconLoc - Location of the icon for the shortcut
  Descritpion - Description of the shortcut
  PathToFile - For the implementation of a Bulk Shortcut creation function

.INPUTS
  List of Shortcuts to be created

.OUTPUTS
  <None>

.NOTES
  Version:        1.0
  Author:         Peuge Benjamin
  Creation Date:  1-2-2017
  Purpose/Change: Initial script development

.EXAMPLE
  Set the name and target for a Web Shortcut
  C:\temp\MIB-DesktopShortcut.ps1 -DeviceAction Web -SCName MobileIrion -Target http://www.mobileiron.com

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

param(
     [Parameter (Mandatory=$true) ]
    [String] $DeviceAction = "Default",
     [Parameter (Mandatory=$true) ]
    [String] $SCName = "Default",
     [Parameter (Mandatory=$true) ]
    [String] $Target = "Default",
    [String] $WorkingDir = "Default",
    [String] $WinStyle = "Default",
    [String] $HotKey = "Default",
    [String] $IconLoc = "Default",
    [String] $Description = "Default",
    [String] $PathTOFile = ""
    )
function New-AppShorcut {
    param(
        [Parameter (Mandatory=$true) ]
        [String] $ASCName = "",
        [Parameter (Mandatory=$true) ]
        [String] $ATarget = "",
        [String] $AArguments = "",
        [Parameter (Mandatory=$true) ]
        [String] $AWorkingDir = "",
        [String] $AWinStyle = "",
        [String] $AHotKey = "",
        [String] $AIconLoc = "",
        [String] $ADescript
        )
	
    process {
        # Create a Shortcut with Windows PowerShell
        $Shell = New-Object -ComObject ("WScript.Shell")
        $ShortCut = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\$($ASCName).lnk")
        $ShortCut.TargetPath = "$($ATarget)"
        $ShortCut.Arguments = "$($AArguments)"
        $ShortCut.WorkingDirectory = "$($AWorkingDir)"
        $ShortCut.WindowStyle = $AWinStyle
        $ShortCut.Hotkey = "$($AHotKey)"
        $ShortCut.IconLocation = "$($AIconLoc)"
        $ShortCut.Description = "$(ADescript)"
        $ShortCut.Save()
    }
}

function New-WebShortcut {
    param(
        [Parameter (Mandatory=$true) ]
        [String] $WURL = "",
        [Parameter (Mandatory=$true) ]
        [String] $WSCName "",
        [String] $WIconLoc = ""
        )
    process {
        # Create a Shortcut with Windows PowerShell
        $TargetFile = "$($WURL)"
        $ShortcutFile = "$env:Public\Desktop\$($WSCName).URL"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPa
        $ShortCut.IconLocation = "$($AIconLoc)"
        $ShortCut.Save()
    }
}
<#
function New-BulkShortcuts {
    param(
        [Parameter (Mandatory=$true) ]
        [String] $File = "")
    process{
        $Shortcuts = Get-Content $File
        foreach ($sc in $Shortcuts){
            if ($sc[0] -eq "App"){
                New-AppShorcut -ASCName $sc[1] -ATarget $sc[2] -AArguments $sc[3] -AWorkingDir $sc[4] -
            }
        }
    }
}
#>

Switch ($DeviceAction){
    App { New-AppShorcut -ASCName $SCName -ATarget $Target -AArguments $Arguments -AWorkingDir $WorkingDir -AWinStyle $WinStyle -AHotKey $Hotkey -ADescript $Description }
    Web {New-AppShorcut -WURL $Target -WSCName $SCName -WIconLoc $IconLocation }
}





