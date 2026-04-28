#!/bin/bash

TIME=$(date "+%Y-%m-%d %H:%M:%S")

LISTEN_COUNT=$(ss -tunlp | grep -c LISTEN)
ESTAB_COUNT=$(ss -tnp state established | grep -cv "Recv-Q")
EXPOSED_COUNT=$(./external_port_exposure_audit.sh | grep -c "ALERT")
SUSP_COUNT=$(./suspicious_remote_connection_audit.sh | grep -c "ALERT")

CLASS=$(./network_incident_classifier.sh | grep "CLASSIFICATION" | awk '{print $2}')

if [ "$ESTAB_COUNT" -gt 0 ]; then
    TOP_PROC_INFO=$(ss -tnp state established | grep "users:" | awk '{print $6}' | cut -d'"' -f2 | sort | uniq -c | sort -nr | head -n1)
    TOP_COUNT=$(echo $TOP_PROC_INFO | awk '{print $1}')
    TOP_NAME=$(echo $TOP_PROC_INFO | awk '{print $2}')
    TOP_DISPLAY="$TOP_NAME ($TOP_COUNT connections)"
else
    TOP_DISPLAY="NONE"
fi

echo "=== NETWORK SNAPSHOT ==="
echo "TIME: $TIME"
echo "LISTENING SERVICES: $LISTEN_COUNT"
echo "ESTABLISHED CONNECTIONS: $ESTAB_COUNT"
echo "UNEXPECTED EXPOSED PORTS: $EXPOSED_COUNT"
echo "SUSPICIOUS REMOTE CONNECTIONS: $SUSP_COUNT"
echo "TOP PROCESS BY ESTABLISHED CONNECTIONS: $TOP_DISPLAY"
echo "CLASSIFICATION: $CLASS"
