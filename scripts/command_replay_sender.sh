#!/bin/bash
HOST="127.0.0.1"
PORT=6004
USER_NAME=$1
ROLE=$2
CMD=$3
TS=$(date -Iseconds)
COMMAND_ID="CMD-$(date +%Y%m%d%H%M%S)-$RANDOM"

case "$USER_NAME" in
alice) TOKEN="token-alice-123" ;;
bob) TOKEN="token-bob-999" ;;
*) TOKEN="unknown" ;;
esac

DATA="USER=$USER_NAME;ROLE=$ROLE;CMD=$CMD;COMMAND_ID=$COMMAND_ID;TIMESTAMP=$TS"
AUTH=$(printf "%s" "$DATA" | openssl dgst -sha256 -hmac "$TOKEN" | awk '{print $2}')
MESSAGE="$DATA;AUTH=$AUTH"

echo "[SENDING] $MESSAGE"
echo "$MESSAGE" | nc -q 0 "$HOST" "$PORT"
