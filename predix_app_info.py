#!/usr/bin/python

### This script is used to login predix and view specifc app health status and recent log ####

from __future__ import print_function
import subprocess
import os
import re
import getpass
import sys
import shlex


email = raw_input("Please Enter your user mail id: \n")
if not re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", email):
    print ("Error! Only valid email id is allowed!")
    sys.exit()
Pass = getpass.getpass(prompt= "Please enter your password: \n")
URL = raw_input("Please Enter your predix url with https: \n")

URL_login = 'cf login -a ' + URL + '  -u ' + email + ' -p ' + Pass
args = shlex.split(URL_login)
subprocess.call(args)
os.system('cf apps')

app_name = raw_input("Please Enter your app name: \n")

def get_app_status():
	command = 'cf app ' + app_name 
	arg1 = shlex.split(command)
	subprocess.call(arg1)

def get_app_log():
       print ("This will show only recent logs: \n")
       log_cmd = 'cf logs ' + app_name + ' --recent '
       arg2 = shlex.split(log_cmd)
       subprocess.call(arg2)      

if __name__ == '__main__':
	get_app_status()
        get_app_log()

