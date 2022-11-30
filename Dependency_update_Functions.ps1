#################################################################
#Checking for Nmap updates
#This only Checks for updates and downloads the latest installer
#You will need to manually extract the files
#################################################################
function Nmap_updater {
$HTML = Invoke-WebRequest "https://nmap.org/download#windows"
$HTML = $HTML.Links | Select href
$HTML = $HTML -match "setup.exe"
$HTML = $HTML.href
$download_url = $HTML
$HTML = $HTML -split("-")
$Newest_Nmap_Release = $HTML[1]

$Nmap_properties = get-itemproperty ".\Dependencies\Nmap\nmap.exe"
$Current_Nmap_version = $Nmap_properties.versioninfo.fileversion

    If ($Current_Nmap_version -notmatch $Newest_Nmap_Release) {
        $Nmap_Update = $true
        $Nmap_Message = "There is a newer version of Nmap Available
        Downloading Nmap $Newest_Nmap_Release
        "
        Invoke-WebRequest -uri $download_url -outfile ".\Dependencies\Nmap.exe"
    }
    else {
        $Nmap_Update = $false 
    }
} 

function Available_Updates {
    If ($Nmap_Update) {
        $Available_Updates = write-output "There are updates available for dependencies, please select U, to view them" 
    }
}
