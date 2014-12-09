FROM phundament/standard

# Install packages required for testing
RUN /usr/local/bin/composer global require  --prefer-dist \
        "codeception/codeception:2.0.*" "codeception/specify:*" "codeception/verify:*" && \
    /usr/local/bin/composer require  --prefer-dist --dev \
        "yiisoft/yii2-coding-standards:2.*" "yiisoft/yii2-codeception:2.*" "yiisoft/yii2-faker:2.*"

# Install application packages on image build when used as a base-image
ONBUILD ADD . /app
ONBUILD RUN /usr/local/bin/composer install --prefer-dist