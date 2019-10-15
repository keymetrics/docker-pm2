FROM node:slim
LABEL maintainer="Keymetrics <contact@keymetrics.io>"

# Add the missing `ps` that `slim` doesn't provide
RUN apt install procps

# Install pm2
RUN npm install pm2 -g

# Expose ports needed to use Keymetrics.io
EXPOSE 80 443 43554

# Start pm2.json process file
CMD ["pm2-runtime", "start", "pm2.json"]
