#!/bin/bash

PORT=5001

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="$SCRIPT_DIR/reports"
LOG_FILE="../reports/telemetry_secure.log"
SECRET_KEY="orion-shared-secret"
DATA=$(echo "$line" | sed ’s/;SIGNATURE=.*//’)
RECEIVED_SIGNATURE=$(echo "$line" | sed ’s/.*;SIGNATURE=//’)
EXPECTED_SIGNATURE=$(printf "%s" "$DATA" | openssl dgst -sha256 -hmac "$SECRET_KEY" |
cut -d’ ’ -f2)

mkdir -p "$REPORT_DIR"
touch "$LOG_FILE"

echo "=== TELEMETRY RECEIVER STARTED ==="
echo "Listening on port $PORT"
echo "Logging to $LOG_FILE"
echo ""

while true; do
    nc -l -p "$PORT" | while IFS= read -r line; do
        TS=$(date -Iseconds)
        echo "[RECEIVED $TS] $line"
        echo "[RECEIVED $TS] $line" >> "$LOG_FILE"
    done
done


if [ "$RECEIVED_SIGNATURE" = "$EXPECTED_SIGNATURE" ]; then
echo "[ACCEPTED $TS] $DATA"
echo "[ACCEPTED $TS] $DATA" >> "$LOG_FILE"
else
echo "[REJECTED $TS] INVALID SIGNATURE: $line"
echo "[REJECTED $TS] INVALID SIGNATURE: $line" >> "$LOG_FILE"
fi
