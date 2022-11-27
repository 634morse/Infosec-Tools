
##################
###Welcome Menu###
##################

function Welcome_Menu {
    Clear-Host
    write-output "
    #########################################################################################################################
    #########################################################################################################################
      \\                        //         _____              _____    _____  ______           \\                        //
        \\                    //          / ____|     /\     |  __ \  |  __ \|  ____|            \\                    //  
          \\                //           | |         /  \    | |__) | | |__) | |__                 \\                //     
            \\            //             | |        / /\ \   |  _  /  |  ___/|  __|                  \\            //     
              \\        //               | |____ _ / ____ \ _| | \ \ _| |_   | |_____                  \\        //     
                \\    //                  \_____(_)_/    \_(_)_|  \_(_)_(_)  |_____(_)                   \\    // 
                  \\//                                                                                     \\//  
    #########################################################################################################################
    #########################################################################################################################
    Author: Corey Patterson
    Version: 0.1

                        [1] Select '1' to view documentation
                        [2] Select '2' if you want to Run Enumeration
                        [3] Select '3' If you want to take a look at the Random Tools
                        [Q] Select 'Q' If you would like to Quite

    "
    $Option = Read-Host    "                        Please Choose an option"      
    
    Switch ($Option) {
            1 { Documentation }
            2 { Enumeration_Menu_1 }
            Q { Exit }
        }
}

######################
###Enumeration Menu###
######################

function Enumeration_Menu_1 {
  clear-host
  Write-output "
                      ________________________________________________________________________ 
                      |  _____ _   _ _   _ __  __ _____ ____      _  _____ ___ ___  _   _    |
                      |  | ____| \ | | | | |  \/  | ____|  _ \    / \|_   _|_ _/ _ \| \ | |  |
                      |  |  _| |  \| | | | | |\/| |  _| | |_) |  / _ \ | |  | | | | |  \| |  |
                      |  | |___| |\  | |_| | |  | | |___|  _ <  / ___ \| |  | | |_| | |\  |  |
                      |  |_____|_| \_|\___/|_|  |_|_____|_| \_\/_/   \_\_| |___\___/|_| \_|  |
                      |______________________________________________________________________|                                                                   
  ################################## \\ Welcome to the Enumeration Menu! // ################################################
  
                      [1] If you want to gather local information on Host(s,) Please Select 1
                      [2] If you would like to gather Active Directory Info, Please Select 2
                      [B] If you would like to return to the Main Menu, Please Select B
  "
 $EOption = Read-Host "                     Please Choose an option"

  Switch ($EOption) {
      1 { Local_Enumerations_Menu }
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

              [1] To Gather Basic info On a Host (OS/Hostname/ETC), Select 1
              [2] To Gather User Info On a Host, Select 2
              [3] To Gather Network Info On a Host, Select 3
              [4] To Return to the Main Menu, Select 4
              [Q] To Quite, Select Q

  "
  $LEOption = Read-Host "                Please Select an option"

  Switch ($LEOption) {

      1 {Basic_Host_Info}
      3 {Get_Local_Network_Info}
      4 {Welcome_Menu}
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

