Set-Location C:\Temp

Invoke-Expression "curl.exe -k -s 'https://next-services.apps.microsoft.com/browse/6.3.9600-0/776/en-US_en-US.en.cs/c/US/cp/10005001/Apps/add3d66a-358d-4fe2-be68-8a3f934e9ea1' > out.html"

Get-Content "C:\temp\out.html"