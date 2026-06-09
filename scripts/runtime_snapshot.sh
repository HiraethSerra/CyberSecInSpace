
#!/bin/bash

CPU_THRESH=50

ERR_THRESH=10

whitelist="sleep bash sh"

now=$(date '+%Y-%m-%d %H:%M:%S')

fname=$(date '+%Y-%m-%d_%H-%M-%S')

outfile="reports/runtime_snapshot_${fname}.txt"



total_procs=$(ps -eo pid --no-headers | wc -l)



top_line=$(ps -eo pid,comm,%cpu --no-headers --sort=-%cpu | head -1)

top_pid=$(echo "$top_line" | awk '{print $1}')

top_proc=$(echo "$top_line" | awk '{print $2}')

top_cpu=$(echo "$top_line" | awk '{print $3}')



unauth=0

unauth_details=""

while read pid comm; do

  found=false

  for name in $whitelist; do

    if [ "$comm" = "$name" ]; then

      found=true

    fi

  done

  if [ "$found" = "false" ]; then

    unauth=$((unauth + 1))

    unauth_details="$unauth_details- PID=$pid PROC=$comm\n"

  fi

done < <(ps -eo pid,comm --no-headers)



total_errors=0

max_err=0

most_unstable=""

log_summary=""

for file in logs/*.log; do

  name=$(basename "$file")

  count=$(grep ERROR "$file" | wc -l)

  total_errors=$((total_errors + count))

  log_summary="$log_summary- $name: $count ERROR entries\n"

  if [ "$count" -gt "$max_err" ]; then

    max_err=$count

    most_unstable=$name

  fi

done



status=$(bash scripts/incident_classifier.sh $CPU_THRESH $ERR_THRESH)

{

echo "========================================"

echo "Runtime Security Snapshot"

echo "========================================"

echo "Date and time: $now"

echo "Total active processes: $total_procs"

echo "Top CPU process: PID=$top_pid PROC=$top_proc CPU=${top_cpu}%"

echo "Unauthorized processes: $unauth"

echo "Total ERROR entries across all logs: $total_errors"

echo "Incident classification: $status"

echo "----------------------------------------"

echo "Thresholds:"

echo "- CPU threshold: ${CPU_THRESH}%"

echo "- ERROR threshold per log: $ERR_THRESH"

echo "----------------------------------------"

echo "Log summary:"

echo -e "$log_summary"

echo "Most unstable log: $most_unstable ($max_err ERROR entries)"

echo "----------------------------------------"

echo "Unauthorized process details:"

echo -e "$unauth_details"

} | tee "$outfile"

