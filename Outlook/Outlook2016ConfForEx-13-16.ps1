##### Example Configuration Script for Outlook 2016 #####

### This is the workround for connecting to Exchange 2016/2013 mentioned in
### http://www.mistercloudtech.com/2015/12/08/how-to-resolve-slow-office-2016-autodiscover-with-office-365/   

# Input sId, this sId will be filled by MI Bridge
param(
	[String] $mdmUserSid
)

# Set the registry for AutoDiscover settings, this should be executed after Outlook 2016 installation

$registryPath = "Registry::HKU\$mdmUserSid\Software\Microsoft\Office\16.0\Outlook\AutoDiscover"
$Name = "ExcludeHttpsRootDomain"
$value = "1"

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD  -Force | Out-Null 

echo "OutLook2016 Configuration script complete"