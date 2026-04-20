#!/bin/bash

top=""
max=0

for file in logs/*.log
do
warn=$(grep -c WARN "$file")
error=$(grep -c ERROR "$file")
total=$((warn + error))

if [ "$total" -gt "$max" ]
then
max=$total
top=$(basename "$file")
fi
done

echo "$top"
