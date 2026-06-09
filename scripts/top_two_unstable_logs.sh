#!/bin/bash

for file in logs/*.log
do
count=$(grep -c ERROR "$file")
echo "$count $(basename "$file")"
done | sort -nr | head -2
