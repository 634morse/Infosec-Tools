function nmap_scan {
    Do {
    $option1 = Read-host "
    [1] To import hosts/subnets from csv (column-name needs to be 'range')
    [2] To manually choose hosts/subnets to scan
    "
    } until ($option1 -eq "1" -or $option1 -eq "2")    
    If ($option1 -eq "1") {
        do {
        $Ranges = Read-host "Please enter the full path of the csv file"
        $Test_path = Test-Path $Ranges
        $Ranges = Import-csv $Ranges
        } Until ($Test_path)

    }
    elseif ($option1 -eq "2") {
        $Ranges = Read-Host "
    Enter an ip, subnet or multiple subnets to scan
    Formats accepted
    Single IP: 192.168.1.50
    CIDR Notation: 192.168.1.1/24
    IP Range: 192.168.1.1-192.168.1.254
    "
    }
    do {
        $Export = Read-Host "   Export data to csv? [Y/N]"
    } until ($Export -eq "Y" -or $Export -eq "N")
    If ( $Export -eq "Y") {
        $ExportPath = Read-Host "   Enter Desired location to store the csv file"
    }
    If ($NOption -eq "portscan" -or $NOption -eq "stealthscan") {
        $Ports = Read-host "List ports to scan:
        Single port (1)
        Comma Delimited (1,2,3)
        Range (1-10)
        All to scan all ports
        "
    }   
    
    ###Scanning###
    If ($option1 -eq "1" -and $Export -eq "y") {
        write-output "Scanning Now"
        foreach ($Range in $Ranges) {
            $Range = $Range.range
            Write-Host $Range
            If ($NOption -eq "pingscan") {
                $scan = nmap $Range -sn -oX .\temp\pingscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
                $ParseScan | select IPv4, Status, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
            If ($NOption -eq "portscan") {
                If ($Ports -eq "All") {
                    $scan = nmap $Range -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap $Range -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
                $ParseScan | select IPv4, Status, Ports, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
            If ($NOption -eq "stealthscan") {
                If ($Ports -eq "All") {
                    $scan = nmap $Range -sS -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap $Range -p $Ports -sS -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
                $ParseScan | select IPv4, Status, Ports, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
        }
        write-output "done scanning, csv file stored here: $ExportPath"
    }
    elseif ($option1 -eq "1" -and $Export -eq "n") {
        write-output "Scanning Now"
        foreach ($Range in $Ranges) {
            $Range = $Range.range
            Write-Host $Range
            If ($NOption -eq "pingscan") {
                $scan = nmap $Range -sn -oX .\temp\pingscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
            }
            If ($NOption -eq "portscan") {
                If ($Ports -eq "All") {
                    $scan = nmap $Range -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap $Range -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
            }
            If ($NOption -eq "stealthscan") {
                If ($Ports -eq "All") {
                    $scan = nmap $Range -sS -oX .\temp\stealthscan-$date.xml
                }
                else {
                    $Scan = nmap $Range -sS -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
            }
            $ParseScan
        }
    }
    elseif ($option1 -eq "2" -and $Export -eq "y") {
        write-output "Scanning Now"
        If ($NOption -eq "pingscan") {
            $scan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
            $ParseScan | select IPv4, Status, HostName | export-csv $ExportPath -Append -NoTypeInformation
        }
        If ($NOption -eq "portscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -oX .\temp\portscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -oX .\temp\portscan-$date.xml   
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
            $ParseScan | select IPv4, Status, HostName | export-csv $ExportPath -Append -NoTypeInformation
        }
        If ($NOption -eq "stealthscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -sS -oX .\temp\stealthscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -sS -oX .\temp\stealthscan-$date.xml   
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
            $ParseScan | select IPv4, Status, Ports, HostName | export-csv $ExportPath -Append -NoTypeInformation
        }
        write-output = "done scanning, csv file stored here: $ExportPath"
    }
    elseif ($option1 -eq "2" -and $Export -eq "n") {
        write-output "Scanning Now"
        If ($NOption -eq "pingscan") {
            $scan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
        }
        If ($NOption -eq "portscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -oX .\temp\portscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -oX .\temp\portscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
        }
        If ($NOption -eq "stealthscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -sS -oX .\temp\stealthscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -sS -oX .\temp\stealthscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
        }
        $ParseScan
    }
    $Option = read-host "
    To run another $NOption, select [1]
    To return to the Nmap Menu, Select [2]"
 
     switch ($Option) {
         1 { nmap_scan }
         2 { Nmap_network_discovery_menu }
     }
}
