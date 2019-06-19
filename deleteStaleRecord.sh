#!/bin/bash
#
# deleteStaleRecord.sh
# Written by Steve Summers
##########
# This script will query the Jamf server for all machine records assigned
# to a user, then you select one of them to delete, then the record is 
# deleted from the database.
##########
# The person running it must have API read and write permissions
# in the Jamf server.
##########

jamfURL="https://<jssURL>:8443/JSSResource"

# this step prompts the person running it for their credentials
read -p 'Enter your user Name: ' <jamfUser>
read -sp 'Enter your password (cursor will not move): ' <jamfpass>
echo
echo "Enter first.last name of the customer to search: "${compName}" "
read compName

# here we take the info entered above and parse it via the Jamf API to search
# for the assigned computer(s).  
declare -a apiData=( $( /usr/bin/curl -s \
--user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request GET \
$jamfURL/computers/match/name/$compName | \
/usr/bin/xmllint --format - | \
/usr/bin/grep -e "<name>" | \
/usr/bin/awk -F "<name>|</name>" '{ print $2 }' ) )

# Once we find the info, the computername is diplayed via select as 1) 2) and so on
echo Which one do you want to delete?
select name in ${apiData[@]}:
do
	deleteMe=$name
	break
done

# Once the choice is made, it's then sent back up to the Jamf API for deletion
echo Deleting $deleteMe ...
# END NEW ADDITION

computerID=$( /usr/bin/curl -s \
--user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request GET \
$jamfURL/computers/name/$deleteMe \ | \
/usr/bin/xmllint --format - | \
/usr/bin/xpath "/computer/general/id" | \
/usr/bin/grep -e "<id>" | \
/usr/bin/awk -F "<id>|</id>" '{ print $2 }')

/usr/bin/curl -s \
--user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request DELETE \
$jamfURL/computers/id/$computerID > /dev/null

# Confirmation that the selected computername has been removed from the Jamf DB.
echo Done. $deleteMe has been removed from inventory. You may now close the window.