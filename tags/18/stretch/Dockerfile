FROM node:18-stretch
LABEL maintainer="Keymetrics <contact@keymetrics.io>"

# Install pm2
RUN npm install pm2 -g

# Expose ports needed to use Keymetrics.io
EXPOSE 80 443 43554 81

# Start pm2.json process file
CMD ["pm2-runtime", "start", "pm2.json"]
