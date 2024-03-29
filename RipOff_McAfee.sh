#!/usr/bin/env bash

## HEADER


## DEFINITIONS


## FUNCTIONS

grabConsoleUserAndHome(){

	# don't assume the home folder is equal to the user's name

	currentUser=""
	homeFolder=""

	currentUser=$(stat -f %Su "/dev/console")
	homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed 's/^ *//'| tr -d '\n')

}


removeMcAfee(){

	bolRunARecon=true

	grabConsoleUserAndHome

	## ARRAYS

	McAfeeKernelExtensions=(
		'/usr/local/McAfee/AntiMalware/Extensions/AVKext.kext'
		'/usr/local/McAfee/AppProtection/Extensions/AppProtection.kext'
		'/usr/local/McAfee/StatefulFirewall/Extensions/SFKext.kext'
		'tocal/McAfee/fmp/Extensions/FMPSysCore.kext'
		'/usr/local/McAfee/fmp/Extensions/FileCore.kext'
		'/usr/local/McAfee/fmp/Extensions/NWCore.kext'
		)

	McAfeeLaunchDaemons=(
		'/Library/LaunchDaemons/com.mcafee.agent.cma.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.Eupdate.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist'
		'/Library/LaunchDaemons/com.mcafee.virusscan.fmpd.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.ma.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macmn.plist'
		'/Library/LaunchDaemons/com.mcafee.agent.macompat.plist'
		)

	McAfeeFiles=(
		'/etc/cma.conf'
		'/Library/LaunchDaemons/com.mcafee.agent.cma.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.Eupdate.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist'
		'/Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist'
		'/Library/LaunchDaemons/com.mcafee.virusscan.fmpd.plist'
		'/Library/LaunchAgents/com.mcafee.menulet.plist'
		'/Library/LaunchAgents/com.mcafee.reporter.plist'
		'/Library/Preferences/.com.mcafee.StatefulFirewall.license'
		'/Library/Preferences/.com.mcafee.antimalware.license'
		'/Library/Preferences/.com.mcafee.appprotection.license'
		'/Library/Preferences/com.mcafee.ssm.StatefulFirewall.plist'
		'/Library/Preferences/com.mcafee.ssm.antimalware.plist'
		'/Library/Preferences/com.mcafee.ssm.appprotection.plist'
		'/var/log/McAfeeSecurity.log'
		'/private/var/db/receipts/com.mcafee.agent.pkg.bom'
		'/private/var/db/receipts/com.mcafee.agent.pkg.plist'
		'/private/var/db/receipts/com.mcafee.epm.pkg.bom'
		'/private/var/db/receipts/com.mcafee.epm.pkg.plist'
		'/private/var/db/receipts/com.mcafee.mscui.bom'
		'/private/var/db/receipts/com.mcafee.mscui.plist'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.bom'
		'/private/var/db/receipts/com.mcafee.pkg.StatefulFirewall.plist'
		'/private/var/db/receipts/com.mcafee.ssm.appp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.appp.plist'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.bom'
		'/private/var/db/receipts/com.mcafee.ssm.fmp.plist'
		'/private/var/db/receipts/com.mcafee.virusscan.bom'
		'/private/var/db/receipts/com.mcafee.virusscan.plist'
		'/etc/cma.conf'
		'/Library/Receipts/cma.pkg'
		)

	McAfeeFolders=(
		
		'/Library/McAfee'
		'/Library/StartupItems/cma'
		'/private/etc/cma.d'
		'/private/etc/ma.d'
		'/Library/Application Support/McAfee'
		'/Applications/McAfee Endpoint Protection for Mac.app'
		'/Applications/McAfee Endpoint Security for Mac.app'
		'/Library/Documentation/Help/McAfeeSecurity_AVOnly.help'
		'/Library/Documentation/Help/McAfeeSecurity_ApplicationProtection.help'
		'/Library/Documentation/Help/McAfeeSecurity_Firewall.help'
		'/usr/local/McAfee'
		'/private/var/McAfee'
		)	

	if [[ "$currentUser" != "root" ]]; then
	
		su - $currentUser -c 'launchctl unload /Library/LaunchAgents/com.mcafee.menulet.plist'
		su - $currentUser -c 'launchctl unload /Library/LaunchAgents/com.mcafee.reporter.plist'
		su - $currentUser -c 'killall "McAfee Endpoint Protection for Mac"'
		su - $currentUser -c 'killall "McAfee Endpoint Security for Mac"'
		sleep 5

	fi

	#Stop StartupItems
	/Library/StartupItems/cma/cmamesh forcestop

	#Unload all LaunchDaemons from array McAfeeLaunchDaemons
	for EachFile in "${McAfeeLaunchDaemons[@]}"; do
		[[ -e "$EachFile" ]] && launchctl unload "$EachFile" && echo "Unloading $EachFile"
	done

	#Unload all Kernel Extensions
	for EachFile in "${McAfeeKernelExtensions[@]}"; do
		[[ -e "$EachFile" ]] && kextunload "$EachFile" > /dev/null 2>&1 && echo "Unloading $EachFile" && sleep 5
	done

	#Delete all files from array McAfeeFiles
	for EachFile in "${McAfeeFiles[@]}"; do
		[[ -e "$EachFile" ]] && rm -f "$EachFile" && echo "Deleting $EachFile"
	done

	#Delete all folders from array McAfeeFolders
	for EachFolder in "${McAfeeFolders[@]}"; do
		[[ -e "$EachFolder" ]] && rm -rf "$EachFolder" && echo "Deleting $EachFolder"
	done

	#Delete all LaunchDaemons from array McAfeeLaunchDaemons
	for EachFile in "${McAfeeLaunchDaemons[@]}"; do
		echo $EachFile 
		[[ -e "$EachFile" ]] && rm -f "$EachFile" && echo "Deleting $EachFile"
	done

	#Unload all Kernel Extensions
	for EachFile in "${McAfeeKernelExtensions[@]}"; do
		[[ -e "$EachFile" ]] && rm -rf "$EachFile" > /dev/null 2>&1 && echo "Deleting $EachFile"
	done

	#If above 10.6 forget package receipt
	pltvrsn=`/usr/bin/sw_vers | grep ProductVersion | cut -d: -f2`
	majvrsn=`echo $pltvrsn | cut -d. -f1`
	minvrsn=`echo $pltvrsn | cut -d. -f2`
	if (($majvrsn>=10 && $minvrsn>=6)); then
		echo "Forgetting McAfee Agent package..."
		/usr/sbin/pkgutil --forget comp.nai.cmamac > /dev/null 2>&1 
	fi

	dscl . -delete /Users/mfe

	dscl . -delete /Groups/mfe

	dscl . -delete /Groups/Virex

	killall -c Menulet

}


## BODY

removeMcAfee

#jamf policy -event <Your event name to install new goes here>


## FOOTER
exit 0