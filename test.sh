#!/bin/bash

docker run -d -p 5678:3000 -v `pwd`/example_app:/app -e "APP=ecosystem.yml" keymetrics/pm2-docker-alpine

wget http://localhost:5678
