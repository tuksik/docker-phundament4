FROM debian:wheezy

# Modify the PHP modules below to match your project requirements
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

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin && \
    ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

RUN /usr/local/bin/composer global require "fxp/composer-asset-plugin:1.0.0-beta3" && \
    /usr/local/bin/composer create-project --stability=dev phundament/app:4.0.x-dev /app && \
    /app/init --"env=Dotenv"
    
# /!\ development setting
###COPY ./ /app/

RUN ln -s /app/backend/web /app/frontend/web/backend
    