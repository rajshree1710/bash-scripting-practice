#!/usr/bin/env bash

echo "===== System Health Check ====="
echo "Uptime:" && uptime
echo -e "\nMemory Usage:" && free -h
echo -e "\nDisk Usage:" && df -h
echo -e "\nTop Processes:" && ps aux --sort=-%mem | head -5

