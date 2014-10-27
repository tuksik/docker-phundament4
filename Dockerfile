FROM debian:wheezy

MAINTAINER Tobias Munk <tobias@diemeisterei.de>

# Prepare Debian environment
ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN apt-get update && \
    apt-get install -y \
        git \
        mercurial \ 
        curl \
        php5-curl \
        php5-cli \
        php5-imagick \
        php5-intl \
        php5-mcrypt \
        php5-mysql \
        php-apc && \
    rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install global asset plugin (Yii 2.0 requirement)
RUN /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta3"

# Download Phundament 4 extensions to image and fill composer cache
RUN /usr/local/bin/composer create-project --prefer-dist --stability=dev phundament/app /app-dist

WORKDIR /app
ONBUILD ADD . /app

# Initialize application 
ONBUILD RUN /app/init --env=Dotenv --overwrite=n
ONBUILD RUN /usr/local/bin/composer install --prefer-dist
ONBUILD RUN ["/app/yii","migrate","--interactive=0"]

#TODO: obsolete with fig?
# /!\ development settings:
#ONBUILD RUN ln -s /app/backend/web /app/frontend/web/backend
#ONBUILD EXPOSE 8000
#ONBUILD CMD ["php","-S","0.0.0.0:8000","-t","/app/frontend/web"]
