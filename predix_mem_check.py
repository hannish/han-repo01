#!/usr/bin/env python

from subprocess import check_output
import json
import subprocess
import os
#import re
#import getpass
#import sys
#import shlex

#URL = raw_input("Please Enter your predix url with https: \n")
#email = raw_input("Please Enter your user mail id: \n")
#if not re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", email):
#    print ("Error! Only valid email id is allowed!")
#    sys.exit()
#Pass = getpass.getpass(prompt= "Please enter your password: \n")

#URL_login = 'echo 1 | cf login -a ' + URL + '  -u ' + email + ' -p ' + Pass
#args = shlex.split(URL_login)
#subprocess.call(args, shell=True)

orgs = json.loads(check_output(['cf', 'curl', '/v2/organizations']).decode('utf8'))

def mem_check():
   for org in orgs['resources']:
       name = org['entity']['name']
       guid = org['metadata']['guid']
       quota_url = org['entity']['quota_definition_url']
       quota = json.loads(check_output(['cf', 'curl', quota_url]).decode('utf8'))
       quota_memory_limit = quota['entity']['memory_limit']
       used = json.loads(check_output(['cf', 'curl', '/v2/organizations/' + guid + '/memory_usage']).decode('utf8'))['memory_usage_in_mb']
       quota_limit = 0
       if ( used >= quota_limit ):
          #print "Org " + name + " is using " + str(used / 1024) + "GB of " + str(quota_memory_limit / 1024) + "GB memory (" + str(100 * used / quota_memory_limit) + "%) of org quota"
           print "high memory usage by Org " + name + " is using " + str(used / 1024) + "GB"
       elif (used <= quota_limit):
          print "low memory usage by Org " + name + " is using " + str(used / 1024) + "GB"
          #print "low memory usage by Org " + name + " is using " + str(used / 1024) + "GB of " + str(quota_memory_limit / 1024)
       else: 
           print "bye"

if __name__ == '__main__':
      mem_check()
