$url = "https://s3-us-west-2.amazonaws.com/bridges/nircmd.exe"
$output = "$PSScriptRoot\nircmd.exe"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"