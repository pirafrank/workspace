#!/usr/bin/env bash

source env.sh

# create dedicated namespace first
kubectl apply -f namespace.yaml

# deploy to that namespace
# nb. comment the line above and change namespace below to deploy to your namespace.
kubectl apply -f deployment.yaml --namespace="$WORKSPACE_NAMESPACE"
