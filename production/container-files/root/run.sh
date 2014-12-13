#!/bin/bash

function setEnvironmentVariable() {

    if [ -z "$2" ]; then
            echo "Environment variable '$1' not set."
            return
    fi
    echo "env[$1] = $2" >> /etc/php5/fpm/pool.d/www.conf
}

# Grep for variables that look like docker set them (_PORT_)
for _curVar in `env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    setEnvironmentVariable ${_curVar} ${!_curVar}
done

# create database in MySQL server
/usr/bin/php -f /root/create-db.php

# create schema
./yii app/setup --interactive=0

# start PHP and nginx
service php5-fpm start & /usr/sbin/nginx