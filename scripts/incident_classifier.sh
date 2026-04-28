
#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then

  echo "Usage: $0 <CPU_THRESHOLD> <ERROR_THRESHOLD>"

  exit 1

fi

cpu_thresh=$1

err_thresh=$2

whitelist="sleep bash sh"

indicators=0



ps -eo pid,comm,%cpu --no-headers | awk -v t="$cpu_thresh" '{if ($3+0 > t+0) print $0}' > /tmp/high_cpu.txt

if [ -s /tmp/high_cpu.txt ]; then

  indicators=$((indicators + 1))

fi



while read pid comm; do

  found=false

  for name in $whitelist; do

    if [ "$comm" = "$name" ]; then

      found=true

    fi

  done

  if [ "$found" = "false" ]; then

    indicators=$((indicators + 1))

    break

  fi

done < <(ps -eo pid,comm --no-headers)



for file in logs/*.log; do

  count=$(grep ERROR "$file" | wc -l)

  if [ "$count" -gt "$err_thresh" ]; then

    indicators=$((indicators + 1))

    break

  fi

done

if [ "$indicators" -eq 0 ]; then

  echo "NORMAL"

elif [ "$indicators" -eq 1 ]; then

  echo "WARNING"

else

  echo "CRITICAL"

fi

