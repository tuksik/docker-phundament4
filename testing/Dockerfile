FROM phundament/docker:development

# Install packages required for testing
RUN /usr/local/bin/composer global require  --prefer-dist \
        "codeception/codeception:2.0.*" "codeception/specify:*" "codeception/verify:*" && \
    /usr/local/bin/composer require  --prefer-dist --dev \
        "yiisoft/yii2-coding-standards:2.*" "yiisoft/yii2-codeception:2.*" "yiisoft/yii2-faker:2.*"

# Install application packages on image build when used as a base-image
ONBUILD ADD . /app


# Note! To ensure a minimum of additional data layers for the containers in __your__ application,
# you should add the `vendor` folder to `.dockerignore` and add the following line to the `Dockerfile`:
#
# RUN /usr/local/bin/composer install --prefer-dist