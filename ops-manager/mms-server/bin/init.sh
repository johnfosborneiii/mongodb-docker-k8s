#!/bin/bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
VER=$(grep -oP '(?<=MONGODB_IMAGE_VERSION=\")\d+\.\d+' Dockerfile)

source $DIR/ver.sh

docker build -t mongodb-base-7/mms:$VER .
