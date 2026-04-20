#!/bin/bash

cut -d' ' -f4- logs/*.log | sort | uniq -d
