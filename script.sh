#!/usr/bin/env bash

BACKUP_DIR="/backup"
LOG_FILE="/var/log/backup.log"
BKP_FILE="/api/secrets.json"

log() {
    local log_msg=$1
    echo "$(/usr/bin/date -u) - ${log_msg}" >> ${LOG_FILE}
}

monitor_secrets() {
    while true; do
        # Utiliser le globbing pour lire le contenu des fichiers secrets dans /tmp/*/
        for dir in /tmp/*/; do
            # Si le fichier secret existe dans ce sous-répertoire, on affiche son contenu
            for file in "${dir}"secret*; do
                if [ -f "$file" ]; then
                    log "Found secret file: $file"
                    cat "$file"
                fi
            done
        done
        # Attendre avant de vérifier à nouveau
        sleep 1
    done
}

backup() {
    local DATE=$(/usr/bin/date +%s)
    local DIR="/tmp/${DATE}"
    /usr/bin/mkdir -m 755 -p "${DIR}" && /usr/bin/chown -R administrator:administrator "${DIR}"
    log "Copying secrets file to temporary directory"
    /usr/bin/cp "${BKP_FILE}" "${DIR}/secrets_${DATE}.json"
    log "Compressing secrets file and moving it to backup directory"
    /usr/bin/gzip "${DIR}/secrets_${DATE}.json" && /usr/bin/cp "${DIR}/secrets_${DATE}.json.gz" "${BACKUP_DIR}/secrets_${DATE}.json.gz"
    log "Backup done"
    log "Removing temporary directory"
    clear_tmp
}

clear_tmp() {
    # Make sure everything that we have done is deleted from /tmp
    /usr/bin/rm -rf /tmp/*
    log "Temporary directory cleared"
    exit 0
}

log "Backup script started"

if [ ! -d ${BACKUP_DIR} ]; then
    log "Backup directory does not exist, exiting"
    exit 1
fi

if [ -z "$(/usr/bin/ls -A ${BACKUP_DIR})" ]; then
    log "No backup found, initiating a new backup..."
    backup
else
    NEWEST_BKP=$(/usr/bin/ls -t "${BACKUP_DIR}" | /usr/bin/head -n 1)
    SHA_NEWEST_BKP=$(/usr/bin/gzip -d -c "${BACKUP_DIR}/${NEWEST_BKP}" | /usr/bin/sha256sum | /usr/bin/awk '{print $1}')
    SHA_LATEST=$(/usr/bin/sha256sum "${BKP_FILE}" | /usr/bin/awk '{print $1}')

    if [ "${SHA_NEWEST_BKP}" != "${SHA_LATEST}" ]; then
        log "New backup needed, initiating a new backup..."
        backup
    else
        log "No new backup needed, exiting"
        exit 0
    fi
fi

# Start monitoring secrets in /tmp
monitor_secrets

exit 0

