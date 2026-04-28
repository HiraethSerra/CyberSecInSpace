#!/bin/bash

COUNT=0

while IFS= read -r line; do
    local=$(echo "$line" | awk '{print $5}')
    remote=$(echo "$line" | awk '{print $6}')
    proc=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+')
    pid=$(echo "$line" | grep -oP 'pid=\K[0-9]+')

    if [ -z "$proc" ]; then proc="unknown"; fi
    if [ -z "$pid" ]; then pid="unknown"; fi

    echo "ESTABLISHED CONNECTION: $local -> $remote $proc $pid"
    ((COUNT++))
done < <(ss -tnp state established | tail -n +2)

if [ "$COUNT" -eq 0 ]; then
    echo "NO ESTABLISHED CONNECTIONS DETECTED"
else
    echo "TOTAL ESTABLISHED CONNECTIONS: $COUNT"
fi
