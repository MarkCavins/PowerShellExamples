param (
	[String] $DeviceAction = " ",
	[String] $PathToFile = "c:\temp\",
	[String] $HomeURL = "google.com" ,
	[String] $PopURL = "google.com"
	)

# Set up additional registry drives:

New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null



#Disable changing home page setting
Function Disable-IEHome {
	param ( [String] $SID = "",
		[String] $URL = "google.com")
	process {
		if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"){
			if(Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel"){
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Name "HomePage" -Value "1" | Out-Null

				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Main"
				New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Internet Explorer\Main" -Name "Start Page" -PropertyType String -Value $URL | Out-Null
			}
			else{
				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel"
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Name "HomePage" -PropertyType DWORD -Value "1" | Out-Null
			
				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Main"
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Main" -Name "Start Page" -PropertyType String -Value $URL | Out-Null
			}
		}	
		else{
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel"
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Name "HomePage" -PropertyType DWORD -Value "1" | Out-Null
		
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Main"			
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Main" -Name "Start Page" -PropertyType String -Value $URL | Out-Null
		}
	}
}
#Enable changing home page setting
Function Enable-IEHome {
	param ([String] $SID )
	process {
		Set-ItemProperty -Path "HKU:\$($SID)\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel" -Name "HomePage" -Value "0"
	}
}
#Add URLS to POPUP list
Function Enable-AllowList {
	param ([String] $SID = "",
		[String] $URL = "" )
	process {
        Write-Host $SID
        $Urls = Get-Content $URL
		#Add sites for which pop-ups are allowed Local Machine
		if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"){
			if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows"){
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
#Remove sites for which pop-ups are allowed
Function Remove-AllowList {
	param ([String] $SID = "",
		[String] $URL = "" )
	process {
	Remove-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow" -Name $URL
	}
}
#Disable pop-ups not explicitly allowed
function Unrestrict-PopupExcept{
	param ([String] $SID )
	process {
		Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name RestrictPopupExceptionList -Value "0" | Out-Null
	}
}
#Enable pop-ups not explicitly allowed
function Restrict-PopupExcept {
	param ([String] $SID )
	process {
		if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"){
			If (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"){
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name RestrictPopupExceptionList -Value "1" | Out-Null		
			}
			else {
				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name RestrictPopupExceptionList -PropertyType DWORD -Value "1" | Out-Null
			}
		}
		else{
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name RestrictPopupExceptionList -PropertyType DWORD -Value "1" | Out-Null
		}
	}
}
#Enable Save-as options
Function Enable-SaveAS{
	param ([String] $SID )

	Process {
		if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"){
			If (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"){
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -Value "0" | Out-Null
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir   -Value "0" | Out-Null					
			}
			else {
				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -PropertyType DWORD -Value "0" | Out-Null
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir -PropertyType DWORD -Value "0" | Out-Null			
			}
		}
		else{
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -PropertyType DWORD -Value "0" | Out-Null
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir -PropertyType DWORD -Value "0" | Out-Null
		}
	}
}
#Disable Save-as options
Function Disable-SaveAS{
	param ([String] $SID )

	Process {
		if (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"){
			If (Test-Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"){
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -Value "1" | Out-Null
				Set-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir   -Value "1" | Out-Null					
			}
			else {
				New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -PropertyType DWORD -Value "1" | Out-Null
				New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir -PropertyType DWORD -Value "1" | Out-Null			
			}
		}
		else{
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer"
			New-Item -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions"
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoBrowserSaveAs  -PropertyType DWORD -Value "1" | Out-Null
			New-ItemProperty -Path "HKU:\$($SID)\Software\Policies\Microsoft\Internet Explorer\Restrictions" -Name NoSelectDownloadDir -PropertyType DWORD -Value "1" | Out-Null
		}
	}
}
$EnabledUser = Get-localUser | where {$_.Enabled -eq $true}
Switch ($DeviceAction) {
	DIEHome { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-IEHome -SID $_.SID.Value -URL $HomeURL } }
	EIEHome { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Enable-IEHome -SID $_.SID.Value } }
	EPopUp { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Enable-AllowList -SID $_.SID.Value -URL $PathToFile } }
	RMPopup { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Remove-AllowList -SID $_.SID.Value -URL $PopURL } }
	Unrest { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Unrestrict-PopupExcept -SID $_.SID.Value } }
	Restrict { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Restrict-PopupExcept -SID $_.SID.Value } }
	ESave { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object {Enable-SaveAS -SID $_.SID.Value } }
	DSave { Get-localUser | where {$_.Enabled -eq $true} | ForEach-Object { Disable-SaveAS -SID $_.SID.Value } }
}