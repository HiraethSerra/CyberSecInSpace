#!/bin/bash
CPU_THRESH=50
ERR_THRESH=10
whitelist="sleep bash sh"

get_top_cpu() {
  ps -eo comm,%cpu --no-headers --sort=-%cpu | head -1 | awk '{print $1}'
}

get_unauth_count() {
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
  echo $unauth
}

get_status() {
  bash scripts/incident_classifier.sh $CPU_THRESH $ERR_THRESH
}

echo "Taking first snapshot..."
t1=$(get_top_cpu)
u1=$(get_unauth_count)
c1=$(get_status)

echo "Waiting 10 seconds..."
sleep 10

echo "Taking second snapshot..."
t2=$(get_top_cpu)
u2=$(get_unauth_count)
c2=$(get_status)

echo ""
echo "STATE CHANGE DETECTED:"

if [ "$t1" = "$t2" ]; then
  echo "Top CPU process changed: NO"
else
  echo "Top CPU process changed: YES ($t1 -> $t2)"
fi

if [ "$u1" = "$u2" ]; then
  echo "Unauthorized process count changed: NO"
else
  echo "Unauthorized process count changed: YES ($u1 -> $u2)"
fi

if [ "$c1" = "$c2" ]; then
  echo "Incident classification changed: NO"
else
  echo "Incident classification changed: YES ($c1 -> $c2)"
fi
