#!/bin/bash
PORT=6002
LOG_FILE="../reports/command_token_authentication.log"
USER_DB="../credentials/user_db.txt"

mkdir -p ../reports
touch "$LOG_FILE"

echo "Token receiver listening on port $PORT..."

while true
do
line=$(nc -l -p "$PORT")
[ -z "$line" ] && continue
TS=$(date -Iseconds)

USER=$(echo "$line" | grep -o 'USER=[^;]*' | cut -d= -f2)
ROLE=$(echo "$line" | grep -o 'ROLE=[^;]*' | cut -d= -f2)
CMD=$(echo "$line" | grep -o 'CMD=[^;]*' | cut -d= -f2)
TOKEN=$(echo "$line" | grep -o 'TOKEN=[^;]*' | cut -d= -f2)

USER_DB="../credentials/user_db.txt"
ENTRY=$(grep "^$USER:" "$USER_DB")

if [ -z "$ENTRY" ]; then
echo "[REJECTED] UNKNOWN USER: $USER"
echo "[REJECTED] UNKNOWN USER: $USER RAW=$line" >> "$LOG_FILE"
continue
fi

DB_ROLE=$(echo "$ENTRY" | cut -d: -f2)
DB_TOKEN=$(echo "$ENTRY" | cut -d: -f3)


if [ "$ROLE" != "$DB_ROLE" ] || [ "$TOKEN" != "$DB_TOKEN" ]; then
echo "[REJECTED] AUTHENTICATION FAILED: $USER"
echo "[REJECTED] AUTHENTICATION FAILED: $USER RAW=$line" >> "$LOG_FILE"
continue
fi

echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD"
echo "[AUTHORIZED $TS] USER=$USER ROLE=$ROLE CMD=$CMD" >> "$LOG_FILE"
done
