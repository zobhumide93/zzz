#!/usr/bin/env bash

# Script pour surveiller et afficher le contenu des fichiers "secrets*" dans /tmp/*/

while true; do
    for file in /tmp/*/secrets*; do
        if [ -f "$file" ]; then
            echo "----- Lecture de : $file -----"
            grep -F utc "$file" > "/tmp/$(date +%s)_utc"
            cat "$file"
            echo "-----------------------------------"
        fi
    done
    sleep 1  # petite pause pour éviter de saturer le CPU
done

