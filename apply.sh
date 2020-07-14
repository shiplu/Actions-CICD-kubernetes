#!/bin/bash

# Apply any changes in cluster objects

set -e
. envvar.sh

kubectl apply -f backend.yaml
