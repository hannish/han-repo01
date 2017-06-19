#!/bin/bash

echo 1 | cf login -a https://api.system.asv-pr.ice.predix.io -u ${CFUSER} -p ${CFPSWD} https_proxy="https://proxy-src.research.ge.com:8080"

filename="/opt/jenkins_build/workspace/Oil_and_Gas_Digital/CloudOps-Jobs/Predix-COLO_Org_Memory_Usage_Monitoring/monitoring_scripts/"

chmod +x $filename/Predix-COLO_Org_Memory_Usage_Monitoring.py

touch $filename/report.txt

python $filename/Predix-COLO_Org_Memory_Usage_Monitoring.py >> $filename/report.txt

high_mem="80"
flag=0
while read i; do
 set +e
 org=$(echo $i | awk '{ print $1 }')
 pre=$(echo $i | awk '{ print $2 }' | tr -d '%')
  if [ "$pre" -ge "$high_mem" ]
  then
    echo "$org is having high memory as $pre%"
    flag=1
  else
    echo "$org memory under capacity"   
  fi   	    	
done <<< "$(grep "^Org" $filename/report.txt|while read i; do org=`echo $i|cut -f2 -d' '`; perc=`echo $i|cut -f9 -d' '`; echo "$org" "$perc"; done)"

echo "code=$flag"
exit $flag
echo "--"
