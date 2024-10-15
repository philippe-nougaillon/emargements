# Emargements

## Application Web de gestion de Feuilles de présences numériques


### Fonctionnement :

Importer vos participants par thématique (Ex: Santé, Mobilité, etc.)

Créer une session (Assemblée, session de formation, etc.) autour d'une ou plusieurs thématiques

Envoyer vos convocations (automatiquement ou manuellement) à l'ensemble des participants liés aux thématiques de la session. 

Chaque participant recoit la convocation et peux justifier de sa présence en y apposant sa signature manuscrite.

### Points clés :

* Une information claire et partagée entre les parties prenantes et les services 

* Une référence unique sur les émargements et sur tous les supports (PC/Smartphone)

+ Recherche et filtres 
+ Import rapide des participants
* Export Excel des émargements 
+ Notification par email automatique 
+ Audit trail des modifications (Activité de la base de données)
+ Les données relative à la signature manuscrite sont chiffrées directement dans la base de données.

# Installer l'application avec Docker

## Créer un nouveau serveur Arch Linux (chez Gandi) et s’y connecter
$ ssh arch@92.243.26.96

## Pour mettre à jour le système
$ sudo pacman -Syu

## Pour installer les packages git, docker, docker-compose
$ sudo pacman -S git docker docker-compose

## Pour voir les packages installés
$ sudo pacman -Qe

## Activer et Démarrer le Docker daemon
$ sudo systemctl enable docker

Nécessite parfois un reboot ou 
$ sudo systemctl start docker

## Pour checker l’état de Docker

$ systemctl status docker

# Installer TALEA depuis les sources

## Cloner le repo
$ git clone https://github.com/philippe-nougaillon/emargements.git

Dans le répertoire de Talea, copier le fichier dot.env.example en .env
$ cp dot.env.example .env

ou créer le fichier .env comme suit :
```
PGHOST=db
PGUSER=postgres
PGPASSWORD=changeme
```

## Créer le container 
$ sudo docker-compose build

## Créer la base de données TALEA
$ sudo docker-compose run --rm web bin/rails db:setup

## Créer le premier utilisateur (Administrateur)
$ sudo docker-compose run --rm web bin/rails c

> User.create(email: 'philippe.nougaillon@gmail.com', admin: true, password: '1234567890', confirmed_at: DateTime.now, organisation_id: Organisation.create(nom: 'CESER').
id)

> exit

## Démarrer le serveur Ruby on Rails
$ sudo docker-compose up

## Lancer TALEA
Ouvrir un navigateur et aller sur http://ip_du_serveur:3000 

Se connecter avec l'utilisateur/adminstrateur nouvellement créé 
