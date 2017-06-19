#!/bin/bash

echo 1 | cf login -a https://api.system.asv-pr.ice.predix.io -u ${CFUSER} -p ${CFPSWD} https_proxy="https://proxy-src.research.ge.com:8080"

filename="/opt/jenkins_build/workspace/Oil_and_Gas_Digital/CloudOps-Jobs/Predix-COLO_Org_Memory_Usage_Monitoring/monitoring_scripts/"

chmod +x $filename/Predix-COLO_Org_Memory_Usage_Monitoring.py

touch $filename/report.txt

python $filename/Predix-COLO_Org_Memory_Usage_Monitoring.py >> $filename/report.txt

cat $filename/report.txt | awk '{ print $2,$3,$4,$11 }' | grep -v "is using"  >> $filename/data1.txt
cat $filename/report.txt | awk '{ print $2,$9 }' | grep -v "OnG 600GB" >> $filename/data2.txt

high_mem="80"
flag=0
while read i; do
 set +e
 org1=$(echo "$i" | awk '{ print $1 }')
 pre1=$(echo "$i" | awk '{ print $2 }' | tr -d '%')
  if [ "$pre1" -ge "$high_mem" ]
  then
    echo "$org1 is having high memory as $pre1%"
    flag=1
  else
    echo "$org1 memory under capacity as $pre1%"
  fi
done <<< "$(cat $filename/data2.txt)"

while read j; do
 set +e
 org2=$(echo "$j" | awk '{ print $1,$2,$3 }')
 pre2=$(echo "$j" | awk '{ print $4 }' | tr -d '%')
  if [ "$pre2" -ge "$high_mem" ]
  then
    echo "$org2 is having high memory as $pre2%"
    flag=1
  else
    echo "$org2 memory under capacity as $pre2%"
  fi
done <<< "$(cat $filename/data1.txt)"

echo "code=$flag"
exit $flag
echo "--"
