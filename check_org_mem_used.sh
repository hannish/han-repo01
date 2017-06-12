#!/bin/sh

echo "This script used to check the over all memory in use by Org's in PREDIX Acc"

echo "Enter URL:"
read url
echo "Enter UserName:"
read user
echo "Enter Password"
stty -echo
read pwd
stty echo

echo 1 | cf login -a ${url} -u ${user} -p ${pwd}

org1=`cf curl /v2/organizations | jq -r '.resources[].entity.name' | awk NR==1`
a="$org1"
echo "$org1"
org2=`cf curl /v2/organizations | jq -r '.resources[].entity.name' | awk NR==2`
b="$org2"
echo "$org2"

if [ $a == "$org1" ] || [ $b == "$org2" ];
then
   mem_check_1=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb' | awk NR==1`
   echo "**************"
   echo "current memory usage for ${org1} org in mb : ${mem_check_1}"
   echo "**************"
   
   mem_check_2=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb' | awk NR==2`
   echo "**************"
   echo "current memory usage for ${org2} org in mb : ${mem_check_2}"
   echo "**************"

else
  echo "Org not present"
fi

echo "logging out from org's"
cf logout
