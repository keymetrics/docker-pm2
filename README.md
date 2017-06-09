# keymetrics/pm2-docker-alpine

![https://travis-ci.org/keymetrics/pm2-docker-alpine](https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master)

Node.js lightweight Docker image including the [PM2 runtime](http://pm2.keymetrics.io/) for production applications.

This Docker image in association with PM2, increase application uptime, increase performance (spawn multiple processes and [load-balance network query](http://pm2.keymetrics.io/docs/usage/cluster-mode/) without any code change) and allow graceful state change, adapted to production environment.

### Usage

```bash
$ docker pull keymetrics/pm2-docker-alpine
```

Versions available:

- keymetrics/pm2-docker-alpine:latest with `node:alpine`
- keymetrics/pm2-docker-alpine:8 with `node:8-alpine`
- keymetrics/pm2-docker-alpine:7 with `node:7-alpine`
- keymetrics/pm2-docker-alpine:6 with `node:6-alpine`
- keymetrics/pm2-docker-alpine:4 with `node:4-alpine`
- keymetrics/pm2-docker-alpine:next with `node:alpine` and `pm2@next`

These images are automatically built from the Docker hub based on this Github repository folder arrangement.

[Hub link](https://hub.docker.com/r/keymetrics/pm2-docker-alpine/)

### Running the container

Make sure you declared a [process file](http://pm2.keymetrics.io/docs/usage/application-declaration/) called process.yml, this file will be started by PM2.

```bash
# Get example app
$ git clone https://github.com/keymetrics/pm2-docker-alpine
# Run example app, mounted as a volume
$ docker run -p 80:3000 -v `pwd`/example_app:/app keymetrics/pm2-docker-alpine
```

For [Keymetrics](https://keymetrics.io/) linking you can set the extra env variables:

```
-e "KEYMETRICS_SECRET=YYY
-e "KEYMETRICS_PUBLIC=XXX"
-e "INSTANCE_NAME=hostname"
```

### Log output

Append to pm2-docker CMD directive:

- **--json** to output logs in JSON
- **--format** to output logs in key=val style
- **--raw** to display logs in raw format

## Actions

### Monitoring CPU/Usage of each process

```bash
$ docker exec -it <container_id> pm2 monit
```

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
