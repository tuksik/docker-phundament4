Docker Container for Phundament 4
=================================

**12factor PHP Application Template for Yii 2.0**

*Container Version 0.0.6*

PHP-Development environment based on Debian Wheezy. 

Available on [DockerHub](https://registry.hub.docker.com/u/phundament/docker/).


Setup
-----

Create a MySQL container...

```
docker run -d \
    --name=mysql1  \
    -e MYSQL_ROOT_PASSWORD=sssshhhhhh \
    -e MYSQL_DATABASE=p4 \
    -e MYSQL_USER=phundament \
    -e MYSQL_PASSWORD=changeme \
    mysql
```

and a reverse proxy

```
docker run -d \
    --name rproxy -p 80:80 \
    -v /var/run/docker.sock:/tmp/docker.sock \
    jwilder/nginx-proxy
```

Run the application in a PHP container...

```
docker run \
    --name=myapp \
    --link mysql1:DB \
    -p 8000 \
    -e HOME=/root \
    -e VIRTUAL_HOST=myapp.127.0.0.1.xip.io,myapp.192.168.59.103.xip.io \
    phundament/docker
```

> Check your port with `docker ps` or add a port mapping `-p 8000:8000`

Optional(*)

```
docker exec myapp composer install
```

Setup database

```
docker exec myapp ./yii app/setup --interactive=0
```

Usage
-----

Access the applications through wildcard DNS and virtual hosts...

*Frontend-App*

- [myapp.127.0.0.1.xip.io](http://myapp.127.0.0.1.xip.io) (Linux)
- [myapp.192.168.59.103.xip.io](http://myapp.192.168.59.103.xip.io) (OS X, Windows) 

*Backend-App*

- [myapp.127.0.0.1.xip.io/backend](http://myapp.127.0.0.1.xip.io/backend) (Linux)
- [myapp.192.168.59.103.xip.io/backend](http://myapp.192.168.59.103.xip.io/backend) (OS X, Windows) 


(Re)start stopped application...

```
docker start myapp
```

---


See [phundament.com](http://phundament.com) for details.


