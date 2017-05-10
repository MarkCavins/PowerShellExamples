Param (
  [String] $DeviceName = ""
)

Function Set-Name {
  Param ([cmdletbinding()]
    [string]$NewName = "")

  Process {
      Rename-Computer -NewName $NewName -Restart -ErrorAction Stop
  }
}

Set-Name -NewName $DeviceName