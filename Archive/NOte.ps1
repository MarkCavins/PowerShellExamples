
HKLM\Software\Policies\Microsoft\Windows\Explorer\StartPinAppsWhenInstalled
HKLM\Software\Policies\Microsoft\Windows\Explorer!StartPinAppsWhenInstalled

HKCU\Software\Policies\Microsoft\Windows\Explorer\StartPinAppsWhenInstalled
HKCU\Software\Policies\Microsoft\Windows\Explorer!StartPinAppsWhenInstalled 


HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer!RestrictRun 
HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun
#Block Control Panel
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -PropertyType DWORD -Value "0" | Out-Null
New-ItemProperty -Path "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoPinningToTaskbar" -PropertyType DWORD -Value "1" | Out-Null
New-ItemProperty -Path "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisallowRun" -PropertyType DWORD -Value "1" | Out-Null
#New-ItemProperty -Path "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "DisallowRun" -PropertyType * -Value "DELETEALLVALUES" | Out-Null
New-ItemProperty -Path "HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "1" -PropertyType SZ -Value "explorer.exe"c | Out-Null


HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System!DisableTaskMgr



Windows Registry Editor Version 5.00

[HKEY_USERS\S-1-5-21-1782198603-2829040579-3784375565-1001\SOFTWARE\Policies\Microsoft\Windows\Explorer\StartPinAppsWhenInstalled]
"1"="MobileIron.AppsAtWork_ekps40mpcpkay!App"
"2"="Microsoft.Windows.RemoteDesktop"


%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar

<#

function New-DesktopShorcut {
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\IExplorer.lnk")
$ShortCut.TargetPath="C:\Program Files (x86)\Internet Explorer\iexplore.exe"
#$ShortCut.Arguments=""
$ShortCut.WorkingDirectory = "C:\Program Files (x86)\Internet Explorer\";
$ShortCut.WindowStyle = 1;
$ShortCut.Hotkey = "CTRL+SHIFT+I";
$ShortCut.IconLocation = "iexplore.exe, 0";
$ShortCut.Description = "Your Custom Shortcut Description";

$ShortCut.Save()
}
New-DesktopShorcut



$TargetFile = "$env:SystemRoot\System32\notepad.exe"
    $ShortcutFile = "$env:Public\Desktop\Notepad.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()

#>