#!/usr/bin/env bash

docker build -f Dockerfile.routeur -t routeur-img .
docker build -f Dockerfile.host -t host-img .
