FROM node:alpine
LABEL maintainer="Keymetrics <contact@keymetrics.io>"

# Install pm2
RUN npm install pm2 -g

# Expose ports
EXPOSE 80 443 43554

# Start pm2.json process file
CMD ["pm2-docker", "start", "pm2.json"]
