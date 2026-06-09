#!/bin/bash

COUNT=0

while IFS= read -r line; do
    proto=$(echo "$line" | awk '{print $1}')
    local=$(echo "$line" | awk '{print $5}')
    proc=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+')
    pid=$(echo "$line" | grep -oP 'pid=\K[0-9]+')

    if [ -z "$proc" ]; then proc="unknown"; fi
    if [ -z "$pid" ]; then pid="unknown"; fi

    echo "LISTENING SERVICE: $proto $local $proc $pid"
    ((COUNT++))
done < <(ss -tlunp | tail -n +2)

if [ "$COUNT" -eq 0 ]; then
    echo "NO LISTENING SERVICES DETECTED"
else
    echo "TOTAL LISTENING SERVICES: $COUNT"
fi
