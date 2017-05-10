Param(
    [string]$Action,
    [string]$User,
    [string]$fullName,
    [string]$Description
)

process {
    Switch ($Action)
    {
        Create {New-LocalAccount -LocalName $User -FullName $fullName -Description $Description}
        Disable { Disable-LocalAccount -LocalName $User }
        Enable { Enable-LocalAccount -LocalName $User }
        Delete { Remove-LocalAccount -LocalName $User }
    }


Function New-LocalAccount {
	[cmdletbinding()]
	Param (
		[string]$LocalName,
		[string]$Description,
		[string]$FullName
    	) 
	# End of Parameters

	Process {
		New-LocalUser -Name $LocalName -Description $Description -FullName $FullName -NoPassword
        Write-Host "Acount $localName has Been Create"
	}
}

function Disable-LocalAccount {
	[cmdletbinding()]
	Param (
		[string]$LocalName
	)
	
	Process {
		Disable-LocalUser -Name $LocalName
		Write-Host "Acount has Been Disabled"
	}
}


Function Enable-LocalAccount{
	[cmdletbinding()]
	Param (
		[string]$LocalName
	)
	
	Process {
		Enable-LocalUser -Name $LocalName
		Write-Host "Acount has Been Enabled"
	}
}


Function Remove-LocalAccount{
	[cmdletbinding()]
	Param (
		[string]$LocalName
	)
	
	Process {
		Remove-LocalUser -Name $LocalName
		Write-Host "Acount has Been Removed"
	}
}
}