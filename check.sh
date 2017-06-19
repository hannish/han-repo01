#!/bin/bash

/usr/bin/python Predix-COLO_Org_Memory_Usage_Monitoring.py >> report.txt

cat report.txt | awk '{ print $2,$3,$4,$11 }' | grep -v "is using"  >> data1.txt
cat report.txt | awk '{ print $2,$9 }' | grep -v "OnG 600GB" >> data2.txt

high_mem="80"
flag=0
while read i; do
 set +e
 org1=$(echo "$i" | awk '{ print $1 }')
 pre1=$(echo "$i" | awk '{ print $2 }' | tr -d '%')
  if [ "$pre1" -ge "$high_mem" ]
  then
    echo "$org1 is having high memory as $pre1"
    flag=1
  else
    echo "$org1 memory under capacity as $pre1"
  fi
done <<< "$(cat data2.txt)"

while read j; do
 set +e
 org2=$(echo "$j" | awk '{ print $1,$2,$3 }')
 pre2=$(echo "$j" | awk '{ print $4 }' | tr -d '%')
  if [ "$pre2" -ge "$high_mem" ] 
  then
    echo "$org2 is having high memory as $pre2"
    flag=1
  else
    echo "$org2 memory under capacity as $pre2"
  fi
done <<< "$(cat data1.txt)"

echo "code =$flag"

rm *.txt
