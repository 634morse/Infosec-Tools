function test {
#Discovering Servers with Port 445 Open
$SMBHosts = Nmap -p 445 172.28.1.1/24 -oX .\temp\SMB-Export.xml
$SMBHosts = .\Dependencies\Parse-Nmap.ps1 .\temp\SMB-Export.xml
$SMBHosts = $SMBHosts | select IPv4, Ports
foreach ($SMBHost in $SMBHosts) {
    $SMBHost_IPv4 = $SMBHost.IPv4
    $SMBHost_Ports = $SMBHost.Ports
    If ($SMBHost_Ports -match "open:tcp:445") {
        $Table = New-Object PSObject -Property @{
            Host    = $SMBHost_IPv4
        }
    $Table | Export-Csv .\Exports\SMB_Hosts_$date.csv -Append -NoTypeInformation
    }
}

$Shares = net view /ALL \\17.28.1.25\

$Search_string = Read-Host "Enter A String to crawl for"
do { 
    $Path = read-host "Enter the file path you would like to enumerate"
    $test = test-path $Path
} until ($test)

$Files = Get-ChildItem -path $Path -recurse -file | select Name, Directory, Extension
#$File_Count = $Files | Measure-Object
$File_Count = $Files.Count
$i = 0
Foreach ($File in $Files) {
    $File_Dir = $File.Directory.FullName
    $File_Name = $File.Name
    $File_Path = (Join-Path $File_Dir $File_Name)
    $Crawled = select-string $Search_string -path $File_Path | export-csv \\avo\temp\copatterson\$Search_String-Crawled.csv -Append -NoTypeInformation
    $i++
    Write-Progress -Activity "Crawling Files - " -Status "Crawled: $i of $File_Count"
    
}



Foreach ($_ in $Shares) {
    $SMB_Host = $_.Host
    $SMB_share = $_.Share
    $Directories = Get-ChildItem \\Avo\$SMB_share -Directory | select name
    Foreach ($Directory in $Directories) {
        (get-acl).access
    }
}

}





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
                $scan = nmap $Range -oX .\temp\portscan-$date.xml
            }
            else {
                $Scan = nmap $Range -p $Ports -oX .\temp\portscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
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
                $scan = nmap $Range -oX .\temp\portscan-$date.xml
            }
            else {
                $Scan = nmap $Range -p $Ports -oX .\temp\portscan-$date.xml
            }
            $global:ParseScan = .\Dependencies\Parse-Nmap.ps1 .\temp\portscan-$date.xml
        }
        $ParseScan







        ###############################################################
        $AD_OUS = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | select Name, DistinguishedName, ObjectGuid

    Foreach ($OU in $AD_OUS) {
        $ODS = $OU.DistinguishedName
        $ODN = $OU.Name
        $ACLS = (Get-Acl -path "AD:\$ODS").Access | Select ActiveDirectoryRights, InheritanceType, IdentityReference, AccessControlType, IsInherited
        Foreach ($ACL in $ACLS) {
            If ($ACL.IdentityReference -notmatch "Builtin" -and $ACL.IdentityReference -notlike "CREATOR OWNER" -and $ACL.IdentityReference -notmatch"NT AUTHORITY" ) {
            $ADR = $ACL.ActiveDirectoryRights
            $IT = $ACL.InheritanceType
            $IR = $ACL.IdentityReference
            $ACT = $ACL.AccessControlType
            $II = $ACL.IsInherited
        
            $Table = New-Object PSObject -Property @{
                OU_Name             = $ODS
                OU_Path             = $ODN
                AD_Rights           = $ADR
                IdentityReference   = $IR
                InheritanceType     = $IT
                IsInherited         = $II
                AccessControlType   = $ACT
            }
            $Table | Select OU_Name, OU_Path, AD_Rights, IdentityReference, InheritanceType, IsInherited, AccessControlType | export-csv c:\temp\AD_OU_Rights_$((Get-Date).ToString('MM-dd-yyyy')).csv -Append -NoTypeInformation
            }
        }
    }
}