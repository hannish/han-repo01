#!/bin/sh

echo "This script used to check the over all memory in use by Org's in PREDIX-US-WEST(AWS)"

echo "Enter URL:"
read url
echo "Enter UserName:"
read user
echo "Enter Password"
stty -echo
read pwd
stty echo

echo 1 | cf login -a ${url} -u ${user} -p ${pwd}

getOrg=`cf curl /v2/organizations | jq -r '.resources[].entity.name'`
echo "$getOrg"

for org in "$getOrg"
do
 mem_check=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb'`
 echo "**************"
 echo "current memory usage for ${org} org in mb : ${mem_check}"
 echo "**************"  
done

echo "logging out from org's"
cf logout
