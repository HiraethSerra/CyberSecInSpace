#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <PATTERN>"
  exit 1
fi
pattern=$1
echo "PATTERN REPORT: $pattern" > reports/pattern_report.txt
for file in logs/*.log; do
  count=$(grep "$pattern" "$file" | wc -l)
  echo "$(basename $file): $count" >> reports/pattern_report.txt
done
cat reports/pattern_report.txt
