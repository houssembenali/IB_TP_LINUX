#!/bin/bash

PATH_TRASH="$HOME/trash"
INDEX_FOLDER="$PATH_TRASH/index"


#RM script
if [ $1 = "RM" ]; then
        shift;
		for path in $@
		do
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
		
	
#TRASH script
elif [ $1 = "TRASH" ]; then
    shift;
	echo $(ls -p $PATH_TRASH | grep -v / ) 

	
#RESTORE
elif [ $1 = "RESTORE" ]; then
    shift;
	for file in $@
	do
	
		if [ ! -f "$PATH_TRASH/$file" ]; then
			echo "ERREUR : $FILE n'exists."
		fi
	
		mv $PATH_TRASH/$file $(cat $INDEX_FOLDER/$file.info)
		rm "$INDEX_FOLDER/$file.info"
	done
	
else
	echo "invalid Option"
fi
