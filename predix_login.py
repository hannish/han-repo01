#!/usr/bin/python

from __future__ import print_function
import subprocess
import os
import re
import getpass
import sys
import shlex


User = raw_input("Please Enter your user name: \n").lower()
if not re.match("^[a-zA-Z0-9!@#$&()\\-`.+,/\"]*$", User):
    print ("Error! Only valid email id is allowed!")
    sys.exit()
Pass = getpass.getpass(prompt= "Please enter your password: \n")

URL = raw_input("Please Enter your predix url with https: \n")
URL_login = 'cf login -a ' + URL + '  -u ' + User.lower() + ' -p ' + Pass 

####URL_login = 'cf login -a https://api.system.asv-pr.ice.predix.io -u ' + User.lower() + ' -p ' + Pass

args = shlex.split(URL_login)
subprocess.call(args)
os.system('cf apps > apps.txt')

with open("apps.txt") as origin_file:
	result = []
	for line in origin_file:
		if 'name' in line:
			result.append(line)
			print(line)


def get_app_info(app):
	User = raw_input("Please Enter your user name: \n").lower()
	if not re.match("^[a-zA-Z0-9!@#$&()\\-`.+,/\"]*$", User):
    	print ("Error! Only valid email id is allowed!")
    	sys.exit()
	Pass = getpass.getpass(prompt= "Please enter your password: \n")

	URL = raw_input("Please Enter your predix url with https: \n")
	URL_login = 'cf login -a ' + URL + '  -u ' + User.lower() + ' -p ' + Pass

	args = shlex.split(URL_login)
	subprocess.call(args)

if __name__ == '__main__':
	#os.system('cf apps')
        os.system('cf app '')
