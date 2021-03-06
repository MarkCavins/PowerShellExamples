
#Block Control Panel

New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoControlPanel' -PropertyType DWORD -Value '1' | Out-Null

New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPinningToTaskbar' -PropertyType DWORD -Value '1' | Out-Null

#Disallow  Apps
New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun'
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'DisallowRun' -PropertyType DWORD -Value '1' | Out-Null
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun' -Name '1' -PropertyType String -Value "explorer.exe" | Out-Null