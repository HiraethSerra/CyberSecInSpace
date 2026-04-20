#!/bin/bash
e1=$(grep ERROR logs/sat-001.log | wc -l)
e2=$(grep ERROR logs/sat-002.log | wc -l)
echo "ERROR events in sat-001: $e1"
echo "ERROR events in sat-002: $e2"
