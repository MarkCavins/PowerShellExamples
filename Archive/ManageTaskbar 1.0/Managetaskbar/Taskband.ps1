$arguments = "import $PSScriptRoot\TaskbandCU.reg"
Copy-Item -Path $PSScriptRoot\Quicklaunch\* -Destination $env:UserProfile'\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch' -Recurse -Force
Stop-Process -ProcessName explorer -Force