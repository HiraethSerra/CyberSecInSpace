#!/bin/bash

set -u

PID_FILE="network_simulation_pids.txt"

echo "Starting network simulation..."

> "$PID_FILE"

store_pid() {
  echo "$1" >> "$PID_FILE"
}

cleanup_old_processes() {
  if [ -f "$PID_FILE" ]; then
    while read -r pid; do
      kill "$pid" 2>/dev/null
    done < "$PID_FILE"
    rm -f "$PID_FILE"
    > "$PID_FILE"
  fi
}

cleanup_old_processes

echo "Starting expected listening services..."
(while true; do nc -l -p 5000 >/dev/null 2>&1; sleep 0; done) &
store_pid "$!"

(while true; do nc -l -p 6000 >/dev/null 2>&1; sleep 0; done) &
store_pid "$!"

echo "Starting unexpected listening service..."
(while true; do nc -l -p 9999 >/dev/null 2>&1; sleep 0; done) &
store_pid "$!"

echo "Waiting for listeners to be ready..."
sleep 3

echo "Creating local established connections..."
(while true; do echo "ping" | nc 127.0.0.1 5000 >/dev/null 2>&1; sleep 4; done) &
store_pid "$!"

(while true; do echo "ping" | nc 127.0.0.1 9999 >/dev/null 2>&1; sleep 4; done) &
store_pid "$!"

echo "Simulating suspicious outbound connection..."
(while true; do python3 -c "
import socket, time
try:
    s = socket.socket()
    s.settimeout(2)
    s.connect(('1.1.1.1', 80))
    time.sleep(10)
    s.close()
except Exception:
    pass
" 2>/dev/null; sleep 15; done) &
store_pid "$!"

echo "----------------------------------------"
echo "Network simulation started."
echo "Expected listening ports: 5000, 6000"
echo "Unexpected exposed port: 9999"
echo "Suspicious outbound target: 1.1.1.1:80"
echo "PID file: $PID_FILE"
echo "Use ./stop_network_simulation.sh to stop the simulation."
echo "----------------------------------------"
