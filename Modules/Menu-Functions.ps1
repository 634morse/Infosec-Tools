
##################
###Welcome Menu###
##################

function Welcome_Menu {
    Clear-Host
    write-output "
#####################################################################################################################################################
#####################################################################################################################################################
              \\                        //         _____              _____    _____  ______           \\                        //                    
                \\                    //          / ____|     /\     |  __ \  |  __ \|  ____|            \\                    //  
                  \\                //           | |         /  \    | |__) | | |__) | |__                 \\                //     
                    \\            //             | |        / /\ \   |  _  /  |  ___/|  __|                  \\            //     
                      \\        //               | |____ _ / ____ \ _| | \ \ _| |_   | |_____                  \\        //     
                        \\    //                  \_____(_)_/    \_(_)_|  \_(_)_(_)  |_____(_)                   \\    // 
                          \\//                                                                                     \\//  
#####################################################################################################################################################
#####################################################################################################################################################
    Author: Corey Patterson                                                                                                                        
    Version: 0.1                                                                                                                                 
                                                                                                                                                 
    Updates:                                                                                                                                     
    $Available_Updates                                                                                                                           
                                                                                                                                                 
                            [1] To view documentation                                                                                 
                            [2] To Run Enumeration/Discovery                                                                        
                            [3] To to take a look at the Random Tools                                                        
                            [U] To view dependecy versions/Updates                                                          
                            [Q] To Quite                                                                         
                                                                                                                                                

    "
    $Option = Read-Host    "                        Please Choose an option"      
    
    Switch ($Option) {
            1 { Documentation }
            2 { Enumeration_Menu_1 }
            U { update_menu }
            s { SMB_Prowler_Menu }
            Q { Exit }
        }
}


######################
######Update Menu#####
######################

function update_menu {
  clear-Host
  write-output "
#####################################################################################################################################################  
                                  ##          ##__ __ ____  ____    ___  ______  ____  __ ##          ###
                                  # ##      ##  || || || \\ || \\  // \\ | || | ||    (( \  ##      ##  # 
                                  #   ##  ##    || || ||_// ||  )) ||=||   ||   ||==   \\     ##  ##    #
                                  #     ##      \\_// ||    ||_//  || ||   ||   ||___ \_))      ##      #
#####################################################################################################################################################                                           
                      
Dependencies:
     NAME:              Current Version:                       Current Release:   

     Nmap:              $Current_Nmap_version                       ##$Nmap_Message##
     7zip:              $Current_7zip_version                        ##$7zip_Message##

                                  To run all updates, Press '1'
                                  To Run an individual update, type the name of the dependency
                                  To Refer to help documentation on how dependencies need to be updated, type 'help'
"
$option = Read-Host "Select an option"

switch ($option) {
  1 {}
  Nmap { Download_Nmap }
}

}

######################
###Enumeration Menu###
######################

