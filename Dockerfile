FROM mhart/alpine-node:4
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN apk update
RUN apk add ca-certificates wget && update-ca-certificates

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.2/dumb-init_1.1.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Install V2 with pm2-docker command
RUN npm install pm2@next -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80
EXPOSE 443
# Reverse interaction port for KM
EXPOSE 43554

ADD start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["dumb-init", "/start.sh"]
