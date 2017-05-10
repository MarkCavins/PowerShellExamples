# Set up additional registry drives:
New-PSDrive -Name HKCU -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null


#Disable changing home page setting

Function Disable-IEHomeLM {
	if (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'){
		if(Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel'){
			Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -Value '1' | Out-Null
		}
		else{
			New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel'
			New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -PropertyType DWORD -Value '1' | Out-Null
		}

	}
	else{
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -PropertyType DWORD -Value '1' | Out-Null

		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main' -Name 'Start Page' -PropertyType String -Value 'google.com' | Out-Null
	}

}

#Enable changing home page setting

Function Enable-IEHomeLM {
	Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -Value '0'
}

Function POPUP-AllowListLM ($URL) {
	#Add sites for which pop-ups are allowed Local Machine
	if (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'){
		if (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows'){
			Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows' -Name ListBox_Support_Allow  -Value '1' | Out-Null
		}
		else {
			New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows'
			New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows' -Name ListBox_Support_Allow -PropertyType DWORD -Value '1' | Out-Null
		}

		if (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow'){
			New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name $url -PropertyType String -Value $url | Out-Null 
		}
		else{
			New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow'
			New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name $url -PropertyType String -Value $url | Out-Null 
		}
	}
	else {
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows' -Name ListBox_Support_Allow -PropertyType DWORD -Value '1' | Out-Null
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name $url -PropertyType String -Value $url | Out-Null 
	}
}


#Remove sites for which pop-ups are allowed

Function RMPOPUP-AllowListLM ($url) {
	Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name $url
}

#Disable pop-ups not explicitly allowed
function Unrestrict-PopupExceptLM{
	Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -Value '0' | Out-Null
}


#Enable pop-ups not explicitly allowed
function Restrict-PopupExceptLM {
	if (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'){
		If (Test-Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions'){
			Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -Value '1' | Out-Null		
		}
		else {
			New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions'
			New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -PropertyType DWORD -Value '1' | Out-Null
		}
	}
	else{
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer'
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -PropertyType DWORD -Value '1' | Out-Null
	}

	
}

Disable-IEHomeLM
POPUP-AllowListLM -URL "*.mobileiron.com"
POPUP-AllowListLM -URL "*.google.com"
POPUP-AllowListLM -URL "*.yahoo.com"

