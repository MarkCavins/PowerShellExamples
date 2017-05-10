function Speak-Text
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$text
    )

    Begin
    {
        $speaker = New-Object -com SAPI.SpVoice
    }
    Process
    {
        $speaker.Speak($text)
    }
    End
    {
        #$speaker.Dispose()
    }
}

Speak-Text "Hello World!"
#Start-Sleep 1
Speak-Text "Hello MobileIron"



# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
# -command "& 'C:\Scripts\s_Restart-WiFi.ps1'