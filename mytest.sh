#!/bin/bash -x

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

while read -r line; do
 set +e
 echo $line
 a="$line"
   if [ $a == $line ]; then
     	mem_check=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb'`
     	echo "**************"
     	echo "current memory usage for ${line} org in mb : ${mem_check}"
    	echo "**************"
   else
     echo "Org not present"
   fi 
done <<< "$(cf curl /v2/organizations | jq -r '.resources[].entity.name')"
     
echo "logging out from org's"
cf logout
