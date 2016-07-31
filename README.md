# pm2-docker-alpine

![https://travis-ci.org/keymetrics/pm2-docker-alpine](https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master)

Node.js lightweight Docker image including the [PM2 runtime](http://pm2.keymetrics.io/).

This Docker image includes a better signal handling with graceful stop, direct log output in various format (prefixed logs, json logs) and easy [Keymetrics](https://keymetrics.io/) integration.

All version are tagged on the [pm2-docker-alpine](https://github.com/keymetrics/pm2-docker-alpine) repository.

### Usage

```bash
$ docker pull keymetrics/pm2-docker-alpine:latest
```

Versions available:

- keymetrics/pm2-alpine-docker:latest with Node.js 6
- keymetrics/pm2-alpine-docker:4 with Node.js 4
- keymetrics/pm2-alpine-docker:0.12 with Node.js 0.12

These images are automatically built from the Docker hub based on this Github repository.

[Hub link](https://hub.docker.com/r/keymetrics/pm2-docker-alpine/)

### Running the container

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

### Listing managed processes

```bash
$ docker exec -it <container_id> pm2 list
```

### Get more information about a process

```bash
$ docker exec -it <container_id> pm2 show <app_name>
```

### 0sec downtime reload all applications

```bash
$ docker exec -it <container_id> pm2 reload all
```

### Automatically synchronize your application with git

Add into your Dockerfile:

```
RUN pm2 install pm2-auto-pull
```

Or try it:

```bash
$ docker exec -it <container_id> pm2 install pm2-auto-pull
```

*Make sure the .git is present in your application source folder.*

## License

MIT
