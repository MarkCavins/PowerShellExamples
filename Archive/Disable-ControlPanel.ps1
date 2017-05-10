Param (
[String] $UserAcc
)

# Set up additional registry drives:
Try {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null -ErrorAction Continue
}
Catch { Continue }

Function Get-EnabledUsers {
    Process {
        $LocalUsers = Get-LocalUser
        Try {
            #This Creates an array object to store the Values for the Next Call
            $objs = @()

            #THis loop will go through all the Results
            foreach ($rpt in $LocalUsers) {
                if ( $rpt.Enabled){
                    #Stores the Device kes and values to the Object array
                    $obj = New-Object PSObject
                    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $rpt.name
                    Add-Member -InputObject $obj -MemberType NoteProperty -Name SID -Value $rpt.SID.Value
                    Add-Member -InputObject $obj -MemberType NoteProperty -Name Enabled -Value $rpt.Enabled
                    $objs += $obj
                }
            }
         }
        Catch {
            Write-Host "Error: $($_.Exception)"
        }
        Return $objs      
    }
}

Function Disable-Control {
    param ( [String] $User = "")

    process {
    $account = Get-LocalUser -Name $User
    $SID = $account.SID
        if ( Test-Path -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer){
            Set-ItemProperty -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name 'NoControlPanel' -Value '1' | Out-Null
            set-ItemProperty -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name 'NoPinningToTaskbar'  -Value '1' | Out-Null
        }
        else{
            New-Item -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
            New-ItemProperty -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name 'NoControlPanel' -PropertyType DWORD -Value '1' | Out-Null
            New-ItemProperty -Path HKU:\$($SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name 'NoPinningToTaskbar' -PropertyType DWORD -Value '1' | Out-Null
        }
    }
}

Disable-Control -User $UserAcc