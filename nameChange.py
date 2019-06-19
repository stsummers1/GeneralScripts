#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 21 13:34:02 2018

@author: steve.summers
"""

import easygui
import subprocess
#boxes prompting name and to chose either Staff or Contractor
userName = easygui.enterbox("What is your name?", title = "Enter Name:" )
userType = easygui.buttonbox("Are you a Staff Member or Contractor?\n Choose from below:", title = "Employee Type", choices = ['CFA Staff', 'Contractor'])
#need to confirm the customer didn't misspell the name they entered
if easygui.ynbox (title = "Confirm" , msg = "You entered " + userName + "\n Is this correct?", choices =('Yes', 'No')):
    pass
#this runs if they selected NO above and they reenter their name
else:
    userName = easygui.enterbox("Re-Enter your name: ", title = "Enter Name:" )
    if easygui.ynbox (title = "Confirm" , msg = "You entered " + userName + "\n Is this correct?", choices =('Yes', 'No')):
        pass
#confirmation box for contractor/staff choice
easygui.ynbox (title = "Confirm" , msg = "You picked " + userType + "\n Is this correct?", choices =('Yes', 'No'))
if userType == 'Contractor':
#concatenates contractor prefix with userName string
    newuserName = 'cm7'+userName
#removes spaces between first and last name
    newuserName = newuserName.replace(' ', '')
#makes upper case characters lower case
    finaluserName = newuserName.lower()
#slices the name string off at fifteen characters
    finaluserName = finaluserName[:15]

else:
#concatenates staff prefix with userName string
    newuserName = 'sm7'+userName
#removes spaces between first and last name
    newuserName = newuserName.replace(' ', '')
#makes upper case characters lower case
    finaluserName = newuserName.lower()
#slices the name string off at fifteen characters   
    finaluserName = finaluserName[:15]
    
result = subprocess.call(['/usr/sbin/scutil', '--set', 'ComputerName', finaluserName])
result = subprocess.call(['/usr/sbin/scutil', '--set', 'HostName', finaluserName])
result = subprocess.call(['/usr/sbin/scutil', '--set', 'LocalHostName', finaluserName])