#!/bin/bash

if [[ -e '/Library/Managed Preferences/com.cfa.customconfig.plist' ]] 
then
	jamf policy -id 2575
	exit 0
else
	echo "User does not have Config Profile, exiting..."
	exit 1
fi