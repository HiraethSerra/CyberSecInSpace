#!/bin/bash
w1=$(grep WARN logs/sat-001.log | wc -l)
w2=$(grep WARN logs/sat-002.log | wc -l)
echo "WARN events in sat-001: $w1"
echo "WARN events in sat-002: $w2"
if [ "$w1" -gt "$w2" ]; then
  echo "sat-001 produced more warnings"
elif [ "$w2" -gt "$w1" ]; then
  echo "sat-002 produced more warnings"
else
  echo "Both satellites produced equal warnings"
fi
