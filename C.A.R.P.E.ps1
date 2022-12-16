# try {
#     Set-ExecutionPolicy "Allsigned" -scopt localmachine
# }

# catch {
#     #Do nothing
# }

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
$env:path += ';.\Dependencies\Nmap'

#Clean Temp folder
Remove-item -Path .\temp\* -recurse -force

#Importing C.A.R.P.E. Functions
$I = ls .\Modules| select name
Foreach ($F in $I) {
    $FName = $F.name
    Import-Module .\Modules\$FName
}
#Importing 3rd party Modules/Tools
Import-Module .\Dependencies\ThreadJob\2.0.0\Microsoft.PowerShell.ThreadJob.dll

Nmap_update_check
7zip_update_check 

Available_Updates

Welcome_Menu