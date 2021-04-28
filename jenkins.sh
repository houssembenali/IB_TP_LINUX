#!/bin/bash
set -e # En cas de code de retour non zero, arrêter le script

# Ce script est destiner au milestone 2 Jenkins
# Alias Zabasux (Arnaud DEGEZ)
# Variable de mise en forme
RED='\033[0;31m'	# Red Color
YELLOW='\033[0;33m'	# Yellow Color
GREEN='\033[0;32m'	# Grean Color
NC='\033[0m' 		# No Color
#BOLD=$(tput bold)	# Ecrire en Gras

# Fonctions
#Création partition 
ws_partition_is_present() {
    test -d /mnt/dd1
}
ws_create_partition() {
    mkdir /mnt/dd1
    mkfs.ext4 /dev/sdb
}
ws_mount_partition() {
    mount -t ext4 /dev/sdb /mnt/dd1
}

# Vérifier que le script est bien lancé en tant que root
ws_assert_root() {
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then 
		1>&2 echo "Erreur le script doit être lancé en tant que root" 
		exit 1
	fi
}
# installation de package
ws_install_package() {
	PACKAGE_NAME="$1"
	if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then 
		apt-get install -y "$PACKAGE_NAME"
    fi
}
#Installation de la source du package jenkins
ws_source_package() {
        if ! test -f /etc/apt/sources.list.d/jenkins.list ; then
        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
        sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
            /etc/apt/sources.list.d/jenkins.list'
    fi
}

ws_permission_user(){
    #sauvegarde du sudoers
    cp /etc/sudoers /etc/sudoers.old
    #ajout des droits du user dans le sudoers
    cat /etc/sudoers |
        echo "userjob      ALL(ALL)/bin/apt," >> sudo tee -a /etc/sudoers
}

# Main
#Vérification au lancement du script (root)
ws_assert_root

#creation partition 
if ! ws_partition_is_present ; then 
    ws_create_partition
    ws_mount_partition
fi

#Installation du package openjdk-11-jdk et gnupg
apt-get -y update
ws_install_package "openjdk-11-jdk"
ws_install_package "gnupg"

#Enregistrement sources de Jenkins
ws_source_package

#Installation Jenkins
apt-get -y update
ws_install_package "jenkins"

systemctl start jenkins

#Création de l utilisateur userjob
useradd -m -d /mnt/dd1 -p "userjob" "userjob"

#ajout des droits apt
ws_permission_user


echo "success"