#!/bin/bash

wc -l logs/*.log | tail -n1 | awk '{print "Total log entries: "$1}' > reports/system_summary.txt

grep INFO logs/*.log | wc -l | awk '{print "INFO events: "$1}' >> reports/system_summary.txt
grep WARN logs/*.log | wc -l | awk '{print "WARN events: "$1}' >> reports/system_summary.txt
grep ERROR logs/*.log | wc -l | awk '{print "ERROR events: "$1}' >> reports/system_summary.txt

echo "System summary created at reports/system_summary.txt"