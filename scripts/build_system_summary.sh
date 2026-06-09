#!/bin/bash
total=$(cat logs/*.log | wc -l)
errors=$(grep ERROR logs/*.log | wc -l)
warns=$(grep WARN logs/*.log | wc -l)
infos=$(grep INFO logs/*.log | wc -l)
echo "System summary saved to reports/system_summary.txt"
{
  echo "ORION SYSTEM SUMMARY"
  echo "Total log entries: $total"
  echo "ERROR events: $errors"
  echo "WARN events: $warns"
  echo "INFO events: $infos"
} > reports/system_summary.txt
cat reports/system_summary.txt
