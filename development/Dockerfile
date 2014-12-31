# Docker container for Phundament 4 Applications
# ----------------------------------------------

FROM phundament/app:production

# Add system development packages
ENV IMAGE_DEVELOPMENT_APT_GET_DATE 2014-12-10-00-43-00
RUN apt-get update && \
    apt-get install -y \
        nano \
        php5-xdebug \
        mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV TERM linux

# Install application development packages
ENV YII_ENV dev
ENV YII_DEBUG true
RUN /usr/local/bin/composer install --prefer-dist --dev

# /!\ DEVELOPMENT ONLY SETTINGS /!\
# Running PHP-FPM as root, required for volumes mounted from host
RUN sed -i.bak 's/user = www-data/user = root/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/group = www-data/group = root/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i.bak 's/--fpm-config /-R --fpm-config /' /etc/init.d/php5-fpm
# /!\ DEVELOPMENT ONLY SETTINGS /!\


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following lines __uncommented__
# to the `Dockerfile`, eg. after installing additional system packages:

## Install application packages on image build when used as a base-image
#ADD ./composer.lock /app/composer.lock
#ADD ./composer.json /app/composer.json
#RUN /usr/local/bin/composer install --prefer-dist --dev
#ADD . /app

