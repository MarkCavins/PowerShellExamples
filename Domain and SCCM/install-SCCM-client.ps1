[string] $taskName = 'InstallSCCMClient'
[string] $taskCommand = "$pshome\powershell.exe"
[string] $taskLogFile = "%TEMP%\$taskName.log"
[string] $configMgrDomain = 'CORP.contoso.com'
[string] $configMgrHost = 'CM1'
[string] $configMgrSiteCode = 'CHQ'
[string] $domainUser = "$configMgrDomain\LabAdmin"
[string] $domainPassword = 'P@$$w0rd'

[string] $installClientScript = @"
& \\$configMgrHost.$configMgrDomain\SMS_$configMgrSiteCode\Client\CCMSetup.exe /noservice /logon
"@

$scriptText = '&{' + $installClientScript + '}'
$scriptBytes = [System.Text.Encoding]::Unicode.GetBytes($scriptText)
$encodedScript = [Convert]::ToBase64String($scriptBytes)
$taskArg = "-NonInteractive -WindowStyle Hidden -Command ""$taskCommand -EncodedCommand $encodedScript"" >> $taskLogFile 2>&1"
$taskAction = New-ScheduledTaskAction -Execute Powershell -Argument "$taskArg"
Unregister-ScheduledTask -TaskName "$taskName" -Confirm:$false -ErrorAction Ignore
Write-Host "Registering task $taskName"
Register-ScheduledTask -TaskName "$taskName" -User "$domainUser" -Password "$domainPassword" -Action $taskAction -RunLevel HIGHEST | Out-Null
Write-Host "Running task $taskName"
Start-ScheduledTask "$taskName"
Write-Host "Waiting for task $taskName to complete"
[int] $timeSpent = 0
[int] $taskTimeout = 30
for ($i = 0; ((Get-ScheduledTask $taskName).state -ne 'Ready') -and ($i -lt $taskTimeout); $i++) {
    $timeSpent++;
    Start-Sleep -Seconds 1;
}
Write-Host "Task $taskName completed in $timeSpent seconds"

