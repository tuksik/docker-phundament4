#!/bin/bash

set -e

function setEnvironmentVariable() {
    if [ -z "$2" ]; then
            echo "Environment variable '$1' not set."
            return
    fi
    echo "env[$1] = \"$2\"" >> /etc/php5/fpm/pool.d/www.conf
}

# Grep all ENV variables
for _curVar in `env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    setEnvironmentVariable ${_curVar} ${!_curVar}
done

# wait for mysql
while ! curl http://$DB_PORT_3306_TCP_ADDR:$DB_PORT_3306_TCP_PORT/
do
  echo "$(date) - still trying"
  sleep 1
done
echo "$(date) - connected successfully"

# create database in MySQL server, if not exists
/usr/bin/php -f /root/create-db.php

# prepare log output
mkdir -p /app/runtime/logs /app/web/assets
touch /var/log/nginx/access.log \
      /var/log/nginx/error.log \
      /app/runtime/logs/web.log \
      /app/runtime/logs/console.log
chmod -R 777 /app/runtime /app/web/assets

# create schema, disable with APP_ENABLE_AUTOMIGRATIONS=0
if [ "$APP_ENABLE_AUTOMIGRATIONS" != 0 ] ; then
  ./yii app/setup --interactive=0
fi

# start PHP and nginx
service php5-fpm start
/usr/sbin/nginx
