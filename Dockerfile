FROM mhart/alpine-node:latest
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN npm install pm2@next -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 43554

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "test", "process.yml"]
