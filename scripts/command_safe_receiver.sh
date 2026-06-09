#!/bin/bash
PORT=6005
LOG_FILE="../reports/command_safety_gate.log"
USER_DB="../credentials/user_db.txt"
STATE_FILE="../reports/processed_commands.db"
PENDING_FILE="../reports/pending_commands.db"

mkdir -p ../reports
touch "$LOG_FILE"
touch "$STATE_FILE"
touch "$PENDING_FILE"

echo "Safety-gated receiver listening on port $PORT..."

while true
do
line=$(nc -l -p "$PORT")
[ -z "$line" ] && continue
TS=$(date -Iseconds)

USER=$(echo "$line" | grep -o 'USER=[^;]*' | cut -d= -f2)
ROLE=$(echo "$line" | grep -o 'ROLE=[^;]*' | cut -d= -f2)
CMD=$(echo "$line" | grep -o 'CMD=[^;]*' | cut -d= -f2)
TIMESTAMP=$(echo "$line" | grep -o 'TIMESTAMP=[^;]*' | cut -d= -f2)
COMMAND_ID=$(echo "$line" | grep -o 'COMMAND_ID=[^;]*' | cut -d= -f2)
REQUEST_ID=$(echo "$line" | grep -o 'REQUEST_ID=[^;]*' | cut -d= -f2)
RECEIVED_AUTH=$(echo "$line" | grep -o 'AUTH=[^;]*' | cut -d= -f2)

ENTRY=$(grep "^$USER:" "$USER_DB")
if [ -z "$ENTRY" ]
then
echo "[REJECTED $TS] UNKNOWN USER: $USER"
echo "[REJECTED $TS] UNKNOWN USER: $USER RAW=$line" >> "$LOG_FILE"
continue
fi

DB_ROLE=$(echo "$ENTRY" | cut -d: -f2)
DB_TOKEN=$(echo "$ENTRY" | cut -d: -f3)

if [ "$ROLE" != "$DB_ROLE" ]
then
echo "[REJECTED $TS] ROLE MISMATCH: USER=$USER DECLARED=$ROLE EXPECTED=$DB_ROLE"
echo "[REJECTED $TS] ROLE MISMATCH: USER=$USER RAW=$line" >> "$LOG_FILE"
continue
fi

if [ -n "$REQUEST_ID" ]; then
DATA="USER=$USER;ROLE=$ROLE;CMD=$CMD;REQUEST_ID=$REQUEST_ID;COMMAND_ID=$COMMAND_ID;TIMESTAMP=$TIMESTAMP"
else
DATA="USER=$USER;ROLE=$ROLE;CMD=$CMD;COMMAND_ID=$COMMAND_ID;TIMESTAMP=$TIMESTAMP"
fi

EXPECTED_AUTH=$(printf "%s" "$DATA" | openssl dgst -sha256 -hmac "$DB_TOKEN" | awk '{print $2}')

if [ "$RECEIVED_AUTH" != "$EXPECTED_AUTH" ]
then
echo "[REJECTED $TS] INVALID AUTH: $USER"
echo "[REJECTED $TS] INVALID AUTH: $USER RAW=$line" >> "$LOG_FILE"
continue
fi

if grep -q "^$COMMAND_ID$" "$STATE_FILE"
then
echo "[REJECTED $TS] REPLAY DETECTED: COMMAND_ID=$COMMAND_ID"
echo "[REJECTED $TS] REPLAY DETECTED: COMMAND_ID=$COMMAND_ID RAW=$line" >> "$LOG_FILE"
continue
fi

if [ "$ROLE" = "operator" ] && [ "$CMD" != "SET_MODE_NOMINAL" ] && [ "$CMD" != "SET_MODE_SAFE" ] && [ "$CMD" != "CONFIRM" ]
then
echo "[REJECTED $TS] UNAUTHORIZED: USER=$USER ROLE=$ROLE CMD=$CMD"
echo "[REJECTED $TS] UNAUTHORIZED: USER=$USER ROLE=$ROLE CMD=$CMD" >> "$LOG_FILE"
continue
fi

echo "$COMMAND_ID" >> "$STATE_FILE"

if [ "$CMD" = "CONFIRM" ]
then
PENDING_ENTRY=$(grep "^$REQUEST_ID:" "$PENDING_FILE")
if [ -z "$PENDING_ENTRY" ]
then
echo "[REJECTED $TS] UNKNOWN REQUEST_ID=$REQUEST_ID"
echo "[REJECTED $TS] UNKNOWN REQUEST_ID=$REQUEST_ID RAW=$line" >> "$LOG_FILE"
continue
fi
ORIG_CMD=$(echo "$PENDING_ENTRY" | cut -d: -f4)
sed -i "/^$REQUEST_ID:/d" "$PENDING_FILE"
echo "[CONFIRMED $TS] EXECUTING: USER=$USER CMD=$ORIG_CMD REQUEST_ID=$REQUEST_ID"
echo "[CONFIRMED $TS] EXECUTING: USER=$USER CMD=$ORIG_CMD REQUEST_ID=$REQUEST_ID" >> "$LOG_FILE"
continue
fi

if [ "$CMD" = "RESET" ] || [ "$CMD" = "SHUTDOWN" ]
then
REQUEST_ID="REQ-$(date +%Y%m%d%H%M%S)-$RANDOM"
echo "$REQUEST_ID:$USER:$ROLE:$CMD" >> "$PENDING_FILE"
echo "[PENDING $TS] CRITICAL COMMAND REQUIRES CONFIRMATION REQUEST_ID=$REQUEST_ID"
echo "[PENDING $TS] USER=$USER ROLE=$ROLE CMD=$CMD REQUEST_ID=$REQUEST_ID" >> "$LOG_FILE"
continue
fi

echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD"
echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD" >> "$LOG_FILE"
done
