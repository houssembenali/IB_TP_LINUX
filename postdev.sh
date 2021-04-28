#!/bin/sh
set -u # STOP script si variable non définie.
set -e # STOP script en cas d'erreur (code retour != 0 )

# Variable de mise en forme
RED='\033[0;31m'	# Red Color
YELLOW='\033[0;33m'	# Yellow Color
GREEN='\033[0;32m'	# Grean Color
NC='\033[0m' 		# No Color
#BOLD=$(tput bold)	# Ecrire en Gras


# Vérifier si le script est lancer avec le profil root
pd_assert_root() {
	REAL_ID="$(id -u)"
		if [ "$REAL_ID" -ne 0 ]; then
			1>&2 echo "${RED}$(date +'%Y-%m-%d %H:%M:%S') [ ERROR ] : This script must be run as root ${NC}"
			exit 1
	fi
}

# Vérifier si package existe sinon l'installer
pd_install_package() {
	PACKAGE_NAME="$1"
	if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then 
		echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation du Package $PACKAGE_NAME ${NC}"
		apt-get install -y "$PACKAGE_NAME"
	else 
		echo "${YELLOW}$(date +'%Y-%m-%d %H:%M:%S') [WARNING] : Le Package $PACKAGE_NAME est déja installer ${NC}"
	fi
}



pd_assert_root
apt-get -y update
pd_install_package "python3"
apt-get -y update
pd_install_package "python3-pip"
apt-get -y update
pd_install_package "python3-dev"
pd_install_package "git"

apt install -y software-properties-common apt-transport-https curl
curl -k -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt install -y code


