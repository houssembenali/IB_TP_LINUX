# IB_TP_LINUX
Travaux pratique demander par IB Formation et réaliser Arnaud DEGEZ &amp; Houssem Eddine AMOR BEN ALI.
Ce projet est réaliser avec la méthodologie Agile Kanban.

Les Projet, Milestones ainsi que leurs issues sont consultable en public.
Les issues sont référencer dans les commit afin de savoir les commiter lier pour chaque issue.



# Description et documentation ci-dessous

Les script ssh contient des log pour facilité le suivie d'état d'avancement des traitement.
Chaque script qui se termine avec succée affiche un message postif vert.
Il existe 3 type de log :
- les erreurs en ![#f03c15] ROUGE `#f03c15`
- les warning en ![#f0cf15] JAUNE `#f0cf15`
- les info en ![#c5f015] VERT `#c5f015`


Script de poste développeur (2 args)
```console
hoos@ib:~$ sudo postdev.ssh 127.0.0.1 passwordJenkins
```
le script prends 2 argement en paramétre comme l'exemple ci-dessus :
- le nom de domaine ou l'adresse ip du serveur Jenkins déployer
- le mot de pass du serveur Jenkins déployer pour le transfert de la clée public du développeur.



#Commande corbeille :
commande install deb file corbeille
```console
hoos@ib:~$ sudo apt install /home/user/IB_TP_LINUX/corbeille.deb
```
      RM : déplacer un ou plusieur fichiers vers la corbeille.
      TRASH : Afficher les fichier dispo dans la corbeille.
      RESOTRE : réstaurer un ou plusieur fichiers vers leurs emplacements original.
      
Exemple :
```console
hoos@ib:~$ corbeille RM /home/hoos/houssem.txt /home/hoos/Adrnaud.pdf
hoos@ib:~$ corbeille TRASH
hoos@ib:~$ corbeille RESTORE /home/hoos/houssem.txt /home/hoos/Adrnaud.pdf
```



IMPORTANT : Pour des mesures de sécurité le projet doit êtres, de préférence, contribuer par SSH et non pas avec par HTTPS
