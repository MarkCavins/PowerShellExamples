[string] $configMgrDomain = 'CORP.contoso.com'
[string] $domainUser = "$configMgrDomain\LabAdmin"
[string] $domainPassword = 'P@$$w0rd'

$secpasswd = ConvertTo-SecureString "$domainPassword" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$domainUser",$secpasswd)
Add-Computer -DomainName "$configMgrDomain" -Credential $credential -Confirm:$false -PassThru -Verbose
Start-Sleep -Seconds 1
Set-NetFirewallRule -Name 'FPS-SMB-In-TCP' -Enabled True -Profile Domain
shutdown -r -t 300 -c "System rebooting in 5 minutes for domain join.  Please save your work."
