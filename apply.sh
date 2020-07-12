#!/bin/bash

set -e
. envvar.sh

kubectl apply -f backend.yaml
