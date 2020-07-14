#!/bin/bash

# Deploy the application to kubernetes cluster by setting the image tag

set -e
. envvar.sh

image_tag=$(docker images gcr.io/${PROJECT_ID}/backend --format '{{.Tag}}')

kubectl set image deployment.apps/backend-deployment backend="gcr.io/${PROJECT_ID}/backend:${image_tag}"
