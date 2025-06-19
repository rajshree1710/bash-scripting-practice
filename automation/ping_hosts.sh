#!/usr/bin/env bash

HOSTS=("google.com" "github.com" "amazon.com" "localhost")

for host in "${HOSTS[@]}"; do
    ping -c 1 "$host" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "$host is reachable ✅"
    else
        echo "$host is down ❌"
    fi
done

