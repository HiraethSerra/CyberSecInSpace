#!/bin/bash

files=0
entries=0
info=0
warn=0
error=0
top=""
max=0

for file in $1
do
files=$((files + 1))

lines=$(wc -l < "$file")
entries=$((entries + lines))

i=$(grep -c INFO "$file")
w=$(grep -c WARN "$file")
e=$(grep -c ERROR "$file")

info=$((info + i))
warn=$((warn + w))
error=$((error + e))

if [ "$e" -gt "$max" ]
then
max=$e
top=$(basename "$file")
fi
done

echo "MISSION REPORT" > reports/mission_report.txt
echo "Processed files: $files" >> reports/mission_report.txt
echo "Total entries: $entries" >> reports/mission_report.txt
echo "INFO: $info" >> reports/mission_report.txt
echo "WARN: $warn" >> reports/mission_report.txt
echo "ERROR: $error" >> reports/mission_report.txt
echo "Most unstable log: $top" >> reports/mission_report.txt
