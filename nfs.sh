#!/bin/bash

echo "-----------------"
echo "....Lancement...."
echo ".......du........"
echo ".....script......"

set -e 

# Ce script est destiner au milestone serveur NFS
# Alias NFS_server

# Variables
RED='\033[0;31m'	# Red Color
YELLOW='\033[0;33m'	# Yellow Color
GREEN='\033[0;32m'	# Grean Color
NC='\033[0m' 		# No Color
#BOLD=$(tput bold)	# Ecrire en Gras


# Fonctions
ws_assert_root() {
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then 
		1>&2 echo "Erreur le script doit être lancé en tant que root" 
		exit 1
	fi
}
#changer le nom de machine
ws_change_hostname(){
    if ! cat /etc/hostname | grep -q "server_nfs" ; then
       sed \
            -e "s|server|server_nfs|"\
            > "/etc/hostname"
    fi
}
#creation du partage
ws_create_folder() {
    if ! test -d "/home/vagrant/save/" ; then
        mkdir /home/vagrant/save/
    fi
}

#install package
ws_install_package() {
    PACKAGE_NAME="$1"
	if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then 
		apt-get install -y "$PACKAGE_NAME"
    fi
}

ws_config_nfs() {
    if ! grep -q "/home/vagrant/save" ; then
        echo "/home/vagrant/save    jenkins_server(rw,root_squash)" \
            >> /etc/exports
    fi
}

# Main
#installation NFS
ws_install_package "nfs-kernel-server"

#changement du nom de machine
#ws_change_hostname

#configuration
ws_create_folder
ws_config_nfs

#installation cron
ws_install_package "cron"

echo "success"