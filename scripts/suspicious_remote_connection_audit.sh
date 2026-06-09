#!/bin/bash

SUSPICIOUS=$(ss -tnp state established | grep -v "127.0.0.1")

echo "--- Suspicious Remote Connections ---"

if [ -z "$SUSPICIOUS" ]; then
    echo "CLEAN: No external connections detected."
else
    while read -r line; do
        # Skip header
        if [[ $line == Recv-Q* ]]; then continue; fi
        
        REMOTE=$(echo $line | awk '{print $5}')
        PROCESS=$(echo $line | grep -o 'users:((".*"))' | cut -d'"' -f2)
        PID=$(echo $line | grep -o 'pid=[0-9]*' | cut -d'=' -f2)
        
        echo "ALERT: External connection to $REMOTE by $PROCESS (PID: $PID)"
    done <<< "$SUSPICIOUS"
fi
