#!/bin/bash

grep -v INFO logs/*.log | wc -l
