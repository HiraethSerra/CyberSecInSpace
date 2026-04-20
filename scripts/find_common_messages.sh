#!/bin/bash
echo "Messages appearing in more than one log file:"
cut -d '"' -f2 logs/*.log | sort | uniq -d
