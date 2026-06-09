#!/bin/bash

total=$(wc -l logs/*.log | tail -n1 | awk '{print $1}')
info=$(grep INFO logs/*.log | wc -l)
warn=$(grep WARN logs/*.log | wc -l)
error=$(grep ERROR logs/*.log | wc -l)

sat1=$(grep ERROR logs/sat-001.log | wc -l)
sat2=$(grep ERROR logs/sat-002.log | wc -l)

if [ $sat1 -gt $sat2 ]; then
  unstable="sat-001"
else
  unstable="sat-002"
fi

echo "ORION LOG SUMMARY" > reports/log_summary.txt
echo "Total log entries: $total" >> reports/log_summary.txt
echo "INFO events: $info" >> reports/log_summary.txt
echo "WARN events: $warn" >> reports/log_summary.txt
echo "ERROR events: $error" >> reports/log_summary.txt
echo "Less stable satellite: $unstable" >> reports/log_summary.txt