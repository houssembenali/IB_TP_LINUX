#!/bin/bash

PATH_TRASH="$HOME/trash"
INDEX_FOLDER="$PATH_TRASH/index"

for file in $@
do
        echo "the path is : $path"
	rm "$INDEX_FOLDER/$file.info"
done


