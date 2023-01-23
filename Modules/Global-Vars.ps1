#This is where all global variables and functions should live
Function Get_Threaded_Jobs {
    If ($Enum_Directories_Job -eq "1" -or $Dire_Shares_Job -eq "1" ) {
     Get-Job | Where-Object {$_.Name -match "Enum_Directories" -or $_.Name -match "Dir_Shares"}
     $option = Read-host  "Press any button to return to the SMB_Prowler Menu"
     SMB_Prowler_Menu
    }
    If (Enum_OUs_Job -eq "1") {
        Get-Job | Where-Object {$_.Name -match "Enum_OU_Rights"}
        $option = Read-host  "Press any button to return to the AD Enumeration menu"
        AD_Enumeration_Menu
    }   
}

