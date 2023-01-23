# Function Get_SMB_Jobs {
#     Get-Job | Where-Object {$_.Name -match "Enum_Directories" -or $_.Name -match "Dir_Shares"}
#     $option = Read-host  "Press any button to return to SMB_Prowler Menu"
#     SMB_Prowler_Menu
# }

#Phase 1: Discovery/Reconnaissance
Function SMB_Phase_1 {
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
    $ExportPath = ".\Exports\SMB_Hosts_$Date.csv"
    foreach ($Range in $Ranges) {
        write-output "          $Range"
        write-output "          Scanning Now"
        $smbscan = nmap $Ranges -p 445 -oX .\temp\smbscan-$date.xml
        $global:ParseSMBscan = .\Dependencies\Parse-Nmap.ps1 .\temp\smbscan-$date.xml
        foreach ($Device in $ParseSMBscan) {
            $Device_IPv4 = $Device.IPv4
            $Device_Status = $Device.Ports
            If ($Device_Status -match "open:tcp:445") {
                $Table = New-Object PSObject -Property @{
                    IPv4   = $Device_IPv4
                    Status = $Device_Status
                }
                $Table = $Table | select IPv4, Status | Export-csv $ExportPath -Append -NoTypeInformation    
            }
        }
              
        write-output "      done scanning, hosts with port 445 open stored here: $ExportPath"
        Start-Sleep -s 2   
    }
    #Phase 1.2
    $Device_List = Import-Csv $ExportPath
    write-host "      Beginning Host Share Discovery" -ForegroundColor Cyan
    start-sleep -s 1
     
    
    Foreach ($Device in $Device_List) {
        $Device_IPv4 = $Device.IPv4
        write-host $Device_IPv4 -ForegroundColor Yellow
        $Shares = net view /ALL \\$Device_IPv4\
        #Found Online to Parse net view output
        #May not need
        $Shares_List = @()
        $completed = $false
        for($x=0;$x -lt $Shares.count;$x++){
            $next_line = $x + 1
            if ($Shares[$x] -like "*------*"){
                do{ 
                    $content = $Shares[$next_line] -split '\s+'
                    $share_name = $content[0].Trim()
                    $custom_object = new-object PSObject
                     if (($share_name -ne "ADMIN$") -and ($share_name -ne "C$") -and ($share_name -ne "IPC$") -and ($share_name -ne "The")) {
                        Write-Host $share_name
                        $Table1 = New-Object PSObject -Property @{
                            Host = $Device_IPv4
                            Share = $share_name
                        }
                    }
                
                    $Table1 | select Host, Share | Export-Csv .\Exports\SMB_shares_$Date.csv -Append -NoTypeInformation
                    # $custom_object | add-member -MemberType NoteProperty -name 'Share_Name' -Value $share_name
                    # $custom_object | write-host
                    #may not need
                    # $Shares_List += $custom_object
                    if($Shares[$next_line] -like "*command completed*"){
                        $completed = $true
                    }
                    $next_line++
                } until ($completed)
            }
        }

    }
    write-host "      Shares stored here .\Exports\SMB_shares_$Date.csv" -ForegroundColor Cyan
    Read-Host "
    [1] to Move on to phase 2 [Enumeration]
    [2] to return to main menu
    "
}

