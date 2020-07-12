#!/bin/bash

function timed {
    START=$SECONDS

    "$@"

    DURATION=$(($SECONDS - $START))
    echo "$(($DURATION/60)):$(($DURATION%60))" to run "$@"
}

set -e
. envvar.sh

pushd backend
# Remove any old images
# docker images demo -q | xargs -r docker rmi

# build the docker image using spring-boot
timed ./mvnw spring-boot:build-image

# tag the image to latest so Dockerfile's FROM statement picks it up
docker image tag $(docker images 'demo:*.*' --format '{{.Repository}}:{{.Tag}}' | head -n 1) demo:latest

# Modify the image based to include somet tools defined in Dockerfile
# Then tag it as backend
timed docker build --tag backend:latest .

# Push it GCR
image_tag=gcr.io/${PROJECT_ID}/backend:$(date +%y%m%d.%H.%M)
docker image tag backend:latest $image_tag
docker push $image_tag
popd

