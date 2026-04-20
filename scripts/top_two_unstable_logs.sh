#!/bin/bash
for file in logs/*.log; do
  count=$(grep ERROR "$file" | wc -l)
  echo "$count $(basename $file)"
done | sort -rn | head -2 | awk '{print $2": "$1" ERROR events"}'
