#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
INTERVAL=30
REPORT_FILE="../reports/network_monitor_$(date +%Y-%m-%d-%H-%M-%S).txt"

echo "Starting network monitor. Interval: ${INTERVAL}s. Output: $REPORT_FILE"
echo "Press Ctrl+C to stop."

while true; do
    TS=$(date +%Y-%m-%d-%H-%M-%S)

    LISTEN=$(bash "$SCRIPT_DIR/listening_service_audit.sh" | grep "TOTAL" | grep -oP '[0-9]+')
    ESTAB=$(bash "$SCRIPT_DIR/established_connection_audit.sh" | grep "TOTAL" | grep -oP '[0-9]+')
    EXPOSED=$(bash "$SCRIPT_DIR/external_port_exposure_audit.sh" | grep "TOTAL" | grep -oP '[0-9]+')
    SUSPICIOUS=$(bash "$SCRIPT_DIR/suspicious_remote_connection_audit.sh" | grep "TOTAL" | grep -oP '[0-9]+')
    CLASS=$(bash "$SCRIPT_DIR/network_incident_classifier.sh" | grep "CLASSIFICATION:" | awk '{print $2}')

    if [ -z "$LISTEN" ]; then LISTEN=0; fi
    if [ -z "$ESTAB" ]; then ESTAB=0; fi
    if [ -z "$EXPOSED" ]; then EXPOSED=0; fi
    if [ -z "$SUSPICIOUS" ]; then SUSPICIOUS=0; fi
    if [ -z "$CLASS" ]; then CLASS="UNKNOWN"; fi

    LINE="$TS LISTEN=$LISTEN ESTAB=$ESTAB EXPOSED=$EXPOSED SUSPICIOUS=$SUSPICIOUS CLASS=$CLASS"
    echo "$LINE"
    echo "$LINE" >> "$REPORT_FILE"

    sleep "$INTERVAL"
done
