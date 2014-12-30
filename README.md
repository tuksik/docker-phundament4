Docker Container for Phundament 4
=================================

**12factor PHP Application Template for Yii 2.0**

*Container Version 0.1.0-dev*

Yii 2 Application environment based on Debian Wheezy.


Tags
----

- `docker/phundament:production` minimal installation without development pacakges
- `docker/phundament:development`, `:latest` default installation with development pacakges
- `docker/phundament:testing` testing installation with additional pacakges

Available on [DockerHub](https://registry.hub.docker.com/u/phundament/app/).


Setup
-----

First, create a MySQL container for the application data and a reverse proxy for easy access...

```
docker run -d \
    --name=mysql1  \
    -p 3306 \
    -e MYSQL_ROOT_PASSWORD=secretroot \
    -e MYSQL_DATABASE=p4 \
    -e MYSQL_USER=phundament \
    -e MYSQL_PASSWORD=changeme \
    mysql

docker run -d \
    --name rproxy -p 80:80 \
    -v /var/run/docker.sock:/tmp/docker.sock \
    jwilder/nginx-proxy
```

Run the application...

```
docker run \
    --detach \
    --name=myapp \
    --link mysql1:DB \
    -p 80 \
    -e VIRTUAL_HOST=myapp.127.0.0.1.xip.io,myapp.192.168.59.103.xip.io \
    phundament/app
```

> Check with `docker ps` which ports docker has mapped for the container or 
> add a port mapping `-p 8000:8000` to your commmand.

Setup database...

```
docker exec myapp ./yii app/setup --interactive=0
```


View logs of running application...

```
docker logs --follow myapp
``` 


Usage
-----

Access the applications through wildcard DNS and virtual hosts...

*Frontend-App*

- [myapp.127.0.0.1.xip.io](http://myapp.127.0.0.1.xip.io) (Linux)
- [myapp.192.168.59.103.xip.io](http://myapp.192.168.59.103.xip.io) (OS X, Windows) 

*Backend-App*

- [myapp.127.0.0.1.xip.io/backend](http://myapp.127.0.0.1.xip.io/admin) (Linux)
- [myapp.192.168.59.103.xip.io/backend](http://myapp.192.168.59.103.xip.io/admin) (OS X, Windows) 


Start/stop application...

```
docker start myapp
docker stop myapp
```



Application Development
-----------------------

Getting the source code from the image by mounting a `myapp` directory into the container and copying the app into it...

    export MYAPP=myapp

    docker run \
        -v `pwd`/$MYAPP:/app-install \
        -e HOME=/root \
        phundament/app \
        cp -r /app/. /app-install
    
    cd $MYAPP

Setup application...

    echo "FROM phundament/docker" >> Dockerfile

Build an run the container with a linked MySQL instance (see above)... 

```
docker build -t $MYAPP .

docker run \
    --detach=true \
    --name=$MYAPP \
    --link mysql1:DB \
    -p 80 \
    -e DB_ENV_MYSQL_DATABASE=$MYAPP \
    -e VIRTUAL_HOST=$MYAPP.127.0.0.1.xip.io,$MYAPP.192.168.59.103.xip.io \
    $MYAPP
```

Check if it is up with `docker ps`, your output should look similar to:

```
Kraftbuch:TESTING tobias$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                     NAMES
c197783f13b5        myapp:latest        "php -S 0.0.0.0:8000   8 seconds ago       Up 7 seconds        0.0.0.0:49165->8000/tcp   myapp
```

Setup the database...

```
docker exec $MYAPP ./yii app/setup --interactive=0
```

Access the application, eg. under `http://192.168.59.103:49165` or via the reverse proxy `open http://$MYAPP.192.168.59.103.xip.io`. 

> For more details about Phundament application development see also [phundament.com/docs](http://phundament.com/docs).

Building the images
-------------------

Build in sequence, since they depend on each other...

```
docker build -t phundament/app:production production
docker build -t phundament/app:development development
docker build -t phundament/app:testing testing
```

Testing the images
------------------

Start MySQL container in advance (see above)...

```
docker start mysql1
```

Run app...

```
export APP=myapp
```

Production (interactive)

```
docker -D run -it \
    -p 80 \
    --name $APP \
    -e APP_NAME=$APP \
    -e YII_ENV=prod \
    -e YII_DEBUG=1 \
    -e DB_ENV_MYSQL_DATABASE=$APP \
    --link mysql1:DB \
    phundament/app:production
```

Development (interactive)

```
docker -D run -it \
    -p 80 \
    --name $APP \
    -e APP_NAME=$APP \
    -e DB_ENV_MYSQL_DATABASE=$APP \
    --link mysql1:DB \
    phundament/app:development
```

Use replace `-it` with `-d` for detached containers.

---


See [phundament.com](http://phundament.com) for details.


