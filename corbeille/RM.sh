#!/bin/bash

#paths=$(echo $@ | tr ";" "\n")

PATH_TRASH="$HOME/trash"
INDEX_FOLDER="$PATH_TRASH/index"

for path in $@
do
        echo "the path is : $path"
        # Créer répertoire s'il n'existe pas
        if [ ! -d "$INDEX_FOLDER" ]; then
         mkdir -p $INDEX_FOLDER
        fi

        #récupérer le nom du fichier
        file="$(basename -- $path)"

        #déplacer le fichier vers la corbeille
        mv $path "$PATH_TRASH/$file"

        echo "$path" >> "$INDEX_FOLDER/$file.info"

done
