#!/bin/bash

function timed {
    START=$SECONDS

    "$@"

    DURATION=$(($SECONDS - $START))
    echo "$(($DURATION/60)):$(($DURATION%60))" to run "$@"
}

set -e

pushd backend
# Remove any old images
docker images demo -q | xargs -r docker rmi

# build the docker image using spring-boot
timed ./mvnw spring-boot:build-image

# tag the image to latest so Dockerfile's FROM statement picks it up
docker image tag $(docker images demo --format '{{.Repository}}:{{.Tag}}') demo:latest

# Modify the image based to include somet tools defined in Dockerfile
# Then tag it as backend
timed docker build --tag backend:latest .

popd
