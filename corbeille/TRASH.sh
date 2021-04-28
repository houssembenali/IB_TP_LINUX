#!/bin/bash

#paths=$(echo $@ | tr ";" "\n")

PATH_TRASH="$HOME/trash"

echo $(ls -p $PATH_TRASH | grep -v / ) 
