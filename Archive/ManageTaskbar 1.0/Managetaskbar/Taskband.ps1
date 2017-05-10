$arguments = "import $PSScriptRoot\TaskbandCU.reg"start-Process $env:windir\System32\reg.exe -ArgumentList $arguments -WindowStyle Hidden
Copy-Item -Path $PSScriptRoot\Quicklaunch\* -Destination $env:UserProfile'\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch' -Recurse -Force
Stop-Process -ProcessName explorer -Force
