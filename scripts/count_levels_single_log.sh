#!/bin/bash
echo "Log level counts for sat-001.log:"
cut -d ' ' -f3 logs/sat-001.log | sort | uniq -c
