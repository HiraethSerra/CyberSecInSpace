#!/bin/bash
total=$(grep -v INFO logs/*.log | wc -l)
echo "Non-INFO entries across all logs: $total"
grep -v INFO logs/*.log