function Enumeration_Menu_1 {
  clear-host
  Write-output "
                       _____  _                                                                      
                      |  __ \(_)                                                                     
                      | |  | |_ ___  ___ _____   _____ _ __ _   _                                    
                      | |  | | / __|/ __/ _ \ \ / / _ \ '__| | | |                                   
                      | |__| | \__ \ (_| (_) \ V /  __/ |  | |_| |                                   
                      |_____/|_|___/\___\___/ \_/ \___|_|   \__, |                 _   _             
                                      |  ____|               __/ |                | | (_)            
                                      | |__   _ __  _   _ _ |___/_   ___ _ __ __ _| |_ _  ___  _ __  
                                      |  __| | '_ \| | | | '_ ` _ \ / _ \ '__/ _` | __| |/ _ \| '_ \ 
                                      | |____| | | | |_| | | | | | |  __/ | | (_| | |_| | (_) | | | |
                                      |______|_| |_|\__,_|_| |_| |_|\___|_|  \__,_|\__|_|\___/|_| |_|
                                                                                 
                                                                                                                                                  
                                Welcome to the Discovery/Enumeration Menu! 
  
                      [1] If you want to gather local information on Host(s,) Please Select 1
                      [2] If you would like to gather Active Directory Info, Please Select 2
                      [3] If you would like to run Nmap Scans, Please Select 3
                      [4] If you would like to run SMB Prowler
                      [B] If you would like to return to the Main Menu, Please Select B
  "
 $EOption = Read-Host "                     Please Choose an option"

  Switch ($EOption) {
      1 { Local_Enumerations_Menu }
      2 { AD_Enumeration_Menu }
      3 { Nmap_network_discovery_menu }
      4 { SMB_Prowler_Menu }
      B { Welcome_Menu }
      Q { Exit }
  }
}



############################
###Local Enumeration Menu###
############################

function Local_Enumerations_Menu {
  clear-host
  Write-output "
   __________________________________________________________________________________
  |##################################################################################|
  |#       __                _    _____                           _   _             #|
  |#      |  |   ___ ___ ___| |  |   __|___ _ _ _____ ___ ___ ___| |_|_|___ ___     #|
  |#      |  |__| . |  _| .'| |  |   __|   | | |     | -_|  _| .'|  _| | . |   |    #|
  |#      |_____|___|___|__,|_|  |_____|_|_|___|_|_|_|___|_| |__,|_| |_|___|_|_|    #|
  |##################################################################################|

              [s] To stage creds, Select S
              [1] To Gather Basic info On a Host (OS/Hostname/ETC), Select 1
              [2] To Gather User Info On a Host, Select 2
              [3] To Gather Network Info On a Host, Select 3
              [4] To Return to the Main Menu, Select 4
              [Q] To Quite, Select Q

  "
  $LEOption = Read-Host "                Please Select an option"

  Switch ($LEOption) {

      2 { Stage_Creds }
      1 { Basic_Host_Info } 
      3 { Get_Local_Network_Info }
      4 { Welcome_Menu }
      Q { Exit }
  }
}


###################
###Documentation###
###################

function Documentation {
  Clear-Host
  Get-Content .\ReadMe.txt
  $Option = Read-Host "Return to the main menu, Press 1"

  switch ($Option) {
   1 { Welcome_Menu }
  }
}

#######################
#Active Directory Menu#
#######################

function AD_Enumeration_Menu {
  Clear-Host
  Write-Output "
  #####################################################################################
  #####################################################################################
  #                   _   _             _____  _               _                      #
  #         /\       | | (_)           |  __ \(_)             | |                     #
  #        /  \   ___| |_ ___   _____  | |  | |_ _ __ ___  ___| |_ ___  _ __ _   _    #
  #       / /\ \ / __| __| \ \ / / _ \ | |  | | | '__/ _ \/ __| __/ _ \| '__| | | |   #
  #      / ____ \ (__| |_| |\ V /  __/ | |__| | | | |  __/ (__| || (_) | |  | |_| |   #
  #     /_/    \_\___|\__|_| \_/ \___| |_____/|_|_|  \___|\___|\__\___/|_|   \__, |   # 
  #            ______                                      _   _                / /   #
  #           |  ____|                                    | | (_)              / /    #
  #           | |__   _ __  _   _ _ __ ___   ___ _ __ __ _| |_ _  ___  _ __           #
  #           |  __| | '_ \| | | | '_ ` _ \ / _ \ '__/ _` | __| |/ _ \| '_ \          #
  #           | |____| | | | |_| | | | | | |  __/ | | (_| | |_| | (_) | | | |         #
  #           |______|_| |_|\__,_|_| |_| |_|\___|_|  \__,_|\__|_|\___/|_| |_|         # 
  #                                                                                   #                                                           
  #####################################################################################
  #####################################################################################

                        [1] Enumerate User Info (IN DEVELOPMENT)
                        [2] Enumerate Group Membership (IN DEVELOPMENT)
                        [3] Enumerate Group Policy Objects (IN DEVELOPMENT)
                        [4] Enumerate AD OU Permissions
                                                                         
"
Do {
  $option = Read-Host "Select what job you would like to run"
} until ($option -eq "1" -or $option -eq "2" -or $option -eq "3" -or $option -eq "4")
switch ($option) {
  4 { Enum_AD_OU_Rights }

}

}

function Nmap_network_discovery_menu {
  clear-host
  Write-Output "
##################################################################################################################################################### 
##          ##          ##           ##          ##          ##  _  _  _   _   _   ___  ##          ##          ##          ##          ##          #
  ##      ##  ##      ##  ##       ##  ##      ##  ##      ## # | \| || \_/ | / \ | o \ # ##      ##  ##      ##  ##      ##  ##      ##  ##      ##
    ##  ##      ##  ##      ##  ##       ##  ##      ##  ##   # | \\ || \_/ || o ||  _/ #   ##  ##      ##  ##      ##  ##      ##  ##      ##  ##
      ##          ##          ##           ##          ##     # |_|\_||_| |_||_n_||_|   #     ##          ##          ##          ##          ##
#####################################################################################################################################################                       
  
                                       [PingScan]     To run a Ping Scan
                                       [PortScan]     To run a Port Scan
                                       [StealthScan]  To run a Stealthy port Scan
                                       [SMBScan]      To run a SMB Security Mode Scan

                                       [Documentation] To read Documentation
                                                                                
"
$global:NOption = read-host "Please Type in the name of the scan you would like to run"

switch ($NOption) {
  PingScan { nmap_scan }
  PortScan { nmap_scan }
  stealthscan { nmap_scan }
  SMBScan { nmap_scan }
  Documentation { nmap_documentation }
}
}

Function SMB_Prowler_Menu {
  Clear-Host
  $Host.UI.RawUI.ForegroundColor = "red"
   Write-Host "  
                                  __   _____ __  __ ____          ____                           
                                 / /  / ____|  \/  |  _ \         / / /                           
                                / /  | (___ | \  / | |_) |       / / /                            
                               < <    \___ \| |\/| |  _ <       / / /                             
                                \ \   ____) | |  | | |_) |     / / /                              
                                 \_\ |_____/|_|__|_|____/     /_/_/  ______                   _              _
                                                             / / /   |  __ \                 | |            \ \  
                                                            / / /    | |__) | __ _____      _| | ___ _ __    \ \ 
                                                           / / /     |  ___/ '__/ _ \ \ /\ / / |/ _ \ '__|    > >
                                                          / / /      | |   | | | (_) \ V  V /| |  __/ |      / / 
                                                         /_/_/       |_|   |_|  \___/ \_/\_/ |_|\___|_|     /_/  
                                                                   
                                                                   
          SMB Prowler is a tool to Discover, Enumerate and Exfiltrate SMB Shares
          With the use of Nmap and powershell
          
          Broken into Phases this tool can be used to do the following
            [1] Phase 1: Discovery
                  First this Phase uses Nmap to discover hosts with smb port 445 open
                  Then it uses net view on each of those hosts to see possible shares it can find

            [2] Phase 2: Enumeration
                  With The data collected during Phase 1,
                  We can start Enumerating (Directories, Files and the contents of Files)
                    You can search for strings within files, or you can open them

            [3] Phase 3: Exfiltration
                  Once you have ran through Discovery and Enumeration, you can find that juicy data and exfiltrate it

            [4] To check Current Jobs

                                                                                         
                                                      
  "
  $option = read-host "select the phase or additional option you would like to run"

  switch ($option) {
    1 { SMB_Phase_1 }
    2 { SMB_Phase_2 }
    3 {}
    4 { Get_SMB_Jobs }

  }
}


                                                                                                                                                                 
                         
                                                                                                                                                                 