# Docker container for Phundament 4 Applications
# ----------------------------------------------

FROM phundament/app:production

# Add system packages
ENV IMAGE_DEVELOPMENT_APT_GET_DATE 2014-12-10-00-43-00
RUN apt-get update && \
    apt-get install -y \
        php5-imagick \
        mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install development packages
RUN /usr/local/bin/composer install --prefer-dist

# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following lines __uncommented__
# to the `Dockerfile`, eg. after installing system packages:

## Install application packages on image build when used as a base-image
#ADD . /app
#RUN /usr/local/bin/composer install --prefer-dist
