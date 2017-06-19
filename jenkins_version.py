#!/usr/bin/python

import sys
import getpass
from jenkinsapi.jenkins import Jenkins
from jenkinsapi.job import *
from jenkinsapi.build import *


def get_server_instance():
    jenkins_url = 'https://predix1.jenkins.build.ge.com/job/Oil_and_Gas_Digital/job/CloudOps-Jobs/'
    server = Jenkins(jenkins_url, username='212627439', password='d8a63653b09121019b69e33dad1982bb')
    return server

if __name__ == '__main__':
    print get_server_instance().version
