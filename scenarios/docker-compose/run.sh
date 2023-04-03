#!/usr/bin/env bash

source env.sh
docker compose -f compose.yml -p workspace up -d
