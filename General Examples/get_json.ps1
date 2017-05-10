Set-Location C:\Temp

Invoke-Expression "curl.exe -k -H 'MS-Contract-Version: 4' -H 'User-Agent: WindowsStore/2016.29.13.0' -s 'https://storeedgefd.dsx.mp.microsoft.com/pages/search?appversion=2016.29.13.0&market=US&locale=en-US&deviceType=&deviceFamily=windows.desktop&catalogLocales=en-US&musicMarket=US&screenSize=L&hardware=ble%2Ccmr%2Cdx9%2Cdxa%2Cdxb%2Ckbd%2Cm30%2Cm75%2CmA0%2Cmse%2CmT0&packageHardware=dx9%2Cdxa%2Cdxb%2Cm30%2Cm75%2CmA0%2CmT0&deviceFamilyVersion=2814750702896104&architecture=x64&oemId=LENOVO&scmId=Public&moId=Public&query=Twitter&navItemId=home' > out.html"

Get-Content "C:\temp\out.html"