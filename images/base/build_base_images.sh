#!/bin/bash

#####
# DOCKER AND PROJECT auxiliary variables
#####
DOCKER_VERSION_ARG=$1
PROJECT_NAME_BASE=$2
ARCHITECTURES=$3
DOCKERFILE_BASE_DIR=$4

CURRENT_TAG=${CURRENT_TAG:-"latest"}

####
# BUILD BASE IMAGES
####
for ARCH in $ARCHITECTURES
do
    echo "[INFO] Building image with name: strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH)."
    docker build --platform linux/$ARCH --build-arg version=$DOCKER_VERSION_ARG -t strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH $DOCKERFILE_BASE_DIR
done

# PRINT ALL IMAGES
docker images

