FROM node:8-alpine
LABEL maintainer "Keymetrics <contact@keymetrics.io>"

RUN npm install pm2 -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80 443 43554

WORKDIR /app

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "production", "process.yml"]
