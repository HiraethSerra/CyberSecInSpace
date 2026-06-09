#!/bin/bash

grep WARN logs/*.log | cut -d ' ' -f 1,2 > reports/warn_timestamps.txt

cat reports/warn_timestamps.txt
