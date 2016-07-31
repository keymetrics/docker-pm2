# pm2-docker-alpine

<a href="https://travis-ci.org/keymetrics/pm2-docker-alpine">
  <img src="https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master" alt="Build Status"/>
</a>

Node.js lightweight Docker image including the PM2 runtime.

This Docker image includes a better signal handling with graceful stop, direct log output in various format (prefixed logs, json logs) and simple [Keymetrics](https://keymetrics.io/) integration.

To maximize your Node.js workflow and performance, make sure you declare your application behavior into a [configuration file](http://pm2.keymetrics.io/docs/usage/application-declaration/) and enable the [cluster mode](http://pm2.keymetrics.io/docs/usage/cluster-mode/).

### Install

```bash
$ docker pull keymetrics/pm2-docker-alpine:latest
```

[Hub image](https://hub.docker.com/r/keymetrics/pm2-docker-alpine/)

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

You can also pass the JSON_LOGS env variable to ouput JSON instead of classic logs.

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
