$pshost = Get-Host
$psWindow = $pshost.UI.RawUI
$newSize =$psWindow.BufferSize
$newSize.Height = 4000
$newSize.Width = 200
$psWindow.BufferSize = $newSize
$newSize = $psWindow.WindowSize
$newSize.Height = 30
$newSize.Width = 125
$psWindow.WindowSize= $newSize

#Importing Functions
$I = ls | select name
Foreach ($F in $I) {
    $FName = $F.name
    $FName
    if ($F -match "Functions") {
        Import-Module .\$FName
    } 
} 

Nmap_updater

Available_Updates

Welcome_Menu