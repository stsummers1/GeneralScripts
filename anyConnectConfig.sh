#!/bin/sh
#Uninstall Web Security Module
/opt/cisco/anyconnect/bin/websecurity_uninstall.sh
#
#Uninstall Network Visibility Module
/opt/cisco/anyconnect/bin/nvm_uninstall.sh
#
#Uninstall ISE Posture Module
/opt/cisco/anyconnect/bin/iseposture_uninstall.sh
#
#Uninstall Posture
#/opt/cisco/anyconnect/bin/posture_uninstall.sh
#
#Uninstall Umbrella
/opt/cisco/anyconnect/bin/umbrella_uninstall.sh
#
#Uninstall Dart
/opt/cisco/anyconnect/bin/dart_uninstall.sh
#
#Uninstall AMP Module
/opt/cisco/anyconnect/bin/amp_uninstall.sh
#
#restarts the Cisco client if it was open to remove the security modules 
Cisco=`pgrep -f Cisco`
if [ $Cisco -eq $null ]
then
    open "/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app"/ &
else
    Kill $Cisco
    sleep 3
    open "/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app"/ &
fi