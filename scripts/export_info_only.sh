#!/bin/bash
grep INFO logs/*.log > reports/info_only.txt
echo "INFO messages saved to reports/info_only.txt"
