#!/bin/sh
set -e

# Détecter l'UID et le GID de /var/www/app (monté depuis l'hôte)
HOST_UID=$(stat -c '%u' /var/www/app)
HOST_GID=$(stat -c '%g' /var/www/app)

echo "Détection automatique: UID=$HOST_UID, GID=$HOST_GID."

# Ajuster les permissions sur les dossiers de cache et log
echo "Correction des permissions sur var/cache et var/log..."
chown -R $HOST_UID:$HOST_GID /var/www/app/var/cache /var/www/app/var/log

# Nettoyer et régénérer le cache Symfony
echo "Nettoyage et régénération du cache..."
php bin/console cache:clear --no-warmup
php bin/console cache:warmup

# Relancer le processus principal en tant que l'utilisateur détecté
echo "Passage aux droits de $HOST_UID:$HOST_GID."
exec gosu $HOST_UID:$HOST_GID "$@"
