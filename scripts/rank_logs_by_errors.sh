#!/bin/bash
for file in logs/*.log; do
  count=$(grep ERROR "$file" | wc -l)
  echo "$count $(basename $file)"
done | sort -rn | awk '{print $2": "$1}'
