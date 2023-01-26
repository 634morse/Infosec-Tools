function Enum_AD_OU_Rights {
    do {
        $option = Read-host "
        Do you want to enumerate rights on a single OU, or ALL?
        [1] or [All]
        "
    } until ($option -eq "1" -or $option -eq "All")
    If ($option -eq "1") {
        do {
            $option1 = Read-Host "
            Enter the distinguished name of the OU
            EX: OU=Sales,DC=Fabrikam,DC=COM
            "
            $i = Get-ADOrganizationalUnit $option1 -ErrorAction SilentlyContinue
        } until ($null -ne $i)
        $AD_OUS = Get-ADOrganizationalUnit -Filter 'DistinguishedName -like $i' | select Name, DistinguishedName, ObjectGuid
    }
    else {
        $AD_OUS = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | select Name, DistinguishedName, ObjectGuid  
    }
    $global:Enum_OUs_Job = "1"
    Start-ThreadJob Enum_OU_Rights {
        Foreach ($OU in $using:AD_OUS) {
            $ODS = $OU.DistinguishedName
            $ODN = $OU.Name
            $Export = "AD_OU_Rights_"
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
                $Table | Select OU_Name, OU_Path, AD_Rights, IdentityReference, InheritanceType, IsInherited, AccessControlType | export-csv $Export$Date.csv -Append -NoTypeInformation
                }
            }
        }
    }
    Do {
        $option = Read-host "
        Job is running and saving directories to a csv file ( $Export$Date.csv )
        Do not close C.A.R.P.E. while this is running.
        The Job may take awhile depending on what you are trying to enumerate
        [1] Go back to the AD Enumeration Menu
        [2] Check Jobs
        " 
    } until ($option -eq "1" -or $option -eq "2")
    switch ($option) {
         1 { AD_Enumeration_Menu }
         2 { Get_Threaded_Jobs }
    }

}