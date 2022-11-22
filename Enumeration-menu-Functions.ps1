function Enumeration-Menu-1 {
    clear-host
    Write-Output "#########################################################################################################################"
    write-Output "#########################################   \\ENUMERATION//   ###########################################################"
    write-Output "################################## \\Welcome to the Enumeration Menu! // ################################################"
    write-output "                                       "
    Write-Output " [1] If you want to gather local information on Host(s,) Please Select 1"
    Write-Output " [2] If you would like to gather Active Directory Info, Please Select 2"
    Write-Output " [B] If you would like to return to the Main Menu, Please Select B"
    $EOption = Read-Host    "                     Please Choose an option"

    Switch ($EOption) {
        B { Welcome-Menu }
        Q { Exit }
    } 
}