#!/bin/bash
#Written by Steve Summers
#ifconfig is searching for a connection to the VPN.  If a device
#is connected, the IP variable will contain the IP address.  If a device is not
#connected, it does not return anything.  

#You'll need to input the first 2 octets of your institutions IP range when a
#device is connected.
IP=$(ifconfig | grep -E '(10\.octet1|10\.octet2)' -A 3 -B 1)

#This is a simple test condition, if IP is false (no return value) 
#else the return is true. False = uninstall : True = active VPN, quit.
if [[ -z $IP ]]; then
	echo "VPN Not Connected, uninstalling..."
#this calls the silent uninstaller.  we don't use the one in applications
	sudo /opt/cisco/anyconnect/bin/anyconnect_uninstall.sh
	sleep 15
#policy to install the new VPN
	jamf policy -id <policyID>
	exit 0
else
	echo "VPN Connected, exiting..."
	exit 1
fi