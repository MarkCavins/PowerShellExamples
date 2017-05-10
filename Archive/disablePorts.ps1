#VZ Script
$UDPports = @(135,
		137,
		138,
		139,
		445)


#UDP Ports
function Disable-UDPPorts ($Ports){
	foreach ($port in $UDPports){
		New-NetFirewallRule -DisplayName "Disable Inbound UDP Port $($port)" -Profile Any -Protocol UDP -Enabled True -Action Block -RemotePort $port -Direction Inbound > $null
	}
}
#TCP Ports
$TCPports= @(135,
137,
138,
139,
445,
593,
1025,
1026,
5357)

Function Disable-TCPPorts ($Ports) {
	foreach ($port in $TCPports){
		New-NetFirewallRule -DisplayName "Disable Inbound TCP Port $($port)" -Profile Any -Protocol TCP -Enabled True -Action Block -RemotePort $port -Direction Inbound > $null
	}
}