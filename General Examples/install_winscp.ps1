Set-Location C:\Temp
Invoke-Expression "curl.exe -O --insecure https://s3-us-west-2.amazonaws.com/bridges/winscp577setup.exe"
Invoke-Expression "& 'C:\Temp\winscp577setup.exe' /VERYSILENT"
