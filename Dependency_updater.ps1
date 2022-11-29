###########################
#Checking for Nmap updates#
###########################

$HTML = Invoke-WebRequest "https://nmap.org/download#windows"
$HTML = $HTML.Links | Select href
$HTML = $HTML -match "setup.exe"
$HTML = $HTML.href

