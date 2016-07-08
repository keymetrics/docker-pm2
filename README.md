# pm2-docker-alpine

Official lightweight Docker image for PM2 + Keymetrics integration.

Uses the dedicated pm2-docker command for nice integration with Docker.

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

???

### Restart your app in docker container

```bash
$ docker exec -it nodepm2 pm2 restart app
```

### Display your app logs in docker container

```bash
$ docker exec -it nodepm2 pm2 logs app
```
