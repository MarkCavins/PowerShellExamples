#VZ Script
#UDP Ports
$UDPports = @(135,
		137,
		138,
		139,
		445)

foreach ($port in $UDPports){
	New-NetFirewallRule -DisplayName "Disable Inbound UDP Port $($port)" -Profile Any -Protocol UDP -Enabled True -Action Block -RemotePort $port -Direction Inbound > $null
}

#TCP Ports
$TCPports= @(135,
137,
138,
139,
445,
593,
1025,
1026,
5357)

foreach ($port in $TCPports){
	New-NetFirewallRule -DisplayName "Disable Inbound TCP Port $($port)" -Profile Any -Protocol TCP -Enabled True -Action Block -RemotePort $port -Direction Inbound > $null
}

#Applications
$Apps = @("9E2F88E3.Twitter".
"king.com.CandyCrushSodaSaga"
"Microsoft.3DBuilder",
"Microsoft.BingFinance",
"Microsoft.BingNews",
"Microsoft.BingSports",
"Microsoft.BingWeather",
"Microsoft.CommsPhone",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.Office.OneNote",
"Microsoft.Office.Sway",
"Microsoft.People",
"Microsoft.SkypeApp",
"Microsoft.Windows.Cortana",
"Microsoft.Windows.Photos",
"Microsoft.WindowsPhone",
"Microsoft.XboxApp",
"Microsoft.XboxGameCallableUI",
"Microsoft.XboxIdentityProvider",
"Microsoft.ZuneMusic",
"Microsoft.ZuneVideo")
$installed = Get-AppxPackage
foreach( $ins in $installed){
Foreach ($app in $Apps){
    if( $ins.Name -eq $app){
	Write-Host "$($app)..." -ForegroundColor Yellow
           #Remove-AppxProvisionedPackage -Online -PackageName $ins.PackageName | Out-Null
            Remove-AppxPackage -Package $ins.PackageFullName | Out-Null
    }
}
}

#Block Control Panel

New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoControlPanel' -PropertyType DWORD -Value '1' | Out-Null

New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPinningToTaskbar' -PropertyType DWORD -Value '1' | Out-Null

#Disallow  Apps
New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun'
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'DisallowRun' -PropertyType DWORD -Value '1' | Out-Null
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun' -Name '1' -PropertyType String -Value "explorer.exe" | Out-Null

# Disable Cortana:
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' | Out-Null