#!/bin/bash
HOST="127.0.0.1"
PORT=6003
USER_NAME=$1
ROLE=$2
CMD=$3
TS=$(date -Iseconds)

case "$USER_NAME" in
alice) TOKEN="token-alice-123" ;;
bob) TOKEN="token-bob-999" ;;
*) TOKEN="unknown" ;;
esac

DATA="USER=$USER_NAME;ROLE=$ROLE;CMD=$CMD;TIMESTAMP=$TS"
AUTH=$(printf "%s" "$DATA" | openssl dgst -sha256 -hmac "$TOKEN" | cut -d' ' -f2)
MESSAGE="$DATA;AUTH=$AUTH"
echo "$MESSAGE" | nc -q 0 "$HOST" "$PORT"
