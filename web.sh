#!/bin/sh
set -u # STOP script si variable non définie.
set -e # STOP script en cas d'erreur (code retour != 0 )

# Ce script est destiner au milestone serveur web
# Alias w_XXXXXX

###### Variables

# Variable de mise en forme
RED='\033[0;31m'	# Red Color
YELLOW='\033[0;33m'	# Yellow Color
GREEN='\033[0;32m'	# Grean Color
NC='\033[0m' 		# No Color
#BOLD=$(tput bold)	# Ecrire en Gras

###### Fonctions

# Vérifier si le script est lancer avec le profil root
w_assert_root() {
	REAL_ID="$(id -u)"
		if [ "$REAL_ID" -ne 0 ]; then 
			1>&2 echo "${RED}$(date +'%Y-%m-%d %H:%M:%S') [ ERROR ] : This script must be run as root" 
			exit 1
	fi
}

# Vérifier si package existe sinon l'installer
w_install_package() {
	PACKAGE_NAME="$1"
	if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then 
		echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation du Package $PACKAGE_NAME"
		apt-get install -y "$PACKAGE_NAME"
	else 
		echo "${YELLOW}$(date +'%Y-%m-%d %H:%M:%S') [WARNING] : Le Package $PACKAGE_NAME est déja installer"
	fi
}





# afficher le numero de ligne pour faciliter le debugage
echo_line_no () {
	   echo grep -n "$1" $0 |  sed "s/echo_line_no//" 
}


######## Main
w_assert_root
w_install_package "apache2"
# droit r/w du dossier WWW
echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Réglage des droit du répertoir WWW d'apach2"
chown -R www-data:www-data "/var/www/html"

