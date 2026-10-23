ARG BASE_IMAGE=keymetrics/pm2:latest-alpine
FROM ${BASE_IMAGE}

# Bundle APP files
COPY src src/
COPY package.json .
COPY pm2.json .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL=warn
RUN npm install --omit=dev

CMD [ "pm2-runtime", "start", "pm2.json" ]
