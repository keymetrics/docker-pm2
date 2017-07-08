# keymetrics/pm2-docker-alpine

![https://travis-ci.org/keymetrics/pm2-docker-alpine](https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master)

Production ready nodeJS Docker image including the [PM2 runtime](http://pm2.keymetrics.io/).

The goal of this image is to wrap your applications into a proper Node.js production environment. It solves major issues when running Node.js applications inside a container like:

- Correct PID 1 signals Handling & Forwarding
- Graceful application Start and Shutdown
- Seamless application clustering to increase performance and reliability

Further than that, using PM2 as a layer between the container and the application brings PM2 features like [application declaration file](http://pm2.keymetrics.io/docs/usage/application-declaration/), [customizable log system](http://pm2.keymetrics.io/docs/usage/log-management/), [source map support](http://pm2.keymetrics.io/docs/usage/source-map-support/) and other great features to manage your Node.js application in production environment.

#### Tags available:

- keymetrics/pm2-docker-alpine:`latest` with `node:alpine`
- keymetrics/pm2-docker-alpine:`8` with `node:8-alpine`
- keymetrics/pm2-docker-alpine:`7` with `node:7-alpine`
- keymetrics/pm2-docker-alpine:`6` with `node:6-alpine`
- keymetrics/pm2-docker-alpine:`4` with `node:4-alpine`
- keymetrics/pm2-docker-alpine:`next` with `node:alpine` and `pm2@next`

These images are automatically built from the [Docker Hub](https://hub.docker.com/r/keymetrics/pm2-docker-alpine/) based on this Github repository folder arrangement.


## Usage

### Create a `Dockerfile` in your Node.js app project

```dockerfile
FROM keymetrics/pm2-docker-alpine:latest

# You can insert here your custom docker commands if you need it.

CMD [ "pm2-docker", "start", "pm2.json" ]
```
See the [documentation](http://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/#usage) for more info about the `pm2-docker` command.

### Create a `pm2.json` in your Node.js app project

```json
{
  "apps": [{
    "name": "your-app-name",
    "script": "app.js",
    "env": {
      "production": true
    }
  }]
}
```

See the [documentation](http://pm2.keymetrics.io/docs/usage/application-declaration/) for more information about how to configure the pm2 `process file`.
<br>All options available are listed [here](http://pm2.keymetrics.io/docs/usage/application-declaration/#attributes-available).

### Build and Run your image
From your Node.js app project folder launch those commands:

```bash
$ docker build -t your-app-name .
$ docker run your-app-name .
```







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

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

License information for
the software contained in this image can be found [here](https://github.com/Unitech/pm2/blob/master/GNU-AGPL-3.0.txt) (pm2) and [here](https://github.com/nodejs/node/blob/master/LICENSE) (node).
