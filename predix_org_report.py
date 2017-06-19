#!/usr/bin/env python

from subprocess import check_output
import json
import subprocess
import os
import re
import getpass
import sys
import shlex

URL = raw_input("Please Enter your predix url with https: \n")
email = raw_input("Please Enter your user mail id: \n")
if not re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", email):
    print ("Error! Only valid email id is allowed!")
    sys.exit()
Pass = getpass.getpass(prompt= "Please enter your password: \n")

URL_login = 'echo 1 | cf login -a ' + URL + '  -u ' + email + ' -p ' + Pass
args = shlex.split(URL_login)
subprocess.call(args, shell=True)

orgs = json.loads(check_output(['cf', 'curl', '/v2/organizations']).decode('utf8'))
appcount = 0
appinstancecount = 0
for org in orgs['resources']:
    name = org['entity']['name']
    guid = org['metadata']['guid']
    quota_url = org['entity']['quota_definition_url']
    quota = json.loads(check_output(['cf', 'curl', quota_url]).decode('utf8'))
    quota_memory_limit = quota['entity']['memory_limit']
    used = json.loads(check_output(['cf', 'curl', '/v2/organizations/' + guid + '/memory_usage']).decode('utf8'))['memory_usage_in_mb']
    print "Org " + name + " is using " + str(used / 1024) + "GB of " + str(quota_memory_limit / 1024) + "GB memory (" + str(100 * used / quota_memory_limit) + "%) of org quota"
    spaces_url = org['entity']['spaces_url']
    spaces = json.loads(check_output(['cf', 'curl', spaces_url]).decode('utf8'))
    for space in spaces['resources']:
        apps_url = space['entity']['apps_url']
        consumed = 0
        apps = json.loads(check_output(['cf', 'curl', apps_url]).decode('utf8'))
        for app in apps['resources']:
            instances = app['entity']['instances']
            memory = app['entity']['memory']
            consumed += (instances * memory)
            appcount = appcount + 1
            appinstancecount = appinstancecount + instances
        print "\tSpace " + space['entity']['name'] + " is using " + str(consumed / 1024) + "GB memory (" + str(100 * consumed / quota_memory_limit) + "%) of org quota"
        if len(apps['resources']) > 0:
            print "\t\t running " + str(len(apps['resources'])) + " apps with " + str(instances * len(apps['resources'])) + " instances"
print "\nYou are running " + str(appcount) + " apps in all orgs, with a total of " + str(appinstancecount) + " instances"
