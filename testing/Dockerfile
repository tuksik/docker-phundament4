FROM phundament/app:development

# Install packages required for testing
RUN /usr/local/bin/composer global require  --prefer-dist \
        "codeception/codeception:2.0.*" "codeception/specify:*" "codeception/verify:*" && \
    /usr/local/bin/composer require  --prefer-dist --dev \
        "yiisoft/yii2-coding-standards:2.*" "yiisoft/yii2-codeception:2.*" "yiisoft/yii2-faker:2.*"


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following lines __uncommented__
# to the `Dockerfile`, eg. after installing system packages:

## Install application packages on image build when used as a base-image
#ADD ./composer.lock /app/composer.lock
#ADD ./composer.json /app/composer.json
#RUN /usr/local/bin/composer install --prefer-dist
#ADD . /app

