$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Gmail.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
$Shortcut.Arguments = "--profile-directory=Default --app-id=pjkljhegncpnkpknbcohdijeoejaedia"
$Shortcut.IconLocation = "https://s3-us-west-2.amazonaws.com/bridges/Gmail.ico"
$Shortcut.WorkingDirectory = "C:\Program Files (x86)\Google\Chrome\Application"
$Shortcut.WindowStyle = 3
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Google Docs.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
$Shortcut.Arguments = "--profile-directory=Default --app-id=aohghmighlieiainnegkcijnfilokake"
$Shortcut.IconLocation = "https://s3-us-west-2.amazonaws.com/bridges/Google+Docs.ico"
$Shortcut.WorkingDirectory = "C:\Program Files (x86)\Google\Chrome\Application"
$Shortcut.WindowStyle = 3
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Google Drive.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
$Shortcut.Arguments = "--profile-directory=Default --app-id=apdfllckaahabafndbhieahigkjlhalf"
$Shortcut.IconLocation = "https://s3-us-west-2.amazonaws.com/bridges/Google+Drive.ico"
$Shortcut.WorkingDirectory = "C:\Program Files (x86)\Google\Chrome\Application"
$Shortcut.WindowStyle = 3
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\MobileIron.lnk")
$Shortcut.TargetPath = "https://mfc16.mobileironevents.com/"
$Shortcut.IconLocation = "https://www.mobileiron.com/sites/default/files/favicon.ico"
$Shortcut.WorkingDirectory = "C:\Temp"
$Shortcut.WindowStyle = 7
$Shortcut.Save()


Set-Location C:\Temp
Invoke-Expression "curl.exe -O --insecure https://s3-us-west-2.amazonaws.com/bridges/Set-Wallpaper.ps1"
Invoke-Expression "curl.exe -O --insecure https://s3-us-west-2.amazonaws.com/bridges/european_architecture-wallpaper-2400x1350.jpg"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\tmather\Desktop\SetWallpaper.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-Command `"C:\Temp\Set-Wallpaper.ps1`""
$Shortcut.IconLocation = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.WorkingDirectory = "C:\Temp"
$Shortcut.WindowStyle = 7
$Shortcut.Save()

Set-Location C:\Temp
Invoke-Expression "curl.exe -O --insecure https://s3-us-west-2.amazonaws.com/bridges/hello.ps1"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Hello.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-Command `"C:\Temp\hello.ps1`""
$Shortcut.IconLocation = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.WorkingDirectory = "C:\Temp"
$Shortcut.WindowStyle = 7
$Shortcut.Save()
