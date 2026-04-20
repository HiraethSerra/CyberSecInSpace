#!/bin/bash

top=""
best=0

for file in logs/*.log
do
total=$(wc -l < "$file")
errors=$(grep -c ERROR "$file")

rate=$((errors * 100 / total))

echo "$(basename "$file"): $rate%"

if [ "$rate" -gt "$best" ]
then
best=$rate
top=$(basename "$file")
fi
done

echo "Highest: $top"
