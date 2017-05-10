echo 'hello from PS';get-date; get-culture;

$hklm64 = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, 
                                                     [Microsoft.Win32.RegistryView]::Registry64);
$key = $hklm64.CreateSubKey("Software\MobileIron");

$keyNames = $key.GetValueNames() | sort;

$timeValue =  Get-Date -format F
$key.SetValue("Setting3", $timeValue, [Microsoft.Win32.RegistryValueKind]::String);

#$key.SetValue("Setting4", $timeValue, [Microsoft.Win32.RegistryValueKind]::String);
#$key.DeleteValue("Setting4");

foreach ($keyName in $keyNames) {
   $value = $key.GetValue($keyName);
   "$keyName => $value";
}
