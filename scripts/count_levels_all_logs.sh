#!/bin/bash
echo "Log level counts across all satellite logs:" > reports/level_summary.txt
cat logs/*.log | cut -d ' ' -f3 | sort | uniq -c >> reports/level_summary.txt
cat reports/level_summary.txt
