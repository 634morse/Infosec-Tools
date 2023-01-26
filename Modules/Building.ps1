#Virus Total Hash Search
Function VirusTotalSearch {
    Import-Module .\Dependencies\VirusTotal\VTKey.psm1
    Set_VT_API_KEY
    import-module .\Dependencies\VirusTotal\get-VTFileReport\get-VTFileReport.psm1
    $option = Read-Host "Enter the hash you would like to search"

    $hashsearch = get-VTFileReport -h $option
    $hashsearch
    $option = Read-Host " Visit the peramlink for additional info"
}