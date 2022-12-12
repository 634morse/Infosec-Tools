
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
        try {
        $Shares = net view /ALL \\$Device_IPv4\
        }
        catch {
            write-host $Error -ForegroundColor Green
        }
        #Found Online to Parse net view output
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
                        $custom_object | add-member -MemberType NoteProperty -name 'Share_Name' -Value $share_name
                        #write-host "$share_name"
                    }
                    $custom_object | write-host
                    $Shares_List += $custom_object
                    if($Shares[$next_line] -like "*command completed*"){
                        $completed = $true
                    }
                    $next_line++
                } until ($completed)
            }
        }
        write-host $Shares_List

    }
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
    "
    } until ($option -match "1" -or $option -match "2" -or $option -match "3")
    If ($option -eq "1") {
        
    }
    
}




