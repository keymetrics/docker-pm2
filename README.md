# keymetrics/pm2-docker-alpine

![https://travis-ci.org/keymetrics/pm2-docker-alpine](https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master)

Production ready nodeJS Docker image including the [PM2 runtime](http://pm2.keymetrics.io/).

The goal of this image is to wrap your applications into a proper Node.js production environment. It solves major issues when running Node.js applications inside a container like:

- Correct PID 1 signals Handling & Forwarding
- Graceful application Start and Shutdown
- Seamless application clustering to increase performance and reliability

Further than that, using PM2 as a layer between the container and the application brings PM2 features like [application declaration file](http://pm2.keymetrics.io/docs/usage/application-declaration/), [customizable log system](http://pm2.keymetrics.io/docs/usage/log-management/), [source map support](http://pm2.keymetrics.io/docs/usage/source-map-support/) and other great features to manage your Node.js application in production environment.









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
