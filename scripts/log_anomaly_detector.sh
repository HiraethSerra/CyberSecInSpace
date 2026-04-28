#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <ERROR_THRESHOLD>"
  exit 1
fi

threshold=$1
max=0
most_unstable=""

echo "Processing log files..."

for file in logs/*.log; do
  name=$(basename "$file")
  count=$(grep ERROR "$file" | wc -l)
  echo "$name: $count ERROR entries"
  if [ "$count" -gt "$threshold" ]; then
    echo "ALERT: log anomaly detected in $name"
  fi
  if [ "$count" -gt "$max" ]; then
    max=$count
    most_unstable=$name
  fi
done

echo "Most unstable log file: $most_unstable ($max ERROR entries)"
