# 1. Prérequis
### Avant de commencer, assurez-vous d’installer les outils suivants sur votre machine :

# Docker Desktop
### Permet de créer et gérer vos conteneurs Docker via une interface conviviale.

# Docker Compose
### Facilite la définition et l’exécution d’applications multi-conteneurs via un fichier YAML.

# Git
### Pour cloner et gérer votre code source.

# 2. Structure de votre projet
Une bonne organisation de votre projet facilite la maintenance et l’évolution de votre application. Voici un exemple de structure de projet typique :


test_docker_symfony/
├── docker-compose.yml      # Définition des services et des configurations Docker
├── php/                    # Dossier dédié au conteneur web
│   ├── Dockerfile          # Instructions de build pour l’image Apache/PHP
│   └── vhosts/             # Configuration des hôtes virtuels pour Apache
│       └── vhosts.conf     # Exemple de configuration Apache (sites)
└── project/                # Projet Symfony réel
    ├── bin/                # Fichiers exécutables de Symfony (console, etc.)
    ├── config/             # Configuration de l’application (services, routes, etc.)
    ├── public/             # Racine web (index.php, assets, etc.)
    ├── src/                # Code source PHP de l’application
    ├── templates/          # Templates Twig pour l’affichage
    ├── var/                # Fichiers générés par Symfony (cache, logs)
    └── vendor/             # Dépendances Composer

Détails des principaux dossiers
docker-compose.yml :
Ce fichier définit l’ensemble des services (conteneurs) comme la base de données, phpMyAdmin, MailDev et le conteneur web (« www »).

php/Dockerfile :
Contient les instructions pour construire l’image Docker qui servira votre application web (exécution d’Apache avec PHP).

project/ :
C’est le cœur de votre application Symfony.
– Le dossier public/ contient l’index du site.
– Le dossier var/ héberge le cache, les logs et autres fichiers générés par Symfony.

Note :
Lorsqu’on se connecte au conteneur web via Docker, le répertoire par défaut est /var/www.
Puisque votre application Symfony se trouve dans le sous-dossier project, vous devrez vous positionner dans /var/www/project pour exécuter les commandes Symfony (par exemple, bin/console).

## 3. Commandes Utiles et Explications
# 3.1 Installation et Construction
# Cloner le dépôt Git
# Clonez votre projet depuis le dépôt et positionnez-vous dans le répertoire cloné :

git clone https://github.com/votre-utilisateur/docker_PHP_Symfony_frame.git

cd test_docker_symfony


Construire l’image Docker (avec cache)
Cette commande utilise le Dockerfile situé dans le dossier php/ et construit l’image en se basant sur le contexte du projet :

```docker build -f php/Dockerfile -t mon-image .```

Construire l’image Docker sans cache
Pour forcer une reconstruction complète et éviter l’utilisation du cache local, utilisez :

```docker build -f php/Dockerfile --no-cache -t mon-image .```

Démarrer les services Docker
Lancez l’ensemble des conteneurs définis dans votre fichier docker-compose.yml en arrière-plan (mode détaché) :

```docker compose up -d```

````$env:PROJECT_DIR = "tocomplete with principal folder"````

# 3.2 Création et Gestion du Projet Symfony

Créer un nouveau projet Symfony (si nécessaire)
Vous pouvez utiliser Symfony CLI pour initialiser un projet Symfony directement dans le conteneur. Par exemple, en vous connectant au conteneur et en positionnant le répertoire de travail :

# Exemple avec une variable d'environnement $PROJECT_DIR qui représente le nom du conteneur
```docker exec -w /var/www $env:PROJECT_DIR symfony new --webapp app``
Ici, le projet sera créé dans /var/www/app.

Installer les dépendances avec Composer
Pour installer ou mettre à jour les dépendances depuis le dossier de votre projet Symfony, utilisez :

```docker exec -w /var/www/project $env:PROJECT_DIR composer install``
Pour ajouter une nouvelle dépendance (exemple : Twig) :


docker exec -w /var/www/project $env:PROJECT_DIR composer require twig
3.3 Commandes de Débogage et Maintenance
Accéder au conteneur
Pour ouvrir un shell interactif dans le conteneur web :


