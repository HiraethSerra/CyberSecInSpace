#!/bin/bash
CPU_THRESH=50
ERR_THRESH=10

declare -A level
level[NORMAL]=0
level[WARNING]=1
level[CRITICAL]=2

prev=""

echo "Monitoring for escalation... (Ctrl+C to stop)"

while true; do
  now=$(date '+%Y-%m-%d %H:%M:%S')
  current=$(bash scripts/incident_classifier.sh $CPU_THRESH $ERR_THRESH)

  if [ -n "$prev" ]; then
    if [ "${level[$current]}" -gt "${level[$prev]}" ]; then
      echo "ESCALATION DETECTED:"
      echo "Time: $now"
      echo "From: $prev"
      echo "To: $current"
      exit 0
    fi
  fi

  prev=$current
  sleep 5
done
