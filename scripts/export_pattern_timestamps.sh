#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <PATTERN>"
  exit 1
fi
grep "$1" logs/*.log | cut -d ' ' -f1-2 > reports/pattern_timestamps.txt
echo "Timestamps saved to reports/pattern_timestamps.txt"
cat reports/pattern_timestamps.txt
