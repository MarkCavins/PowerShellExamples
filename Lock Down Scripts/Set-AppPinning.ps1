# Set up additional registry drives:
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null


#Disable changing home page setting
Function Disable-Pinning {
    param ([String] $SID )
    process {
        if ( Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" ) {
            Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToDestinations" -Value "1" | Out-Null
            Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToTaskbar" -Value "1" | Out-Null
            Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningStoreToTaskbar" -Value "1" | Out-Null
        }
        else {
            New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer"
            New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToDestinations" -PropertyType DWORD -Value "1" | Out-Null
            New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToTaskbar" -PropertyType DWORD -Value "1" | Out-Null
            New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningStoreToTaskbar" -PropertyType DWORD -Value "1" | Out-Null
        }
    }
}
Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-Pinning -SID $_.SID.Value } }