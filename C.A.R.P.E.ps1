#Creating Desktop shortcut
$S = get-childitem $env:USERPROFILE\desktop\C.A.R.P.E.lnk -ErrorAction SilentlyContinue
If ($null -eq $S) {
    $WshShell = New-Object -comObject WScript.Shell
    #$Shortcut = $WshShell.CreateShortcut("$pwd\C.A.R.P.E.lnk")
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\C.A.R.P.E.lnk")
    $Shortcut.WorkingDirectory = "$pwd"
    $Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy bypass $pwd\C.A.R.P.E.ps1"
    $Shortcut.IconLocation = "$pwd\Dependencies\Icon\Piranha-icon.ico"
    $Shortcut.Save()  
}

$Host.UI.RawUI.WindowTitle = " C.A.R.P.E."
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Magenta"
$Host.UI.RawUI.Window

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
$env:path += '.\Dependencies\Nmap'

#Clean Temp folder
Remove-item -Path .\temp\*  -recurse -force -ErrorAction SilentlyContinue

#Importing Functions
$I = ls .\Modules| select name
Foreach ($F in $I) {
    $FName = $F.name
    Import-Module .\Modules\$FName
} 

Nmap_update_check
7zip_update_check 
Available_Updates
Welcome_Menu
