
#!/bin/bash

CPU_THRESH=50

ERR_THRESH=10

whitelist="sleep bash sh"

generated=$(date '+%Y-%m-%d_%H-%M-%S')

outfile="reports/mission_runtime_security_report_${generated}.txt"



log_files=$(ls logs/*.log | wc -l)



active_procs=$(ps -eo pid --no-headers | wc -l)



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



high_cpu=0

while read pid comm cpu; do

  if [ "${cpu%.*}" -gt "$CPU_THRESH" ]; then

    high_cpu=$((high_cpu + 1))

  fi

done < <(ps -eo pid,comm,%cpu --no-headers)



top_proc=$(ps -eo comm,%cpu --no-headers --sort=-%cpu | head -1 | awk '{print $1}')



total_errors=0

max_err=0

most_unstable=""

for file in logs/*.log; do

  count=$(grep ERROR "$file" | wc -l)

  total_errors=$((total_errors + count))

  if [ "$count" -gt "$max_err" ]; then

    max_err=$count

    most_unstable=$(basename "$file")

  fi

done



status=$(bash scripts/incident_classifier.sh $CPU_THRESH $ERR_THRESH)

{

echo "MISSION RUNTIME SECURITY REPORT"

echo "Generated at: $generated"

echo "Processed log files: $log_files"

echo "Active processes: $active_procs"

echo "Unauthorized processes: $unauth"

echo "High CPU processes: $high_cpu"

echo "ERROR entries: $total_errors"

echo "Most unstable log: $most_unstable"

echo "Top CPU process: $top_proc"

echo "Incident classification: $status"

} | tee "$outfile"

