# FROM php:8.2.28-apache-bullseye

# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# # Installation des dépendances
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev unzip

# # Configuration de la locale
# RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
#     locale-gen

# # Installation de Composer
# RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
#    mv composer.phar /usr/local/bin/composer

# # Installation de Symfony CLI
# RUN curl -sS https://get.symfony.com/cli/installer | bash \
#     && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# # Installation de Yarn
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends gnupg curl \
#     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#     && apt-get update \
#     && apt-get install -y yarn

# # Configuration et installation des extensions PHP
# RUN docker-php-ext-configure intl
# RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring zip gd xsl
# RUN pecl install apcu && docker-php-ext-enable apcu

# RUN a2enmod rewrite


# WORKDIR /var/www/

FROM php:8.2.28-apache-bullseye

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Installation des dépendances
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev unzip

# Configuration de la locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

# Installation de Composer
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
    mv composer.phar /usr/local/bin/composer

# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Installation de Yarn
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg curl \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# Configuration et installation des extensions PHP
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring zip gd xsl
RUN pecl install apcu && docker-php-ext-enable apcu

RUN a2enmod rewrite

WORKDIR /var/www/

# Copier le script d'entrypoint dans l'image
COPY bin/sh/entrypoint.sh /usr/local/bin/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir l'entrypoint pour automatiser le réglage des permissions et autres actions au démarrage
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Conserver la commande de démarrage par défaut de l'image Apache
CMD ["apache2-foreground"]