```docker exec -it $env:PROJECT_DIR bash'''`
Une fois connecté, n’oubliez pas de vous déplacer dans le dossier du projet Symfony :

````cd project```
Vider le cache Symfony
Pour éviter les problèmes de cache ou lorsque vous mettez à jour la configuration :


```docker exec -w /var/www/project $env:PROJECT_DIR bin/console cache:clear```

Voir les logs des services
Affichez les logs générés par les conteneurs pour diagnostiquer d’éventuels problèmes :

docker compose logs
Voir les logs Apache
Pour consulter les erreurs ou messages générés par Apache (dans le conteneur web) :

bash
Copier
docker exec -it $env:PROJECT_DIR cat /var/log/apache2/error.log
3.4 Problèmes de Permissions et leur Résolution
Les problèmes de permissions surviennent souvent avec Docker, notamment pour le cache Symfony. Voici quelques conseils :

Exécution du conteneur avec un script d'entrypoint
Vous pouvez automatiser l’ajustement des permissions avec un script d’entrypoint qui détecte l’UID et le GID du dossier monté, ce qui évite de devoir lancer manuellement :

bash
Copier
sudo chown -R www-data:www-data /var/www/project/var/cache
Cette opération peut être intégrée dans votre image Docker via un script d’entrypoint.

Utilisation de variables d’environnement pour UID/GID
Plutôt que de spécifier ces informations à la main, vous pouvez configurer votre Dockerfile/entrypoint pour détecter automatiquement les droits d’accès.

Astuce :
Si vous constatez des problèmes lors du démarrage des conteneurs, vérifiez que les fichiers et dossiers montés ont les permissions adéquates pour l’utilisateur exécutant Apache (souvent www-data).

# 4. Accès aux Services
Une fois vos conteneurs démarrés, vous pouvez accéder aux services suivants :

Application Symfony
# http://localhost:8741
(Assurez-vous que le port est bien mappé dans votre docker-compose.yml.)

phpMyAdmin
# http://localhost:8080

Serveur : db

Utilisateur : root

Mot de passe : (laisser vide)

MailDev
http://localhost:8081

# 5. Résumé des Commandes Clés

### Commande	Description

```git clone https://github.com/votre-utilisateur/test_docker_symfony.git```	Cloner le dépôt depuis GitHub.

```docker build -f php/Dockerfile -t mon-image .```	Construire l'image Docker à partir du Dockerfile situé dans php/, avec le contexte de build à la racine du projet.
```docker build -f php/Dockerfile --no-cache -t mon-image .```	Construire l'image Docker sans utiliser le cache.

se décompose ainsi :

## docker build
## C’est la sous‑commande de Docker qui crée une image à partir d’un ensemble d’instructions définies dans un Dockerfile.

```-f php/Dockerfile```
# Le flag -f (ou --file) permet de spécifier le chemin vers le Dockerfile à utiliser.

# Ici, on indique que le Dockerfile se trouve dans le sous‑dossier php/ du répertoire courant.

# Sans ce flag, Docker chercherait par défaut un fichier nommé Dockerfile à la racine du contexte de build.

# -t mon-image
# Le flag -t (ou --tag) assigne un nom et, facultativement, une balise (tag) à l’image qui sera construite.

# Dans cet exemple, l’image sera nommée mon-image.

# Vous pouvez aussi préciser une version, par exemple -t mon-image:1.0 ou -t mon-image:latest.

````.``` (le point final)
# C’est le contexte de build, c’est‑à‑dire l’ensemble des fichiers et dossiers accessibles pour le Dockerfile.

# Le . signifie « répertoire courant ».

# Docker va envoyer tout ce qui se trouve sous ce chemin (en tenant compte du .dockerignore) vers le démon Docker pour que les instructions COPY, ADD, etc., puissent y accéder.


```docker compose up -d```	Lancer tous les services définis dans le fichier docker-compose.yml en arrière-plan.
```docker exec -it $env:PROJECT_DIR bash```	Ouvrir une session shell dans le conteneur web.
```docker exec -w /var/www/project $env:PROJECT_DIR bin/console cache:clear```	Vider le cache Symfony.
```docker compose logs```	Afficher les logs des conteneurs pour faciliter le débogage.

