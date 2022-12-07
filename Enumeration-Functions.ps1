
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

##################################
#Nmap Network Discovery Functions#
##################################

function nmap_scan {
    Do {
    $option = Read-host "
    [1] To import hosts/subnets from csv (column-name needs to be 'range')
    [2] To manually choose hosts/subnets to scan
    "
    } until ($option -eq "1" -or $option -eq "2")    
    If ($option -eq "1") {
        do {
        $Ranges = Read-host "Please enter the full path of the csv file"
        $Test_path = Test-Path $Ranges
        $Ranges = Import-csv $Ranges
        } Until ($Test_path)

    }
    elseif ($option -eq "2") {
        $Ranges = Read-Host "
    Enter an ip, subnet or multiple subnets to scan
    Formats accepted
    Single IP: 192.168.1.50
    CIDR Notation: 192.168.1.1/24
    IP Range: 192.168.1.1-192.168.1.254
    "
    }
    do {
        $Export = Read-Host "Export data to csv? [Y/N]"
    } until ($Export -eq "Y" -or $Export -eq "N")
    If ( $Export -eq "Y") {
        $ExportPath = Read-Host "Enter Desired location to store the csv file"
    }
    
    ###PingScan###
    If ($NOption -eq "pingscan" -and $Export -eq "y") {
        foreach ($Range in $Ranges) {
            write-output $Range
            $Range = $Range.range
            write-output "Scanning Now"
            $pingscan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
            $global:ParsePingScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
            $ParsePingScan | select HostName, Status, IPv4, Mac | export-csv $ExportPath -Append -NoTypeInformation  
            write-output "done scanning, csv file stored here: $ExportPath"
        }
    }
    elseif ($NOption -eq "pingscan" -and $Export -eq "n") {
        write-output "Scanning Now"
        $pingscan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
        $global:ParsePingScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
        $ParsePingScan
    }
    ###PortScan###
    If ($NOption -eq "portscan") {
        $Ports = Read-host "List ports to scan:
        Single port (1)
        Comma Delimited (1,2,3)
        Range (1-10)
        All to scan all ports
        "
        If ($Ports -eq "All") {
            $Scan = nmap $Range
        }
        else {
            $Scan = nmap $Range $Ports
        }
        If ($Export -eq "y") {
            foreach ($Range in $Ranges) {
                write-output $Range
                $Range = $Range.range
                $portscan = nmap $Range -p $Ports 
            }
        }
        El
    }   
    $Option = read-host "
   To run another scan, select [1]
   To return to the Nmap Menu, Select [2]"

    switch ($Option) {
        1 { nmap_ping_scan }
        2 { Nmap_network_discovery_menu }
    }
}

