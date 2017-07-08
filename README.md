# keymetrics/pm2-docker-alpine

![https://travis-ci.org/keymetrics/pm2-docker-alpine](https://travis-ci.org/keymetrics/pm2-docker-alpine.svg?branch=master)

Node.js lightweight Docker image including the [PM2 runtime](http://pm2.keymetrics.io/) for production applications.

This Docker image in association with PM2, increase application uptime, increase performance (spawn multiple processes and [load-balance network query](http://pm2.keymetrics.io/docs/usage/cluster-mode/) without any code change) and allow graceful state change, adapted to production environment.









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
