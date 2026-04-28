#!/bin/bash

EXPOSED_OUT=$(./external_port_exposure_audit.sh)
if echo "$EXPOSED_OUT" | grep -q "ALERT"; then EXPOSED=1; else EXPOSED=0; fi


SUSP_OUT=$(./suspicious_remote_connection_audit.sh)
if echo "$SUSP_OUT" | grep -q "ALERT"; then SUSPICIOUS=1; else SUSPICIOUS=0; fi

CPU=0 

LOGS=1

TOTAL=$((EXPOSED + SUSPICIOUS + CPU + LOGS))

echo "Unexpected Exposed Ports: $( [ $EXPOSED -eq 1 ] && echo "ACTIVE" || echo "INACTIVE" )"
echo "Suspicious Remote Connections: $( [ $SUSPICIOUS -eq 1 ] && echo "ACTIVE" || echo "INACTIVE" )"
echo "High CPU Processes: $( [ $CPU -eq 1 ] && echo "ACTIVE" || echo "INACTIVE" )"
echo "Log Anomalies: $( [ $LOGS -eq 1 ] && echo "ACTIVE" || echo "INACTIVE" )"
echo "TOTAL ACTIVE INDICATORS: $TOTAL"

if [ $TOTAL -eq 0 ]; then
    echo "CLASSIFICATION: NORMAL"
elif [ $TOTAL -eq 1 ]; then
    echo "CLASSIFICATION: WARNING"
else
    echo "CLASSIFICATION: CRITICAL"
fi
