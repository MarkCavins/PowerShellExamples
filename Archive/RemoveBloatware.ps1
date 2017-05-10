$name = (Get-Item env:\Computername).Value
$filepath = (Get-ChildItem env:\userprofile).value

#### HTML Output Formatting #######

$a = "<style>"
$a = $a + "BODY{background-color:Lavender ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"

###############################################




#Applications
$Apps = @("9E2F88E3.Twitter".
"king.com.CandyCrushSodaSaga"
"Microsoft.3DBuilder",
"Microsoft.BingFinance",
"Microsoft.BingNews",
"Microsoft.BingSports",
"Microsoft.BingWeather",
"Microsoft.CommsPhone",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.Office.OneNote",
"Microsoft.Office.Sway",
"Microsoft.People",
"Microsoft.SkypeApp",
"Microsoft.Windows.Cortana",
"Microsoft.Windows.Photos",
"Microsoft.WindowsPhone",
"Microsoft.XboxApp",
"Microsoft.XboxGameCallableUI",
"Microsoft.XboxIdentityProvider",
"Microsoft.ZuneMusic",
"Microsoft.ZuneVideo")
$installed = Get-AppxPackage

ConvertTo-Html -Head $a  -title "Applications on $name" -Body "<h1> Computer Name : $name </h1>" >  "$filepath\$name.html" 

ConvertTo-Html -Body "<table>
						<tr>
							<th>App Name</th>
							<th>Status</th>
						</tr>" >> $filepath\$name.html" 

foreach( $ins in $installed){
	Foreach ($app in $Apps){
    	if( $ins.Name -eq $app){
			Write-Host "$($app)..." -ForegroundColor Yellow
           #Remove-AppxProvisionedPackage -Online -PackageName $ins.PackageName | Out-Null
            Remove-AppxPackage -Package $ins.PackageFullName | Out-Null
            ConvertTo-Html -Body "<tr>
            						<td>$ins.PackageFullName</td>
            						<td>Status</td>
        						</tr>" >> $filepath\$name.html" 

    	}
	}
}
ConvertTo-Html -Body "</table" >> $filepath\$name.html" 

## Invoke Expressons

#invoke-Expression "$filepath\$name.html"

Get-Content "$filepath\$name.html"
