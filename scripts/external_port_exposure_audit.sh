#!/bin/bash

WHITELIST=("5000" "6000")

OPEN_PORTS=$(nmap -n 127.0.0.1 | grep "open" | awk -F'/' '{print $1}')

for PORT in $OPEN_PORTS; do
    if [[ ! " ${WHITELIST[@]} " =~ " ${PORT} " ]]; then
        echo "ALERT: Unexpected port exposed: $PORT"
    else
        echo "OK: Port $PORT is approved."
    fi
done
