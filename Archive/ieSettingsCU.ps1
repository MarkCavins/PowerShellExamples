
Function Disable-IEHomeCU{
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer'
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -PropertyType DWORD -Value '1' | Out-Null

	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name 'Start Page' -PropertyType String -Value 'google.com' | Out-Null


}

Function Enable-IEHomeCU{
	Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'HomePage' -Value '0'
}

Function POPUP-AllowListCU{
	#Add sites for which pop-ups are allowed Current User
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer'
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\New Windows'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\New Windows' -Name ListBox_Support_Allow -PropertyType DWORD -Value '1' | Out-Null
	New-Item -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name google.com -PropertyType String -Value 'google.com' | Out-Null
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name mobileiron.com -PropertyType String -Value 'Mobileiron.com' | Out-Null
}


Function POPUP-AllowListCU ($Property) {
	Remove-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\New Windows\Allow' -Name google.com
}

function Unrestrict-PopupExceptCU{
	Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -Value '0' | Out-Null
}

function Restrict-PopupExceptCU {
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -PropertyType DWORD -Value '1' | Out-Null
}

#Disable Save-as options
function Disable-SaveAs {
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer'
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name NoSelectDownloadDir -PropertyType DWORD -Value '1' | Out-Null

	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Infodelivery'
	New-Item -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions'
	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions'-Name NoBrowserSaveWebComplete -PropertyType DWORD -Value '1' | Out-Null

	New-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name NoBrowserSaveAs -PropertyType DWORD -Value '1' | Out-Null
}

#Enable Save-as options
Function Enable-SaveAS{
	Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name NoBrowserSaveAs -Value '0' | Out-Null
	Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name NoSelectDownloadDir -Value '0' | Out-Null
	Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Restrictions' -Name RestrictPopupExceptionList -Value '0' | Out-Null
}