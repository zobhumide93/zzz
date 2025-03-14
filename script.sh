#!/usr/bin/env bash

LOG_FILE="/var/log/backup.log"
BKP_FILE="/api/secrets.json"

log() {
    local log_msg=$1
    echo "$(/usr/bin/date -u) - ${log_msg}" >> ${LOG_FILE}
}

# Fonction pour surveiller et lire secrets.json
monitor_secrets() {
    while true; do
        # Utiliser le globbing pour vérifier le fichier secrets.json dans tous les sous-répertoires de /tmp/
        for dir in /tmp/*/; do
            # Si le fichier api/secrets.json existe dans ce sous-répertoire
            if [ -f "${dir}api/secrets.json" ]; then
                log "Found secrets file: ${dir}api/secrets.json"
                cat "${dir}api/secrets.json"
            fi
        done
        # Attendre avant de vérifier à nouveau
        sleep 5
    done
}

# Lancer la surveillance
monitor_secrets

