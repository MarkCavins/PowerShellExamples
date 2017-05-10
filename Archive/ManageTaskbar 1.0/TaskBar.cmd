reg load "hku\Default" "C:\USers\Default\NTUSER.DAT"
reg import %~dp0taskbar.reg
xcopy %~dp0Managetaskbar "C:\Windows\ManageTaskBar" /e /s /y /h /i
reg unload "hku\default"
