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
HTML_INDEX_CONTENT='!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"><html><head><title>Ma première page avec du style</title></head><body><!-- Menu de navigation du site -->
<ul class="navbar"><li><a href="index.html">Home page</a></ul><!-- Contenu principal --><h1>Ma première page avec du style</h1><p>Bienvenue sur ma page avec du style!
<p>Il lui manque des images, mais au moins, elle a du style. Et elle a desliens, même s''ils ne mènent nulle part...&hellip;<p>Je devrais étayer, mais je ne sais comment encore.
<!-- Signer et dater la page, c''est une question de politesse! --><address>Fait le 22 avril 2021<br>par moi.</address></body></html>'

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
#génération de la page index.html
echo "${GREEN}$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Génération de page index /var/www/html/index.html"
echo $HTML_INDEX_CONTENT > /var/www/html/index.html
