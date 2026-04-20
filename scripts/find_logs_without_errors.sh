#!/bin/bash
echo "Log files with no ERROR entries:"
for file in logs/*.log; do
  count=$(grep ERROR "$file" | wc -l)
  if [ "$count" -eq 0 ]; then
    echo "$(basename $file)"
  fi
done
