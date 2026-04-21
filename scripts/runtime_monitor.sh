#!/bin/bash
CPU_THRESH=50
ERR_THRESH=2
whitelist="sleep bash sh"
timestamp=$(date +%Y%m%d_%H%M%S)
outfile="reports/runtime_monitor_${timestamp}.txt"

echo "Starting monitoring loop..."
echo "Interval: 5s"
echo "Output: $outfile"
echo "Using: ./incident_classifier.sh"
echo "Press Ctrl+C to stop."
echo "----------------------------------------"

echo "===== Monitoring started: $(date '+%Y-%m-%d %H:%M:%S') =====" >> "$outfile"

while true; do
  now=$(date '+%Y-%m-%d %H:%M:%S')


  top_line=$(ps -eo pid,comm,%cpu --no-headers --sort=-%cpu | head -1)
  top_pid=$(echo "$top_line" | awk '{print $1}')
  top_proc=$(echo "$top_line" | awk '{print $2}')
  top_cpu=$(echo "$top_line" | awk '{print $3}')


  unauth=0
  while read pid comm; do
    found=false
    for name in $whitelist; do
      if [ "$comm" = "$name" ]; then
        found=true
      fi
    done
    if [ "$found" = "false" ]; then
      unauth=$((unauth + 1))
    fi
  done < <(ps -eo pid,comm --no-headers)


  anomaly="NO"
  for file in logs/*.log; do
    count=$(grep ERROR "$file" | wc -l)
    if [ "$count" -gt "$ERR_THRESH" ]; then
      anomaly="YES"
      break
    fi
  done


  status=$(bash scripts/incident_classifier.sh $CPU_THRESH $ERR_THRESH)

  line="[$now] TOP_CPU: $top_proc (PID=$top_pid, CPU=${top_cpu}%) | UNAUTHORIZED: $unauth | LOG_ANOMALY: $anomaly | STATUS: $status"
  echo "$line"
  echo "$line" >> "$outfile"

  sleep 5
done
