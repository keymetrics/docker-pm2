# pm2hive/docker-volume

![https://travis-ci.org/pm2hive/docker-volume](https://travis-ci.org/pm2-hive/docker-volume.svg?branch=master)

Node.js lightweight Docker image including the [PM2 runtime](http://pm2.keymetrics.io/) for production Node.js applications.

This Docker image in association with PM2, allow to enhance Node.js application uptime, [performance](http://pm2.keymetrics.io/docs/usage/cluster-mode/), [logs systems](http://pm2.keymetrics.io/docs/usage/log-management/) and includes a clean graceful shutdown mechanism to auto-scale containers properly.

### Usage

```bash
$ docker pull pm2hive/docker-volume
```

Versions available:

- pm2hive/docker-volume:latest with Node.js 6
- pm2hive/docker-volume:4 with Node.js 4
- pm2hive/docker-volume:0.12 with Node.js 0.12

These images are automatically built from the Docker hub based on this Github repository branch arrangement.

[Hub link](https://hub.docker.com/r/pm2hive/docker-volume/)

### Running the container

Make sure you declared a [process file](http://pm2.keymetrics.io/docs/usage/application-declaration/) called process.yml, this file will be started by PM2.

```bash
# Get example app
$ git clone https://github.com/pm2hive/docker-volume
# Run example app, mounted as a volume
$ docker run -p 80:3000 -v `pwd`/example_app:/app pm2hive/docker-volume
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
