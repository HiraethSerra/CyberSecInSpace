#!/bin/bash

echo "PATTERN REPORT: $1" > reports/pattern_report.txt

for file in logs/*.log
do
count=$(grep -c "$1" "$file")
echo "$(basename "$file"): $count" >> reports/pattern_report.txt
done
