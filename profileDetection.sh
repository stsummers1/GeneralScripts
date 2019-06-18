#!/bin/bash

if [[ -e '/Library/Managed Preferences/com.nameof.customconfig.plist' ]] 
then
	jamf policy -id <policyID>
	exit 0
else
	echo "User does not have Config Profile, exiting..."
	exit 1
fi