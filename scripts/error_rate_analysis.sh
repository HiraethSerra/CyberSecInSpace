#!/bin/bash
max_rate=0
most_unstable=""
for file in logs/*.log; do
  total=$(wc -l < "$file")
  errors=$(grep ERROR "$file" | wc -l)
  if [ "$total" -gt 0 ]; then
    rate=$(echo "scale=4; $errors / $total" | bc)
  else
    rate=0
  fi
  echo "$(basename $file): $errors/$total errors (rate: $rate)"
  if (( $(echo "$rate > $max_rate" | bc -l) )); then
    max_rate=$rate
    most_unstable=$(basename $file)
  fi
done
echo "Highest error rate: $most_unstable ($max_rate)"
