#!/bin/bash
export SSHKEYS="YOUR_SSH_KEY_OR_KEYS"
nohup az container create \
  --resource-group YOUR_RESOURCE_GROUP \
  --name SOME_CONTAINER_INSTANCE_NAME \
  --image pirafrank/workspace:bundle \
  --location westeurope \
  --os-type Linux \
  --cpu 1 \
  --memory 2.0 \
  --dns-name-label SOME_CONTAINER_INSTANCE_NAME \
  -e SSH_SERVER='true' SSH_PUBKEYS="${SSHKEYS}" \
    GITUSERNAME='John Doe' GITUSEREMAIL='john@doe.net' \
  --ports 2222 &
