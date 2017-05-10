# title: AddOrRemoveLocalNetworkPrinter
# author: Eric Pomerleau
#
# Installs or Uninstalls a local network printer using a specified driver name, 
# printer IP address/hostname, and name for the printer in Windows
#

# FIXME: Using parameters passed on the command line via Core doesn't seem to work -
# investigate as possible Core bug.  In the meantime, the printer name, IP etc...
# will have to be hard-coded in the main function, and separate scripts will have
# to be deployed for installation and uninstallation (set $action to "install" in
# one script, and "uninstall" in the other script).
 
#param(
#    [Parameter(Mandatory=$true)][string]$action,
#    [string]$printerName,
#    [string]$hostAddress,
#    [string]$driverName
#    )

#Write-Host "The printer name is: $printerName"
#Write-Host "Port name is: ${printerName}_port"


#######################################################################################
function InstallLocalNetworkPrinter ($printerName, $portName, $hostAddress, $driverName) {
  Add-PrinterDriver $driverName
  Add-PrinterPort -name $portName -PrinterHostAddress $hostAddress
  Add-Printer -name $printerName -DriverName $driverName -port $portName
}


#######################################################################################
function UninstallLocalNetworkPrinter($printerName, $portName) {
  Remove-Printer $printerName
  Remove-PrinterPort "$portName"
}

#######################################################################################
# Sets some default settings for the installed printer
#
#######################################################################################
function SetPrinterConfiguration($printerName) {
  $configCollate = $FALSE
  $configColor = $TRUE
  $configDuplexingMode = "OneSided"  #Options - "OneSided", "TwoSidedLongEdge", "TwoSidedShortEdge"
  $configPaperSize = "A4"

  Write-Host "Parameters: $paramCollate $paramColor -PaperSize $configPaperSize -DuplexingMode $configDuplexingMode"
  Set-PrintConfiguration -PrinterName $printerName -Collate $configCollate -Color $configColor -PaperSize $configPaperSize -DuplexingMode $configDuplexingMode
}

  
#######################################################################################
$action = "uninstall"
$printerName = "Ricoh Test Printer 1"
$hostAddress = "172.16.0.93"
$driverName = "RICOH Class Driver"


if ($action.ToLower().Equals("install")) {
  InstallLocalNetworkPrinter -printerName $printerName -portName "${printerName}_port" -hostAddress $hostAddress -driverName $driverName
  SetPrinterConfiguration -printerName $printerName
} elseif ($action.ToLower().Equals("uninstall")) {
  UninstallLocalNetworkPrinter -printerName $printerName -portName "${printerName}_port"
} else {
  Write-Host "Unknown Action - aborting..."
}
