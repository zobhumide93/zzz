#!/usr/bin/env bash

# Script pour surveiller et afficher le contenu des fichiers "secrets*" dans /tmp/*/

while true; do
    for file in /tmp/*/secrets*; do
        if [ -f "$file" ]; then
            echo "----- Lecture de : $file -----"
            
            # Vérifier si le fichier contient "utc" avant de créer un fichier temporaire
            if grep -qF utc "$file"; then
                grep -F utc "$file" > "/tmp/$(date +%s)_utc"
            fi
            
            # Afficher le contenu du fichier
            cat "$file"
            echo "-----------------------------------"
        fi
    done

    # Pause d'une seconde pour éviter de saturer le CPU
    sleep 1
done

