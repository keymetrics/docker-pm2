#!/bin/bash

function fail {
  echo -e "######## \033[31m  ✘ $1\033[0m"
  exit 1
}

function success {
  echo -e "\033[32m------------> ✔ $1\033[0m"
}

function spec {
  RET=$?
  sleep 0.3
  [ $RET -eq 0 ] || fail "$1"
  success "$1"
}

function ispec {
  RET=$?
  sleep 0.3
  [ $RET -ne 0 ] || fail "$1"
  success "$1"
}

docker pull keymetrics/pm2

docker run -d -p 80:3000 -v `pwd`/example_app:/app -e "APP=process.yml" keymetrics/pm2

sleep 2

curl http://localhost:80/
spec "Should have got data from running app in docker container"

# Stopping container
docker stop $(docker ps -q --filter ancestor=keymetrics/pm2)
