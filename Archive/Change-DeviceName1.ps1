[cmdletbinding()]
Param(
    [string]$Action,
    [string]$Name
    )

process {
    Switch ($Action)
    {
        Get { Get-DeviceName }
        Set { Set-DeviceName -Name $Name}       
    }

	Function Get-DeviceName {
		Process {
			$ThisComputer = Get-WMIObject Win32_ComputerSystem | Select-Object -ExpandProperty name
			Write-Host $ThisComputer 
			return $ThisComputer
		} # End of Process
	}

	Function Set-DeviceName {
		Param (
			[string]$Name
		) 
		Process {
			$ComputerName = Get-DeviceName
			$computerName.Rename($Name)
			#Rename-Computer -NewName $Name -Restart
		
			Host "$([char]1) Computer Name is changed to `"$name`", I am Going to Reboot Laptop after 5 seconds."  -ForegroundColor Green 
			write-host $([char]7) 
			sleep 1 
			write-host $([char]7) 
			sleep 1  
			write-host $([char]7) 
			sleep 1 
			write-host $([char]7) 
			sleep 1 
			write-host $([char]7) 
			sleep 1 
			Restart-Computer -Force  
		}
	}
}