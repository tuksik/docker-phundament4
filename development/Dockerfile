# Docker container for Phundament 4 Applications
# ----------------------------------------------

FROM phundament/docker:production

# Add system packages
RUN apt-get update && \
    apt-get install -y \
        php5-imagick \
        mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Install development packages
RUN /usr/local/bin/composer install --prefer-dist

# Install application packages on image build when used as a base-image
ONBUILD ADD . /app


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following line to the `Dockerfile`:
#
# RUN /usr/local/bin/composer install --prefer-dist
