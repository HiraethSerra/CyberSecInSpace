#!/bin/bash
TARGET_URL="http://localhost:4318/v1/traces"
MALICIOUS_USER="attacker_unknown"
COMPROMISED_NODE="ground-station-malicious"

echo "=================================================="
echo "⚠️  SIMULATING RUNTIME ANOMALY & INTRUSION ATTACK"
echo "=================================================="
echo "Targeting Telemetry Ingestion Node..."

# Array of unauthorized, destructive orbital actions to fire sequentially
ATTACK_COMMANDS=("FORCE_DEORBIT" "OVERRIDE_AUTH" "WIPE_TELEMETRY" "PURGE_FIRMWARE")

for CMD in "${ATTACK_COMMANDS[@]}"
do
  TRACE_ID=$(openssl rand -hex 16)
  SPAN_ID=$(openssl rand -hex 8)
  NOW=$(date +%s%N)
  END=$((NOW + 20000000)) # Longer execution duration to visually simulate anomaly
  
  echo "Firing unauthorized payload: $CMD"
  
  curl -X POST "$TARGET_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"resourceSpans\": [
      {
        \"resource\": {
          \"attributes\": [
            {
              \"key\": \"service.name\",
              \"value\": {\"stringValue\": \"mission-orion-attack-vector\"}
            },
            {
              \"key\": \"security.incident\",
              \"value\": {\"stringValue\": \"true\"}
            },
            {
              \"key\": \"operator.identity\",
              \"value\": {\"stringValue\": \"$MALICIOUS_USER\"}
            },
            {
              \"key\": \"node.origin\",
              \"value\": {\"stringValue\": \"$COMPROMISED_NODE\"}
            }
          ]
        },
        \"scopeSpans\": [
          {
            \"spans\": [
              {
                \"traceId\": \"$TRACE_ID\",
                \"spanId\": \"$SPAN_ID\",
                \"name\": \"$CMD\",
                \"kind\": 2,
                \"startTimeUnixNano\": \"$NOW\",
                \"endTimeUnixNano\": \"$END\"
              }
            ]
          }
        ]
      }
    ]
  }"
  echo "--------------------------------------------------"
  sleep 1
done

echo "⚠️ Intrusion simulation batch sent."
echo "=================================================="
