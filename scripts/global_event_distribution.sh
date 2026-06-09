#!/bin/bash

grep -h -o "INFO\|WARN\|ERROR" logs/*.log | sort | uniq -c
