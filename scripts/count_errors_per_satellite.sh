#!/bin/bash
echo "Count of errors in sat-001: $(grep ERROR logs/sat-001.log | wc -l)"
echo "Count of errors in sat-002: $(grep ERROR logs/sat-002.log | wc -l)"



