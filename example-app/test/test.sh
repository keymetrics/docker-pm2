#!/bin/bash

function fail {
  echo -e "\033[31m  ✘ \033[0m$1"
}

function success {
  echo -e "\033[32m ✔ \033[0m$1"
}

function spec {
  if [ $1 == $2 ]; then
    success "$3"
  else
    fail "$3"
  fi
}

function ispec {
  if [ $1 != $2 ]; then
    success "$3"
  else
    fail "$3"
  fi
}

function test {
  echo -e "Building keymetrics/pm2:$1"
  # Set the tag name into the Dockerfile
  sed -i.bk "s/{{tag}}/$1/g" 'Dockerfile' && rm 'Dockerfile.bk'

  # Build the image
  IID=$(docker build -q -t example-app .)
  # Create and Start the container
  CID=$(docker run -d -p 80:3000 example-app)

  sleep 5

  # Starting tests
  echo -e "Testing keymetrics/pm2:$1"
  EXPECTED="hey"
  ACTUAL=$(curl -s http://localhost:80/)
  spec ${ACTUAL} ${EXPECTED} "Should have got data from running app in docker container"
  # Tests executed

  echo -e "Cleaning keymetrics/pm2:$1"
  # Stop the container
  docker stop ${CID} >> /dev/null
  # Delete the container
  docker rm ${CID} >> /dev/null
  # Delete the image
  docker rmi ${IID} >> /dev/null

  # Reset the tag name into the Dockerfile
  sed -i.bk "s/$1/{{tag}}/g" 'Dockerfile' && rm 'Dockerfile.bk'
}

# Test all the tags that we ship on Docker Hub
tags=(${TEST_TAGS:-'latest-alpine' 'latest-stretch' 'latest-jessie' 'latest-slim' 'latest-wheezy'})

for tag in "${tags[@]}"
do
  test ${tag}
done
