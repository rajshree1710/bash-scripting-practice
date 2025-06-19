#!/usr/bin/env bash

LOG_FILE=$1

echo "Top 10 IPs by access count:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10

