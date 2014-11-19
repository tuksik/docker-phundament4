# Docker container for Phundament 4 Applications
# ----------------------------------------------
# See https://github.com/phundament/app/blob/master/docs/51-fig.md for instructions, 
# how to use this image with phundament/app.

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
        php5-gd \
        php5-intl \
        php5-mcrypt \
        php5-mysql \
        php5-xsl \
        php-apc && \
    rm -rf /var/lib/apt/lists/*

# Install composer && global asset plugin (Yii 2.0 requirement)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta3"

# Download Phundament 4 and extensions
RUN /usr/local/bin/composer create-project --prefer-dist --stability=dev phundament/app /app

WORKDIR /app
ONBUILD ADD . /app

# Initialize application 
ONBUILD RUN /usr/local/bin/composer install --prefer-dist

# /!\ development settings /!\
#ONBUILD RUN ln -s /app/backend/web /app/frontend/web/backend
#ONBUILD EXPOSE 8000
#ONBUILD CMD ["php","-S","0.0.0.0:8000","-t","/app/frontend/web"]
