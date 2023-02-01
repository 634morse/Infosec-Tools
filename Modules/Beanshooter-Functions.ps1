
Function Set_Beanshooter_var {
    $jar = get-childitem .\Dependencies\Beanshooter | where-object { $_.name -match "bean" } | select name
    $jar = $jar.name
    $global:beanshooter = ".\dependencies\beanshooter\$jar"
}

Function Beanshooter_Help {
    Clear-Host
    Write-output "
    As C.A.R.P.E. does with a lot of the third party tools included, these functions
    take use of Beanshooter to run JMX enumerations and attacks.

    The use of the tool is not as extensive and does not use all available functions,
    but provides ease of use through easy to answer fields, and integrates the tool with others
    in one interface. 

    requests can be made for additional functionality

    [1] Enumerate for possible JMX vulnerabilities
        This option takes use of the enum option to enumerate some config settings to see if things 
        such as authentication and pre authenticated arbitrary deserialization are misconfigured.
        https://github.com/qtc-de/beanshooter#enum

    [2] Deploy TonkaBean and create a command shell
        This option takes use of the 'deploy' option to first deploy an MBean to the destined JXM service,
        then uses the tonka shell option to gain a shell on the host.
        https://github.com/qtc-de/beanshooter#generic-deploy
        https://github.com/qtc-de/beanshooter#tonka-shell

    "
    $option = Read-Host "Press any button to return"
    Beanshooter_Menu
}
Function bn_jmx_vuln_enum {
    $ips = read-host "
                    Enter the host(s) you would like to test
                    "
    $port = read-host "
                    Enter the port you want to test
                    "
    foreach ( $ip in $ips) {
        $global:Bean_enum = java -jar $beanshooter enum $ip $port
    }
}