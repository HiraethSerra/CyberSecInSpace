#!/bin/bash

sat1=$(grep ERROR logs/sat-001.log | wc -l)
sat2=$(grep ERROR logs/sat-002.log | wc -l)

if [ $sat1 -gt $sat2 ]; then
  echo "Less stable satellite: sat-001"
elif [ $sat2 -gt $sat1 ]; then
  echo "Less stable satellite: sat-002"
else
  echo "Both satellites appear equally stable"
fi