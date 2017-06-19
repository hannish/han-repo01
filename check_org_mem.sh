#!/bin/sh

echo "This script used to check the over all memory in use by Org's in PREDIX-US-WEST(AWS)"

echo 1 | cf login -a https://api.system.aws-usw02-pr.ice.predix.io -u 212627439@mail.ad.ge.com -p ILiv3@b3ngal0re

org1=`cf curl /v2/organizations | jq -r '.resources[].entity.name' | awk NR==1`
org2=`cf curl /v2/organizations | jq -r '.resources[].entity.name' | awk NR==2`

if [ $org1 == "POA_West" ];
then
 mem_check_1=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb' | awk NR==1`
 echo "**************"
 echo "current memory usage for ${org1} in mb : ${mem_check_1}"
 echo "**************"
 if [ $org2 == "Oil&Gas_Product_Demo" ];
 then
   mem_check_2=`cf curl /v2/organizations | jq -r '.resources[].metadata.url' | xargs -I %s cf curl %s/memory_usage | jq -r '.memory_usage_in_mb' | awk NR==2`
   echo "**************"
   echo "current memory usage for ${org2} in mb : ${mem_check_2}"
   echo "**************"
 else
   echo "Org not present"
 fi
else
  echo "Org not present"
fi

echo "logging out from org's"
cf logout
