
docker build -t keymetrics/pm2-docker-alpine .
docker run -d -p 5678:3000 -v `pwd`/example_app:/app -e "APP=ecosystem.yml" keymetrics/pm2-docker-alpine
sleep 4
docker tag $(docker ps -q --filter ancestor=keymetrics/pm2-docker-alpine) keymetrics/pm2-docker-alpine:latest
docker commit -m "Publish" -a "Keymetrics" 630cd99 keymetrics/pm2-docker-alpine
