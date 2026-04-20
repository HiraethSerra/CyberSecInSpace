#!/bin/bash
max=0
noisiest=""
for file in logs/*.log; do
  count=$(grep -E "WARN|ERROR" "$file" | wc -l)
  echo "$(basename $file): $count non-INFO events"
  if [ "$count" -gt "$max" ]; then
    max=$count
    noisiest=$(basename $file)
  fi
done
echo "Noisiest satellite: $noisiest ($max non-INFO events)"
