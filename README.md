# PM2

Production ready nodeJS Docker image including the [PM2 runtime](http://pm2.keymetrics.io/).

The goal of this image is to wrap your applications into a proper Node.js production environment. It solves major issues when running Node.js applications inside a container like:

- Correct PID 1 signals Handling & Forwarding
- Graceful application Start and Shutdown
- Seamless application clustering to increase performance and reliability

Further than that, using PM2 as a layer between the container and the application brings PM2 features like [application declaration file](http://pm2.keymetrics.io/docs/usage/application-declaration/), [customizable log system](http://pm2.keymetrics.io/docs/usage/log-management/), [source map support](http://pm2.keymetrics.io/docs/usage/source-map-support/) and other great features to manage your Node.js application in production environment.

## Tags available

Standard images are built from the [Dockerfile](Dockerfile) on top of the [official Node.js images](https://hub.docker.com/_/node). All images are published for `linux/amd64` and `linux/arm64`. `latest` points to the newest Node.js release, and `keymetrics/pm2:latest` is an alias of `latest-alpine`.

**Image Name** | **Operating system** | **Base image**
---|---|---
keymetrics/pm2:`latest-alpine`|[Alpine](https://www.alpinelinux.org/about/)|`node:alpine`
keymetrics/pm2:`26-alpine`|[Alpine](https://www.alpinelinux.org/about/)|`node:26-alpine`
keymetrics/pm2:`24-alpine`|[Alpine](https://www.alpinelinux.org/about/)|`node:24-alpine`
keymetrics/pm2:`22-alpine`|[Alpine](https://www.alpinelinux.org/about/)|`node:22-alpine`

**Image Name** | **Operating system** | **Base image**
---|---|---
keymetrics/pm2:`latest-bookworm`|[Debian Bookworm](https://wiki.debian.org/DebianBookworm)|`node:bookworm`
keymetrics/pm2:`26-bookworm`|[Debian Bookworm](https://wiki.debian.org/DebianBookworm)|`node:26-bookworm`
keymetrics/pm2:`24-bookworm`|[Debian Bookworm](https://wiki.debian.org/DebianBookworm)|`node:24-bookworm`
keymetrics/pm2:`22-bookworm`|[Debian Bookworm](https://wiki.debian.org/DebianBookworm)|`node:22-bookworm`

**Image Name** | **Operating system** | **Base image**
---|---|---
keymetrics/pm2:`latest-trixie`|[Debian Trixie](https://wiki.debian.org/DebianTrixie)|`node:trixie`
keymetrics/pm2:`26-trixie`|[Debian Trixie](https://wiki.debian.org/DebianTrixie)|`node:26-trixie`
keymetrics/pm2:`24-trixie`|[Debian Trixie](https://wiki.debian.org/DebianTrixie)|`node:24-trixie`
keymetrics/pm2:`22-trixie`|[Debian Trixie](https://wiki.debian.org/DebianTrixie)|`node:22-trixie`

**Image Name** | **Operating system** | **Base image**
---|---|---
keymetrics/pm2:`latest-slim`|Debian (minimal packages, follows the `node:<version>-slim` default)|`node:slim`
keymetrics/pm2:`26-slim`|Debian (minimal packages, follows the `node:<version>-slim` default)|`node:26-slim`
keymetrics/pm2:`24-slim`|Debian (minimal packages, follows the `node:<version>-slim` default)|`node:24-slim`
keymetrics/pm2:`22-slim`|Debian (minimal packages, follows the `node:<version>-slim` default)|`node:22-slim`

### Hardened

**Image Name** | **Base image**
---|---
keymetrics/pm2:`26-hardened`|`dhi.io/node:26-debian13`
keymetrics/pm2:`24-hardened`|`dhi.io/node:24-debian13`
keymetrics/pm2:`22-hardened`|`dhi.io/node:22-debian13`

Built from [Dockerfile.hardened](Dockerfile.hardened) on top of [Docker Hardened Images](https://docs.docker.com/dhi/): minimal Debian 13, near-zero CVEs, non-root `node` user (uid 1000), working directory `/app`. There is **no shell, no npm and no package manager** at runtime, so install your dependencies in a build stage:

```dockerfile
FROM dhi.io/node:24-debian13-dev AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

FROM keymetrics/pm2:24-hardened
COPY --from=deps /app/node_modules node_modules/
COPY src src/
COPY pm2.json .
CMD ["pm2-runtime", "start", "pm2.json"]
```

Without `ps` in the image, PM2 can only stop the main process of an app: child processes spawned by your app are not killed on stop or restart.

### Bun

**Image Name** | **Base image**
---|---
keymetrics/pm2:`bun`|`oven/bun:1` (Debian)
keymetrics/pm2:`bun-alpine`|`oven/bun:1-alpine`

Built from [Dockerfile.bun](Dockerfile.bun): PM2 and your applications run on [Bun](https://bun.sh) instead of Node.js (`node` is a shim to `bun` in these images). Install your dependencies with `bun install`.

The list of built versions lives in [versions.json](versions.json).

You can find more information about the image variants [here](https://github.com/nodejs/docker-node#image-variants).

> Images are rebuilt every week to pick up Node.js and PM2 releases, and on every push to the master branch of [docker-pm2](https://github.com/keymetrics/docker-pm2).

> Tags for end-of-life Node.js versions (18, 20 and older) and Debian releases (buster, bullseye and older) are no longer rebuilt. They remain on [Docker Hub](https://hub.docker.com/r/keymetrics/pm2/tags) but do not receive security updates. _(Not recommended)_

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
  "name": "your-app-name",
  "script": "src/app.js",
  "instances": "2",
  "env": {
    "NODE_ENV": "development"
  },
  "env_production" : {
    "NODE_ENV": "production"
  }
}
```
> You can choose the name of the `ecosystem` file arbitrarily, but we will assume you called it `pm2.json` in the following steps.

See the [documentation](http://pm2.keymetrics.io/docs/usage/application-declaration/#generate-configuration) for more information about how to configure the `ecosystem` file.

### Create a Dockerfile file

Create a new file called `Dockerfile` with the following content:

```dockerfile
FROM keymetrics/pm2:latest-alpine

# Bundle APP files
COPY src src/
COPY package.json .
COPY pm2.json .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL=warn
RUN npm install --omit=dev

CMD [ "pm2-runtime", "start", "pm2.json" ]
```
See the [documentation](http://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/#usage) for more info about the `pm2-runtime` command.
<br>All options available are listed [here](http://pm2.keymetrics.io/docs/usage/application-declaration/#attributes-available).

### Build and Run your image
From your Node.js app project folder launch those commands:

```bash
$ docker build -t your-app-name .
$ docker run your-app-name
```

## Custom configurations

### Enable git auto-pull

If you want to [Automatically synchronize your application with git](https://github.com/pm2-hive/pm2-auto-pull) add this into your Dockerfile:

```
RUN pm2 install pm2-auto-pull
```
*Make sure the .git is present in your application source folder.*

### Enable Monitor server

If you want to [Automatically monitor vital signs of your server](https://github.com/keymetrics/pm2-server-monit) add this into your Dockerfile:

```
RUN pm2 install pm2-server-monit
```

### Use Keymetrics.io dashboard

[Keymetrics.io](https://keymetrics.io/) is a monitoring service built on top of PM2 that allows to monitor and manage applications easily (logs, restart, exceptions monitoring, etc...). Once you created a Bucket on Keymetrics you will get a public and a secret key.

To enable Keymetrics monitoring with pm2-runtime, you can whether use the CLI option –public `XXXX` and –secret `YYYY` or you can pass the environment variables `KEYMETRICS_PUBLIC` and `KEYMETRICS_SECRET`.

From your Node.js app project folder launch those commands:

```bash
$ docker build -t your-app-name .
$ docker run -e KEYMETRICS_PUBLIC=XXXX -e KEYMETRICS_SECRET=YYYY your-app-name
```

Make sure that the port 443 (HTTPS outbound) is allowed on your firewall.

See the [troubleshooting](http://docs.keymetrics.io/docs/pages/faq-troubleshooting/#troubleshooting-for-keymetrics-pm2) in case you encounter any problem.

### Enabling Graceful Shutdown

When the Container receives a shutdown signal, PM2 forwards this signal to your application allowing to close all the database connections, wait that all queries have been processed or that any other final processing has been completed before a successful graceful shutdown.

Catching a shutdown signal is straightforward. You need to add a listener in your Node.js applications and execute anything needed before stopping the app:

```javascript
process.on('SIGINT', function() {
  db.stop(function(err) {
    process.exit(err ? 1 : 0);
  });
});
```
By default PM2 will wait `1600ms` before sending a final `SIGKILL` signal. You can modify this delay by setting the `kill_timeout` option inside your application configuration file.

### Expose health endpoint
The `--web [port]` option allows to expose all vital signs (docker instance + application) via a JSON API.

```
CMD ["pm2-runtime", "start", "pm2.json", "--web"]
```
or
```
CMD ["pm2-runtime", "start", "pm2.json", "--web", "port"]
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

License information for the software contained in this image can be found [here](https://github.com/Unitech/pm2/blob/master/GNU-AGPL-3.0.txt) (pm2) and [here](https://github.com/nodejs/node/blob/master/LICENSE) (node).

## Development

```bash
# Build and test images locally without pushing
./build-and-push.sh --no-push 24-alpine

# Test any image against example-app
bash test/test-image.sh keymetrics/pm2:24-alpine
```
