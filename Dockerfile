FROM alpine:latest
MAINTAINER Keymetrics <contact@keymetrics.io>

ENV NODE_VERSION=v6.3.0

RUN apk upgrade --update \
 && apk add curl make gcc g++ linux-headers paxctl musl-dev git \
    libgcc libstdc++ binutils-gold python openssl-dev zlib-dev \
 && mkdir -p /root/src \
 && cd /root/src \
 && curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz \
 && cd /root/src/node-* \
 && ./configure --prefix=/usr --without-snapshot \
 && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && make install \
 && paxctl -cm /usr/bin/node \
 && npm cache clean \
 && apk del make gcc g++ python linux-headers \
 && rm -rf /root/src /tmp/* /usr/share/man /var/cache/apk/* \
    /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
 && apk search --update

# Install V2 with pm2-docker command
RUN npm install pm2@next -g

# Install pm2-server-monit module
# https://github.com/dashersw/docker-node-pm2-keymetrics/blob/master/Dockerfile#L14
# RUN pm2 install pm2-server-monit

VOLUME ["/app"]

# Expose ports
EXPOSE 80
EXPOSE 443
# Reverse interaction port for KM
EXPOSE 43554

ADD start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
