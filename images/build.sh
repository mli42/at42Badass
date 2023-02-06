#!/usr/bin/env bash

IMG_DIR="images"

if [[ ! "$(dirname ${0})" =~ "${IMG_DIR}" ]]; then
  echo "${0} has to be run from the root of the repo"
  exit 1
fi

docker build -f ${IMG_DIR}/Dockerfile.routeur -t routeur-img .
docker build -f ${IMG_DIR}/Dockerfile.host -t host-img .
