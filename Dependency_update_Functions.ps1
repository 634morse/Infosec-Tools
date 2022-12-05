#################################################################
#Checking for Nmap updates
#This only Checks for updates and downloads the latest installer
#You will need to manually extract the files
#################################################################
function Nmap_update_check {
$global:Nmap_Message = "Nmap is up to date"
$HTML = Invoke-WebRequest "https://nmap.org/download#windows"
$HTML = $HTML.Links | Select href
$HTML = $HTML -match "setup.exe"
$HTML = $HTML.href
$global:nmap_download_url = $HTML
$HTML = $HTML -split("-")
$Newest_Nmap_Release = $HTML[1]

$Nmap_properties = get-itemproperty ".\Dependencies\Nmap\nmap.exe"
$global:Current_Nmap_version = $Nmap_properties.versioninfo.fileversion

    If ($Current_Nmap_version -notmatch $Newest_Nmap_Release) {
        $global:Nmap_Update = $true
        $global:Nmap_Message = "##New version of Nmap Available - $Newest_Nmap_Release##"
    }
    else {
        $global:Nmap_Update = $false 
    }
} 

function Download_Nmap {
    Write-Output "Downloading Newest Nmap EXE"
    Invoke-WebRequest -uri $nmap_download_url -outfile ".\Dependencies\Nmap.exe"
    Write-output "Nmap EXE has been downloaded, and is located in the dependencies folder, please extract and replace the current nmap folder"
    Start-Sleep -seconds 3
    update_menu
}

function 7zip_update_check {
    $global:7zip_message = "7zip is up to date"
    $HTML = Invoke-WebRequest "https://www.7-zip.org/download.html"
    $HTML = $HTML.Links | select href
    $HTML = $HTML | where-object -filterscript {$_.href -match "exe"  -and $_.href -notmatch "-x64"}
    $7zip_Online_Version = $HTML.href -replace ".exe"
    $7zip_Online_Version = $7zip_Online_Version -replace "a/7z"
    $7zip_Online_Version = $7zip_Online_Version -replace "r"
    $7zip_Online_Version = $7zip_Online_Version -replace "-am64"
    $7zip_Online_Version = $7zip_Online_Version -replace "-am"
    $Newest_7zip_release = $7zip_Online_Version[0]
    
    $7zip_properties = get-itemproperty ".\Dependencies\7-Zip\7z.exe"
    $global:current_7zip_version = $7zip_properties.VersionInfo.fileversion
    $global:current_7zip_version = $global:current_7zip_version -replace "\."

    If ($Current_7zip_version -notmatch $Newest_7zip_Release) {
        $global:7zip_Update = $true
        $global:7zip_Message = "##New version of 7zip Available - $Newest_7zip_Release##"
    }
    else {
        $global:7zip_Update = $false 
    }

    $global:7zip_download_url = "https://www.7-zip.org/a/7z$Newest_7zip_release-x64.exe"

}

function Download_7zip {
    Write-Output "Downloading Newest Version of 7zip"
    Invoke-WebRequest $7zip_download_url -OutFile ".\Dependencies\"
    write-output "7zip EXE has been downloaded, and is located in the dependencies folder, please extract and replace the current 7zip folder"
    Start-Sleep -seconds 3
    update_menu
}

function Available_Updates {
    $global:Available_Updates = "No available updates at this time"
    If ($Nmap_Update -or $7zip_Update) {
        $global:Available_Updates = write-output "There are updates available for dependencies, please select U, to view them" 
    }
}



