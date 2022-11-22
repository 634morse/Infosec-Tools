function Basic_Host_Info {
    Write-output "Reminder: Make sure you have the Appropriate rights to Enumerate the host"
    $IsRemoteMachine = Read-Host "Is this a remote machine? (Yes/No)"
    If ($IsRemoteMachine -match "Yes") {
        $Cred = Get-Credential
    }
    $DeviceName = Read-Host "Please Enter the HostName to Enumerate"

    $ISHostLocal = Get-CimInstance -classname Win32_OperatingSystem | select CSName
    
    If ($DeviceName -Like $ISHostLocal.CSName) {
        $BHI = get-ciminstance -classname Win32_OperatingSystem | select caption, csname, version, OSArchitecture, RegisteredUser, LastBootUpTime
    }
    else {
        $Session = New-CimSession -ComputerName $DeviceName $Credential
        $BHI = get-ciminstance -classname Win32_OperatingSystem -CimSession $Session | select caption, csname, version, OSArchitecture, RegisteredUser, LastBootUpTime
    }

    $BHI = get-ciminstance -classname Win32_OperatingSystem | select caption, csname, version, OSArchitecture, RegisteredUser, LastBootUpTime
    $BHI_Name = $BHI.csname
    $BHI_OS = $BHI.caption
    $BHI_OS_Version = $BHI.version
    $BHI_OSARCH = $BHI.OSArchitecture
    $BHI_Reg_user = $BHI.RegisteredUser
    $BHI_LASTBOOT_TIME = $BHI.LastBootUpTime

    $Table = New-Object PSObject -Property @{
        HostName = $BHI_Name
        RegisteredUser = $BHI_Reg_user
        LastRebootTime = $BHI_LASTBOOT_TIME
        OS       = $BHI_OS
        OS_Version = $BHI_OS_Version
        OS_Architecture = $BHI_OSARCH
    }
    $Table = $Table | Select HostName, RegisteredUser, LastRebootTime, OS, OS_Version, OS_Architecture
    clear-host
    $Table
    Read-Host "Select 1 to go back to the menu, 2 to Exit"
}
function Local_Enumerations_Menu {
    clear-host
    Write-output ""
    Write-output ""
    Write-output ""
    Write-output " __________________________________________________________________________________"
    Write-output "|##################################################################################|"                                                                       
    Write-output "|#       __                _    _____                           _   _             #|"
    Write-output "|#      |  |   ___ ___ ___| |  |   __|___ _ _ _____ ___ ___ ___| |_|_|___ ___     #|"
    Write-output "|#      |  |__| . |  _| .'| |  |   __|   | | |     | -_|  _| .'|  _| | . |   |    #|"
    Write-output "|#      |_____|___|___|__,|_|  |_____|_|_|___|_|_|_|___|_| |__,|_| |_|___|_|_|    #|"                                                                      
    Write-output "|##################################################################################|"
    Write-output "                                                                                    "
    Write-output "              [1] To Gather Basic info On a Host (OS/Hostname/ETC), Select 1        "
    Write-output "              [2] To Gather User Info On a Host, Select 2                           "
    Write-output "              [3] To Gather Network Info On a Host, Select 3                        "
    Write-output "              [B] To Return to the Main Menu, Select B                              "
    Write-output "              [Q] To Quite, Select Q                                                " 
    Write-Output "                                                                                    "
    $LEOption= Read-Host "        Please Select an option:                                             "

    Switch ($LEOption) {

        1 {Basic_Host_Info}
        B { Welcome-Menu }
        Q { Exit }
    }
}
 