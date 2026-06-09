#!/bin/bash
PORT=6003
LOG_FILE="../reports/command_hmac_authentication.log"
USER_DB="../credentials/user_db.txt"

mkdir -p ../reports
touch "$LOG_FILE"

echo "HMAC receiver listening on port $PORT..."

while true
do
line=$(nc -l -p "$PORT")
[ -z "$line" ] && continue
TS=$(date -Iseconds)

USER=$(echo "$line" | grep -o 'USER=[^;]*' | cut -d= -f2)
ROLE=$(echo "$line" | grep -o 'ROLE=[^;]*' | cut -d= -f2)
CMD=$(echo "$line" | grep -o 'CMD=[^;]*' | cut -d= -f2)
TIMESTAMP=$(echo "$line" | grep -o 'TIMESTAMP=[^;]*' | cut -d= -f2)
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

DATA="USER=$USER;ROLE=$ROLE;CMD=$CMD;TIMESTAMP=$TIMESTAMP"
EXPECTED_AUTH=$(printf "%s" "$DATA" | openssl dgst -sha256 -hmac "$DB_TOKEN" | cut -d' ' -f2)

if [ "$RECEIVED_AUTH" != "$EXPECTED_AUTH" ]
then
echo "[REJECTED $TS] INVALID AUTH: $USER"
echo "[REJECTED $TS] INVALID AUTH: $USER RAW=$line" >> "$LOG_FILE"
continue
fi

if [ "$ROLE" = "operator" ]
then
if [ "$CMD" != "SET_MODE_NOMINAL" ] && [ "$CMD" != "SET_MODE_SAFE" ]
then
echo "[REJECTED $TS] UNAUTHORIZED: USER=$USER ROLE=$ROLE CMD=$CMD"
echo "[REJECTED $TS] UNAUTHORIZED: USER=$USER ROLE=$ROLE CMD=$CMD" >> "$LOG_FILE"
continue
fi
fi

echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD"
echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD" >> "$LOG_FILE"
done
