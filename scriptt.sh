#!/bin/bash

# Créer un répertoire temporaire avec un nom basé sur la date actuelle
DATE=$(date +%s)
DIR="/tmp/${DATE}"
mkdir -p "${DIR}"

# Copier le fichier secrets.json dans le répertoire temporaire
cp "/api/secrets.json" "${DIR}/secrets_${DATE}.json"

# Afficher le contenu du fichier
cat "${DIR}/secrets_${DATE}.json"

# Nettoyer (optionnel, mais recommandé pour ne pas laisser de traces)
rm -rf "${DIR}"

