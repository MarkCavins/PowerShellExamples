
param(
    [String] $DeviceAction = ""
)

function Set-ChromeHome {
    param(
        [String] $HomeURL)
    process{
        if ( Test-Path -Path 'HKLM:\Software\Policies\Google' ){
            if ( Test-Path -Path 'HKLM:\Software\Policies\Google\Chrome' ) {
                New-Item -Path 'HKLM:\Software\Policies\Google\Chrome' -Name 'HomepageLocation'
                New-ItemProperty -Path 'HKLM:\Software\Policies\Google\Chrome\HomepageLocation' -Name 'HomepageLocation' -PropertyType String -Value 'mobileiron.com' | Out-Null
            }
            else {
                New-Item -Path 'HKLM:\Software\Policies\Google' -Name 'Chrome' 
                New-Item -Path 'HKLM:\Software\Policies\Google\Chrome' -Name 'HomepageLocation' 
                New-ItemProperty -Path 'HKLM:\Software\Policies\Google\Chrome\HomepageLocation' -Name 'HomepageLocation' -PropertyType String -Value $HomeURL | Out-Null

            }
        }
        else {
            New-Item -Path 'HKLM:\Software\Policies' -Name 'Google'
            New-Item -Path 'HKLM:\Software\Policies\Google' -Name 'Chrome' 
            New-Item -Path 'HKLM:\Software\Policies\Google\Chrome' -Name 'HomepageLocation'
            New-ItemProperty -Path 'HKLM:\Software\Policies\Google\Chrome\HomepageLocation' -Name 'HomepageLocation' -PropertyType String -Value $HomeURL | Out-Null


            New-Item -Path 'HKLM:\Software\Policies' -Name 'Google'
            New-Item -Path 'HKLM:\Software\Policies\Google' -Name 'Chrome' 
          New-Item -Path 'HKLM:\Software\Policies\Google\Chrome' -Name 'HomepageIsNewTabPage'
           New-ItemProperty -Path HKLM:\Software\Policies\Google\Chrome\HomepageIsNewTabPage -Name 'HomepageIsNewTabPage' -PropertyType String -Value '1' | Out-Null
        }
    }
}
Function Enable-AllowList {
    param ([String] $SID = "",
        [String] $URL = "" )
    process {
        Write-Host $SID
        $Urls = Get-Content $URL
        #Add sites for which pop-ups are allowed Local Machine
        if (Test-Path "HKLM:\Software\Policies\Google"){
            if (Test-Path "HKLM:\Software\Policies\Google\Chrome"){
                Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows" -Name ListBox_Support_Allow  -Value "1" | Out-Null
            }
            else {
                New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows"
                New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows" -Name ListBox_Support_Allow -PropertyType DWORD -Value "1" | Out-Null
            }
            foreach ($aurl in $URls) {
                if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow"){
                    New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow" -Name $aurl -PropertyType String -Value $aurl | Out-Null 
                }
                else{
                    New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow"
                    New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow" -Name $aurl -PropertyType String -Value $aurl | Out-Null 
                }
            }
        }
        else {
            New-Item -Path "HKU:\$SID\Software\Policies\Microsoft\Internet Explorer"
            New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows"
            New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows" -Name ListBox_Support_Allow -PropertyType DWORD -Value "1" | Out-Null
            New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow"
            foreach ($aurl in $URls) {
            New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow" -Name $aurl -PropertyType String -Value $aurl | Out-Null 
            }
        }
    }
}
    #Software\Policies\Google\Chrome\PopupsAllowedForUrls
    #New-ItemProperty -Path 'HKLM:\Software\Policies\Google\Chrome\PopupsAllowedForUrls' -Name PopupsAllowedForUrls -PropertyType String -Value $uri

Set-ChromeHome -HomeURL mobileiron.com