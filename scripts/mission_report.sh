#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <file_pattern>"
  exit 1
fi
pattern=$1
files=($pattern)
file_count=${#files[@]}
total=$(cat $pattern | wc -l)
infos=$(grep INFO $pattern | wc -l)
warns=$(grep WARN $pattern | wc -l)
errors=$(grep ERROR $pattern | wc -l)

max=0
most_unstable=""
for file in $pattern; do
  count=$(grep ERROR "$file" | wc -l)
  if [ "$count" -gt "$max" ]; then
    max=$count
    most_unstable=$(basename $file)
  fi
done

{
  echo "MISSION REPORT"
  echo "Processed files: $file_count"
  echo "Total entries: $total"
  echo "INFO: $infos"
  echo "WARN: $warns"
  echo "ERROR: $errors"
  echo "Most unstable log: $most_unstable"
} > reports/mission_report.txt
cat reports/mission_report.txt
