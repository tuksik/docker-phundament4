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

# Update and install system base packages
ENV IMAGE_PRODUCTION_APT_GET_DATE 2015-01-07-22-44
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y \
        git \
        mercurial \ 
        curl \
        nginx \
        mysql-client \
        php5-fpm \
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
ADD container-files/root/.composer/config.json /root/.composer/config.json

# Install composer && global asset plugin (Yii 2.0 requirement)
ENV COMPOSER_HOME /root/.composer
ENV PATH /root/.composer/vendor/bin:$PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.0.0-alpha9 && \
    /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta4"

# Install application template and packages
# Phundament 4 and its extensions can be used directly from the image or serve as local cache
ENV YII_ENV prod
ENV YII_DEBUG 0
ENV IMAGE_PRODUCTION_CREATE_PROJECT 2015-01-09-17-10
RUN /usr/local/bin/composer create-project --no-dev --prefer-dist \
    phundament/app:dev-master \
    /app

# Configure nginx
ADD container-files/etc/nginx/sites-available/default /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && \
    sed -i.bak 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/php5/fpm/php.ini && \
    sed -i.bak '/;catch_workers_output = yes/ccatch_workers_output = yes' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/log_errors_max_len = 1024/log_errors_max_len = 65536/' /etc/php5/fpm/php.ini
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Start application
ENV APP_ENABLE_AUTOMIGRATIONS=1
ADD container-files/root/create-db.php /root/create-db.php
ADD container-files/root/run.sh /root/run.sh
RUN cp .env-dist .env && \
    chmod 700 /root/run.sh


CMD ["/root/run.sh"]
EXPOSE 80


# /!\ debug settings /!\
#RUN echo "<?php phpinfo(); ?>" >> /app/backend/web/info.php


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following lines __uncommented__
# to the `Dockerfile`, eg. after installing additional system packages:

## Install application packages on image build when used as a base-image
#ADD ./composer.lock /app/composer.lock
#ADD ./composer.json /app/composer.json
#RUN /usr/local/bin/composer install --prefer-dist --no-dev
#ADD . /app
