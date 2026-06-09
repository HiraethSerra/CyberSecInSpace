#!/bin/bash
total=$(cat logs/*.log | wc -l)
infos=$(grep INFO logs/*.log | wc -l)
warns=$(grep WARN logs/*.log | wc -l)
errors=$(grep ERROR logs/*.log | wc -l)

e1=$(grep ERROR logs/sat-001.log | wc -l)
e2=$(grep ERROR logs/sat-002.log | wc -l)
if [ "$e1" -gt "$e2" ]; then
  less_stable="sat-001"
elif [ "$e2" -gt "$e1" ]; then
  less_stable="sat-002"
else
  less_stable="sat-001"
fi

{
  echo "ORION LOG SUMMARY"
  echo "Total log entries: $total"
  echo "INFO events: $infos"
  echo "WARN events: $warns"
  echo "ERROR events: $errors"
  echo "Less stable satellite: $less_stable"
} > reports/log_summary.txt

cat reports/log_summary.txt