Function SMB_Phase_2 {
    
    do {
        $option = Read-Host "

    Time to Enumerate and find that sweet sweet data!

    [1] To Gather a list of Directories
    [2] To Gather a list of all files
    [3] To search files for words/Phrases/Etc
    [4] To gather Directory Security Permissions
    "
    } until ($option -match "1" -or $option -match "2" -or $option -match "3" -or $option -match "4")
    #OPTION 1, Gathering Directories #OPTION 2
    If ($option -eq "1" -or $option -eq "4") {
        $option1 = Read-Host "
            [1] To Import csv of shares
            [2] To manually choose starting path
        "
        If ($option1 -eq "1") {
            do {
            $Shares_File = Read-host "      Please supply path of the csv to import"
            $Test_Path = Test-Path $Shares_File
            $Shares = Import-csv $Shares_File
            } until ($Test_Path)
        }
        elseif ($option1 -eq "2") {
            $Shares = Read-Host "       Please Supply the full path of the share you want to enumerate"
        }
        do {
            $option1 = Read-Host "      
                How Many Directories do you want to dig into?
                Select a number, EX: 0,1,5,10,etc (0 will get the base folders within a directory)
                Or Type 'MD' For Max depth
        
        "
        } until ( $option1 -eq "MD" -or $option1 -match "^\d+$" )

        $Current_Path = $pwd.path

        If ($option -eq 1) {
            $global:Enum_Directories_Job = "1"
            Start-ThreadJob -name Enum_Directories -ScriptBlock {
                Foreach ($_ in $using:Shares) {
                    $SMB_Host = $_.Host
                    $SMB_share = $_.Share
                    $Export = "SMB_share-dir_enum_"
                    If ( $using:option1 -eq "MD" ) {
                        get-childitem -path \\$SMB_Host\$SMB_share -Directory -Recurse -ErrorAction SilentlyContinue | select FullName | export-csv $using:Current_Path\Exports\$Export$using:Date.csv -Append -NoTypeInformation
                    }
                    elseif ( $using:option1 -match "^\d+$" ) {
                        get-childitem -path \\$SMB_Host\$SMB_share -Directory -Recurse -Depth $using:option1 -ErrorAction SilentlyContinue | select FullName | export-csv $using:Current_Path\Exports\SMB_share-dir_enum_$using:Date.csv -Append -NoTypeInformation
                    }
                } 
            } 
        }
        If ($option -eq 4) {
            $global:Dire_Shares_Job = "1"
            Start-ThreadJob -name Dir_Shares -ScriptBlock {
                Foreach ($_ in $using:Shares) {
                    $P = $_
                    $Export = "SMB_shares_permissions_"
                    If ( $using:option1 -eq "MD" ) {
                        $Directories = get-childitem -path $P -Directory -ErrorAction SilentlyContinue | select FullName
                    }
                    elseif ( $using:option1 -match "^\d+$" ) {
                        $Directories = get-childitem -path $P -Directory -Recurse -Depth $using:option1 -ErrorAction SilentlyContinue | select FullName
                    }
                    foreach ($Directory in $Directories) {
                        $DirectoryFullName = $Directory.fullname
                        $access = (get-acl $DirectoryFullName).access | select IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags 
                        foreach ($A in $access) {
                            $accessIdentityReference = $A.IdentityReference
                            $accessFileSystemRights = $A.FileSystemRights
                            $accessAccessControlType = $A.AccessControlType
                            $accessIsInherited = $A.IsInherited
                            $accessInheritanceFlags = $A.InheritanceFlags
                            $Table = New-Object PSObject -Property @{
                                path = $DirectoryFullName
                                IdentityReference = $accessIdentityReference
                                FileSystemRights = $accessFileSystemRights
                                AccessControlType = $accessAccessControlType
                                IsInherited = $accessIsInherited
                                InheritanceFlags = $accessInheritanceFlags
                            }
                        $Table | select Path, IdentityReference, FileSystemRights, AccessControlType, IsInherited, InheritanceFlags | export-csv $using:Current_Path\Exports\$Export$using:Date.csv -Append -NoTypeInformation
                        }
                    }   
                }
            }
        }

        $option = Read-host "
        Job is running and saving directories to a csv file ( $Export$Date.csv )
        Do not close C.A.R.P.E. while this is running.
        The Job may take awhile depending on what you are trying to enumerate
        [1] Go back to SMB_Prowler Menu
        [2] Check Jobs
        " 
        switch ($option) {
            1 { SMB_Prowler_Menu }
            2 { Get_SMB_Jobs }
        }
    }
}

