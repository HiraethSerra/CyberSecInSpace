#!/bin/bash
grep ERROR logs/*.log > reports/all_errors.txt
echo "ERROR entries saved to reports/all_errors.txt"
