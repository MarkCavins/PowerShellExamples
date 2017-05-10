$name = (Get-Item env:\Computername).Value
$filepath = (Get-ChildItem env:\userprofile).value#### HTML Output Formatting #######

$a = "<style>"
$a = $a + "BODY{background-color:Lavender ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"

###############################################



#####

ConvertTo-Html -Head $a  -title "IE Settings for $name" -Body "<h1> Computer Name : $name </h1>" >  "$filepath\$name.html" 

#Local Users
Get-LocalUser | select Name,Description,Enabled | ConvertTo-html -Body "<H2> Current Local Users</H2>" >> "$filepath\$name.html" 


## Invoke Expressons

#invoke-Expression "$filepath\$name.html"

Get-Content "$filepath\$name.html"