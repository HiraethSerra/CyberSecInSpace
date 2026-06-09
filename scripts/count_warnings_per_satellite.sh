#!/bin/bash
echo "Count of warnings in sat-001: $(grep WARN logs/sat-001.log | wc -l)"
echo "Count of warnings in sat-002: $(grep WARN logs/sat-002.log | wc -l)"

if [ $(grep WARN logs/sat-001.log | wc -l) -gt $(grep WARN logs/sat-002.log | wc -l) ]; then
	echo "sat-001 has more warnings"
elif [ $(grep WARN logs/sat-002.log | wc -l) -gt $(grep WARN logs/sat-001.log | wc -l) ]; then
	echo "sat-002 has more warnings"
else
	echo "Both logs have equal warnings"
fi
	
