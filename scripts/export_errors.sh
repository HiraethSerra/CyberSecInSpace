#!/bin/bash

grep ERROR logs/*.log >> reports/all_errors.txt
cat reports/all_errors.txt
