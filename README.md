# PM2

[![Docker Hub](http://dockeri.co/image/keymetrics/pm2)](https://hub.docker.com/r/keymetrics/pm2/)

[![Travis CI](https://travis-ci.org/keymetrics/pm2.svg?branch=master)](https://travis-ci.org/keymetrics/pm2)
[![LICENSE](https://img.shields.io/npm/l/express.svg)](LICENSE)
[![Contributors](https://img.shields.io/github/contributors/keymetrics/pm2.svg)](https://github.com/keymetrics/pm2/contributors)
[![Stars](https://img.shields.io/github/stars/keymetrics/pm2.svg?style=flat)](https://github.com/keymetrics/pm2/stargazers)

Production ready nodeJS Docker image including the [PM2 runtime](http://pm2.keymetrics.io/).

The goal of this image is to wrap your applications into a proper Node.js production environment. It solves major issues when running Node.js applications inside a container like:

- Correct PID 1 signals Handling & Forwarding
- Graceful application Start and Shutdown
- Seamless application clustering to increase performance and reliability

Further than that, using PM2 as a layer between the container and the application brings PM2 features like [application declaration file](http://pm2.keymetrics.io/docs/usage/application-declaration/), [customizable log system](http://pm2.keymetrics.io/docs/usage/log-management/), [source map support](http://pm2.keymetrics.io/docs/usage/source-map-support/) and other great features to manage your Node.js application in production environment.

#### Tags available:

- keymetrics/pm2:`latest` with `node:alpine`
- keymetrics/pm2:`8` with `node:8-alpine`
- keymetrics/pm2:`7` with `node:7-alpine`
- keymetrics/pm2:`6` with `node:6-alpine`
- keymetrics/pm2:`4` with `node:4-alpine`
- keymetrics/pm2:`next` with `node:alpine` and `pm2@next`

These images are automatically built from the [Docker Hub](https://hub.docker.com/r/keymetrics/pm2/) based on this Github repository folder arrangement.


## Usage

Let's assume the following folder structure for your project.

```
`-- your-app-name/
    |-- src/
        `-- app.js
    |-- package.json
    |-- pm2.json     (we will create this in the following steps)
    `-- Dockerfile   (we will create this in the following steps)
```

### Create a pm2 ecosystem file

Create a new file called `pm2.json` with the following content:

```json
{
  "apps": [{
    "name": "your-app-name",
    "script": "src/app.js",
    "env": {
      "production": true
    }
  }]
}
```
> You can choose the name of the `ecosystem` file arbitrarly, but we will assume you called it `pm2.json` in the following steps.

See the [documentation](http://pm2.keymetrics.io/docs/usage/application-declaration/#generate-configuration) for more information about how to configure the `ecosystem` file.

### Create a Dockerfile file

Create a new file called `Dockerfile` with the following content:

```dockerfile
FROM keymetrics/pm2:latest

# Bundle APP files
COPY src src/
COPY package.json .
COPY pm2.json .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production

# Show current folder structure in logs
RUN ls -al -R

CMD [ "pm2-docker", "start", "pm2.json" ]
```
See the [documentation](http://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/#usage) for more info about the `pm2-docker` command.
<br>All options available are listed [here](http://pm2.keymetrics.io/docs/usage/application-declaration/#attributes-available).

### Build and Run your image
From your Node.js app project folder launch those commands:

```bash
$ docker build -t your-app-name .
$ docker run your-app-name
```

## Custom configurations

### Enable Git auto-pull

If you want to [Automatically synchronize your application with git](https://github.com/pm2-hive/pm2-auto-pull) add this into your Dockerfile:

```
RUN pm2 install pm2-auto-pull
```
*Make sure the .git is present in your application source folder.*

## Logging Format option

If you want to change the log output format you can select one of this options:

- **--json** to output logs in JSON
- **--format** to output logs in key=val style
- **--raw** to display logs in raw format

To use one of this flag, you just need to pass them to pm2-docker:

```
CMD ["pm2-docker", "start", "--json", "pm2.json"]
```

See the [documentation](http://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/#usage) for all available configuration.

## Use Keymetrics.io

[Keymetrics.io](https://keymetrics.io/) is a monitoring service built on top of PM2 that allows to monitor and manage applications easily (logs, restart, exceptions monitoring, etc...). Once you created a Bucket on Keymetrics you will get a public and a secret key.

To enable Keymetrics monitoring with pm2-docker, you can whether use the CLI option –public `XXX` and –secret `YYY` or you can pass the environment variables `KEYMETRICS_PUBLIC` and `KEYMETRICS_SECRET`.

Example with the CLI options via a Dockerfile:

```
CMD ["pm2-docker", "start", "--public", "XXX", "--secret", "YYY", "pm2.json"]
```

Or via environment variables:

```
ENV KEYMETRICS_PUBLIC=XXX
ENV KEYMETRICS_SECRET=YYY
```

## Enabling Graceful Shutdown

When the Container receives a shutdown signal, PM2 forwards this signal to your application allowing to close all the database connections, wait that all queries have been processed or that any other final processing has been completed before a successfull graceful shutdown.

Catching a shutdown signal is straightforward. You need to add a listener in your Node.js applications and execute anything needed before stopping the app:

```javascript
process.on('SIGINT', function() {
  db.stop(function(err) {
    process.exit(err ? 1 : 0);
  });
});
```
By default PM2 will wait `1600ms` before sending a final `SIGKILL` signal. You can modify this delay by setting the `kill_timeout` option inside your application configuration file.

## Expose health endpoint
The `--web [port]` option allows to expose all vital signs (docker instance + application) via a JSON API.

```
CMD ["pm2-docker", "start", "pm2.json", "--web"]
```
or
```
CMD ["pm2-docker", "start", "pm2.json", "--web", "port"]
```

## Useful commands

Command | Description
--------|------------
```$ docker exec -it <container-id> pm2 monit``` | Monitoring CPU/Usage of each process
```$ docker exec -it <container-id> pm2 list``` | Listing managed processes
```$ docker exec -it <container-id> pm2 show``` | Get more information about a process
```$ docker exec -it <container-id> pm2 reload all``` | 0sec downtime reload all applications

## Documentation

The documentation can be found [here](http://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/).

## Authors
* **Alexandre Strzelewicz** - [Unitech](https://github.com/Unitech)
* **Simone Primarosa** - [simonepri](https://github.com/simonepri)

See also the list of [contributors](https://github.com/keymetrics/docker-pm2/contributors) who participated in this project.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

License information for
the software contained in this image can be found [here](https://github.com/Unitech/pm2/blob/master/GNU-AGPL-3.0.txt) (pm2) and [here](https://github.com/nodejs/node/blob/master/LICENSE) (node).
