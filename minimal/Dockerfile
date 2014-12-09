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
RUN apt-get update && \
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

# Install composer && global asset plugin (Yii 2.0 requirement)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta4"

# Install application template and packages
# Phundament 4 and its extensions can be used directly from the image or serve as local cache
RUN /usr/local/bin/composer create-project --prefer-dist --no-dev --stability=dev phundament/app /app

# Initialize application
WORKDIR /app
ONBUILD ADD . /app

# /!\ convenience settings, you may run the backend in a separate container /!\
RUN ln -s /app/backend/web /app/frontend/web/backend
RUN cp platforms/fig/.env .env

# Start application
CMD ["php","-S","0.0.0.0:8000","-t","/app/frontend/web"]
EXPOSE 8000
