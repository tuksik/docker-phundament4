Docker container for Phundament 4
=================================

**12factor PHP Application Template for Yii 2.0**


Yii 2 Application environment based on Debian Wheezy.


Tags
----

- `phundament/app:latest` default installation with development packages (stable)
- `phundament/app:4.0-production` minimal installation (stable)
- `phundament/app:4.0-development` default installation with development packages (stable)
- `phundament/app:production` minimal installation (unstable)
- `phundament/app:development` default installation with development packages (unstable)

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

Pick a name for your new application, this is just for convenience to be able to copy & paste the commands below. 

```
export APP_NAME=myapp
```

Run the application...

```
docker run \
    --detach \
    --name=$APP_NAME \
    --link mysql1:DB \
    --publish 80 \
    --env VIRTUAL_HOST=myapp.127.0.0.1.xip.io,myapp.192.168.59.103.xip.io \
    --env APP_PRETTY_URLS=1 \
    phundament/app
```

> Check with `docker ps` which ports docker has mapped for the container or 
> add a port mapping `-p 8080:80` to your commmand.

View logs of running application...

```
docker logs --follow $APP_NAME
``` 


Usage
-----

Access the applications through wildcard DNS and virtual hosts...

*Frontend-App*

- [myapp.127.0.0.1.xip.io](http://myapp.127.0.0.1.xip.io) (Linux)
- [myapp.192.168.59.103.xip.io](http://myapp.192.168.59.103.xip.io) (OS X, Windows) 

*Backend-App*

- [myapp.127.0.0.1.xip.io/admin](http://myapp.127.0.0.1.xip.io/admin) (Linux)
- [myapp.192.168.59.103.xip.io/admin](http://myapp.192.168.59.103.xip.io/admin) (OS X, Windows) 


Start/stop application...

```
docker start $APP_NAME
docker stop $APP_NAME
```

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
export APP_NAME=myapp
```

Production (interactive)

```
docker -D run -it \
    -p 80 \
    --name $APP_NAME \
    -e APP_NAME=$APP_NAME \
    -e YII_ENV=prod \
    -e YII_DEBUG=1 \
    -e DB_ENV_MYSQL_DATABASE=$APP_NAME \
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

> Note: Replace `-it` with `-d` for detached containers.


 
