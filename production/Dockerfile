# Docker container for Phundament 4 Applications
# ----------------------------------------------
# See https://github.com/phundament/app/blob/master/docs/51-fig.md for instructions, 
# how to use this image with phundament/app.

FROM debian:wheezy

MAINTAINER Tobias Munk <tobias@diemeisterei.de>

# Prepare Debian environment
ENV DEBIAN_FRONTEND noninteractive

# Performance optimization - see https://gist.github.com/jpetazzo/6127116
# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# Install system base packages
ENV IMAGE_PRODUCTION_APT_GET_DATE 2014-12-10-00-36-00
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y \
        git \
        mercurial \ 
        curl \
        php5-curl \
        php5-cli \
        php5-gd \
        php5-intl \
        php5-mcrypt \
        php5-mysql \
        php5-xsl \
        php-apc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Initialize application
WORKDIR /app
ONBUILD ADD . /app
ADD container-files/root/.composer/config.json /root/.composer/config.json

# Install composer && global asset plugin (Yii 2.0 requirement)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta4"

# Install application template and packages
# Phundament 4 and its extensions can be used directly from the image or serve as local cache
RUN /usr/local/bin/composer create-project --no-dev --prefer-dist \
    phundament/app:dev-master \
    /app

# convenience settings, link backend to frontend container and use dist .env file
# Note: you may run the backend in a separate container /!\
RUN ln -s /app/backend/web /app/frontend/web/backend && \
    cp platforms/fig/.env .env

# Start application
CMD ["php","-S","0.0.0.0:8000","-t","/app/frontend/web"]
EXPOSE 8000


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following lines __uncommented__
# to the `Dockerfile`, eg. after installing system packages:

## Install application packages on image build when used as a base-image
#ONBUILD ADD . /app
#RUN /usr/local/bin/composer install --prefer-dist
