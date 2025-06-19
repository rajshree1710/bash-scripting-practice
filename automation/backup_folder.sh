#!/usr/bin/env bash

SOURCE_DIR=$1
BACKUP_DIR=~/backups
DATE=$(date +%F)

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$(basename $SOURCE_DIR)_$DATE.tar.gz" "$SOURCE_DIR"
echo "Backup of $SOURCE_DIR saved to $BACKUP_DIR"

