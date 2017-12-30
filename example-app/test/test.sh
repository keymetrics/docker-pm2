#!/bin/bash

function fail {
  echo -e "\033[31m  ✘ $1\033[0m"
}

function success {
  echo -e "\033[32m ✔ $1\033[0m"
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

# Build the image
IID=$(docker build -q -t example-app .)
echo "Created: ${IID}"
# Create and Start the container
CID=$(docker run -d -p 80:3000 example-app)
echo "${CID}"
echo "Tagged: example-app:latest"

sleep 5

# Starting tests
echo -e "\nStarting tests"
EXPECTED="hey"
ACTUAL=$(curl -s http://localhost:80/)
spec $ACTUAL $EXPECTED "Should have got data from running app in docker container"
echo -e "Tests executed\n"
# Tests executed

# Stop the container
docker stop ${CID}
# Delete the container
docker rm ${CID}
# Delete the image
docker rmi ${IID}
