# pm2-docker-alpine

Official lightweight Docker image for PM2 + Keymetrics integration.

Uses the dedicated pm2-docker command for nice integration with Docker.

To maximize your Docker/PM2 workflow and performance, make sure you declare your application behavior into a [YML or JSON configuration file](http://pm2.keymetrics.io/docs/usage/application-declaration/) and enable the [cluster mode](http://pm2.keymetrics.io/docs/usage/cluster-mode/)

### Install

```bash
$ docker pull keymetrics/pm2-docker-alpine:latest
```

### Create new nodejs pm2 container

```
$ docker run -d                  \
         -p 3000:80              \
         -v /path/to/source:/app \
         -e "APP=ecosystem.yml"  \
         -e "SECRET_KEY=keymetrics_secret" \
         -e "PUBLIC_KEY=keymetrics_public" \
         -e "INSTANCE_NAME=instance_name"  \
         keymetrics/pm2-docker-alpine
```

* $APP specify your node app start file or [app declaration](http://pm2.keymetrics.io/docs/usage/application-declaration/)
* $SECRET_KEY Keymetrics bucket secret key
* $PUBLIC_KEY Keymetrics bucket public key
* $INSTANCE_NAME Name for this instance on Keymetrics

## Actions

### Git pull application and reload

```bash
$ docker exec -it nodepm2 pm2 pull app_name
```

### 0sec downtime reload all applications

```bash
$ docker exec -it nodepm2 pm2 reload all
```

### Display logs

```bash
$ docker exec -it nodepm2 pm2 logs
```

### Automatically synchronize your application with git

Add into your Dockerfile:

```
RUN pm2 install pm2-auto-pull
```

Or install (not sur that works?)

```bash
$ docker exec -it nodepm2 pm2 install pm2-auto-pull
```

Make sure the .git is present in your application source folder.
