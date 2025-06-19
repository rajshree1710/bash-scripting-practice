#!/usr/bin/env bash

while read user; do
    PASSWORD=$(openssl rand -base64 8)
    sudo useradd -m "$user"
    echo "$user:$PASSWORD" | sudo chpasswd
    echo "Created user $user with password $PASSWORD"
done < users.txt

