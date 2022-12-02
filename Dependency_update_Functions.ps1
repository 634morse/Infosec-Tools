#################################################################
#Checking for Nmap updates
#This only Checks for updates and downloads the latest installer
#You will need to manually extract the files
#################################################################
$global:Nmap_Message = "Nmap is up to date"
function Nmap_update {
$ProgressPreference = 'SilentlyContinue'
$HTML = Invoke-WebRequest "https://nmap.org/download#windows"
$HTML = $HTML.Links | Select href
$HTML = $HTML -match "setup.exe"
$HTML = $HTML.href
$download_url = $HTML
$HTML = $HTML -split("-")
$Newest_Nmap_Release = $HTML[1]

$Nmap_properties = get-itemproperty ".\Dependencies\Nmap\nmap.exe"
$global:Current_Nmap_version = $Nmap_properties.versioninfo.fileversion

    If ($Current_Nmap_version -notmatch $Newest_Nmap_Release) {
        $global:Nmap_Update = $true
        $global:Nmap_Message = "##New version of Nmap Available - $Newest_Nmap_Release##"
        $global:Download_Nmap = Invoke-WebRequest -uri $download_url -outfile ".\Dependencies\Nmap.exe"
    }
    else {
        $global:Nmap_Update = $false 
    }
} 

function Available_Updates {
    $global:Available_Updates = "No available updates at this time"
    If ($Nmap_Update) {
        $global:Available_Updates = write-output "There are updates available for dependencies, please select U, to view them" 
    }
}



