#!/bin/bash

for file in logs/*.log
do
count=$(grep -c ERROR "$file")

if [ "$count" -eq 0 ]
then
basename "$file"
fi
done
