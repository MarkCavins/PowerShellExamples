Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, Publisher, InstallDate > C:\temp\InstalledPrograms-PS.txt

Get-Content C:\temp\InstalledPrograms-PS.txt
