
##############################
#Local Enumeration Functions #
##############################                 
function Stage_Creds {
    $Creds = Get-Credential
}

function Basic_Host_Info {
    Write-output "Reminder: Make sure you have the Appropriate rights to Enumerate the host"
    $IsRemoteMachine = Read-Host "Is this a remote machine? (Yes/No)"
    $CurrentCreds = Read-Host "Does the account that opened C.A.R.P.E. Have enough Privileges? (Yes/No)"
    If ($IsRemoteMachine -match "Yes") {
        If ($null -eq $Creds -and $CurrentCreds -eq "No") {
            $Creds = get-credential
        }
        $DeviceName = Read-Host "Please Enter the HostName to Enumerate"
        $Session = New-CimSession -ComputerName $DeviceName $Credential
        $BHI = get-ciminstance -classname Win32_OperatingSystem -CimSession $Session | select caption, csname, version, OSArchitecture, RegisteredUser, LastBootUpTime
    }
    If ($IsRemoteMachine -match "No") {
        $BHI = get-ciminstance -classname Win32_OperatingSystem | select caption, csname, version, OSArchitecture, RegisteredUser, LastBootUpTime
    }

    $BHI_Name = $BHI.csname
    $BHI_OS = $BHI.caption
    $BHI_OS_Version = $BHI.version
    $BHI_OSARCH = $BHI.OSArchitecture
    $BHI_Reg_user = $BHI.RegisteredUser
    $BHI_LASTBOOT_TIME = $BHI.LastBootUpTime

    $Table = New-Object PSObject -Property @{
        HostName        = $BHI_Name
        RegisteredUser  = $BHI_Reg_user
        LastRebootTime  = $BHI_LASTBOOT_TIME
        OS              = $BHI_OS
        OS_Version      = $BHI_OS_Version
        OS_Architecture = $BHI_OSARCH
    }
    $Table = $Table | Select HostName, RegisteredUser, LastRebootTime, OS, OS_Version, OS_Architecture
    clear-host
    $Table
    $Option = Read-Host "
    [1] Run Another Lookup
    [2] Return To Local Enumeration
    [3] Exit
    "
    switch ($Option) {
        1 { Basic_Host_Info }
        2 { Local_Enumerations_Menu }
        3 { Exit }

    }
}

function Get_Local_Network_Info {
    Write-output "Reminder: Make sure you have the Appropriate rights to Enumerate the host"
    $IsRemoteMachine = Read-Host "Is this a remote machine? (Yes/No)"
    If ($IsRemoteMachine -match "Yes") {
        $Cred = Get-Credential
        $DeviceName = Read-Host "Please Enter the HostName to Enumerate"
        $NetworkAdapters = Get-CimInstance win32_networkadapterconfiguration | select Caption, IPSubnet, IPAddress, MacAddress, DHCPServer, DNSHostName
    }
    If ($IsRemoteMachine -match "No") {
        $NetworkAdapters = Get-CimInstance win32_networkadapterconfiguration | select Caption, IPSubnet, IPAddress, MacAddress, DHCPServer, DNSHostName
    }
    Clear-Host
    Foreach ($NetworkAdapter in $NetworkAdapters) {
        If ($null -ne $NetworkAdapter.IPAddress) {
            $Adapter_Name = $NetworkAdapter.caption
            $Adapter_IPAddress = $NetworkAdapter.IPAddress
            $Adapter_Subnet = $NetworkAdapter.IPSubnet
            $Adapter_DNSHostName = $NetworkAdapter.DNSHostName
            $Adapter_DHCPServer = $NetworkAdapter.DHCPServer
            $Adapter_MacAddress = $NetworkAdapter.MacAddress
            
            Write-output "
                Network Adapter Info
            "
            $Table = New-Object PSObject -Property @{
                Adapter_Name = $Adapter_Name
                IPAddress    = $Adapter_IPAddress
                Subnet       = $Adapter_Subnet
                DNSHostName  = $Adapter_DNSHostName
                DHCPServer   = $Adapter_DHCPServer
                MacAddress   = $Adapter_MacAddress
            }
            $Table = $Table | Select Adapter_Name, IPAddress, Subnet, DNSHostName, DHCPServer, MacAddress
            
            $Table
        }
    }
    $Option = Read-Host "
    [1] Run Another Lookup
    [2] Return To Local Enumeration
    [3] Exit
    "
    switch ($Option) {
        1 { Get_Local_Network_Info }
        2 { Local_Enumerations_Menu }
        3 { Exit }

    }
}


 
# Get-CimInstance win32_networkadapterconfiguration | select Caption, IPSubnet, IPAddress, MacAddress, DHCPServer, DNSHostName
# get-cimclass win32_networkadapterconfiguration | select IPSubnet, IPAddress, MacAddress, DHCPServer, DNSHostName
# get-cimclass win32_useraccount | select -expand cimclassproperties | Select Name,CimType



function Gather_Local_User_Info {
    Write-output "Reminder: Make sure you have the Appropriate rights to Enumerate the host"
    $IsRemoteMachine = Read-Host "Is this a remote machine? (Yes/No)"
    If ($IsRemoteMachine -match "Yes") {
        $Cred = Get-Credential
        $DeviceName = Read-Host "Please Enter the Host to Enumerate"
    }
    $Users = get_ciminstance win32_groupuser | select GroupComponent, PartComponent
}

 

#########################################
#Active Directory Enumeration Functions #
#########################################


function Get_AD_User_Info {
    $ADUsers = Read-Host "Enter the Name of the user(s), for multiple users, seperate by a comma"
    foreach ($ADUser in $ADUsers) {
        Get-ADUser $ADUser | select Name
        return
    }
}

