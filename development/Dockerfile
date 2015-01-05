# Docker container for Phundament 4 Applications
# ----------------------------------------------

FROM phundament/app:production

# Add system development packages
ENV IMAGE_DEVELOPMENT_APT_GET_DATE 2015-01-04-01-00
RUN apt-get update && \
    apt-get install -y \
        nano \
        php5-xdebug && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV TERM linux

# Install packages required for testing globally
RUN /usr/local/bin/composer global require  --prefer-dist \
        "codeception/codeception:2.0.*" "codeception/specify:*" "codeception/verify:*"

# Install application development packages
RUN /usr/local/bin/composer install --prefer-dist --dev

# Set development environment variables
ENV YII_ENV dev
ENV YII_DEBUG true

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

