function Welcome_Menu {
    Clear-Host
    #$Host.UI.RawUI.BackgroundColor = $black
    #$host.ui.RawUI.ForegroundColor = “darkgreen”
write-output "#########################################################################################################################"
Write-Output "#########################################################################################################################"
Write-output "  \\                        //         _____              _____    _____  ______           \\                        //  "
Write-output "    \\                    //          / ____|     /\     |  __ \  |  __ \|  ____|            \\                    //    "
Write-output "      \\                //           | |         /  \    | |__) | | |__) | |__                 \\                //      "
Write-output "        \\            //             | |        / /\ \   |  _  /  |  ___/|  __|                  \\            //        "
Write-output "          \\        //               | |____ _ / ____ \ _| | \ \ _| |_   | |_____                  \\        //          "
Write-output "            \\    //                  \_____(_)_/    \_(_)_|  \_(_)_(_)  |_____(_)                   \\    //            "
Write-output "              \\//                                                                                     \\//              "
write-output "#########################################################################################################################"
write-output "#########################################################################################################################"
#$host.ui.RawUI.ForegroundColor = “Magenta”
write-output "Author: Corey Patterson"
Write-output "Version: 0.1"
write-output "                                       "
Write-output "##########################################  \\Tool Usage//  #############################################################"
Write-output "##########################################  This is a 'Jack of all trades tool'.  #######################################"
write-output "#The Goal is anything we find use running 'by automation or manually', this tools serves as a place to consolidate those#
#tools into a single package. These can be used for small use cases or running something at scale.                     ##
#########################################################################################################################"
#$host.ui.RawUI.ForegroundColor = “Blue”

write-output "                                                                                     "
write-output "                     [1] Select '1' If you want to Install All prereqs               "
Write-output "                     [2] Select '2' if you want to use Enumeration Tools             "
write-output "                     [3] Select '3' If you want to take a look at the Random Tools   "
write-output "                     [Q] Select 'Q' If you would like to Quite                       "
write-output "                                                                                     " 
write-output "                                                                                     "
write-output "                                                                                     "
$Option = Read-Host    "                     Please Choose an option                               "      
    
Switch ($Option) {
        2 { Enumeration_Menu_1 }
        Q { Exit }
    }
}