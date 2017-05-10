param (
	[String] $DeviceAction = "New"
	)
Function Set-NewAssoc {
	if (Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' ) {
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DefaultAssociationsConfiguration' -PropertyType String -Value 'C:\temp\AppAssocSet.txt' | Out-Null
	}
	else {
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Name 'System'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DefaultAssociationsConfiguration' -PropertyType String -Value 'C:\temp\AppAssocSet.txt' | Out-Null

	}
}


Function Set-DefaultAssoc {
	if (Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' ) {
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DefaultAssociationsConfiguration' -PropertyType String -Value 'C:\temp\AppAssocRestore.txt' | Out-Null
	}
	else {
		New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows\System'
		New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DefaultAssociationsConfiguration' -PropertyType String -Value 'C:\temp\AppAssocRestore.txt' | Out-Null

	}
}

Switch ($DeviceAction) {
	New { Set-NewAssoc }
	Default { Set-DefaultAssoc }
}