#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
REPORT_PATH="../reports/mission_network_security_report-$TIMESTAMP.txt"
mkdir -p ../reports

LISTEN_COUNT=$(ss -tunlp | grep -c LISTEN)
ESTAB_COUNT=$(ss -tnp state established | grep -cv "Recv-Q")
EXPOSED_COUNT=$(./external_port_exposure_audit.sh | grep -c "ALERT")
SUSP_COUNT=$(./suspicious_remote_connection_audit.sh | grep -c "ALERT")

if [ "$ESTAB_COUNT" -gt 0 ]; then
    TOP_PROC=$(ss -tnp state established | grep "users:" | awk '{print $6}' | cut -d'"' -f2 | sort | uniq -c | sort -nr | head -n1 | awk '{print $2 " (" $1 ")"}')
else
    TOP_PROC="NONE"
fi

HIGH_CPU_COUNT=$(ps -eo pcpu,comm --sort=-pcpu | awk '$1 > 80.0' | wc -l)
LOG_ERRORS=$(grep -r "ERROR" ../logs/ 2>/dev/null | wc -l)

CLASS=$(./network_incident_classifier.sh | grep "CLASSIFICATION" | awk '{print $2}')

{
    echo "=== MISSION NETWORK SECURITY REPORT ==="
    echo "TIME: $(date "+%Y-%m-%d %H:%M:%S")"
    echo ""
    echo "[NETWORK STATE]"
    echo "LISTENING SERVICES: $LISTEN_COUNT"
    echo "ESTABLISHED CONNECTIONS: $ESTAB_COUNT"
    echo "UNEXPECTED EXPOSED PORTS: $EXPOSED_COUNT"
    echo "SUSPICIOUS REMOTE CONNECTIONS: $SUSP_COUNT"
    echo "TOP PROCESS BY ESTABLISHED CONNECTIONS: $TOP_PROC"
    echo ""
    echo "[RUNTIME AND LOGS]"
    echo "HIGH CPU PROCESSES: $HIGH_CPU_COUNT"
    echo "TOTAL LOG ERRORS: $LOG_ERRORS"
    echo ""
    echo "[CLASSIFICATION]"
    echo "FINAL CLASSIFICATION: $CLASS"
    echo ""
    echo "[COMPARISON]"
    echo "Current state indicates $CLASS conditions based on active indicators."
} | tee "$REPORT_PATH"

echo -e "\nReport saved to: $REPORT_PATH"
