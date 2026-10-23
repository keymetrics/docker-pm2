# NODE_TAG is a tag of the official node image, e.g. 24-alpine, 22-bookworm, slim
ARG NODE_TAG=lts-alpine
FROM node:${NODE_TAG}

ARG PM2_VERSION=latest

LABEL org.opencontainers.image.title="pm2" \
      org.opencontainers.image.description="Node.js production image with the PM2 runtime" \
      org.opencontainers.image.source="https://github.com/keymetrics/docker-pm2" \
      org.opencontainers.image.vendor="Keymetrics" \
      org.opencontainers.image.licenses="MIT"

# Install pm2
RUN npm install -g pm2@${PM2_VERSION} \
 && npm cache clean --force

EXPOSE 80 443

# Start pm2.json process file
CMD ["pm2-runtime", "start", "pm2.json"]
