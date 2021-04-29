#!/bin/bash

echo "--------------------------------"
echo "----- Planificateur de tâche -----------"
echo "----- Jenkins & WEB ------------"
echo "--------------------------------"
echo ""

#Planification sauvegarde
ws_creation_file_allow() {
    if ! test -f /etc/cron.allow ; then
    touch /etc/cron.allow
    echo "00 */1 * * * /home/vagrant/save.sh > /home/vagrant/save.log"
    fi
}

#Main
ws_creation_file_allow

echo "success"



