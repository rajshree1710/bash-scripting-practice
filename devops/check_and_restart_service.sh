#!/usr/bin/env bash

SERVICE_NAME=$1

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "✅ $SERVICE_NAME is running."
else
    echo "❌ $SERVICE_NAME is not running. Attempting to restart..."
    sudo systemctl restart "$SERVICE_NAME"

    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "✅ Successfully restarted $SERVICE_NAME."
    else
        echo "❌ Failed to restart $SERVICE_NAME. Please check logs."
    fi
fi

