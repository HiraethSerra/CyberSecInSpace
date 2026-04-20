#!/bin/bash

grep "$1" logs/*.log | awk '{print $1, $2}' > reports/pattern_timestamps.txt
