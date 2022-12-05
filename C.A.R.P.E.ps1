try {
    Set-ExecutionPolicy "Allsigned" -scopt localmachine
}

catch {
    #Do nothing
}

$Host.UI.RawUI.WindowTitle = " C.A.R.P.E."
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Magenta"

$pshost = Get-Host
$psWindow = $pshost.UI.RawUI
$newSize =$psWindow.BufferSize
$newSize.Height = 4000
$newSize.Width = 200
$psWindow.BufferSize = $newSize
$newSize = $psWindow.WindowSize
$newSize.Height = 35
$newSize.Width = 150
$psWindow.WindowSize= $newSize

$global:ProgressPreference = 'SilentlyContinue'
$global:date = Get-Date -Format "MM-dd-yyyy"
$global:env:Path += '.\Dependencies\Nmap'

#Clean Temp folder

#Importing Functions
$I = ls | select name
Foreach ($F in $I) {
    $FName = $F.name
    if ($F -match "Functions") {
        Import-Module .\$FName
    } 
} 

Nmap_update_check
7zip_update_check

Available_Updates

Welcome_Menu