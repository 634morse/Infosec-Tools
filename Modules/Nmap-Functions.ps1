function nmap_documentation {
    get-content .\Documentation\Nmap-Documentation.txt
    $option = Read-host  "Press any button to return to Nmap Menu"
    Nmap_network_discovery_menu
}
function nmap_scan {
    Do {
    $option1 = Read-host "
    [1] To import hosts/subnets from a text file (each range needs to be on a new line)
    [2] To manually choose hosts/subnets to scan
    "
    } until ($option1 -eq "1" -or $option1 -eq "2")    
    If ($option1 -eq "1") {
        do {
        $Ranges = Read-host "Please enter the full path of the text file"
        $Test_path = Test-Path $Ranges
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
    If ($NOption -eq "portscan" -or $NOption -eq "stealthscan" -or $NOption -eq "cipherscan") {
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
            If ($NOption -eq "pingscan") {
                $scan = nmap -iL $Ranges -sn -oX .\temp\pingscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
                $ParseScan | select IPv4, Status, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
            #######
            If ($NOption -eq "portscan") {
                If ($Ports -eq "All") {
                    $scan = nmap -iL $Ranges -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
                $ParseScan | select IPv4, Status, Ports, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
            #######
            If ($NOption -eq "stealthscan") {
                If ($Ports -eq "All") {
                    $scan = nmap -iL $Ranges -sS -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -p $Ports -sS -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
                $ParseScan | select IPv4, Status, Ports, HostName | export-csv $ExportPath -Append -NoTypeInformation
            }
            #######
            If ($NOption -eq "smbscan") {
                $scan = nmap -p 445 --script smb2-security-mode.nse -iL $Ranges -oX .\temp\smbscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\smbscan-$date.xml
                foreach ($_ in $ParseScan) {
                    $IPv4 = $_.IPv4
                    $Ports = $_.ports
                    $SMB_Signing = $_.Script
                    $shorten = $SMB_Signing -replace '\s*'
                    $i = $shorten.split(':')
                        $i = $i.split('><')
                        $i = $i.split(':')
                        $SMB_Version = $i[2]
                        $SMB_Status = $i[3]
                    $Table = New-Object PSObject -Property @{
                        IPv4 = $IPv4
                        SMB_Version = $SMB_Version
                        SMB_Status = $SMB_Status
                        Port_status = $Ports
                    }
                    $Table | select IPv4, SMB_Version, SMB_Status, Port_status | export-csv $ExportPath -append -notypeinformation
                }
            }
            #######
            If ($NOption -eq "CipherScan") {
                If ($Ports -eq "All") {
                    $scan = nmap -iL $Ranges --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -p $Ports --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\cipherscan-$date.xml
                foreach ($_ in $ParseScan) {
                    $IPv4 = $_.IPv4
                    $Ports = $_.ports
                    $Ciphers = $_.Script
                    If ($Ciphers -ne "<no-script>") {
                        $Table = New-Object PSObject -Property @{
                        IPv4 = $IPv4
                        Port_status = $Ports
                        Ciphers = $Ciphers
                        }
                    $Table | select IPv4, Ciphers | export-csv $ExportPath -append -notypeinformation
                    }
                }
            }
        write-output "done scanning, csv file stored here: $ExportPath"
    }
    elseif ($option1 -eq "1" -and $Export -eq "n") {
        write-output "Scanning Now"
            If ($NOption -eq "pingscan") {
                $scan = nmap -iL $Ranges -sn -oX .\temp\pingscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
            }
            #######
            If ($NOption -eq "portscan") {
                If ($Ports -eq "All") {
                    $scan = nmap $-iL $Ranges -oX .\temp\portscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
            }
            #######
            If ($NOption -eq "stealthscan") {
                If ($Ports -eq "All") {
                    $scan = nmap -iL $Ranges -sS -oX .\temp\stealthscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -sS -p $Ports -oX .\temp\portscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
            }
            #######
            If ($NOption -eq "smbscan") {
                $scan = nmap -p 445 --script smb2-security-mode.nse -iL $Ranges -oX .\temp\smbscan-$date.xml
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\smbscan-$date.xml
            }
            #######
            If ($NOption -eq "CipherScan") {
                If ($Ports -eq "All") {
                    $scan = nmap -iL $Ranges --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
                }
                else {
                    $Scan = nmap -iL $Ranges -p $Ports --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
                }
                $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\cipherscan-$date.xml
            }
            $ParseScan
        }
    elseif ($option1 -eq "2" -and $Export -eq "y") {
        write-output "Scanning Now"
        If ($NOption -eq "pingscan") {
            $scan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
            $ParseScan | select IPv4, Status, HostName | export-csv $ExportPath -Append -NoTypeInformation
        }
        #######
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
        #######
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
        #######
        If ($NOption -eq "smbscan") {
            $scan = nmap -p 445 --script smb2-security-mode.nse $Ranges -oX .\temp\smbscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\smbscan-$date.xml
            foreach ($_ in $ParseScan) {
                $IPv4 = $_.IPv4
                $Ports = $_.ports
                $SMB_Signing = $_.Script
                $shorten = $SMB_Signing -replace '\s*'
                $i = $shorten.split(':')
                    $i = $i.split('><')
                    $i = $i.split(':')
                    $SMB_Version = $i[2]
                    $SMB_Status = $i[3]
                $Table = New-Object PSObject -Property @{
                    IPv4 = $IPv4
                    SMB_Version = $SMB_Version
                    SMB_Status = $SMB_Status
                    Port_status = $Ports
                }
                $Table | select IPv4, SMB_Version, SMB_Status, Port_status | export-csv $ExportPath -append -notypeinformation
            }
        }
        #######
        If ($NOption -eq "CipherScan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\cipherscan-$date.xml
            foreach ($_ in $ParseScan) {
                $IPv4 = $_.IPv4
                $Ports = $_.ports
                $Ciphers = $_.Script
                If ($Ciphers -ne "<no-script>") {
                     $Table = New-Object PSObject -Property @{
                        IPv4 = $IPv4
                        Port_status = $Ports
                        Ciphers = $Ciphers
                    }
                    $Table | select IPv4, Ciphers | export-csv $ExportPath -append -notypeinformation
                }
            }
        }
        #######
        If ($NOption -eq "ftpanon") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges --script ftp-anon.nse -oX .\temp\ftpanpnscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports --script ftp-anon.nse -oX .\temp\ftpanpnscan-$date.xml
            } 
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\ftpanpnscan-$date.xml
            
        } 
        write-output = "done scanning, csv file stored here: $ExportPath"
    }
    elseif ($option1 -eq "2" -and $Export -eq "n") {
        write-output "Scanning Now"
        If ($NOption -eq "pingscan") {
            $scan = nmap $Ranges -sn -oX .\temp\pingscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\pingscan-$date.xml
        }
        #######
        If ($NOption -eq "portscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -oX .\temp\portscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -oX .\temp\portscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
        }
        #######
        If ($NOption -eq "stealthscan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges -sS -oX .\temp\stealthscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports -sS -oX .\temp\stealthscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\stealthscan-$date.xml
        }
        #######
        If ($NOption -eq "smbscan") {
            $scan = nmap -p 445 --script smb2-security-mode.nse $Ranges -oX .\temp\smbscan-$date.xml
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\smbscan-$date.xml
        }
        #######
        If ($NOption -eq "CipherScan") {
            If ($Ports -eq "All") {
                $scan = nmap $Ranges --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
            }
            else {
                $Scan = nmap $Ranges -p $Ports --script ssl-enum-ciphers.nse -oX .\temp\cipherscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\cipherscan-$date.xml
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

