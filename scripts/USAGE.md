
## Update all branch with master

$ bash scripts/update.sh

## Build

$ docker build -t keymetrics/pm2-docker-alpine .

## Run

$ docker run -p 3000:80 -v `pwd`/example_app:/app -e "APP=ecosystem.yml" <container id>

## Commit

$ docker commit -m "Publish image" -a "Keymetrics" 630cd99 keymetrics/pm2-docker-alpine
