#!/bin/bash
whitelist="sleep bash sh"

auth=0
unauth=0

ps -eo pid,comm --no-headers > /tmp/procs.txt

while read pid comm; do
  found=false
  for name in $whitelist; do
    if [ "$comm" = "$name" ]; then
      found=true
    fi
  done
  if [ "$found" = "true" ]; then
    echo "AUTHORIZED PROCESS: $comm (PID: $pid)"
    auth=$((auth + 1))
  else
    echo "UNAUTHORIZED PROCESS: $comm (PID: $pid)"
    unauth=$((unauth + 1))
  fi
done < /tmp/procs.txt

echo "TOTAL AUTHORIZED: $auth"
echo "TOTAL UNAUTHORIZED: $unauth"
