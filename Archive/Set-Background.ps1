param(
    [String] $PathToFile = "",
    [String] $WPStyle = "4")
# Set up additional registry drives:
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null


#Disable changing home page setting
Function Set-WallPaper {
    param ( [String] $Image = "",
            [String] $Style = "",
            [String] $SID = "")

    process {
        
        Set-ItemProperty -Path "HKU:\$($SID)\Control Panel\Desktop" -Name Wallpaper -Value $Image
        rundll32.exe user32.dll, UpdatePerUserSystemParameters

    }
}

$EnabledUser = Get-localUser | where {$_.Enabled -eq $true}

Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Set-WallPaper -SID $_.SID.Value -Image $PathToFile -Style $WPStyle }