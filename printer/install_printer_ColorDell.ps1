#Invoke-Expression "& 'C:\Windows\Sysnative\pnputil.exe' /delete-driver oem2.inf"
Invoke-Expression "& 'C:\Windows\Sysnative\pnputil.exe' -i -a C:\Temp\drivers\1320c_DRV_ENG_01-01-06-00_01-01-06-00\English\Drivers\Win_x64\dlhsnzi.inf"
Invoke-Expression "& 'C:\Windows\Sysnative\pnputil.exe' /enum-drivers"

add-printerdriver "Dell Color Laser 1320c"
get-printerdriver

add-printerport -name "ToColor" -printerhostaddress "10.50.50.50"
get-printerport

add-printer -name "ColorDell" -drivername "Dell Color Laser 1320c" -port "ToColor"
get-printer
