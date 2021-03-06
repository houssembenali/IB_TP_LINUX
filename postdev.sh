#!/bin/sh
set -u # STOP script si variable non définie.
set -e # STOP script en cas d'erreur (code retour != 0 )

#Variable
#TODO Please change this value
IP_OR_DOMAIN_JENKINS=$1
MOT_DE_PASSE_USERJOB=$2

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

echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation des prérequis de Visual Studio Code ${NC}"
#Prérequis pour install Visual Studio Code
apt install -y software-properties-common apt-transport-https curl
curl -k -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#install Visual Studio Code
echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation de Visual Studio Code ${NC}"
apt install -y code

#install sshpass requis pour le transfert de la clée public RSA vers serveur Jenkins
pd_install_package sshpass


echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Génération de la paire de clée RSA256 pour serveur IC Jenkins ${NC}"
#Tester répertoir des clées ssh existe
if [ ! -d /home/$SUDO_USER/.ssh ]; then
        mkdir /home/$SUDO_USER/.ssh
fi

#supprimer la clée ssh de notre script s'il existe déja
if [ -f /home/$SUDO_USER/.ssh/ic-jenkins-key ]; then
        rm /home/$SUDO_USER/.ssh/ic-jenkins-key*
fi

#génerer la clée ssh dans le dossier home de l'utilisateur
ssh-keygen -t rsa -N "passphrase" -C "test key" -f /home/$SUDO_USER/.ssh/ic-jenkins-key
yes | cp /home/$SUDO_USER/.ssh/ic-jenkins-key.pub /home/userjob/.ssh/ic-jenkins-key.pub

echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Transfert de la clée public RSA256 vers le serveur Jenkins ${NC}"
#transfert clée public du client vers le serveur IC Jenkins via protocol SSH
sshpass -p $MOT_DE_PASSE_USERJOB ssh-copy-id -i ~/.ssh/ic-jenkins-key.pub -o StrictHostKeyChecking=no userjob@$IP_OR_DOMAIN_JENKINS

echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation Vagrant 2.2.6 ${NC}"
#install vagrant
curl -k -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb
apt -y update
sudo apt install ./vagrant_2.2.6_x86_64.deb






echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Colner le repo. example-python ${NC}"
# supprimer le répertoire git s'il existe
if [ -d /home/$SUDO_USER/example-python ]; then
        rm -rf /home/$SUDO_USER/example-python
fi

git clone https://github.com/vanessakovalsky/example-python.git /home/$SUDO_USER/example-python

echo "${GREEN} ************************************************************************* ${NC}"
echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Installation terminer avec succée ${NC}"
echo "${GREEN} ************************************************************************* ${NC}"
