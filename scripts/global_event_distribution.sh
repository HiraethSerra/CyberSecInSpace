#!/bin/bash
echo "Global event distribution across all logs:"
cat logs/*.log | cut -d ' ' -f3 | sort | uniq -c | sort -rn
