FROM mhart/alpine-node:latest
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN npm install pm2@next -g
RUN pm2 install pm2-auto-pull

VOLUME ["/app"]

# Expose ports
EXPOSE 80 443 43554

WORKDIR /app

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "production", "process.yml"]
