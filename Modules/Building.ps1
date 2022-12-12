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
}
