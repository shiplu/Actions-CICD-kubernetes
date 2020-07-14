#!/bin/bash

# Apply any changes in cluster objects

set -e
. envvar.sh
if [[ "$1" = "" ]];
then
    echo backend image is not passed as first argument 1>&2
    exit 1
fi


export K8_BACKEND_IMAGE="$1"

envsubst '$K8_BACKEND_IMAGE' < backend.yaml | kubectl apply -f -
