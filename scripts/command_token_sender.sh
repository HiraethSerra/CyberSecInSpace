#!/bin/bash
HOST="127.0.0.1"
PORT=6002
USER_NAME=$1
ROLE=$2
CMD=$3
TS=$(date -Iseconds)

case "$USER_NAME" in
alice)
TOKEN="token-alice-123"
;;
bob)
TOKEN="token-bob-999"
;;
*)
TOKEN="unknown"
;;
esac

MESSAGE="USER=$USER_NAME;ROLE=$ROLE;CMD=$CMD;TOKEN=$TOKEN;TIMESTAMP=$TS"
echo "$MESSAGE" | nc -q 0 "$HOST" "$PORT"
