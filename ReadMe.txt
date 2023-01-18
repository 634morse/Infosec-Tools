![Alt text](url "https://github.com/634morse/Infosec-Tools/blob/main/Dependencies/Icon/Piranha-Fish-PNG-Picture.png")

C.A.R.P.E.
"Corey's Attack, Red-Team, Pentest, Enumeration Tool"

Overall Objective:
    As I learn and build scripts to automate/perform various tasks that Enumerate and test an infrastructures security posture,
    I want to include them in a platform that will allow others to run them on demand without having to rewrite them.
    The goal of this tool is to also allow the user to run these tools without having to install any extra dependencies outside the github package.
    Things like Nmap/AD RSAT modules/powercat/etc will be included in this repo.

Design:
    The Current Design of this Tool is to build everything (Custom menus/commands) into functions, so that all "C.A.R.P.E." needs to do find and 
    import them. As for third party Modules/Software, C.A.R.P.E. will be able to import/call them as well.

    C.A.R.P.E.ps1
       1: First the script will run a get-childitem to see if there is shorcut created for it, if not it will create one.
          This will configure with the start path, target, icon and argument to run with powershell, allowing double-clicking
       2: Then the script sets all of the window settings (size, backround/foreground color, title name,etc)
       3: Next it will set global paramaters and the current shells env path to add Nmap
       4: Cleans the temp folder from past runs
       5: gets all modules and imports them
       6: runs update check functions
       7: Starts the Welome Menu


Local Enumeration:
