Set-Location C:\Temp
Invoke-Expression "curl.exe -O --insecure https://s3-us-west-2.amazonaws.com/bridges/BrowsingHistoryView.exe"

Invoke-Expression "C:\Temp\BrowsingHistoryView.exe /HistorySource 1 /sverhtml bhv.html"

Get-Content "C:\Temp\bhv.html"