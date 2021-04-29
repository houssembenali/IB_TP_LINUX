#!/bin/bash

# Ce script est destiner au milestone CRON Sauvegarde /1 heur

# date du jour
backupdate=$(date +%Y-%m-%d)

#répertoire de backup
dirbackup=/home/save/server_ic/
dirbackup2=/home/save/web/

# création du répertoire de backup
mkdir "$dirbackup"
mkdir "$dirbackup2"


# créé une archive bz
#connexion ssh sur le serveur jenkins et récupération du dossier  /usr/local/jenkins
scp vagrant@jenkins_server:/usr/local/jenkins/ /tmp
#connexion ssh sur le serveur web et récupération du dossier  /var/www/html
scp web@web_server:/var/www/html/ /tmp
# sauvegarde du dossier  /usr/local/jenkins
tar -cjf $dirbackup/server_ic-$backupdate.tar.gz /tmp/jenkins
# sauvegarde du dossier  /var/www/html
tar -cjf $dirbackup2/server_web-$backupdate.tar.gz /tmp/web

#suppression des fichiers tmp
rm -r /tmp/jenkins
rm -r /tmp/web

echo "success"

