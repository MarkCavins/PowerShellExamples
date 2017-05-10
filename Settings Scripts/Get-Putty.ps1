$url = "https://the.earth.li/~sgtatham/putty/latest/x86/putty.exe"
$output = "$PSScriptRoot\putty.exe"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"