#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <CPU_THRESHOLD> <MEM_THRESHOLD>"
  exit 1
fi

ps -eo pid,comm,%cpu,%mem --no-headers | awk -v cpu="$1" -v mem="$2" '
{
  if ($3 > cpu) print "WARNING: suspicious CPU usage: " $2 " (PID: " $1 ")"
  if ($4 > mem) print "WARNING: suspicious memory usage: " $2 " (PID: " $1 ")"
}'
